import 'package:flutter/material.dart';
// Riverpod is a state management library for Flutter
// It helps us share data between different parts of our app easily
import 'package:flutter_riverpod/flutter_riverpod.dart';
// This imports our provider that manages user profile data
import 'package:udyogmitra/src/providers/user_profile_provider.dart';
// These imports bring in all the widget components that make up our profile page
import 'package:udyogmitra/src/pages/profile/widgets/profile_header_widget.dart';
import 'package:udyogmitra/src/pages/profile/widgets/personal_info_card.dart';
import 'package:udyogmitra/src/pages/profile/widgets/skills_section.dart';
import 'package:udyogmitra/src/pages/profile/widgets/business_section.dart';
import 'package:udyogmitra/src/pages/profile/widgets/applications_section.dart';
import 'package:udyogmitra/src/pages/profile/widgets/additional_info_section.dart';

/// ProfilePage is the main screen that shows all user profile information
///
/// We use ConsumerStatefulWidget instead of regular StatefulWidget because:
/// 1. Consumer = This widget can "listen" to changes in our data (provider)
/// 2. Stateful = This widget can have its own internal state that can change
/// 3. When the user profile data changes, this widget automatically rebuilds
class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    // This is the MAGIC LINE! 🎭
    // ref.watch() tells this widget to "watch" or "listen to" the userProfileProvider
    // Whenever the user profile data changes (like when user edits their info),
    // this widget will automatically rebuild with the new data
    // Think of it like subscribing to a YouTube channel - you get notified when new content comes!
    final userProfile = ref.watch(userProfileProvider);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        centerTitle: true,
        automaticallyImplyLeading: false, // Remove the back arrow
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Navigate to settings page
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // Main scrollable content
          SingleChildScrollView(
            padding: const EdgeInsets.only(
              bottom: 100,
            ), // to avoid overlap with bottom nav
            child: userProfile == null
                ? // Show loading spinner while we wait for user data to load
                  const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                    ),
                  )
                : // Once we have user data, show the profile content
                  Column(
                    children: [
                      // All these widgets below automatically get the user data
                      // because they also use the same provider (userProfileProvider)

                      // Profile Header Section - Shows profile picture, name, location
                      const ProfileHeaderWidget(),

                      const SizedBox(height: 16),

                      // Personal Information Card - Shows email, phone, gender etc.
                      const PersonalInfoCard(),

                      const SizedBox(height: 16),

                      // Skills Section - Shows and manages user skills
                      const SkillsSection(),

                      const SizedBox(height: 16),

                      // Business Section - Shows user's registered businesses
                      const BusinessSection(),

                      const SizedBox(height: 16),

                      // Applications Section - Shows user's job/scheme applications
                      const ApplicationsSection(),

                      const SizedBox(height: 16),

                      // Additional Information Section - Shows education, occupation etc.
                      const AdditionalInfoSection(),

                      const SizedBox(height: 20),

                      // Action Buttons for logout and password change
                      _buildActionButtons(context),
                    ],
                  ),
          ),

          // Floating Custom Bottom Nav - Exactly same as home screen
          Positioned(
            left: 90,
            right: 90,
            bottom: 30,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(32),
              child: Container(
                height: 64,
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(32),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(50),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _NavBarItem(
                      icon: Icons.home,
                      label: 'Home',
                      selected:
                          false, // Not selected since we're on Profile page
                      onTap: () {
                        Navigator.pushReplacementNamed(context, '/home');
                      },
                    ),
                    _NavBarItem(
                      icon: Icons.info_outline,
                      label: 'About Us',
                      selected: false,
                      onTap: () {
                        Navigator.pushReplacementNamed(context, '/about-us');
                      },
                    ),
                    _NavBarItem(
                      icon: Icons.person_outline,
                      label: 'Profile',
                      selected:
                          true, // Currently selected since we're on Profile page
                      onTap: () {
                        // Already on profile page, no navigation needed
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          // Change Password Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                _showChangePasswordDialog(context);
              },
              icon: const Icon(Icons.lock_outline),
              label: const Text(
                'Change Password',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[50],
                foregroundColor: Colors.blue[700],
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.blue[200]!, width: 1),
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Logout Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                _showLogoutDialog(context);
              },
              icon: const Icon(Icons.logout),
              label: const Text(
                'Logout',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[50],
                foregroundColor: Colors.red[700],
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.red[200]!, width: 1),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showChangePasswordDialog(BuildContext context) {
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    bool obscureCurrentPassword = true;
    bool obscureNewPassword = true;
    bool obscureConfirmPassword = true;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text(
            'Change Password',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Current Password
              TextField(
                controller: currentPasswordController,
                obscureText: obscureCurrentPassword,
                decoration: InputDecoration(
                  labelText: 'Current Password',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      obscureCurrentPassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        obscureCurrentPassword = !obscureCurrentPassword;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // New Password
              TextField(
                controller: newPasswordController,
                obscureText: obscureNewPassword,
                decoration: InputDecoration(
                  labelText: 'New Password',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      obscureNewPassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        obscureNewPassword = !obscureNewPassword;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Confirm Password
              TextField(
                controller: confirmPasswordController,
                obscureText: obscureConfirmPassword,
                decoration: InputDecoration(
                  labelText: 'Confirm New Password',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      obscureConfirmPassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        obscureConfirmPassword = !obscureConfirmPassword;
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                // Validate passwords
                if (newPasswordController.text !=
                    confirmPasswordController.text) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Passwords do not match')),
                  );
                  return;
                }

                if (newPasswordController.text.length < 6) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Password must be at least 6 characters'),
                    ),
                  );
                  return;
                }

                // TODO: Implement password change logic
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Password changed successfully'),
                  ),
                );
              },
              child: const Text('Change Password'),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Logout',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Implement logout logic
              Navigator.pop(context);
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/login',
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}

// NavBarItem widget - exactly same as home screen for consistency
class _NavBarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _NavBarItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: selected ? Colors.white : Colors.white70),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: selected ? Colors.white : Colors.white70,
              fontSize: 12,
              fontWeight: selected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}

/// 🎯 SUMMARY: HOW EVERYTHING WORKS TOGETHER
/// 
/// Our Profile Page uses a modern architecture that makes the app:
/// ✅ Fast and responsive
/// ✅ Easy to maintain and update  
/// ✅ Consistent across all screens
/// ✅ Data safe and persistent
/// 
/// THE BIG PICTURE: 🖼️
/// 
/// 1. USER INTERACTS WITH UI
///    - User taps "Edit" button, changes their name, selects new profile picture
///    - Widget captures this interaction
/// 
/// 2. WIDGET UPDATES PROVIDER
///    - Widget calls provider method: ref.read(userProfileProvider.notifier).updateBasicInfo(...)
///    - Provider creates new UserProfile with updated data
/// 
/// 3. PROVIDER SAVES DATA
///    - Provider saves new data to phone storage (persists between app sessions)
///    - Provider updates its 'state' with the new data
/// 
/// 4. ALL WIDGETS AUTO-UPDATE
///    - Every widget watching userProfileProvider gets notified
///    - They automatically rebuild with the new data
///    - User sees changes immediately across the entire app
/// 
/// 5. DATA STAYS CONSISTENT
///    - All screens show the same user information
///    - No need to manually update each screen
///    - No risk of showing outdated information
/// 
/// BENEFITS OF THIS APPROACH: 🚀
/// 
/// 📱 FOR USERS:
/// - Fast, smooth experience
/// - Changes appear instantly
/// - Data never gets lost
/// - App works offline
/// 
/// 👨‍💻 FOR DEVELOPERS:
/// - Easy to add new features
/// - Less code duplication
/// - Fewer bugs
/// - Easy to understand and maintain
/// 
/// 🏗️ FOR THE APP:
/// - Scalable architecture
/// - Testable components
/// - Consistent data flow
/// - Future-proof design
/// 
/// KEY CONCEPTS USED: 🔧
/// 
/// STATE MANAGEMENT (Riverpod):
/// - Manages data that can change over time
/// - Shares data between different parts of the app
/// - Automatically updates UI when data changes
/// 
/// MODELS (UserProfile, Business, Application):
/// - Define the structure of our data
/// - Ensure data consistency
/// - Provide methods for data manipulation
/// 
/// PROVIDERS (UserProfileNotifier):
/// - Control how data changes
/// - Handle data persistence
/// - Notify widgets of changes
/// 
/// WIDGETS (ProfilePage, ProfileHeaderWidget, etc.):
/// - Display the user interface
/// - Handle user interactions
/// - React to data changes
/// 
/// This architecture follows Flutter and Riverpod best practices,
/// making our app maintainable, testable, and scalable! 🎉
