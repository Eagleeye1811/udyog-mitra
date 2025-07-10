import 'package:flutter/material.dart';

class UserBusiness extends StatelessWidget {
  const UserBusiness({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          margin: EdgeInsets.only(left: 20, right: 20, bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "My Business",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),

              IconButton(icon: Icon(Icons.edit), onPressed: () {}),
            ],
          ),
        ),

        Container(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
          margin: EdgeInsets.symmetric(horizontal: 18),
          decoration: BoxDecoration(
            border: Border.all(width: 1.5, color: Colors.black),
            borderRadius: BorderRadius.circular(25),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(Icons.circle, size: 40),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Dairy Farming",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Small-scale dairy farm with 4 cows",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ],
              ),

              IconButton(icon: Icon(Icons.open_in_new), onPressed: () {}),
            ],
          ),
        ),
      ],
    );
  }
}
