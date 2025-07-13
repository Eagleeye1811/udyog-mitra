import 'package:flutter/material.dart';

/// About Us Page - Shows information about UdyogMitra
///
/// This page provides information about the company, mission, vision,
/// team members, and core values following the same UI/UX theme
/// as the rest of the application.
class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'About Us',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          // Main scrollable content
          SingleChildScrollView(
            padding: const EdgeInsets.only(
              bottom: 100, // Space for floating bottom nav
            ),
            child: Column(
              children: [
                // Hero Section - Company intro
                _buildHeroSection(),

                const SizedBox(height: 16),

                // Mission & Vision Section
                _buildMissionVisionSection(),

                const SizedBox(height: 16),

                // Our Story Section
                _buildOurStorySection(),

                const SizedBox(height: 16),

                // Core Values Section
                _buildCoreValuesSection(),

                const SizedBox(height: 16),

                // Key Features Section
                _buildKeyFeaturesSection(),

                const SizedBox(height: 16),

                // Team Section
                _buildTeamSection(),

                const SizedBox(height: 16),

                // User Testimonials Section
                _buildTestimonialsSection(),

                const SizedBox(height: 16),

                // Our Impact Section
                _buildImpactSection(),

                const SizedBox(height: 16),

                // Data Privacy Section
                _buildDataPrivacySection(),

                const SizedBox(height: 20),
              ],
            ),
          ),

          // Floating Custom Bottom Nav - Same as other pages
          _buildFloatingBottomNav(context),
        ],
      ),
    );
  }

  Widget _buildHeroSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.green.shade50, Colors.green.shade100],
            ),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              // Company Logo Placeholder
              Container(
                height: 80,
                width: 80,
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(Icons.eco, size: 40, color: Colors.white),
              ),

              const SizedBox(height: 16),

              const Text(
                'UdyogMitra',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'Empowering Rural Dreams',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.green,
                ),
              ),

              const SizedBox(height: 16),

              Text(
                'UdyogMitra is your trusted companion for rural business growth, connecting you with opportunities, skills, and resources to build successful enterprises.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMissionVisionSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Our Mission & Vision',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 20),

              // Mission
              _buildMissionVisionItem(
                icon: Icons.rocket_launch,
                title: 'Our Mission',
                description:
                    'To bridge the digital divide and empower rural entrepreneurs through technology-driven solutions that make business opportunities accessible to everyone.',
                color: Colors.green,
              ),

              const SizedBox(height: 20),

              // Vision
              _buildMissionVisionItem(
                icon: Icons.visibility,
                title: 'Our Vision',
                description:
                    'Empowering 1 million rural entrepreneurs by 2025 through innovative technology solutions and comprehensive business support.',
                color: Colors.blue,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMissionVisionItem({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 48,
          width: 48,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 24),
        ),

        const SizedBox(width: 16),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                description,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOurStorySection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Our Story',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 16),

              Text(
                'Born from a deep understanding of the challenges faced by rural entrepreneurs, UdyogMitra was created to democratize access to business opportunities and resources.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
                  height: 1.6,
                ),
              ),

              const SizedBox(height: 16),

              Text(
                'We believe that every individual, regardless of their location or background, deserves the opportunity to build a successful business. Through our platform, we provide the tools, knowledge, and connections needed to transform ideas into thriving enterprises.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
                  height: 1.6,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCoreValuesSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Why UdyogMitra?',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 20),

              // Core values from the design
              _buildValueItem(
                icon: Icons.trending_up,
                title: 'Simplified Business Growth',
                description:
                    'Streamlined tools and resources to help your business flourish without complexity.',
                color: Colors.green,
              ),

              const SizedBox(height: 16),

              _buildValueItem(
                icon: Icons.people,
                title: 'Local Language Support',
                description:
                    'Breaking language barriers with support in regional languages for better understanding.',
                color: Colors.blue,
              ),

              const SizedBox(height: 16),

              _buildValueItem(
                icon: Icons.offline_bolt,
                title: 'Offline Access',
                description:
                    'Access essential features even without internet connectivity for uninterrupted progress.',
                color: Colors.orange,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildValueItem({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2), width: 1),
      ),
      child: Row(
        children: [
          Container(
            height: 48,
            width: 48,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKeyFeaturesSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Key Features',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 20),

              // Horizontal scrollable features
              SizedBox(
                height: 160,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  itemCount: 6,
                  itemBuilder: (context, index) {
                    final features = [
                      {
                        'icon': Icons.chat_bubble_outline,
                        'title': 'AI Chatbot',
                        'description': 'Text/voice support in English & Hindi',
                        'color': Colors.green,
                      },
                      {
                        'icon': Icons.business_center,
                        'title': 'Skill Matching',
                        'description': 'Business skill recommendation',
                        'color': Colors.blue,
                      },
                      {
                        'icon': Icons.lightbulb_outline,
                        'title': 'Idea Evaluator',
                        'description': 'Analyze business potential',
                        'color': Colors.orange,
                      },
                      {
                        'icon': Icons.map_outlined,
                        'title': 'Personalized Roadmap',
                        'description': 'Custom business journey',
                        'color': Colors.purple,
                      },
                      {
                        'icon': Icons.account_balance,
                        'title': 'Government Schemes',
                        'description': 'Access funding opportunities',
                        'color': Colors.red,
                      },
                      {
                        'icon': Icons.trending_up,
                        'title': 'Market Analysis',
                        'description': 'Industry trends & insights',
                        'color': Colors.teal,
                      },
                    ];

                    return Padding(
                      padding: EdgeInsets.only(
                        left: index == 0 ? 0 : 8,
                        right: index == features.length - 1 ? 0 : 8,
                      ),
                      child: _buildFeatureCard(
                        icon: features[index]['icon'] as IconData,
                        title: features[index]['title'] as String,
                        description: features[index]['description'] as String,
                        color: features[index]['color'] as Color,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
  }) {
    return Container(
      width: 150,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),

          const SizedBox(height: 8),

          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: 4),

          Expanded(
            child: Text(
              description,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey[600],
                height: 1.2,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Meet Our Team',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 20),

              // Horizontal scrollable team members
              SizedBox(
                height: 140,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  itemCount: 6,
                  itemBuilder: (context, index) {
                    final teamMembers = [
                      {
                        'name': 'Vedant Gawali',
                        'role': 'Team Lead',
                        'color': Colors.blue,
                      },
                      {
                        'name': 'Bhumik Gianani',
                        'role': 'Developer',
                        'color': Colors.green,
                      },
                      {
                        'name': 'Sumitkumar Jha',
                        'role': 'Developer',
                        'color': Colors.orange,
                      },
                      {
                        'name': 'Rushil Rohra',
                        'role': 'Developer',
                        'color': Colors.purple,
                      },
                      {
                        'name': 'Rohit Dhakras',
                        'role': 'Developer',
                        'color': Colors.teal,
                      },
                      {
                        'name': 'Aditya Agrahari',
                        'role': 'Developer',
                        'color': Colors.red,
                      },
                    ];

                    return Padding(
                      padding: EdgeInsets.only(
                        left: index == 0 ? 0 : 8,
                        right: index == teamMembers.length - 1 ? 0 : 8,
                      ),
                      child: _buildTeamMember(
                        name: teamMembers[index]['name'] as String,
                        role: teamMembers[index]['role'] as String,
                        color: teamMembers[index]['color'] as Color,
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 16),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.green.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Column(
                  children: [
                    const Icon(Icons.eco, size: 32, color: Colors.green),
                    const SizedBox(height: 8),
                    Text(
                      'Founded in 2022, UdyogMitra emerged from a vision to bridge the digital gap in rural India. Our journey began with a simple mission: to make technology accessible and beneficial for rural entrepreneurs.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                        height: 1.5,
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

  Widget _buildTeamMember({
    required String name,
    required String role,
    required Color color,
  }) {
    return Container(
      width: 120,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2), width: 1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: color.withOpacity(0.2),
            child: Icon(Icons.person, size: 28, color: color),
          ),

          const SizedBox(height: 8),

          Text(
            name,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: 2),

          Text(
            role,
            style: TextStyle(fontSize: 11, color: Colors.grey[600]),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildTestimonialsSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'User Testimonials',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 20),

              // Testimonials
              _buildTestimonialCard(
                message:
                    'UdyogMitra helped me start my local business. The AI chatbot is incredibly helpful!',
                name: 'Suresh, Maharashtra',
                color: Colors.green,
              ),

              const SizedBox(height: 12),

              _buildTestimonialCard(
                message:
                    'Now I can access government schemes easily. This app has changed my life.',
                name: 'Lakshmi, Karnataka',
                color: Colors.blue,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTestimonialCard({
    required String message,
    required String name,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: List.generate(
              5,
              (index) => Icon(Icons.star, size: 16, color: Colors.amber),
            ),
          ),

          const SizedBox(height: 8),

          Text(
            message,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
              height: 1.4,
              fontStyle: FontStyle.italic,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            '- $name',
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImpactSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Our Impact',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 20),

              // Impact Grid
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.2,
                children: [
                  _buildImpactCard(
                    icon: Icons.people,
                    title: 'Rural Farmers',
                    description: 'Empowering agricultural communities',
                    color: Colors.green,
                    imagePath: null, // TODO: Add image path for rural farmers
                    // imagePath: 'assets/images/rural_farmers.jpg',
                  ),
                  _buildImpactCard(
                    icon: Icons.store,
                    title: 'Small Businesses',
                    description: 'Supporting local entrepreneurs',
                    color: Colors.blue,
                    imagePath:
                        null, // TODO: Add image path for small businesses
                    // imagePath: 'assets/images/small_businesses.jpg',
                  ),
                  _buildImpactCard(
                    icon: Icons.handyman,
                    title: 'Artisans',
                    description: 'Preserving traditional crafts',
                    color: Colors.orange,
                    imagePath: null, // TODO: Add image path for artisans
                    // imagePath: 'assets/images/artisans.jpg',
                  ),
                  _buildImpactCard(
                    icon: Icons.trending_up,
                    title: 'Economic Growth',
                    description: 'Driving rural development',
                    color: Colors.purple,
                    imagePath: null, // TODO: Add image path for economic growth
                    // imagePath: 'assets/images/economic_growth.jpg',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImpactCard({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
    String? imagePath, // TODO: Optional image path for future implementation
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2), width: 1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // TODO: Replace icon with image when imagePath is provided
          // imagePath != null
          //   ? Image.asset(imagePath, height: 40, width: 40)
          //   :
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 24),
          ),

          const SizedBox(height: 8),

          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 4),

          Text(
            description,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[600],
              height: 1.2,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildDataPrivacySection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.security, color: Colors.green, size: 28),
                  const SizedBox(width: 12),
                  const Text(
                    'Data Privacy',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              _buildPrivacyItem(
                icon: Icons.lock,
                title: 'Your data is encrypted and secure',
                color: Colors.green,
              ),

              const SizedBox(height: 12),

              _buildPrivacyItem(
                icon: Icons.block,
                title: 'We never share your information',
                color: Colors.blue,
              ),

              const SizedBox(height: 12),

              _buildPrivacyItem(
                icon: Icons.verified_user,
                title: 'GDPR compliant data handling',
                color: Colors.orange,
              ),

              const SizedBox(height: 16),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.green.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(Icons.shield, color: Colors.green, size: 24),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Your privacy is our priority. We are committed to protecting your personal information.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                          height: 1.4,
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

  Widget _buildPrivacyItem({
    required IconData icon,
    required String title,
    required Color color,
  }) {
    return Row(
      children: [
        Container(
          height: 32,
          width: 32,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 18),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Text(
            title,
            style: const TextStyle(fontSize: 14, color: Colors.black87),
          ),
        ),

        Icon(Icons.check_circle, color: color, size: 20),
      ],
    );
  }

  Widget _buildFloatingBottomNav(BuildContext context) {
    return Positioned(
      left: 90,
      right: 90,
      bottom: 30,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: Container(
          height: 64,
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.circular(32),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(50),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavBarItem(
                icon: Icons.home,
                label: 'Home',
                selected: false,
                onTap: () {
                  Navigator.pushReplacementNamed(context, '/home');
                },
              ),
              _NavBarItem(
                icon: Icons.info_outline,
                label: 'About Us',
                selected: true, // This page is selected
                onTap: () {
                  // Already on About Us page
                },
              ),
              _NavBarItem(
                icon: Icons.person_outline,
                label: 'Profile',
                selected: false,
                onTap: () {
                  Navigator.pushReplacementNamed(context, '/profile');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _NavBarItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: selected ? Colors.white : Colors.white.withOpacity(0.7),
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: selected ? Colors.white : Colors.white.withOpacity(0.7),
                fontSize: 12,
                fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
