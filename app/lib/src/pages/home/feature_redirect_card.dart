import 'package:flutter/material.dart';

class FeatureRedirectCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final String? routeName;
  final bool openDrawerOnClick;

  const FeatureRedirectCard({
    super.key,
    required this.title,
    required this.icon,
    this.routeName,
    this.openDrawerOnClick = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (openDrawerOnClick) {
          Scaffold.of(context).openDrawer();
        } else if (routeName != null) {
          Navigator.pushNamed(context, routeName!);
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            leading: Icon(icon, size: 32),
            title: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
            trailing: const Icon(Icons.arrow_forward_ios, size: 18),
          ),
        ),
      ),
    );
  }
}
