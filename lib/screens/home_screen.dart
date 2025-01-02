import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myapp/utils/helpers/navigation_helper.dart';
import 'package:myapp/values/app_routes.dart';
import 'package:myapp/values/app_strings.dart';

class HomePage extends StatelessWidget {
  final String uid;

  const HomePage({super.key, required this.uid});

  // Fungsi untuk mengambil data pengguna berdasarkan UID
  Future<Map<String, dynamic>?> fetchUserData(String uid) async {
    try {
      final userDoc = FirebaseFirestore.instance.collection('users').doc(uid);
      final snapshot = await userDoc.get();

      if (snapshot.exists) {
        return snapshot.data();
      }
    } catch (e) {
      debugPrint('Error fetching user data: $e');
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => NavigationHelper.pushReplacementNamed(
              AppRoutes.login,
            ),
          ),
        ],
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: fetchUserData(uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error fetching user data: ${snapshot.error}',
                style: const TextStyle(color: Colors.red, fontSize: 16),
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(
              child: Text(
                'User data not found.',
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          final userData = snapshot.data!;
          final createdAt = userData['createdAt'] != null
              ? (userData['createdAt'] as Timestamp).toDate()
              : null;

          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.blueAccent,
                    child: Text(
                      userData['name']?[0]?.toUpperCase() ?? '?',
                      style: const TextStyle(
                        fontSize: 40,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    userData['name'] ?? 'No Name',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    userData['email'] ?? 'No Email',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Role: ${userData['role'] ?? 'Unknown'}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                  if (createdAt != null)
                    Text(
                      'Joined: ${createdAt.day}/${createdAt.month}/${createdAt.year}',
                      style: const TextStyle(fontSize: 16),
                    )
                  else
                    const Text(
                      'Join date not available.',
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () => NavigationHelper.pushReplacementNamed(
                      AppRoutes.login,
                    ),
                    icon: const Icon(Icons.logout),
                    label: const Text(AppStrings.logout),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
