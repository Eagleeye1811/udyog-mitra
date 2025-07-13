import 'package:flutter/material.dart';

/// WHAT ARE MODELS? 🏗️
///
/// Think of Models like "Blueprints" or "Templates" for our data:
///
/// Real Life Example:
/// - A house blueprint shows where rooms, doors, windows should be
/// - Everyone building that house follows the same blueprint
/// - This ensures all houses have the same structure
///
/// In Our App:
/// - UserProfile model shows what information a user should have
/// - Every user in our app follows this same structure
/// - This ensures our app always knows what data to expect
///
/// Why Do We Need Models?
/// 1. ORGANIZATION: Keeps related data together (like all user info in one place)
/// 2. CONSISTENCY: Every user has the same type of information
/// 3. ERROR PREVENTION: App won't crash if we try to access non-existent data
/// 4. EASY TO UNDERSTAND: Other developers immediately know what data we store
/// 5. DATA VALIDATION: We can check if the data is correct before using it

/// UserProfile Model - The "Blueprint" for user information
///
/// This class defines what information we store about each user:
/// - Personal details (name, email, phone)
/// - Preferences (language, location)
/// - Professional info (skills, businesses, applications)
/// - Verification status (government ID verified or not)
class UserProfile {
  // These are all the pieces of information we store about a user
  // 'final' means once set, these values cannot be accidentally changed
  // 'required' means these MUST be provided when creating a user profile
  // '?' means this information is optional (can be empty)

  final String id; // Unique identifier for this user
  final String fullName; // User's complete name
  final String email; // User's email address
  final String phoneNumber; // User's phone number
  final String gender; // User's gender
  final String language; // User's preferred language
  final String location; // Where the user lives
  final String? profileImagePath; // Path to user's profile picture (optional)
  final List<String> skills; // List of user's skills
  final List<Business> businesses; // List of user's registered businesses
  final List<Application>
  applications; // List of user's job/scheme applications
  final String? education; // User's educational background (optional)
  final String? previousOccupation; // User's previous job (optional)
  final bool isGovernmentIdVerified; // Whether user's ID is verified

  /// Constructor - This is like a "factory" that creates new UserProfile objects
  ///
  /// When we want to create a new user profile, we call:
  /// UserProfile(id: "123", fullName: "John Doe", email: "john@example.com", ...)
  ///
  /// The constructor ensures we provide all required information
  /// and sets default values for optional information
  UserProfile({
    required this.id, // Must provide
    required this.fullName, // Must provide
    required this.email, // Must provide
    required this.phoneNumber, // Must provide
    required this.gender, // Must provide
    required this.language, // Must provide
    required this.location, // Must provide
    this.profileImagePath, // Optional - can be null
    this.skills = const [], // Default to empty list if not provided
    this.businesses = const [], // Default to empty list if not provided
    this.applications = const [], // Default to empty list if not provided
    this.education, // Optional - can be null
    this.previousOccupation, // Optional - can be null
    this.isGovernmentIdVerified = false, // Default to false (not verified)
  });

  /// copyWith - Creates a copy of this profile with some information changed
  ///
  /// WHY DO WE NEED copyWith? 🔄
  ///
  /// In programming, we can't just change parts of an object directly because:
  /// 1. It can cause bugs and confusion
  /// 2. Other parts of the app might be using the old data
  /// 3. We lose track of what changed and when
  ///
  /// Instead, we create a NEW object with the changes we want.
  /// Think like editing a document:
  /// - Instead of erasing and rewriting parts
  /// - We make a new copy with the changes
  /// - The original stays safe, and we can compare them
  ///
  /// Example: If user changes their name from "John" to "Johnny":
  /// 1. Create new UserProfile with name = "Johnny"
  /// 2. All other info (email, phone, etc.) stays the same
  /// 3. Replace the old profile with this new one
  UserProfile copyWith({
    String? id,
    String? fullName,
    String? email,
    String? phoneNumber,
    String? gender,
    String? language,
    String? location,
    String? profileImagePath,
    List<String>? skills,
    List<Business>? businesses,
    List<Application>? applications,
    String? education,
    String? previousOccupation,
    bool? isGovernmentIdVerified,
  }) {
    return UserProfile(
      // The ?? operator means "if the new value is provided, use it; otherwise, keep the old value"
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      gender: gender ?? this.gender,
      language: language ?? this.language,
      location: location ?? this.location,
      profileImagePath: profileImagePath ?? this.profileImagePath,
      skills: skills ?? this.skills,
      businesses: businesses ?? this.businesses,
      applications: applications ?? this.applications,
      education: education ?? this.education,
      previousOccupation: previousOccupation ?? this.previousOccupation,
      isGovernmentIdVerified:
          isGovernmentIdVerified ?? this.isGovernmentIdVerified,
    );
  }

  /// toJson - Converts our UserProfile object to a text format for saving
  ///
  /// WHY CONVERT TO JSON? 📝
  ///
  /// Think of JSON like a "universal language" for data:
  /// - Phones/computers can only save text, not complex objects
  /// - JSON is a special text format that represents our data structure
  /// - It's like translating from English to French - same meaning, different format
  ///
  /// Example: UserProfile object becomes text like:
  /// {"id": "123", "fullName": "John Doe", "email": "john@example.com", ...}
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'phoneNumber': phoneNumber,
      'gender': gender,
      'language': language,
      'location': location,
      'profileImagePath': profileImagePath,
      'skills': skills,
      // Convert complex objects (businesses, applications) to JSON too
      'businesses': businesses.map((b) => b.toJson()).toList(),
      'applications': applications.map((a) => a.toJson()).toList(),
      'education': education,
      'previousOccupation': previousOccupation,
      'isGovernmentIdVerified': isGovernmentIdVerified,
    };
  }

  /// fromJson - Converts saved text back to a UserProfile object
  ///
  /// This is the reverse of toJson():
  /// - We load the saved text from phone storage
  /// - We convert it back to a UserProfile object our app can use
  /// - Like translating from French back to English
  ///
  /// The ?? operator provides default values if some data is missing
  /// (this prevents our app from crashing if old saved data is incomplete)
  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] ?? '', // Use empty string if missing
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      gender: json['gender'] ?? '',
      language: json['language'] ?? 'English', // Default to English
      location: json['location'] ?? '',
      profileImagePath: json['profileImagePath'], // Can be null
      skills: List<String>.from(json['skills'] ?? []), // Default to empty list
      businesses:
          (json['businesses'] as List<dynamic>?)
              ?.map((b) => Business.fromJson(b))
              .toList() ??
          [],
      applications:
          (json['applications'] as List<dynamic>?)
              ?.map((a) => Application.fromJson(a))
              .toList() ??
          [],
      education: json['education'], // Can be null
      previousOccupation: json['previousOccupation'], // Can be null
      isGovernmentIdVerified:
          json['isGovernmentIdVerified'] ?? false, // Default to false
    );
  }
}

/// Business Model - Blueprint for business information
///
/// This represents a business that a user has registered.
/// Users can have multiple businesses, so we store them in a list.
class Business {
  final String id; // Unique identifier for this business
  final String name; // Name of the business
  final String description;
  final BusinessStatus status;
  final DateTime createdAt;

  Business({
    required this.id,
    required this.name,
    required this.description,
    required this.status,
    required this.createdAt,
  });

  Business copyWith({
    String? id,
    String? name,
    String? description,
    BusinessStatus? status,
    DateTime? createdAt,
  }) {
    return Business(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'status': status.name,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Business.fromJson(Map<String, dynamic> json) {
    return Business(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      status: BusinessStatus.values.firstWhere(
        (s) => s.name == json['status'],
        orElse: () => BusinessStatus.pending,
      ),
      createdAt: DateTime.parse(
        json['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }
}

enum BusinessStatus { active, pending, underReview, rejected, suspended }

extension BusinessStatusExtension on BusinessStatus {
  String get displayName {
    switch (this) {
      case BusinessStatus.active:
        return 'Active';
      case BusinessStatus.pending:
        return 'Pending';
      case BusinessStatus.underReview:
        return 'Under Review';
      case BusinessStatus.rejected:
        return 'Rejected';
      case BusinessStatus.suspended:
        return 'Suspended';
    }
  }

  Color get color {
    switch (this) {
      case BusinessStatus.active:
        return Colors.green;
      case BusinessStatus.pending:
        return Colors.orange;
      case BusinessStatus.underReview:
        return Colors.blue;
      case BusinessStatus.rejected:
        return Colors.red;
      case BusinessStatus.suspended:
        return Colors.grey;
    }
  }
}

class Application {
  final String id;
  final String title;
  final ApplicationType type;
  final ApplicationStatus status;
  final DateTime dateApplied;

  Application({
    required this.id,
    required this.title,
    required this.type,
    required this.status,
    required this.dateApplied,
  });

  Application copyWith({
    String? id,
    String? title,
    ApplicationType? type,
    ApplicationStatus? status,
    DateTime? dateApplied,
  }) {
    return Application(
      id: id ?? this.id,
      title: title ?? this.title,
      type: type ?? this.type,
      status: status ?? this.status,
      dateApplied: dateApplied ?? this.dateApplied,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'type': type.name,
      'status': status.name,
      'dateApplied': dateApplied.toIso8601String(),
    };
  }

  factory Application.fromJson(Map<String, dynamic> json) {
    return Application(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      type: ApplicationType.values.firstWhere(
        (t) => t.name == json['type'],
        orElse: () => ApplicationType.scheme,
      ),
      status: ApplicationStatus.values.firstWhere(
        (s) => s.name == json['status'],
        orElse: () => ApplicationStatus.pending,
      ),
      dateApplied: DateTime.parse(
        json['dateApplied'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }
}

enum ApplicationType { scheme, job, loan, grant }

extension ApplicationTypeExtension on ApplicationType {
  String get displayName {
    switch (this) {
      case ApplicationType.scheme:
        return 'Scheme';
      case ApplicationType.job:
        return 'Job';
      case ApplicationType.loan:
        return 'Loan';
      case ApplicationType.grant:
        return 'Grant';
    }
  }

  IconData get icon {
    switch (this) {
      case ApplicationType.scheme:
        return Icons.gavel;
      case ApplicationType.job:
        return Icons.work;
      case ApplicationType.loan:
        return Icons.account_balance;
      case ApplicationType.grant:
        return Icons.monetization_on;
    }
  }
}

enum ApplicationStatus { pending, approved, rejected, underReview, completed }

extension ApplicationStatusExtension on ApplicationStatus {
  String get displayName {
    switch (this) {
      case ApplicationStatus.pending:
        return 'Pending';
      case ApplicationStatus.approved:
        return 'Approved';
      case ApplicationStatus.rejected:
        return 'Rejected';
      case ApplicationStatus.underReview:
        return 'Under Review';
      case ApplicationStatus.completed:
        return 'Completed';
    }
  }

  Color get color {
    switch (this) {
      case ApplicationStatus.pending:
        return Colors.orange;
      case ApplicationStatus.approved:
        return Colors.green;
      case ApplicationStatus.rejected:
        return Colors.red;
      case ApplicationStatus.underReview:
        return Colors.blue;
      case ApplicationStatus.completed:
        return Colors.teal;
    }
  }

  IconData get icon {
    switch (this) {
      case ApplicationStatus.pending:
        return Icons.schedule;
      case ApplicationStatus.approved:
        return Icons.check_circle;
      case ApplicationStatus.rejected:
        return Icons.cancel;
      case ApplicationStatus.underReview:
        return Icons.visibility;
      case ApplicationStatus.completed:
        return Icons.done_all;
    }
  }
}
