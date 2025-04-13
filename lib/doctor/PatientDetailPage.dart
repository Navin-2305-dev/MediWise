import 'package:flutter/material.dart';

class Patient {
  final String name;
  final int age;
  final String description;
  final String condition;
  final double heartRate;
  final double bodyTemperature;
  final double spo2Level;

  Patient({
    required this.name,
    required this.age,
    required this.description,
    required this.condition,
    required this.heartRate,
    required this.bodyTemperature,
    required this.spo2Level,
  });
}

class PatientDetailPage extends StatelessWidget {
  final Patient patient;

  const PatientDetailPage({super.key, required this.patient});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Card(
              shadowColor: Colors.blue,
              color: Color.fromRGBO(100, 193, 255, 1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min, // Wrap content
                  children: [
                    CircleAvatar(
                      radius: 80,
                      backgroundColor: Colors.grey.shade300,
                      child: const Icon(
                        Icons.person,
                        size: 80,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      patient.name,
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Age: ${patient.age}",
                      style: TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Description: ${patient.description}",
                      style: TextStyle(fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Description: ${patient.condition}",
                      style: TextStyle(fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Custom back button at the top-left corner
          Positioned(
            top: 40, // Adjust the position as needed
            left: 16,
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white
                      .withOpacity(0.8), // Light background for contrast
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.arrow_back, color: Colors.black, size: 28),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
