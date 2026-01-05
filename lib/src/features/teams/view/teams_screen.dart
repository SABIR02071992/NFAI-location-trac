import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_storage/get_storage.dart';
import 'package:m_app/src/features/teams/model/created_team_model.dart';
import 'package:m_app/src/utils/app_colors.dart';
import 'package:m_app/src/utils/k_appbar.dart';
import '../../../utils/k_button.dart';
import '../../storage/KStorage.dart';
import '../controller/created_team_list_notifier.dart';
import 'create_team_dialog.dart';
import '../model/team_model.dart';


class TeamsScreen extends ConsumerStatefulWidget {
  const TeamsScreen({super.key});

  @override
  ConsumerState<TeamsScreen> createState() => _TeamsScreenState();
}

class _TeamsScreenState extends ConsumerState<TeamsScreen> {
  final storage = GetStorage();

  @override
  void initState() {
    super.initState();
    // 🔥 Fetch teams when screen loads
    Future.microtask(() {
      ref.read(createdTeamListProvider.notifier).fetchTeams();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(createdTeamListProvider);

    return Scaffold(
      appBar: KAppBar(title: 'Teams'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
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

            const SizedBox(height: 16),

            /// ================= TEAM LIST =================
            Expanded(
              child: _buildTeamList(state),
            ),
          ],
        ),
      ),
    );
  }

  /// ================= TEAM LIST UI =================
  Widget _buildTeamList(state) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null) {
      return Center(
        child: Text(
          state.error!,
          style: const TextStyle(color: Colors.red),
        ),
      );
    }

    if (state.teams.isEmpty) {
      return const Center(
        child: Text(
          'No teams found',
          style: TextStyle(fontSize: 16),
        ),
      );
    }

    return ListView.separated(
      itemCount: state.teams.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final CreatedTeamModel team = state.teams[index];

        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          child: ListTile(
            title: Text(
              team.name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              'Team Lead: ${team.teamLeadName}',
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min, // important so it doesn't take all horizontal space
              children: [
                const SizedBox(width: 4), // small spacing between text and icon
                const Icon(
                  Icons.add,
                  size: 22,
                  color: AppColors.primaryColor,
                ),
              ],
            ),

          ),
        );
      },
    );
  }

  /// ================= SHOW CREATE TEAM DIALOG =================
  /*Future<void> _showCreateTeamDialog(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const CreateTeamDialog(),
    );
  }*/
  Future<bool?> _showCreateTeamDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const CreateTeamDialog(),
    );
  }

}
