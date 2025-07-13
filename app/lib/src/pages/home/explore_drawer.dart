import 'package:flutter/material.dart';
import 'package:udyogmitra/src/services/google_auth_service.dart';

class ExploreDrawer extends StatelessWidget {
  const ExploreDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.green),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                'Username',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              children: const [
                _DrawerItem(
                  title: 'Skills to Business Mapping',
                  icon: Icons.business_center,
                  route: '/skills_to_business',
                ),
                _DrawerItem(
                  title: 'Startup Idea Evaluator',
                  icon: Icons.lightbulb_outline,
                  route: '/idea_evaluator',
                ),
                _DrawerItem(
                  title: 'Govt. Scheme Eligibility',
                  icon: Icons.gavel,
                  route: '/govt_schemes',
                ),
                _DrawerItem(
                  title: 'Learning Management System',
                  icon: Icons.school,
                  route: '/lms',
                ),
                _DrawerItem(
                  title: 'Logo Generator',
                  icon: Icons.design_services,
                  route: '/logo_generator',
                ),
                _DrawerItem(
                  title: 'Announcements',
                  icon: Icons.campaign,
                  route: '/announcements',
                ),
                _DrawerItem(
                  title: 'Feedback Form',
                  icon: Icons.feedback,
                  route: '/feedback',
                ),
                _DrawerItem(
                  title: 'Razorpay Integration',
                  icon: Icons.payment,
                  route: '/razorpay',
                ),
                _DrawerItem(
                  title: 'Chatbot',
                  icon: Icons.message,
                  route: '/chatbot',
                ),
                _DrawerItem(
                  title: 'Settings',
                  icon: Icons.settings,
                  route: '/settings',
                ),
              ],
            ),
          ),
          const Divider(),
          _DrawerItem(title: 'Logout', icon: Icons.logout, route: '/logout'),
        ],
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final String? route;

  const _DrawerItem({required this.title, required this.icon, this.route});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: title == 'Logout' ? Colors.red : null),
      title: Text(
        title,
        style: title == 'Logout' ? const TextStyle(color: Colors.red) : null,
      ),
      onTap: () async {
        Navigator.pop(context); // Close the drawer
        if (route != null) {
          if (route == '/logout') {
            // Sign out from Google and Firebase using GoogleAuthService
            await GoogleAuthService.signOut();
            // No need to navigate, Wrapper will handle auth state
          } else {
            Navigator.pushNamed(context, route!);
          }
        }
      },
    );
  }
}
