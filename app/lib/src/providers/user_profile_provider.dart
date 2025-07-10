// Riverpod helps us manage data that can be shared across our entire app
import 'package:flutter_riverpod/flutter_riverpod.dart';
// SharedPreferences helps us save data on the user's phone (like a mini database)
import 'package:shared_preferences/shared_preferences.dart';
// dart:convert helps us convert our data to text format for saving
import 'dart:convert';
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
  /// 1. Check if we have saved user data on the phone
  /// 2. If yes, load it and convert from text back to UserProfile object
  /// 3. If no, create some sample data for demonstration
  /// 4. Set 'state' which automatically notifies all listening widgets
  Future<void> _loadUserProfile() async {
    try {
      // Get access to phone's storage
      final prefs = await SharedPreferences.getInstance();
      // Try to find saved user profile data (stored as text)
      final profileJson = prefs.getString('user_profile');

      if (profileJson != null) {
        // We found saved data! Convert it back to UserProfile object
        final profileData = json.decode(profileJson);
        state = UserProfile.fromJson(profileData);
      } else {
        // No saved data found, create sample data for first-time users
        state = _createMockProfile();
        await _saveUserProfile();
      }
    } catch (e) {
      // If anything goes wrong, create sample data so app doesn't crash
      state = _createMockProfile();
    }
  }

  /// Save user profile to local storage (phone's memory)
  ///
  /// HOW DATA SAVING WORKS: 💾
  /// 1. Take our UserProfile object (contains all user data)
  /// 2. Convert it to text format (JSON) so it can be stored
  /// 3. Save this text to phone's permanent storage
  /// 4. Next time app opens, we can load this saved data
  Future<void> _saveUserProfile() async {
    if (state != null) {
      try {
        // Get access to phone's storage
        final prefs = await SharedPreferences.getInstance();
        // Convert UserProfile object to text format
        final profileJson = json.encode(state!.toJson());
        // Save the text to phone storage with key 'user_profile'
        await prefs.setString('user_profile', profileJson);
      } catch (e) {
        // If saving fails, print error message (in real app, we might show user a message)
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

  // Create mock profile data
  UserProfile _createMockProfile() {
    return UserProfile(
      id: 'user_001',
      fullName: 'John Smith',
      email: 'john.smith@example.com',
      phoneNumber: '9876543210',
      gender: 'Male',
      language: 'English',
      location: 'Madurai Village, Tamil Nadu',
      skills: ['Organic Farming', 'Dairy Farming', 'Cooking'],
      businesses: [
        Business(
          id: 'business_001',
          name: 'Dairy Farming',
          description: 'Small-scale dairy farm with 4 cows',
          status: BusinessStatus.active,
          createdAt: DateTime.now().subtract(const Duration(days: 30)),
        ),
        Business(
          id: 'business_002',
          name: 'Organic Vegetable Farm',
          description: 'Growing organic vegetables for local market',
          status: BusinessStatus.underReview,
          createdAt: DateTime.now().subtract(const Duration(days: 15)),
        ),
      ],
      applications: [
        Application(
          id: 'app_001',
          title: 'Dairy Farming Scheme',
          type: ApplicationType.scheme,
          status: ApplicationStatus.pending,
          dateApplied: DateTime.now().subtract(const Duration(days: 10)),
        ),
        Application(
          id: 'app_002',
          title: 'Farmer Loan',
          type: ApplicationType.loan,
          status: ApplicationStatus.approved,
          dateApplied: DateTime.now().subtract(const Duration(days: 25)),
        ),
        Application(
          id: 'app_003',
          title: 'Agricultural Grant',
          type: ApplicationType.grant,
          status: ApplicationStatus.underReview,
          dateApplied: DateTime.now().subtract(const Duration(days: 5)),
        ),
      ],
      education: 'Higher Secondary Education',
      previousOccupation: 'Agricultural Worker',
      isGovernmentIdVerified: true,
    );
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
