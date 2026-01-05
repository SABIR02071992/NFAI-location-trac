import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_storage/get_storage.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/k_appbar.dart';
import '../../../utils/k_button.dart';
import '../../storage/KStorage.dart';
import '../../constant/api_ends_point.dart';
import '../../network/api_helper.dart';

import '../controller/created_team_list_notifier.dart';
import '../controller1/created_team_list_notifier.dart';
import '../controller1/remove_team_member_notifier.dart';
import '../model1/add_team_member_dialog.dart';
import '../model1/created_team_model.dart';
import 'create_team_dialog.dart';

class TeamsScreen1 extends ConsumerStatefulWidget {
  const TeamsScreen1({super.key});

  @override
  ConsumerState<TeamsScreen1> createState() => _TeamsScreen1State();
}

class _TeamsScreen1State extends ConsumerState<TeamsScreen1> {
  final GetStorage storage = GetStorage();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final String? userId = storage.read(KStorageKey.userId);
      if (userId == null) return;

      ref
          .read(createdTeamListProvider1.notifier)
          .fetchTeams(loggedInUserId: userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(createdTeamListProvider1);

    return Scaffold(
      appBar: const KAppBar(title: 'My Teams & Members'),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : state.error != null
          ? Center(child: Text(state.error!))
          : ListView(
        padding: const EdgeInsets.all(16),
        children: [

          /// ================= ADD TEAM BUTTON =================

          if(storage.read(KStorageKey.userRole) == 'Team Lead')...[
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                KButton(
                  height: 32,
                  borderRadius: 6,
                  textSize: 16,
                  text: 'Add Team',
                  onPressed: () async {
                    final result = await _showCreateTeamDialog(context);

                    // Dialog success ke saath close hua
                    if (result == true) {
                      ref.read(createdTeamListProvider.notifier).fetchTeams();
                    }
                  },

                ),
              ],
            ),
          ],
          SizedBox(height: 10,),

          /// ================= TEAM LIST =================
          ...state.teams.map(
                (team) => _TeamCard(team: team),
          ),
        ],
      ),
    );
  }

  /// ================= CREATE TEAM DIALOG =================
  Future<bool?> _showCreateTeamDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const CreateTeamDialog(),
    );
  }
}

/// ================= TEAM CARD =================
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
                  icon: const Icon(Icons.person_add,
                      color: AppColors.primaryColor),
                  onPressed: () async {
                    final String? loggedInUserId =
                    GetStorage().read(KStorageKey.userId);
                    if (loggedInUserId == null) return;

                    final usersResponse =
                    await ApiHelper.post(ApiEndpoints.getUsers);

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
                          .read(createdTeamListProvider1.notifier)
                          .fetchTeams(
                          loggedInUserId: loggedInUserId);
                    }
                  },
                ),

                /// ⬇ EXPAND
                IconButton(
                  icon: Icon(
                      expanded ? Icons.expand_less : Icons.expand_more),
                  onPressed: () =>
                      setState(() => expanded = !expanded),
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
                      await ref
                          .read(
                          removeTeamMemberProvider.notifier)
                          .removeMember(
                        memberRecordId:
                        m['member_record_id']
                            .toString(),
                      );

                      final userId =
                      GetStorage().read(KStorageKey.userId)
                      as String?;

                      if (userId != null) {
                        ref
                            .read(createdTeamListProvider1.notifier)
                            .fetchTeams(
                            loggedInUserId: userId);
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
