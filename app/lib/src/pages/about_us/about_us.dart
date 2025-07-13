import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    List whyUdyogmitra = [
      {
        "icon": Icon(Icons.handshake, color: Colors.green, size: 28),
        "title": "Direct Support",
        "desc": "Personalized guidance for business growth",
      },
      {
        "icon": Icon(Icons.groups, color: Colors.green, size: 28),
        "title": "Community Focus",
        "desc": "Building a strong network of entrepreneurs",
      },
      {
        "icon": Icon(Icons.lightbulb, color: Colors.green, size: 28),
        "title": "Innovation First",
        "desc": "Latest tools and technologies for success",
      },
    ];

    List features = [
      {
        "icon": Icon(Icons.chat_outlined, color: Colors.green, size: 28),
        "title": "AI Chatbot",
        "desc": "24/7 support in English & Hindi",
      },
      {
        "icon": Icon(Icons.school_outlined, color: Colors.green, size: 28),
        "title": "Skill Matching",
        "desc": "Find relevant business skills",
      },
      {
        "icon": Icon(Icons.description_outlined, color: Colors.green, size: 28),
        "title": "Loan Recommender",
        "desc": "Smart loan suggestions",
      },
      {
        "icon": Icon(Icons.show_chart_outlined, color: Colors.green, size: 28),
        "title": "Market Predictor",
        "desc": "Demand analysis tools",
      },
      {
        "icon": Icon(Icons.menu_book_outlined, color: Colors.green, size: 28),
        "title": "Learning Modules",
        "desc": "Step-by-step guidance",
      },
      {
        "icon": Icon(Icons.wifi_off, color: Colors.green, size: 28),
        "title": "Offline Mode",
        "desc": "Work without internet",
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text("About Us", style: TextStyle(fontWeight: FontWeight.w800)),
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
          margin: EdgeInsets.only(top: 10, bottom: 20),
          child: Column(
            children: [
              // Heading Section
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color.fromARGB(255, 218, 252, 226),
                      const Color.fromARGB(255, 246, 255, 248),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.circle_outlined, size: 32),
                        const SizedBox(width: 20),
                        Text(
                          "UdyogMitra",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Empowering Rural Development",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // What is UdyogMitra ?
              Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 211, 235, 212),
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                margin: EdgeInsets.symmetric(horizontal: 15),
                child: Text(
                  "UdyogMitra is your trusted companion for rural business growth, connecting you with opportunities, skills, and resources to build successful enterprises.",
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                ),
              ),

              const SizedBox(height: 25),

              // Quote
              Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: 20),
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(Icons.format_quote_sharp),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "To bridge the digital divide and empower rural entrepreneurs through technology-driven solutions",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // Blockquote
              Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: 20),
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 238, 238, 238),
                  border: Border(
                    left: BorderSide(
                      color: const Color.fromARGB(255, 55, 130, 58),
                      width: 8,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Our Vision",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          "Empowering 1 million rural entrepreneurs by 2025",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // Why UdyogMitra ?
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "Why UdyogMitra ?",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
              ),

              const SizedBox(height: 10),
              Column(
                children: whyUdyogmitra.map((item) {
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 7),
                    padding: EdgeInsets.only(
                      left: 30,
                      right: 10,
                      top: 15,
                      bottom: 15,
                    ),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 248, 247, 247),
                      border: Border.all(
                        color: const Color.fromARGB(255, 203, 203, 203),
                        width: 0.5,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        item["icon"],
                        const SizedBox(width: 25),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item["title"],
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                item["desc"],
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 25),

              // Key Features
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "Key Features",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
              ),

              const SizedBox(height: 10),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                childAspectRatio: 1.3,
                children: features.map((item) {
                  return Container(
                    height: 20,
                    margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 245, 245, 245),
                      border: Border.all(color: Colors.grey, width: 1),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Align(
                      alignment: Alignment.center,
                      child: Wrap(
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              item["icon"],
                              const SizedBox(height: 10),
                              Text(
                                item["title"],
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: Text(
                                  item["desc"],
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 25),

              // Our Story
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "Our Story",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Text(
                  "   Founded in 2025, UdyogMitra emerged from a vision to transform rural entrepreneurship through technology. Our journey began with understanding the challenges faced by rural entrepreneurs and developing solutions that truly address their needs.",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                ),
              ),

              const SizedBox(height: 25),

              // What Users Say
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "What Users Say",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 227, 247, 227),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: const Color.fromARGB(255, 105, 105, 105),
                          width: 0.5,
                        ),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 15,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "UdyogMitra helped me start my small business with confidence.",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            "Suresh Kumar, Maharashtra",
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    Container(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 227, 247, 227),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: const Color.fromARGB(255, 105, 105, 105),
                          width: 0.5,
                        ),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 15,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "The AI chatbot is incredibly helpful for my daily queries.",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            "Priya Singh, Uttar Pradesh",
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // Contact Us
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "Contact Us",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(height: 15),

              Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 213, 239, 214),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color.fromARGB(255, 90, 98, 90),
                    width: 0.5,
                  ),
                ),
                margin: EdgeInsets.symmetric(horizontal: 20),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.email_outlined,
                          color: Colors.green,
                          size: 28,
                        ),
                        const SizedBox(width: 15),
                        Text(
                          "support@udyogmitra.org",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 34, 129, 35),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 10,
                      ),
                      child: Text(
                        "Get Support",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
