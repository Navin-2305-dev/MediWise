import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mediwise/Health%20Mobile%20App/widgets/pdfdownloads.dart'; // Adjust path as needed
import 'package:mediwise/Health%20Mobile%20App/widgets/settings.dart'; // Adjust path as needed

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
          .collection('doctors') // Changed to 'doctors' collection
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
                    .collection('doctors') // Changed to 'doctors' collection
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
        title: const Text('Doctor Profile'),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      SettingsPage(), // Ensure SettingsPage exists
                ),
              );
            },
          ),
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
              onEdit: () => editProfileField('uid', userData?['uid'] ?? 'N/A'),
            ),
            const Divider(),
            ProfileDetailRow(
              icon: Icons.email,
              label: 'Email',
              value: userData?['email'] ?? 'N/A',
              onEdit: () =>
                  editProfileField('email', userData?['email'] ?? 'N/A'),
            ),
            const Divider(),
            ProfileDetailRow(
              icon: Icons.person,
              label: 'Specialization',
              value: userData?['specialization'] ?? 'N/A',
              onEdit: () => editProfileField(
                  'specialization', userData?['specialization'] ?? 'N/A'),
            ),
            const Divider(),
            ProfileDetailRow(
              icon: Icons.work,
              label: 'Experience',
              value: userData?['experience'] ?? 'N/A',
              onEdit: () => editProfileField(
                  'experience', userData?['experience'] ?? 'N/A'),
            ),
            const Divider(),
            ProfileDetailRow(
              icon: Icons.local_hospital,
              label: 'Hospital',
              value: userData?['hospital'] ?? 'N/A',
              onEdit: () =>
                  editProfileField('hospital', userData?['hospital'] ?? 'N/A'),
            ),
            const Divider(),
            ProfileDetailRow(
              icon: Icons.phone,
              label: 'Contact',
              value: userData?['contact'] ?? 'N/A',
              onEdit: () =>
                  editProfileField('contact', userData?['contact'] ?? 'N/A'),
            ),
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
          leading: const Icon(Icons.receipt_long, color: Colors.indigo),
          title: const Text(
            'Doctor’s Reports',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          subtitle: const Text('View your reports here',
              style: TextStyle(color: Colors.grey)),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PatientPDFPage(
                  uniqueId:
                      'ba2fc6e7-2cfc-4ea5-a384-60bd873751b2', // Replace with dynamic ID if needed
                ),
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
          onPressed: onEdit,
        ),
      ],
    );
  }
}
