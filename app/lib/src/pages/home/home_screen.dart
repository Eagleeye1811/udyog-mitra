import 'package:flutter/material.dart';
import 'package:udyogmitra/src/pages/home/welcome_banner.dart';
import 'package:udyogmitra/src/pages/home/home_carousel.dart';
import 'package:udyogmitra/src/pages/home/explore_drawer.dart';
import 'package:udyogmitra/src/pages/home/home_feature_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'UdyogMitra',
          style: TextStyle(fontWeight: FontWeight.w800, color: Colors.green),
        ),
        centerTitle: true,
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
                const WelcomeBanner(),
                const SizedBox(height: 20),
                const HomeCarousel(),
                const SizedBox(height: 20),

                // Intro
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.green.withAlpha(15),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Namaste and Welcome to UdyogMitra',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.green,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'UdyogMitra is more than an app — it’s your trusted partner. Whether you’re starting a business, showcasing your skills, or seeking guidance and government support, we’re here to help.\n\n'
                          'Your dreams, our mission. Let’s build an Aatmanirbhar Bharat together!',
                          style: TextStyle(fontSize: 15, color: Colors.black87),
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
          Positioned(
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
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _NavBarItem(
                      icon: Icons.home,
                      label: 'Home',
                      selected: _selectedIndex == 0,
                      onTap: () {
                        setState(() => _selectedIndex = 0);
                        Navigator.pushReplacementNamed(context, '/home');
                      },
                    ),
                    _NavBarItem(
                      icon: Icons.info_outline,
                      label: 'About Us',
                      selected: _selectedIndex == 1,
                      onTap: () {
                        setState(() => _selectedIndex = 1);
                        Navigator.pushReplacementNamed(context, '/about-us');
                      },
                    ),
                    _NavBarItem(
                      icon: Icons.person_outline,
                      label: 'Profile',
                      selected: _selectedIndex == 2,
                      onTap: () {
                        setState(() => _selectedIndex = 2);
                        Navigator.pushReplacementNamed(context, '/profile');
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Add this widget at the end of the file (outside your classes)
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
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: selected ? Colors.white : Colors.white70),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: selected ? Colors.white : Colors.white70,
              fontSize: 12,
              fontWeight: selected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
