import 'dart:io';
import 'package:flutter/material.dart';
// flutter_riverpod is our state management solution
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
// This imports our provider that manages user profile data
import '../../../providers/user_profile_provider.dart';

/// ProfileHeaderWidget - Shows user's profile picture, name, location, and language
///
/// HOW THIS WIDGET CONNECTS TO OUR STATE MANAGEMENT: 🔗
///
/// 1. This widget extends ConsumerStatefulWidget (not just StatefulWidget)
///    - Consumer = Can "listen" to changes in our user profile data
///    - Stateful = Can have its own internal state (like temporary profile image)
///
/// 2. It uses ref.watch(userProfileProvider) to get current user data
///    - When user data changes, this widget automatically rebuilds
///    - This ensures the header always shows the latest information
///
/// 3. It uses ref.read(userProfileProvider.notifier) to update user data
///    - When user picks a new image or edits location/language
///    - Changes are saved and all other widgets see the updates immediately
///
/// 4. The widget manages both:
///    - Global state (user profile data shared across the app)
///    - Local state (temporary image selection before saving)
class ProfileHeaderWidget extends ConsumerStatefulWidget {
  const ProfileHeaderWidget({super.key});

  @override
  ConsumerState<ProfileHeaderWidget> createState() =>
      _ProfileHeaderWidgetState();
}

class _ProfileHeaderWidgetState extends ConsumerState<ProfileHeaderWidget> {
  File? _profileImage;

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _profileImage = File(picked.path);
      });

      // Update profile image in provider
      await ref
          .read(userProfileProvider.notifier)
          .updateProfileImage(picked.path);
    }
  }

  void _showLocationEditDialog(BuildContext context) {
    final userProfile = ref.read(userProfileProvider);
    if (userProfile == null) return;

    final locationController = TextEditingController(
      text: userProfile.location,
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Edit Location',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: TextField(
          controller: locationController,
          decoration: const InputDecoration(
            labelText: 'Location',
            hintText: 'Enter your location',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.location_on),
          ),
          maxLines: 2,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final newLocation = locationController.text.trim();
              if (newLocation.isNotEmpty) {
                await ref
                    .read(userProfileProvider.notifier)
                    .updateBasicInfo(location: newLocation);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Location updated successfully'),
                  ),
                );
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showLanguageEditDialog(BuildContext context) {
    final userProfile = ref.read(userProfileProvider);
    final languages = ref.read(languagesProvider);
    if (userProfile == null) return;

    String selectedLanguage = userProfile.language;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text(
            'Select Language',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: languages.length,
              itemBuilder: (context, index) {
                final language = languages[index];
                return RadioListTile<String>(
                  title: Text(language),
                  value: language,
                  groupValue: selectedLanguage,
                  onChanged: (value) {
                    setState(() {
                      selectedLanguage = value!;
                    });
                  },
                );
              },
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
                    .updateBasicInfo(language: selectedLanguage);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Language updated successfully'),
                  ),
                );
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProfile = ref.watch(userProfileProvider);

    if (userProfile == null) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green[100]!, Colors.green[50]!],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      child: Column(
        children: [
          // Profile Picture
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              CircleAvatar(
                radius: 60,
                backgroundColor: Colors.grey[300],
                backgroundImage: _profileImage != null
                    ? FileImage(_profileImage!)
                    : userProfile.profileImagePath != null
                    ? FileImage(File(userProfile.profileImagePath!))
                    : null,
                child:
                    (_profileImage == null &&
                        userProfile.profileImagePath == null)
                    ? const Icon(Icons.person, size: 60, color: Colors.white)
                    : null,
              ),
              Positioned(
                bottom: 4,
                right: 4,
                child: GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.edit,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Name
          Text(
            userProfile.fullName,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 12),

          // Location
          GestureDetector(
            onTap: () => _showLocationEditDialog(context),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.green[200]!),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    size: 18,
                    color: Colors.green[700],
                  ),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      userProfile.location,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[700],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(Icons.edit, size: 14, color: Colors.green[700]),
                ],
              ),
            ),
          ),

          const SizedBox(height: 8),

          // Language
          GestureDetector(
            onTap: () => _showLanguageEditDialog(context),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.green[200]!),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.translate, size: 18, color: Colors.green[700]),
                  const SizedBox(width: 6),
                  Text(
                    userProfile.language,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(Icons.edit, size: 14, color: Colors.green[700]),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
