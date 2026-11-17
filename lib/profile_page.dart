import 'package:flutter/material.dart';
import 'demo_auth.dart';
import 'login_screen.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  void _logout(BuildContext context) {
    DemoAuth.logout();

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        actions: [
          IconButton(
            tooltip: 'Logout',
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const CircleAvatar(
            radius: 50,
            backgroundColor: Colors.indigo,
            child: Icon(
              Icons.person,
              size: 60,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Prince Alegria',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          const Card(
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.badge),
                  title: Text('Student ID'),
                  subtitle: Text('2026-554271'),
                ),
                ListTile(
                  leading: Icon(Icons.school),
                  title: Text('Course and Section'),
                  subtitle: Text('BSIT — CCE106 (3447)'),
                ),
                ListTile(
                  leading: Icon(Icons.email),
                  title: Text('Email'),
                  subtitle: Text('p.alegria.554271@umindanao.edu.ph'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            onPressed: () => _logout(context),
            icon: const Icon(Icons.logout),
            label: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
