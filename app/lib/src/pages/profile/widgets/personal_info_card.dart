import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:udyogmitra/src/config/themes/app_theme.dart';
import 'package:udyogmitra/src/config/themes/helpers.dart';
import '../../../providers/user_profile_provider.dart';

class PersonalInfoCard extends ConsumerWidget {
  const PersonalInfoCard({super.key});

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
                  Text(
                    'Personal Information',
                    style: context.textStyles.titleLarge,
                  ),
                  IconButton(
                    onPressed: () => _showEditDialog(context, ref),
                    icon: Icon(Icons.edit, color: Colors.green[600]),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              _buildInfoRow(
                context,
                'Full Name',
                userProfile.fullName,
                Icons.person_outline,
              ),

              const SizedBox(height: 12),

              _buildInfoRow(
                context,
                'Email',
                userProfile.email,
                Icons.email_outlined,
              ),

              const SizedBox(height: 12),

              _buildInfoRow(
                context,
                'Phone Number',
                userProfile.phoneNumber,
                Icons.phone_outlined,
              ),

              const SizedBox(height: 12),

              _buildInfoRow(
                context,
                'Gender',
                userProfile.gender,
                Icons.person_outline,
              ),

              const SizedBox(height: 12),

              _buildInfoRow(
                context,
                'Language',
                userProfile.language,
                Icons.translate,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Colors.green[600]),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: context.textStyles.bodySmall.grey(context)),
              const SizedBox(height: 2),
              Text(value, style: context.textStyles.bodyMedium),
            ],
          ),
        ),
      ],
    );
  }

  void _showEditDialog(BuildContext context, WidgetRef ref) {
    final userProfile = ref.read(userProfileProvider);
    final genderOptions = ref.read(genderOptionsProvider);
    final languages = ref.read(languagesProvider);

    if (userProfile == null) return;

    final fullNameController = TextEditingController(
      text: userProfile.fullName,
    );
    final emailController = TextEditingController(text: userProfile.email);
    final phoneController = TextEditingController(
      text: userProfile.phoneNumber,
    );
    String selectedGender = userProfile.gender;
    String selectedLanguage = userProfile.language;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(
            'Edit Personal Information',
            style: context.textStyles.titleLarge,
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Full Name
                TextField(
                  controller: fullNameController,
                  decoration: const InputDecoration(
                    labelText: 'Full Name',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                ),

                const SizedBox(height: 16),

                // Email
                TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                ),

                const SizedBox(height: 16),

                // Phone Number
                TextField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: 'Phone Number',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.phone_outlined),
                  ),
                ),

                const SizedBox(height: 16),

                // Gender Dropdown
                DropdownButtonFormField<String>(
                  value: selectedGender,
                  decoration: const InputDecoration(
                    labelText: 'Gender',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                  items: genderOptions.map((gender) {
                    return DropdownMenuItem<String>(
                      value: gender,
                      child: Text(gender),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedGender = value!;
                    });
                  },
                ),

                const SizedBox(height: 16),

                // Language Dropdown
                DropdownButtonFormField<String>(
                  value: selectedLanguage,
                  decoration: const InputDecoration(
                    labelText: 'Language',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.translate),
                  ),
                  items: languages.map((language) {
                    return DropdownMenuItem<String>(
                      value: language,
                      child: Text(language),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedLanguage = value!;
                    });
                  },
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
                // Validate inputs
                if (fullNameController.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter full name')),
                  );
                  return;
                }

                if (!RegExp(
                  r'^[^@]+@[^@]+\.[^@]+$',
                ).hasMatch(emailController.text.trim())) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter a valid email')),
                  );
                  return;
                }

                if (!RegExp(
                  r'^[0-9]{10}$',
                ).hasMatch(phoneController.text.trim())) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Please enter a valid 10-digit phone number',
                      ),
                    ),
                  );
                  return;
                }

                // Update profile
                await ref
                    .read(userProfileProvider.notifier)
                    .updateBasicInfo(
                      fullName: fullNameController.text.trim(),
                      email: emailController.text.trim(),
                      phoneNumber: phoneController.text.trim(),
                      gender: selectedGender,
                      language: selectedLanguage,
                    );

                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Profile updated successfully')),
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
