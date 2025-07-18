// Riverpod helps us manage data that can be shared across our entire app
import 'package:flutter_riverpod/flutter_riverpod.dart';
// SharedPreferences helps us save data on the user's phone (like a mini database)
import 'package:shared_preferences/shared_preferences.dart';
// dart:convert helps us convert our data to text format for saving
import 'dart:convert';
// Firebase Auth to get current user info
import 'package:firebase_auth/firebase_auth.dart';
// This imports our UserProfile model (the structure of user data)
import '../models/user_profile.dart';

/// WHAT IS A PROVIDER? 🤔
/// Think of a Provider like a "Smart Box" that:
/// 1. Holds our user profile data
/// 2. Lets any part of our app access this data
/// 3. Automatically tells all listening widgets when the data changes
/// 4. Saves the data to phone storage so it persists between app sessions
///
/// Why use Provider instead of just variables?
/// - Variables get lost when you close the app
/// - Providers save data permanently on the phone
/// - Multiple screens can share the same data easily
/// - When data changes, all screens update automatically

// User Profile Provider - This is our "Smart Box" for user profile data
final userProfileProvider =
    StateNotifierProvider<UserProfileNotifier, UserProfile?>((ref) {
      return UserProfileNotifier();
    });

/// UserProfileNotifier is like a "Manager" for our user profile data
///
/// WHAT DOES STATE MANAGEMENT MEAN? 🎯
/// State = The current condition or data of our app (like user's name, email, etc.)
/// Management = Controlling when and how this data changes
///
/// Think of it like a TV remote:
/// - The TV (app) shows different channels (screens)
/// - The remote (StateNotifier) controls what's shown
/// - When you press a button (user action), the TV changes (app updates)
/// - Everyone in the room (all app screens) sees the same TV (same data)
///
/// Why do we need State Management?
/// 1. Data Consistency: All screens show the same user info
/// 2. Data Persistence: User info doesn't disappear when switching screens
/// 3. Easy Updates: Change data once, all screens update automatically
/// 4. Performance: Only update what actually changed
class UserProfileNotifier extends StateNotifier<UserProfile?> {
  /// Constructor - runs when the provider is first created
  /// super(null) means initially we don't have any user profile data
  UserProfileNotifier() : super(null) {
    // As soon as this provider is created, try to load user data from phone storage
    _loadUserProfile();
  }

  /// Load user profile from local storage (phone's memory)
  ///
  /// HOW DATA LOADING WORKS: 📱
  /// 1. Check if we have saved user data for the current user
  /// 2. If yes, load it and convert from text back to UserProfile object
  /// 3. If no, create empty profile for the current user
  /// 4. Set 'state' which automatically notifies all listening widgets
  Future<void> _loadUserProfile() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        print('🔴 No current user found');
        return;
      }

      // Get access to phone's storage
      final prefs = await SharedPreferences.getInstance();
      // Create a unique key for each user based on their UID
      final userKey = 'user_profile_${currentUser.uid}';
      final profileJson = prefs.getString(userKey);

      print('🔍 Loading profile for user: ${currentUser.uid}');
      print('🔍 User email: ${currentUser.email}');
      print('🔍 Profile key: $userKey');
      print('🔍 Profile data exists: ${profileJson != null}');

      if (profileJson != null) {
        // We found saved data for this user! Convert it back to UserProfile object
        final profileData = json.decode(profileJson);
        state = UserProfile.fromJson(profileData);
        print(
          '✅ Loaded existing profile for user: ${state?.fullName} (${currentUser.email})',
        );
        bool isComplete =
            state?.fullName.isNotEmpty == true &&
            state?.phoneNumber.isNotEmpty == true &&
            state?.gender.isNotEmpty == true &&
            state?.location.isNotEmpty == true;
        print('✅ Profile is complete: $isComplete');
      } else {
        // No saved data found for this user, create empty profile
        state = _createEmptyProfile();
        print('🆕 Created empty profile for new user: ${currentUser.email}');
        print('🆕 Profile is complete: false');
        // Don't auto-save here, let the user complete the form first
      }
    } catch (e) {
      // If anything goes wrong, create empty profile so app doesn't crash
      print('❌ Error loading profile: $e');
      state = _createEmptyProfile();
    }
  }

  /// Save user profile to local storage (phone's memory)
  ///
  /// HOW DATA SAVING WORKS: 💾
  /// 1. Take our UserProfile object (contains all user data)
  /// 2. Convert it to text format (JSON) so it can be stored
  /// 3. Save this text to phone's permanent storage with user-specific key
  /// 4. Next time app opens, we can load this saved data for the specific user
  Future<void> _saveUserProfile() async {
    if (state != null) {
      try {
        final currentUser = FirebaseAuth.instance.currentUser;
        if (currentUser == null) {
          print('No current user found, cannot save profile');
          return;
        }

        // Get access to phone's storage
        final prefs = await SharedPreferences.getInstance();
        // Create a unique key for each user based on their UID
        final userKey = 'user_profile_${currentUser.uid}';
        // Convert UserProfile object to text format
        final profileJson = json.encode(state!.toJson());
        // Save the text to phone storage with user-specific key
        await prefs.setString(userKey, profileJson);
        print('Profile saved for user: ${currentUser.email}');
      } catch (e) {
        // If saving fails, print error message
        print('Error saving profile: $e');
      }
    }
  }

  /// Update basic profile information
  ///
  /// HOW UPDATING WORKS: ✏️
  /// 1. User changes something (like their name or phone number)
  /// 2. We create a new UserProfile with the updated information
  /// 3. We set this as our new 'state'
  /// 4. ALL widgets listening to this provider automatically update!
  /// 5. We save the new data to phone storage
  ///
  /// The ? after parameter names means they are optional
  /// Only the provided parameters will be updated, others stay the same
  Future<void> updateBasicInfo({
    String? fullName,
    String? email,
    String? phoneNumber,
    String? gender,
    String? language,
    String? location,
  }) async {
    if (state != null) {
      // Create new profile with updated information
      // copyWith() creates a copy but changes only the provided values
      state = state!.copyWith(
        fullName: fullName,
        email: email,
        phoneNumber: phoneNumber,
        gender: gender,
        language: language,
        location: location,
      );
      // Save the updated profile to phone storage
      await _saveUserProfile();
    }
  }

  // Update profile image
  Future<void> updateProfileImage(String imagePath) async {
    if (state != null) {
      state = state!.copyWith(profileImagePath: imagePath);
      await _saveUserProfile();
    }
  }

  // Add skill
  Future<void> addSkill(String skill) async {
    if (state != null && !state!.skills.contains(skill)) {
      final updatedSkills = [...state!.skills, skill];
      state = state!.copyWith(skills: updatedSkills);
      await _saveUserProfile();
    }
  }

  // Remove skill
  Future<void> removeSkill(String skill) async {
    if (state != null) {
      final updatedSkills = state!.skills.where((s) => s != skill).toList();
      state = state!.copyWith(skills: updatedSkills);
      await _saveUserProfile();
    }
  }

  // Update skills list
  Future<void> updateSkills(List<String> skills) async {
    if (state != null) {
      state = state!.copyWith(skills: skills);
      await _saveUserProfile();
    }
  }

  // Add business
  Future<void> addBusiness(Business business) async {
    if (state != null) {
      final updatedBusinesses = [...state!.businesses, business];
      state = state!.copyWith(businesses: updatedBusinesses);
      await _saveUserProfile();
    }
  }

  // Remove business
  Future<void> removeBusiness(String businessId) async {
    if (state != null) {
      final updatedBusinesses = state!.businesses
          .where((b) => b.id != businessId)
          .toList();
      state = state!.copyWith(businesses: updatedBusinesses);
      await _saveUserProfile();
    }
  }

  // Update business
  Future<void> updateBusiness(Business business) async {
    if (state != null) {
      final updatedBusinesses = state!.businesses.map((b) {
        return b.id == business.id ? business : b;
      }).toList();
      state = state!.copyWith(businesses: updatedBusinesses);
      await _saveUserProfile();
    }
  }

  // Add application
  Future<void> addApplication(Application application) async {
    if (state != null) {
      final updatedApplications = [...state!.applications, application];
      state = state!.copyWith(applications: updatedApplications);
      await _saveUserProfile();
    }
  }

  // Update application status
  Future<void> updateApplicationStatus(
    String applicationId,
    ApplicationStatus status,
  ) async {
    if (state != null) {
      final updatedApplications = state!.applications.map((a) {
        return a.id == applicationId ? a.copyWith(status: status) : a;
      }).toList();
      state = state!.copyWith(applications: updatedApplications);
      await _saveUserProfile();
    }
  }

  // Update additional information
  Future<void> updateAdditionalInfo({
    String? education,
    String? previousOccupation,
    bool? isGovernmentIdVerified,
  }) async {
    if (state != null) {
      state = state!.copyWith(
        education: education,
        previousOccupation: previousOccupation,
        isGovernmentIdVerified: isGovernmentIdVerified,
      );
      await _saveUserProfile();
    }
  }

  // Create empty profile for new users
  UserProfile _createEmptyProfile() {
    final user = FirebaseAuth.instance.currentUser;
    return UserProfile(
      id: user?.uid ?? 'unknown_user',
      fullName: '', // Empty - will be filled in the form
      email: user?.email ?? '',
      phoneNumber: '', // Empty - will be filled in the form
      gender: '', // Empty - will be filled in the form
      language: 'English', // Default language
      location: '', // Empty - will be filled in the form
      skills: [], // Empty list
      businesses: [], // Empty list
      applications: [], // Empty list
      education: null, // Optional
      previousOccupation: null, // Optional
      isGovernmentIdVerified: false, // Default to false
    );
  }

  /// Initialize profile for new users
  /// This creates a fresh profile for a new user but doesn't save it yet
  Future<void> initializeNewUserProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      print('Initializing new user profile for: ${user.email}');

      // Clear any existing data for this user to ensure a fresh start
      final prefs = await SharedPreferences.getInstance();
      final userKey = 'user_profile_${user.uid}';
      await prefs.remove(userKey);

      state = UserProfile(
        id: user.uid,
        fullName: user.displayName ?? '',
        email: user.email ?? '',
        phoneNumber: '',
        gender: '',
        language: 'English',
        location: '',
        skills: [],
        businesses: [],
        applications: [],
        education: null,
        previousOccupation: null,
        isGovernmentIdVerified: false,
      );
      print('New user profile initialized: ${state?.email}');
    }
  }

  /// Clear profile (useful for testing)
  Future<void> clearProfile() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      final prefs = await SharedPreferences.getInstance();
      final userKey = 'user_profile_${currentUser.uid}';
      await prefs.remove(userKey);
      state = _createEmptyProfile();
      print('Profile cleared for user: ${currentUser.email}');
    } else {
      print('No current user found, cannot clear profile');
    }
  }

  /// Reload profile for current user (useful when user changes)
  Future<void> reloadProfile() async {
    await _loadUserProfile();
  }

  /// This method ensures complete reset of user data when logging out or signing up
  /// Call this method when a user logs out to ensure clean state for next user
  Future<void> resetStateForNewUser() async {
    // Set state to null first to ensure clean slate
    state = null;

    // Wait a moment for state to clear
    await Future.delayed(const Duration(milliseconds: 100));

    // Then try to reload with current user (if any)
    await _loadUserProfile();
  }
}

// Skills suggestions provider
final skillsSuggestionsProvider = Provider<List<String>>((ref) {
  return [
    'Organic Farming',
    'Dairy Farming',
    'Poultry Farming',
    'Cooking',
    'Handicrafts',
    'Tailoring',
    'Carpentry',
    'Plumbing',
    'Electrical Work',
    'Masonry',
    'Welding',
    'Auto Repair',
    'Computer Skills',
    'English Speaking',
    'Marketing',
    'Accounting',
    'Photography',
    'Videography',
    'Teaching',
    'Nursing',
    'First Aid',
    'Driving',
    'Food Processing',
    'Beekeeping',
    'Fisheries',
    'Horticulture',
    'Animal Husbandry',
    'Textile Design',
    'Jewelry Making',
    'Soap Making',
  ];
});

// Languages provider
final languagesProvider = Provider<List<String>>((ref) {
  return [
    'English',
    'Hindi',
    'Tamil',
    'Telugu',
    'Kannada',
    'Malayalam',
    'Bengali',
    'Marathi',
    'Gujarati',
    'Punjabi',
    'Urdu',
    'Odia',
    'Assamese',
  ];
});

// Gender options provider
final genderOptionsProvider = Provider<List<String>>((ref) {
  return ['Male', 'Female', 'Other'];
});

// Auth state provider to track authentication changes
final authStateProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});
