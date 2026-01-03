
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../utils/app_colors.dart';
import '../controller/create_team_notifier.dart';
import '../model/create_team_state.dart';

class CreateTeamDialog extends ConsumerStatefulWidget {
  const CreateTeamDialog({Key? key}) : super(key: key);

  @override
  ConsumerState<CreateTeamDialog> createState() =>
      _CreateTeamDialogState();
}

class _CreateTeamDialogState extends ConsumerState<CreateTeamDialog> {
  final TextEditingController teamNameController = TextEditingController();

  bool isButtonEnabled = false;

  @override
  void initState() {
    super.initState();

    // Enable/disable button based on text input
    teamNameController.addListener(() {
      final hasText = teamNameController.text.trim().isNotEmpty;
      if (hasText != isButtonEnabled) {
        setState(() {
          isButtonEnabled = hasText;
        });
      }
    });

    // ✅ Listen to team creation state
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.listen<CreateTeamState>(createTeamProvider, (previous, next) {
        if (next.isSuccess && mounted) {
          // Close the dialog automatically when creation succeeds
          Navigator.of(context, rootNavigator: true).pop();
          // ✅ Ye code yahan use hoga
          if (next.isSuccess && mounted) {
            Navigator.of(context, rootNavigator: true).pop(); // Auto dismiss
            ref.read(createTeamProvider.notifier).reset();
          }

          // Reset the state so dialog can be used again
          ref.read(createTeamProvider.notifier).reset();
        }

        // Optional: show error
        if (next.error != null && next.error!.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(next.error!)),
          );
        }
      });
    });
  }

  @override
  void dispose() {
    teamNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(createTeamProvider);

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      title: Row(
        children: [
          const Text('Create Team'),
          const Spacer(),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close),
          ),
        ],
      ),
      content: TextField(
        controller: teamNameController,
        autofocus: true,
        decoration: const InputDecoration(
          hintText: 'Enter team name',
        ),
      ),
      actions: [
        // CANCEL
        if (!state.isLoading)
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.red),
            ),
          ),


        // CREATE TEAM
        OutlinedButton(
          onPressed: !isButtonEnabled || state.isLoading
              ? null
              : () async {
            await ref.read(createTeamProvider.notifier).createTeam(
              teamName: teamNameController.text.trim(),
              teamLeadId:
              'e47703f7-09d0-46a0-91f0-4cec349166df',
            );

            if (mounted) {
              Navigator.pop(context, true);
            }
          },
          style: OutlinedButton.styleFrom(
            backgroundColor: isButtonEnabled && !state.isLoading
                ? AppColors.primaryColor
                : Colors.grey.shade400,
          ),
          child: state.isLoading
              ? const SizedBox(
            height: 18,
            width: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Colors.white,
            ),
          )
              : const Text(
            'Create Team',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),


      ],
    );
  }
}
