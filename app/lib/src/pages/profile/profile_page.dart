import 'package:flutter/material.dart';
import 'package:udyogmitra/src/pages/profile/personal_info.dart';
import 'package:udyogmitra/src/pages/profile/profile_header.dart';
import 'package:udyogmitra/src/pages/profile/user_business.dart';
import 'package:udyogmitra/src/pages/profile/user_documents.dart';
import 'package:udyogmitra/src/pages/profile/user_skills.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Profile Page",
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/home');
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          margin: EdgeInsets.only(bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Profile Header
              ProfileHeader(),

              const SizedBox(height: 15),

              // Personal Info
              PersonalInfo(),

              const SizedBox(height: 15),

              // Skills
              UserSkills(),

              const SizedBox(height: 20),

              // Selected Business
              UserBusiness(),

              const SizedBox(height: 20),

              // User Documents
              UserDocuments(),

              const SizedBox(height: 20),

              // Change Password
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                      side: BorderSide(
                        color: const Color.fromARGB(255, 102, 54, 145),
                        width: 1.5,
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.edit, size: 24),
                      const SizedBox(width: 10),
                      Text(
                        "Change Password",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Logout
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 249, 233, 232),
                    padding: EdgeInsets.symmetric(vertical: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                      side: BorderSide(
                        color: const Color.fromARGB(255, 255, 104, 104),
                        width: 1.5,
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.exit_to_app, size: 24, color: Colors.red),
                      const SizedBox(width: 10),
                      Text(
                        "Logout",
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
