import 'package:flutter/material.dart';

class UserDocuments extends StatelessWidget {
  const UserDocuments({super.key});

  @override
  Widget build(BuildContext context) {
    final documents = [
      {
        "name": "Dairy Farming Scheme",
        "date": "15/06/2025",
        "status": "Pending",
      },
      {"name": "Farmer Loan", "date": "20/06/2025", "status": "Approved"},
    ];

    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Applications Overview",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              IconButton(onPressed: () {}, icon: Icon(Icons.edit)),
            ],
          ),

          const SizedBox(height: 10),

          SizedBox(
            width: double.infinity,
            height: 120,
            child: ListView.builder(
              itemCount: documents.length,
              itemBuilder: (context, index) {
                String status = documents[index]["status"] as String;
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          documents[index]["name"] as String,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          documents[index]["date"] as String,
                          style: TextStyle(fontSize: 14),
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),

                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: status == "Pending"
                            ? const Color.fromARGB(255, 255, 228, 130)
                            : const Color.fromARGB(255, 136, 243, 191),
                        border: Border.all(color: Colors.black, width: 1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        status,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
