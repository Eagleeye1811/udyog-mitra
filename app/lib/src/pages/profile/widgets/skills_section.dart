import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/user_profile_provider.dart';

class SkillsSection extends ConsumerWidget {
  const SkillsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfile = ref.watch(userProfileProvider);

    if (userProfile == null) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Skills',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  IconButton(
                    onPressed: () => _showEditSkillsDialog(context, ref),
                    icon: Icon(Icons.edit, color: Colors.green[600]),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              if (userProfile.skills.isEmpty)
                _buildEmptyState(context, ref)
              else
                _buildSkillsGrid(context, ref, userProfile.skills),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Icon(Icons.lightbulb_outline, size: 48, color: Colors.grey[400]),
        const SizedBox(height: 8),
        Text(
          'No skills added yet',
          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
        ),
        const SizedBox(height: 12),
        ElevatedButton.icon(
          onPressed: () => _showAddSkillDialog(context, ref),
          icon: const Icon(Icons.add),
          label: const Text('Add Skill'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildSkillsGrid(
    BuildContext context,
    WidgetRef ref,
    List<String> skills,
  ) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        ...skills.map((skill) => _buildSkillChip(context, ref, skill)),
        _buildAddSkillChip(context, ref),
      ],
    );
  }

  Widget _buildSkillChip(BuildContext context, WidgetRef ref, String skill) {
    return Chip(
      label: Text(
        skill,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
      backgroundColor: Colors.green[600],
      deleteIcon: const Icon(Icons.close, color: Colors.white, size: 18),
      onDeleted: () => _removeSkill(context, ref, skill),
      side: BorderSide.none,
      labelPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
    );
  }

  Widget _buildAddSkillChip(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () => _showAddSkillDialog(context, ref),
      child: Chip(
        label: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.add, size: 16, color: Colors.green),
            SizedBox(width: 4),
            Text(
              'Add Skill',
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.green[50],
        side: BorderSide(color: Colors.green[200]!),
        labelPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      ),
    );
  }

  void _removeSkill(BuildContext context, WidgetRef ref, String skill) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Skill'),
        content: Text(
          'Are you sure you want to remove "$skill" from your skills?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              await ref.read(userProfileProvider.notifier).removeSkill(skill);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Removed $skill from skills')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }

  void _showAddSkillDialog(BuildContext context, WidgetRef ref) {
    final skillsSuggestions = ref.read(skillsSuggestionsProvider);
    final userProfile = ref.read(userProfileProvider);
    final availableSkills = skillsSuggestions
        .where((skill) => !userProfile!.skills.contains(skill))
        .toList();

    final customSkillController = TextEditingController();
    String? selectedSuggestion;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text(
            'Add Skill',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Custom skill input
                TextField(
                  controller: customSkillController,
                  decoration: const InputDecoration(
                    labelText: 'Enter custom skill',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lightbulb_outline),
                  ),
                  onChanged: (value) {
                    setState(() {
                      selectedSuggestion = null;
                    });
                  },
                ),

                const SizedBox(height: 16),

                const Text(
                  'Or select from suggestions:',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),

                const SizedBox(height: 8),

                // Skills suggestions
                SizedBox(
                  height: 200,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: availableSkills.length,
                    itemBuilder: (context, index) {
                      final skill = availableSkills[index];
                      return RadioListTile<String>(
                        title: Text(skill),
                        value: skill,
                        groupValue: selectedSuggestion,
                        onChanged: (value) {
                          setState(() {
                            selectedSuggestion = value;
                            customSkillController.clear();
                          });
                        },
                        dense: true,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                String skillToAdd = '';

                if (selectedSuggestion != null) {
                  skillToAdd = selectedSuggestion!;
                } else if (customSkillController.text.trim().isNotEmpty) {
                  skillToAdd = customSkillController.text.trim();
                }

                if (skillToAdd.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter or select a skill'),
                    ),
                  );
                  return;
                }

                await ref
                    .read(userProfileProvider.notifier)
                    .addSkill(skillToAdd);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Added $skillToAdd to skills')),
                );
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditSkillsDialog(BuildContext context, WidgetRef ref) {
    final userProfile = ref.read(userProfileProvider);
    if (userProfile == null) return;

    List<String> tempSkills = List.from(userProfile.skills);

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text(
            'Edit Skills',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (tempSkills.isEmpty)
                  const Text('No skills added yet')
                else
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: tempSkills.map((skill) {
                      return Chip(
                        label: Text(skill),
                        deleteIcon: const Icon(Icons.close, size: 18),
                        onDeleted: () {
                          setState(() {
                            tempSkills.remove(skill);
                          });
                        },
                      );
                    }).toList(),
                  ),

                const SizedBox(height: 16),

                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    _showAddSkillDialog(context, ref);
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Add New Skill'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                await ref
                    .read(userProfileProvider.notifier)
                    .updateSkills(tempSkills);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Skills updated successfully')),
                );
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
