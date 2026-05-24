import 'package:flutter/material.dart';

class DisconnectStravaCard extends StatelessWidget {
  final VoidCallback onTap;

  const DisconnectStravaCard({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: const Icon(Icons.logout, color: Colors.red),
        title: const Text('Disconnect Strava'),
        subtitle: const Text('Remove access to your Strava account'),
        onTap: onTap,
      ),
    );
  }
}
