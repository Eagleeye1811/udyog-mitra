import 'package:flutter/material.dart';

class UserProfile {
  String fullName;
  String email;
  String phoneNumber;
  String gender;
  String password;

  UserProfile({
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.gender,
    required this.password,
  });
}

class PersonalInfo extends StatefulWidget {
  const PersonalInfo({super.key});

  @override
  State<PersonalInfo> createState() => _PersonalInfoState();
}

class _PersonalInfoState extends State<PersonalInfo> {
  UserProfile profile = UserProfile(
    fullName: "John Smith",
    email: "john.smith@gmail.com",
    phoneNumber: "1234567890",
    gender: "Male",
    password: "********",
  );

  void showEditProfileDialog() {
    TextEditingController fullNameController = TextEditingController(
      text: profile.fullName,
    );
    TextEditingController emailController = TextEditingController(
      text: profile.email,
    );
    TextEditingController phoneNumberController = TextEditingController(
      text: profile.phoneNumber,
    );
    String selectedGender = profile.gender;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: Text(
                "Edit Personal Information",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              content: Container(
                width: 400,
                margin: EdgeInsets.only(bottom: 10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Full Name
                    Row(
                      spacing: 10,
                      children: [
                        Text(
                          "Full Name :",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Expanded(
                          child: TextField(
                            controller: fullNameController,
                            decoration: InputDecoration(
                              hintText: "Enter Full Name",
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 6),

                    // Email
                    Row(
                      spacing: 10,
                      children: [
                        Text(
                          "Email Address :",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Expanded(
                          child: TextField(
                            controller: emailController,
                            decoration: InputDecoration(
                              hintText: "Enter Email Address",
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 6),

                    // Phone Number
                    Row(
                      spacing: 10,
                      children: [
                        Text(
                          "Phone Number :",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Expanded(
                          child: TextField(
                            controller: phoneNumberController,
                            decoration: InputDecoration(
                              hintText: "Enter Phone Number",
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 6),

                    // Gender
                    Row(
                      spacing: 10,
                      children: [
                        Text(
                          "Gender :",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Expanded(
                          child: DropdownButton(
                            value: selectedGender,
                            onChanged: (value) {
                              setStateDialog(() {
                                selectedGender = value!;
                              });
                            },
                            items: ["Male", "Female", "Other"]
                                .map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem(
                                    value: value,
                                    child: Text(value),
                                  );
                                })
                                .toList(),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 216, 216, 216),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                      side: BorderSide(color: Colors.black, width: 1),
                    ),
                  ),
                  child: Text(
                    "Cancel",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ),

                TextButton(
                  onPressed: () {
                    String fullName = fullNameController.text.trim();
                    String email = emailController.text.trim();
                    String phoneNumber = phoneNumberController.text.trim();

                    if (fullName.isEmpty ||
                        email.isEmpty ||
                        phoneNumber.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Please fill in all fields")),
                      );
                      return;
                    }

                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(email)) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Please enter a valid Email Address"),
                        ),
                      );
                      return;
                    }

                    if (!RegExp(r'^[0-9]{10}$').hasMatch(phoneNumber)) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Enter a valid 10-digit phone number"),
                        ),
                      );
                      return;
                    }

                    setState(() {
                      profile.fullName = fullName;
                      profile.email = email;
                      profile.phoneNumber = phoneNumber;
                      profile.gender = selectedGender;
                    });

                    Navigator.pop(context);
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 146, 225, 149),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                      side: BorderSide(color: Colors.black, width: 1),
                    ),
                  ),
                  child: Text(
                    "Save",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      margin: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: const Color.fromARGB(255, 99, 99, 99),
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 5),
                child: Text(
                  "Personal Information",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
              IconButton(
                onPressed: () {
                  showEditProfileDialog();
                },
                icon: Icon(Icons.edit),
              ),
            ],
          ),

          infoRow("Full Name", profile.fullName),
          infoRow("Email", profile.email),
          infoRow("Phone Number", profile.phoneNumber),
          infoRow("Gender", profile.gender),
          infoRow("Password", profile.password),
        ],
      ),
    );
  }
}

Widget infoRow(String label, String value) {
  return Container(
    margin: EdgeInsets.only(top: 4),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          textAlign: TextAlign.left,
          style: TextStyle(
            color: const Color.fromARGB(255, 121, 121, 121),
            fontSize: 16,
          ),
        ),
        Text(value, textAlign: TextAlign.right, style: TextStyle(fontSize: 16)),
      ],
    ),
  );
}
