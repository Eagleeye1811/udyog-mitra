import 'package:flutter/material.dart';
import 'package:udyogmitra/src/pages/profile/profile_image_section.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 217, 255, 219),
        gradient: LinearGradient(
          colors: [
            const Color.fromARGB(255, 206, 249, 216),
            const Color.fromARGB(255, 237, 254, 241),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        border: Border.symmetric(
          horizontal: BorderSide(
            width: 1,
            color: const Color.fromARGB(255, 193, 193, 193),
          ),
        ),
      ),
      padding: EdgeInsets.symmetric(vertical: 10),
      margin: EdgeInsets.symmetric(vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ProfileImageSection(),

          const SizedBox(height: 5),

          Text(
            "John Smith",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.location_on_outlined, size: 18),
              const SizedBox(width: 5),
              Text(
                "Madurai Village, Tamil Nadu",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: const Color.fromARGB(255, 134, 134, 134),
                ),
              ),
            ],
          ),

          const SizedBox(height: 4),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.translate, size: 18),
              const SizedBox(width: 5),
              Text(
                "English",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: const Color.fromARGB(255, 134, 134, 134),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
