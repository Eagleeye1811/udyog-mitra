import 'package:flutter/material.dart';
import 'package:udyogmitra/src/config/themes/app_theme.dart';
import 'package:udyogmitra/src/config/themes/helpers.dart';

class SkillInputScreen extends StatefulWidget {
  final Function(List<String>) onSkillsSubmitted;
  final VoidCallback onBack;

  const SkillInputScreen({
    super.key,
    required this.onSkillsSubmitted,
    required this.onBack,
  });

  @override
  State<SkillInputScreen> createState() => _SkillInputScreenState();
}

class _SkillInputScreenState extends State<SkillInputScreen> {
  final List<String> _skills = [];
  final TextEditingController _skillController = TextEditingController();

  // Predefined skill suggestions
  final List<String> _skillSuggestions = [
    'Digital Marketing',
    'Web Development',
    'Graphic Design',
    'Data Analysis',
    'Content Writing',
    'Social Media Management',
    'Photography',
    'Video Editing',
    'Customer Service',
    'Project Management',
    'Sales',
    'Accounting',
    'Cooking',
    'Teaching',
    'Programming',
    'Language Translation',
    'Consulting',
    'Event Planning',
    'Mobile App Development',
    'SEO/SEM',
  ];

  void _addSkill(String skill) {
    if (skill.isNotEmpty && !_skills.contains(skill)) {
      setState(() {
        _skills.add(skill);
        _skillController.clear();
      });
    }
  }

  void _removeSkill(String skill) {
    setState(() {
      _skills.remove(skill);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'What are your skills?',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2E7D32),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Enter your skills to get personalized business ideas that match your expertise.',
            style: context.textStyles.bodySmall.darkGrey(context),
          ),
          const SizedBox(height: 24),

          // Skill input field
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _skillController,
                  decoration: const InputDecoration(
                    hintText: 'Enter a skill...',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lightbulb_outline),
                  ),
                  onSubmitted: _addSkill,
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () => _addSkill(_skillController.text),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E7D32),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                ),
                child: const Icon(Icons.add),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Added skills
          if (_skills.isNotEmpty) ...[
            const Text(
              'Your Skills:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2E7D32),
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _skills.map((skill) {
                return Chip(
                  label: Text(
                    skill,
                    style: context.textStyles.labelMedium.white(),
                  ),
                  backgroundColor: const Color(0xFF2E7D32),
                  labelStyle: context.textStyles.bodySmall,
                  deleteIcon: Icon(
                    Icons.close,
                    size: 18,
                    color: Colors.white70,
                  ),
                  onDeleted: () => _removeSkill(skill),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
          ],

          // Skill suggestions
          const Text(
            'Popular Skills:',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2E7D32),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              itemCount: _skillSuggestions.length,
              itemBuilder: (context, index) {
                final suggestion = _skillSuggestions[index];
                final isAdded = _skills.contains(suggestion);

                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  elevation: 2,
                  child: ListTile(
                    leading: Icon(
                      isAdded ? Icons.check_circle : Icons.add_circle_outline,
                      color: isAdded ? Colors.green : const Color(0xFF2E7D32),
                    ),
                    title: Text(
                      suggestion,
                      style: isAdded
                          ? context.textStyles.labelLarge
                          : context.textStyles.bodySmall.grey(context),
                    ),
                    onTap: isAdded ? null : () => _addSkill(suggestion),
                    enabled: !isAdded,
                  ),
                );
              },
            ),
          ),

          // Navigation buttons
          const SizedBox(height: 16),
          Row(
            children: [
              TextButton(
                onPressed: widget.onBack,
                child: const Text(
                  'Back',
                  style: TextStyle(
                    fontSize: 17,
                    color: Color(0xFF2E7D32),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: _skills.isNotEmpty
                    ? () => widget.onSkillsSubmitted(_skills)
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E7D32),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
                ),
                child: Text(
                  'Generate Business Ideas',
                  style: context.textStyles.labelSmall.white().bold(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _skillController.dispose();
    super.dispose();
  }
}
