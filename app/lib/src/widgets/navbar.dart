import 'package:flutter/material.dart';
import 'package:udyogmitra/src/config/themes/app_theme.dart';

Widget navbar(BuildContext context, int index) {
  return Positioned(
    left: 75,
    right: 75,
    bottom: 30,
    child: ClipRRect(
      borderRadius: BorderRadius.circular(32),
      child: Container(
        height: 64,
        decoration: context.cardStyles.greenCard,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _NavBarItem(
              icon: Icons.home,
              label: 'Home',
              selected: index == 0,
              onTap: () {
                if (index != 0) {
                  Navigator.pushReplacementNamed(context, '/home');
                }
              },
            ),
            _NavBarItem(
              icon: Icons.info_outline,
              label: 'About Us',
              selected: index == 1,
              onTap: () {
                if (index != 1) {
                  Navigator.pushReplacementNamed(context, '/about-us');
                }
              },
            ),
            _NavBarItem(
              icon: Icons.person_outline,
              label: 'Profile',
              selected: index == 2,
              onTap: () {
                if (index != 2) {
                  Navigator.pushReplacementNamed(context, '/profile');
                }
              },
            ),
          ],
        ),
      ),
    ),
  );
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
              color: selected
                  ? Colors.white
                  : Colors.white.withAlpha((0.7 * 255).round()),
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: selected
                    ? Colors.white
                    : Colors.white.withAlpha((0.7 * 255).round()),
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
