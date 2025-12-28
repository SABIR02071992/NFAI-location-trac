import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:m_app/src/utils/app_colors.dart';
import 'package:m_app/src/utils/k_button.dart';
import '../controller/team_controller.dart';

class TeamScreen extends ConsumerWidget {
  const TeamScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final teams = ref.watch(teamProvider); // Watch Riverpod state

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                KButton(
                  height: 32,
                  borderRadius: 6,
                  textSize: 16,
                  text: 'Add Team',
                  onPressed: () {
                    _showCreateTeamDialog(context);
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            // <-- Wrap ListView in Expanded
            Expanded(
              child: teams.isEmpty
                  ? const Center(child: Text('No teams added yet'))
                  : ListView.builder(
                      itemCount: teams.length,
                      itemBuilder: (context, index) {
                        final team = teams[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: ListTile(
                            title: Text(
                              team.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Mobile: ${team.mobile}'),
                                Text('Email: ${team.email}'),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCreateTeamDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return const _CreateTeamDialog();
      },
    );
  }
}

class _CreateTeamDialog extends StatefulWidget {
  const _CreateTeamDialog({Key? key}) : super(key: key);

  @override
  State<_CreateTeamDialog> createState() => _CreateTeamDialogState();
}

class _CreateTeamDialogState extends State<_CreateTeamDialog> {
  final TextEditingController searchController = TextEditingController();
  final List<String> dummyTeams = [
    'Team Alpha',
    'Team Beta',
    'Team Gamma',
    'Team Delta',
    'Team Epsilon',
  ];
  late List<String> filteredTeams;

  @override
  void initState() {
    super.initState();
    filteredTeams = dummyTeams;
    searchController.addListener(_filterTeams);
  }

  @override
  void dispose() {
    searchController.removeListener(_filterTeams);
    searchController.dispose();
    super.dispose();
  }

  void _filterTeams() {
    final query = searchController.text;
    setState(() {
      filteredTeams = dummyTeams
          .where((team) => team.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      title: Row(
        children: [
          const Text('Create Team'),
          const Spacer(),
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.close),
          ),
        ],
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: searchController,
              autofocus: true,
              decoration: const InputDecoration(
                labelText: 'Search Team',
                prefixIcon: Icon(Icons.search),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 150, // Dropdown list height
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: filteredTeams.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(filteredTeams[index]),
                    onTap: () {
                      searchController.text = filteredTeams[index];
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      actions: [
        /// CANCEL BUTTON
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          style: TextButton.styleFrom(
            backgroundColor: Colors.white,
            side: const BorderSide(color: Colors.red, width: 1),
            padding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 14, // ✅ same as Create Team
            ),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            visualDensity: VisualDensity.compact,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: const Text(
            'Cancel',
            style: TextStyle(
              color: Colors.red,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        OutlinedButton.icon(
          onPressed: () {},
          label: const Text(
            "Create Team",
            style: TextStyle(
              color: AppColors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          style: OutlinedButton.styleFrom(
            backgroundColor: AppColors.primaryColor,
            side: BorderSide.none,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),

            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            visualDensity: VisualDensity.compact,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }
}
