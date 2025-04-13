import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mediwise/Health%20Mobile%20App/widgets/pdfdownloads.dart';
import 'package:mediwise/Health%20Mobile%20App/widgets/settings.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? userId;
  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    getUserID();
  }

  void getUserID() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        userId = user.uid;
      });
      fetchUserData();
    }
  }

  void fetchUserData() async {
    if (userId != null) {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      setState(() {
        userData = snapshot.data() as Map<String, dynamic>?;
      });
    }
  }

  void editProfileField(String field, String currentValue) {
    TextEditingController controller =
        TextEditingController(text: currentValue);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit $field'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(
              labelText: 'Enter new $field',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(userId)
                    .update({field: controller.text});
                fetchUserData();
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Profile'),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SettingsPage(),
                  ),
                );
              })
        ],
      ),
      body: userData == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        height: 120,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.indigo, Colors.blueAccent],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                      ),
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(userData?['profilePic'] ??
                            'https://i.pinimg.com/originals/54/72/d1/5472d1b09d3d724228109d381d617326.jpg'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    userData?['name'] ?? 'Unknown',
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 10),
                  buildDetailCard(),
                  const SizedBox(height: 10),
                  buildDiagnosisCard(),
                ],
              ),
            ),
    );
  }

  Widget buildDetailCard() {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ProfileDetailRow(
                icon: Icons.lock,
                label: 'Unique ID',
                value: userData?['uid'] ?? 'N/A',
                onEdit: () =>
                    editProfileField('uniqueId', userData?['uid'] ?? 'N/A')),
            const Divider(),
            ProfileDetailRow(
                icon: Icons.email,
                label: 'Email',
                value: userData?['email'] ?? 'N/A',
                onEdit: () =>
                    editProfileField('email', userData?['email'] ?? 'N/A')),
            const Divider(),
            ProfileDetailRow(
                icon: Icons.bloodtype,
                label: 'Blood Group',
                value: userData?['bloodGroup'] ?? 'N/A',
                onEdit: () => editProfileField(
                    'bloodGroup', userData?['bloodGroup'] ?? 'N/A')),
            const Divider(),
            ProfileDetailRow(
                icon: Icons.warning,
                label: 'Allergies',
                value: userData?['allergies'] ?? 'None',
                onEdit: () => editProfileField(
                    'allergies', userData?['allergies'] ?? 'None')),
            const Divider(),
            ProfileDetailRow(
                icon: Icons.medical_services,
                label: 'Current Medications',
                value: userData?['medications'] ?? 'None',
                onEdit: () => editProfileField(
                    'medications', userData?['medications'] ?? 'None')),
          ],
        ),
      ),
    );
  }

  Widget buildDiagnosisCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: ListTile(
          leading: Icon(Icons.receipt_long, color: Colors.indigo),
          title: Text(
            'Complete Diagnosis Report',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          subtitle: Text('Your Report available here',
              style: TextStyle(color: Colors.grey)),
          trailing: Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PatientPDFPage(
                    uniqueId: 'ba2fc6e7-2cfc-4ea5-a384-60bd873751b2'),
              ),
            );
          },
        ),
      ),
    );
  }
}

class ProfileDetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final VoidCallback onEdit;

  const ProfileDetailRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.indigo, size: 24),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const Spacer(),
        IconButton(
            icon: const Icon(Icons.edit, color: Colors.grey, size: 20),
            onPressed: onEdit),
      ],
    );
  }
}
