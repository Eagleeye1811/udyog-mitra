import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../providers/user_profile_provider.dart';
import '../../pages/home/home_screen.dart';

/// UserProfileFormPage - This page is shown to users after they verify their email
/// It requires them to complete their profile before they can access the main app
class UserProfileFormPage extends ConsumerStatefulWidget {
  const UserProfileFormPage({Key? key}) : super(key: key);

  @override
  ConsumerState<UserProfileFormPage> createState() =>
      _UserProfileFormPageState();
}

class _UserProfileFormPageState extends ConsumerState<UserProfileFormPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  String _selectedGender = '';
  String _selectedLanguage = 'English';
  File? _profileImage;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();

    // Initialize the profile in case it hasn't been created yet
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userProfile = ref.read(userProfileProvider);
      if (userProfile == null) {
        ref.read(userProfileProvider.notifier).initializeNewUserProfile();
      } else {
        // Pre-fill form with any existing data
        _fullNameController.text = userProfile.fullName;
        _phoneController.text = userProfile.phoneNumber;
        _locationController.text = userProfile.location;
        if (userProfile.gender.isNotEmpty) {
          _selectedGender = userProfile.gender;
        }
        if (userProfile.language.isNotEmpty) {
          _selectedLanguage = userProfile.language;
        }
      }
    });
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedGender.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select your gender')),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final notifier = ref.read(userProfileProvider.notifier);

      // Update basic info
      await notifier.updateBasicInfo(
        fullName: _fullNameController.text.trim(),
        phoneNumber: _phoneController.text.trim(),
        gender: _selectedGender,
        language: _selectedLanguage,
        location: _locationController.text.trim(),
      );

      // Update profile image if selected
      if (_profileImage != null) {
        await notifier.updateProfileImage(_profileImage!.path);
      }

      if (mounted) {
        // Profile creation successful, navigate to home screen
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile updated successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating profile: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final genderOptions = ref.watch(genderOptionsProvider);
    final languages = ref.watch(languagesProvider);
    final userProfile = ref.watch(userProfileProvider);

    if (userProfile == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Complete Your Profile'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              final result = await showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Logout Confirmation'),
                  content: const Text(
                    'Are you sure you want to logout? Your profile data may not be saved.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: const Text('Logout'),
                    ),
                  ],
                ),
              );

              if (result == true) {
                await FirebaseAuth.instance.signOut();
              }
            },
            tooltip: 'Logout',
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 16),

                  // Profile image picker
                  GestureDetector(
                    onTap: _pickImage,
                    child: CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.grey[200],
                      backgroundImage: _profileImage != null
                          ? FileImage(_profileImage!)
                          : null,
                      child: _profileImage == null
                          ? const Icon(
                              Icons.add_a_photo,
                              size: 40,
                              color: Colors.grey,
                            )
                          : null,
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    'Tap to add a profile picture',
                    style: TextStyle(color: Colors.grey),
                  ),

                  const SizedBox(height: 24),

                  // Profile form
                  TextFormField(
                    controller: _fullNameController,
                    decoration: InputDecoration(
                      labelText: 'Full Name',
                      prefixIcon: const Icon(Icons.person),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your full name';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _phoneController,
                    decoration: InputDecoration(
                      labelText: 'Phone Number',
                      prefixIcon: const Icon(Icons.phone),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your phone number';
                      }
                      // Simple validation for a 10-digit phone number
                      if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                        return 'Please enter a valid 10-digit phone number';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  // Gender selection
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedGender.isEmpty ? null : _selectedGender,
                        hint: const Text('Select Gender'),
                        isExpanded: true,
                        icon: const Icon(Icons.arrow_drop_down),
                        items: genderOptions.map((gender) {
                          return DropdownMenuItem<String>(
                            value: gender,
                            child: Row(
                              children: [
                                Icon(
                                  gender == 'Male'
                                      ? Icons.male
                                      : gender == 'Female'
                                      ? Icons.female
                                      : Icons.person,
                                  color: Colors.green,
                                ),
                                const SizedBox(width: 10),
                                Text(gender),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedGender = value!;
                          });
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Language selection
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedLanguage,
                        isExpanded: true,
                        icon: const Icon(Icons.arrow_drop_down),
                        items: languages.map((language) {
                          return DropdownMenuItem<String>(
                            value: language,
                            child: Row(
                              children: [
                                const Icon(Icons.language, color: Colors.green),
                                const SizedBox(width: 10),
                                Text(language),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedLanguage = value!;
                          });
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _locationController,
                    decoration: InputDecoration(
                      labelText: 'Location',
                      prefixIcon: const Icon(Icons.location_on),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your location';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 32),

                  // Submit button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isSubmitting ? null : _submitForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _isSubmitting
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              'Complete Profile',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),

                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
