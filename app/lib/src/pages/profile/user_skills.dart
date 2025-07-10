import 'package:flutter/material.dart';

class UserSkills extends StatefulWidget {
  const UserSkills({super.key});

  @override
  State<UserSkills> createState() => _UserSkillsState();
}

class _UserSkillsState extends State<UserSkills> {
  final TextEditingController skillController = TextEditingController();
  List<String> skills = ["Organic Farming", "Dairy Farming", "Cooking"];

  void showEditSkillsDialog() {
    List<String> tempSkills = List.from(skills);
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Edit Skills",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.close),
                  ),
                ],
              ),
              content: SizedBox(
                width: 800,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: tempSkills.map((skill) {
                        return Chip(
                          label: Text(
                            skill,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          backgroundColor: const Color.fromARGB(
                            255,
                            109,
                            223,
                            133,
                          ),
                          side: BorderSide(color: Colors.grey, width: 1),
                          onDeleted: () {
                            setStateDialog(() {
                              tempSkills.remove(skill);
                            });
                          },
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 20),

                    TextField(
                      controller: skillController,
                      decoration: InputDecoration(hintText: "Enter New Skill"),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    if (skillController.text.trim().isEmpty) {
                      return;
                    }
                    setStateDialog(() {
                      tempSkills.add(skillController.text.trim());
                    });
                    skillController.clear();
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 211, 211, 211),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                      side: BorderSide(color: Colors.black, width: 1),
                    ),
                  ),

                  child: Text(
                    "Add Skill",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ),

                TextButton(
                  onPressed: () {
                    setState(() {
                      skills = List.from(tempSkills);
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
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "My Skills",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),

                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    showEditSkillsDialog();
                  },
                ),
              ],
            ),
          ),
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: skills.length,
              itemBuilder: (context, index) {
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 6),
                  margin: EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 109, 223, 133),
                    border: Border.all(color: Colors.black, width: 1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Text(
                      skills[index],
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
