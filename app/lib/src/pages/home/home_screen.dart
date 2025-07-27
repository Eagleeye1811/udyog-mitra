import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:udyogmitra/src/config/themes/app_theme.dart';
import 'package:udyogmitra/src/config/themes/app_theme_provider.dart';
import 'package:udyogmitra/src/config/themes/helpers.dart';
import 'package:udyogmitra/src/pages/home/welcome_banner.dart';
import 'package:udyogmitra/src/pages/home/home_carousel.dart';
import 'package:udyogmitra/src/pages/home/explore_drawer.dart';
import 'package:udyogmitra/src/pages/home/home_feature_card.dart';
import 'package:udyogmitra/src/widgets/navbar.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('UdyogMitra', style: context.textStyles.appBarTitle),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              ref.watch(themeModeProvider) == ThemeMode.dark
                  ? Icons.dark_mode
                  : Icons.light_mode,
              color: Colors.green,
            ),
            onPressed: () {
              ref.read(themeModeProvider.notifier).toggleTheme();
            },
          ),
          // Debug button (remove in production)
          // IconButton(
          //   icon: const Icon(Icons.bug_report),
          //   onPressed: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //         builder: (context) => const ProfileTestPage(),
          //       ),
          //     );
          //   },
          // ),
        ],
      ),
      drawer: const ExploreDrawer(),
      body: Stack(
        children: [
          // Main scrollable content
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 100), // to avoid overlap
            child: Column(
              children: [
                const SizedBox(height: 20),
                WelcomeBanner(),
                const SizedBox(height: 20),
                const HomeCarousel(),
                const SizedBox(height: 20),

                // Intro
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Container(
                    width: double.infinity,
                    decoration: context.cardStyles.greenTransparentCard,
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Namaste and Welcome to UdyogMitra',
                          style: context.textStyles.titleMedium.green(),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'UdyogMitra is more than an app — it’s your trusted partner. Whether you’re starting a business, showcasing your skills, or seeking guidance and government support, we’re here to help.\n\n'
                          'Your dreams, our mission. Let’s build an Aatmanirbhar Bharat together!',
                          style: context.textStyles.bodyMedium.darkGrey(
                            context,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Feature cards
                HomeFeatureCard(
                  icon: Icons.business_center,
                  title: 'Business Planner',
                  description: 'Complete skill-to-business planning journey',
                  onTap: () =>
                      Navigator.pushNamed(context, '/business-planner'),
                ),
                HomeFeatureCard(
                  icon: Icons.lightbulb_outline,
                  title: 'Evaluate Your Idea',
                  description: 'Get detailed insights for your business idea',
                  onTap: () => Navigator.pushNamed(context, '/idea-evaluator'),
                ),
                HomeFeatureCard(
                  icon: Icons.gavel,
                  title: 'Find Schemes',
                  description: 'Check government scheme eligibility',
                  onTap: () => Navigator.pushNamed(context, '/govt_schemes'),
                ),
                Builder(
                  builder: (context) => HomeFeatureCard(
                    icon: Icons.explore,
                    title: 'Explore More',
                    description: 'Discover more features and resources',
                    onTap: () => Scaffold.of(context).openDrawer(),
                  ),
                ),
                const SizedBox(height: 100), // extra space for bottom bar
              ],
            ),
          ),

          // Floating Custom Bottom Nav
          navbar(context, 0),
        ],
      ),
    );
  }
}
