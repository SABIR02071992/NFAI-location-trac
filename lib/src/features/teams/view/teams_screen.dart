import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_storage/get_storage.dart';

import '../controller/created_team_list_notifier.dart';
import '../controller/remove_team_member_notifier.dart';
import '../model/created_team_model.dart';
import '../model/add_team_member_dialog.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/k_appbar.dart';
import '../../storage/KStorage.dart';
import '../../constant/api_ends_point.dart';
import '../../network/api_helper.dart';

class TeamsScreen extends ConsumerStatefulWidget {
  const TeamsScreen({super.key});

  @override
  ConsumerState<TeamsScreen> createState() => _TeamsScreenState();
}

class _TeamsScreenState extends ConsumerState<TeamsScreen> {
  final GetStorage storage = GetStorage();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final String? userId = storage.read(KStorageKey.userId);
      if (userId == null) return;

      ref
          .read(createdTeamListProvider.notifier)
          .fetchTeams(loggedInUserId: userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(createdTeamListProvider);

    return Scaffold(
      appBar: const KAppBar(title: 'My Teams & Members'),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : state.error != null
          ? Center(child: Text(state.error!))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.teams.length,
              itemBuilder: (_, index) {
                return _TeamCard(team: state.teams[index]);
              },
            ),
    );
  }
}

class _TeamCard extends ConsumerStatefulWidget {
  final CreatedTeamModel team;

  const _TeamCard({required this.team});

  @override
  ConsumerState<_TeamCard> createState() => _TeamCardState();
}

class _TeamCardState extends ConsumerState<_TeamCard> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    final team = widget.team;
    final isRemoving = ref.watch(removeTeamMemberProvider);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        children: [
          /// ================= TEAM HEADER =================
          ListTile(
            title: Text(
              team.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text('${team.members.length} Members'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                /// ➕ ADD MEMBER
                IconButton(
                  icon: const Icon(
                    Icons.person_add,
                    color: AppColors.primaryColor,
                  ),
                  onPressed: () async {
                    final String? loggedInUserId = GetStorage().read(
                      KStorageKey.userId,
                    );
                    if (loggedInUserId == null) return;

                    final usersResponse = await ApiHelper.post(
                      ApiEndpoints.getUsers,
                    );
                    final List allUsers =
                        (usersResponse['data']?['users'] ?? []) as List;

                    final Set<String> memberIds = team.members
                        .map((m) => m['id'].toString())
                        .toSet();

                    final List eligibleUsers = allUsers.where((u) {
                      final id = u['id'].toString();
                      if (id == loggedInUserId) return false;
                      if (memberIds.contains(id)) return false;
                      return true;
                    }).toList();

                    final result = await showDialog<bool>(
                      context: context,
                      builder: (_) => AddTeamMemberDialog(
                        teamId: team.id,
                        eligibleUsers: eligibleUsers,
                      ),
                    );

                    if (result == true) {
                      ref
                          .read(createdTeamListProvider.notifier)
                          .fetchTeams(loggedInUserId: loggedInUserId);
                    }
                  },
                ),

                /// 🗑 DELETE TEAM (NEW)
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text('Delete team'),
                        content: const Text(
                          'Are you sure you want to delete this team?',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('Cancel'),
                          ),
                          ElevatedButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text('Delete'),
                          ),
                        ],
                      ),
                    );

                    if (confirm != true) return;

                    try {
                      await ApiHelper.post(
                        ApiEndpoints.removeTeam,
                        body: {"team_id": team.id},
                      );

                      final userId =
                          GetStorage().read(KStorageKey.userId) as String?;

                      if (userId != null) {
                        ref
                            .read(createdTeamListProvider.notifier)
                            .fetchTeams(loggedInUserId: userId);
                      }

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Team deleted successfully'),
                        ),
                      );
                    } catch (_) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Cannot delete team — team active'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                ),

                /// ⬇ EXPAND
                IconButton(
                  icon: Icon(expanded ? Icons.expand_less : Icons.expand_more),
                  onPressed: () => setState(() => expanded = !expanded),
                ),
              ],
            ),
          ),

          if (expanded) const Divider(),

          /// ================= TEAM MEMBERS =================
          if (expanded)
            Column(
              children: team.members.map((m) {
                return ListTile(
                  dense: true,
                  leading: const Icon(Icons.person),
                  title: Text(m['name'] ?? ''),
                  subtitle: Text(m['designation'] ?? ''),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: isRemoving
                        ? null
                        : () async {
                            final confirm = await showDialog<bool>(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: const Text('Remove member'),
                                content: const Text(
                                  'Are you sure you want to remove this member?',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, false),
                                    child: const Text('Cancel'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () =>
                                        Navigator.pop(context, true),
                                    child: const Text('Remove'),
                                  ),
                                ],
                              ),
                            );

                            if (confirm != true) return;

                            try {
                              await ref
                                  .read(removeTeamMemberProvider.notifier)
                                  .removeMember(
                                    memberRecordId: m['member_record_id']
                                        .toString(),
                                  );

                              final userId =
                                  GetStorage().read(KStorageKey.userId)
                                      as String?;

                              if (userId != null) {
                                ref
                                    .read(createdTeamListProvider.notifier)
                                    .fetchTeams(loggedInUserId: userId);
                              }

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Member removed successfully'),
                                ),
                              );
                            } catch (_) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Cannot remove member — team active',
                                  ),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          },
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }
}
