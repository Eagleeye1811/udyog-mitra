import 'package:flutter/material.dart';
import 'package:udyogmitra/src/config/themes/app_theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:udyogmitra/src/config/themes/app_theme_provider.dart';
import 'package:udyogmitra/src/config/themes/helpers.dart';
import 'package:udyogmitra/src/widgets/navbar.dart';

/// About Us Page - Shows information about UdyogMitra
///
/// This page provides information about the company, mission, vision,
/// team members, and core values following the same UI/UX theme
/// as the rest of the application.
class AboutUsPage extends ConsumerWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(
          title: Text('About Us', style: context.textStyles.appBarTitle),
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 10),
              child: IconButton(
                icon: Icon(
                  ref.watch(themeModeProvider) == ThemeMode.dark
                      ? Icons.dark_mode
                      : Icons.light_mode,
                  color: context.textStyles.bodyMedium.color,
                ),
                onPressed: () {
                  ref.read(themeModeProvider.notifier).toggleTheme();
                },
              ),
            ),
          ],
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
                  _buildHeroSection(context),

                  const SizedBox(height: 16),

                  // Mission & Vision Section
                  _buildMissionVisionSection(context),

                  const SizedBox(height: 16),

                  // Our Story Section
                  _buildOurStorySection(context),

                  const SizedBox(height: 16),

                  // Core Values Section
                  _buildCoreValuesSection(context),

                  const SizedBox(height: 16),

                  // Key Features Section
                  _buildKeyFeaturesSection(context),

                  const SizedBox(height: 16),

                  // Team Section
                  _buildTeamSection(context),

                  const SizedBox(height: 16),

                  // User Testimonials Section
                  _buildTestimonialsSection(context),

                  const SizedBox(height: 16),

                  // Our Impact Section
                  _buildImpactSection(context),

                  const SizedBox(height: 16),

                  // Data Privacy Section
                  _buildDataPrivacySection(context),

                  const SizedBox(height: 20),
                ],
              ),
            ),

            // Floating Custom Bottom Nav - Same as other pages
            navbar(context, 1),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          width: double.infinity,
          decoration: context.cardStyles.greenTransparentCard,
          // BoxDecoration(
          //   borderRadius: BorderRadius.circular(16),
          //   gradient: LinearGradient(
          //     begin: Alignment.topLeft,
          //     end: Alignment.bottomRight,
          //     colors: [Colors.green.shade50, Colors.green.shade100],
          //   ),
          // ),
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

              Text('UdyogMitra', style: context.textStyles.titleLarge.green()),

              const SizedBox(height: 8),

              Text(
                'Empowering Rural Dreams',
                style: context.textStyles.titleMedium.green(),
              ),

              const SizedBox(height: 16),

              Text(
                'UdyogMitra is your trusted companion for rural business growth, connecting you with opportunities, skills, and resources to build successful enterprises.',
                textAlign: TextAlign.center,
                style: context.textStyles.bodyMedium.copyWith(height: 1.5),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMissionVisionSection(BuildContext context) {
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
              Text(
                'Our Mission & Vision',
                style: context.textStyles.titleLarge,
              ),

              const SizedBox(height: 20),

              // Mission
              _buildMissionVisionItem(
                context: context,
                icon: Icons.rocket_launch,
                title: 'Our Mission',
                description:
                    'To bridge the digital divide and empower rural entrepreneurs through technology-driven solutions that make business opportunities accessible to everyone.',
                color: Colors.green,
              ),

              const SizedBox(height: 20),

              // Vision
              _buildMissionVisionItem(
                context: context,
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
    required BuildContext context,
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
            color: color.withAlpha((0.1 * 255).round()),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 24),
        ),

        const SizedBox(width: 16),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: context.textStyles.titleMedium),

              const SizedBox(height: 8),

              Text(
                description,
                style: context.textStyles.bodySmall
                    .grey(context)
                    .copyWith(height: 1.5),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOurStorySection(BuildContext context) {
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
              Text('Our Story', style: context.textStyles.titleLarge),

              const SizedBox(height: 16),

              Text(
                'Born from a deep understanding of the challenges faced by rural entrepreneurs, UdyogMitra was created to democratize access to business opportunities and resources.',
                style: context.textStyles.bodyMedium
                    .grey(context)
                    .copyWith(height: 1.6),
              ),

              const SizedBox(height: 16),

              Text(
                'We believe that every individual, regardless of their location or background, deserves the opportunity to build a successful business. Through our platform, we provide the tools, knowledge, and connections needed to transform ideas into thriving enterprises.',
                style: context.textStyles.bodyMedium
                    .grey(context)
                    .copyWith(height: 1.6),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCoreValuesSection(BuildContext context) {
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
              Text('Why UdyogMitra?', style: context.textStyles.titleLarge),

              const SizedBox(height: 20),

              // Core values from the design
              _buildValueItem(
                context: context,
                icon: Icons.trending_up,
                title: 'Simplified Business Growth',
                description:
                    'Streamlined tools and resources to help your business flourish without complexity.',
                color: Colors.green,
              ),

              const SizedBox(height: 16),

              _buildValueItem(
                context: context,
                icon: Icons.people,
                title: 'Local Language Support',
                description:
                    'Breaking language barriers with support in regional languages for better understanding.',
                color: Colors.blue,
              ),

              const SizedBox(height: 16),

              _buildValueItem(
                context: context,
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
    required BuildContext context,
    required IconData icon,
    required String title,
    required String description,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withAlpha((0.05 * 255).round()),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withAlpha((0.2 * 255).round()),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            height: 48,
            width: 48,
            decoration: BoxDecoration(
              color: color.withAlpha((0.1 * 255).round()),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: context.textStyles.cardTitleMedium),

                const SizedBox(height: 4),

                Text(
                  description,
                  style: context.textStyles.bodySmall
                      .grey(context)
                      .copyWith(height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKeyFeaturesSection(BuildContext context) {
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
              Text('Key Features', style: context.textStyles.titleLarge),

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
                        context: context,
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
    required BuildContext context,
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
            style: context.textStyles.labelMedium,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: 4),

          Expanded(
            child: Text(
              description,
              style: context.textStyles.labelSmall
                  .grey(context)
                  .copyWith(height: 1.2),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamSection(BuildContext context) {
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
              Text('Meet Our Team', style: context.textStyles.titleLarge),

              const SizedBox(height: 20),

              // Horizontal scrollable team members
              SizedBox(
                height: 145,
                width: double.infinity,
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
                        context: context,
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
                      style: context.textStyles.bodyMedium.grey(context),
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
    required BuildContext context,
    required String name,
    required String role,
    required Color color,
  }) {
    return Container(
      width: 125,
      padding: const EdgeInsets.all(10),
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
            style: context.textStyles.labelSmall,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: 2),

          Text(
            role,
            style: context.textStyles.labelSmall.grey(context),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildTestimonialsSection(BuildContext context) {
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
              Text('User Testimonials', style: context.textStyles.titleLarge),

              const SizedBox(height: 20),

              // Testimonials
              _buildTestimonialCard(
                context: context,
                message:
                    'UdyogMitra helped me start my local business. The AI chatbot is incredibly helpful!',
                name: 'Suresh, Maharashtra',
                color: Colors.green,
              ),

              const SizedBox(height: 12),

              _buildTestimonialCard(
                context: context,
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
    required BuildContext context,
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
            style: context.textStyles.bodySmall
                .grey(context)
                .copyWith(fontStyle: FontStyle.italic, height: 1.4),
          ),

          const SizedBox(height: 8),

          Text('- $name', style: context.textStyles.labelMedium),
        ],
      ),
    );
  }

  Widget _buildImpactSection(BuildContext context) {
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
              Text('Our Impact', style: context.textStyles.titleLarge),

              const SizedBox(height: 20),

              // Impact Grid
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.3,
                children: [
                  _buildImpactCard(
                    context: context,
                    icon: Icons.people,
                    title: 'Rural Farmers',
                    description: 'Empowering agricultural communities',
                    color: Colors.green,
                    imagePath: null, // TODO: Add image path for rural farmers
                    // imagePath: 'assets/images/rural_farmers.jpg',
                  ),
                  _buildImpactCard(
                    context: context,
                    icon: Icons.store,
                    title: 'Small Businesses',
                    description: 'Supporting local entrepreneurs',
                    color: Colors.blue,
                    imagePath:
                        null, // TODO: Add image path for small businesses
                    // imagePath: 'assets/images/small_businesses.jpg',
                  ),
                  _buildImpactCard(
                    context: context,
                    icon: Icons.handyman,
                    title: 'Artisans',
                    description: 'Preserving traditional crafts',
                    color: Colors.orange,
                    imagePath: null, // TODO: Add image path for artisans
                    // imagePath: 'assets/images/artisans.jpg',
                  ),
                  _buildImpactCard(
                    context: context,
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
    required BuildContext context,
    required IconData icon,
    required String title,
    required String description,
    required Color color,
    String? imagePath, // TODO: Optional image path for future implementation
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withAlpha(13),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withAlpha(52), width: 1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // TODO: Replace icon with image when imagePath is provided
          // imagePath != null
          //   ? Image.asset(imagePath, height: 40, width: 40)
          //   :
          Container(
            height: 50,
            width: 40,
            decoration: BoxDecoration(
              color: color.withAlpha(26),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 24),
          ),

          const SizedBox(height: 8),

          Text(
            title,
            style: context.textStyles.labelMedium,
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 4),

          Text(
            description,
            style: context.textStyles.labelSmall
                .grey(context)
                .copyWith(height: 1.2),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildDataPrivacySection(BuildContext context) {
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
                  Text('Data Privacy', style: context.textStyles.titleLarge),
                ],
              ),

              const SizedBox(height: 20),

              _buildPrivacyItem(
                context: context,
                icon: Icons.lock,
                title: 'Your data is encrypted and secure',
                color: Colors.green,
              ),

              const SizedBox(height: 12),

              _buildPrivacyItem(
                context: context,
                icon: Icons.block,
                title: 'We never share your information',
                color: Colors.blue,
              ),

              const SizedBox(height: 12),

              _buildPrivacyItem(
                context: context,
                icon: Icons.verified_user,
                title: 'GDPR compliant data handling',
                color: Colors.orange,
              ),

              const SizedBox(height: 16),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.withAlpha(13),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.green.withAlpha(52),
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
                        style: context.textStyles.bodySmall.grey(context),
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
    required BuildContext context,
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
            color: color.withAlpha(26),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 18),
        ),

        const SizedBox(width: 12),

        Expanded(child: Text(title, style: context.textStyles.labelMedium)),

        Icon(Icons.check_circle, color: color, size: 20),
      ],
    );
  }
}
