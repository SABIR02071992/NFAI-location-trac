import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controller/add_team_member_notifier.dart';

class AddTeamMemberDialog extends ConsumerStatefulWidget {
  final String teamId;
  final List<dynamic> eligibleUsers;

  const AddTeamMemberDialog({
    super.key,
    required this.teamId,
    required this.eligibleUsers,
  });

  @override
  ConsumerState<AddTeamMemberDialog> createState() =>
      _AddTeamMemberDialogState();
}

class _AddTeamMemberDialogState extends ConsumerState<AddTeamMemberDialog> {
  String? selectedUserId;

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(addTeamMemberProvider);

    return AlertDialog(
      title: const Text('Add Team Member'),
      content: DropdownButtonFormField<String>(
        value: selectedUserId,
        decoration: const InputDecoration(labelText: 'Select User'),
        items: widget.eligibleUsers.map<DropdownMenuItem<String>>((u) {
          return DropdownMenuItem<String>(
            value: u['id'].toString(),
            child: Text('${u['name']} (${u['designation']})'),
          );
        }).toList(),
        onChanged: (val) => setState(() => selectedUserId = val),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: selectedUserId == null || isLoading
              ? null
              : () async {
                  await ref
                      .read(addTeamMemberProvider.notifier)
                      .addMember(
                        teamId: widget.teamId,
                        userId: selectedUserId!,
                      );
                  Navigator.pop(context, true);
                },
          child: isLoading
              ? const CircularProgressIndicator()
              : const Text('Add'),
        ),
      ],
    );
  }
}
