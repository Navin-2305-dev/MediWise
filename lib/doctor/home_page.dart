import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart'; // Add the carousel_slider package
import 'package:mediwise/Health%20Mobile%20App/widgets/health_profile.dart';
import 'package:mediwise/doctor/Schedule.dart';
import 'package:mediwise/doctor/chat_open.dart';
import 'PatientDetailPage.dart';

// List of patients
final List<Patient> patients = [
  Patient(
      name: "Alice Johnson",
      age: 30,
      description:
          "A cheerful and active person. Loves outdoor activities and has a history of asthma.",
      condition: "Pulmonary Asthma",
      heartRate: 72,
      bodyTemperature: 37.0,
      spo2Level: 98.0),
  Patient(
      name: "Bob Smith",
      age: 45,
      description: "Has a heart condition but enjoys cooking and reading.",
      condition: "Cardiovascular Disease",
      heartRate: 58,
      bodyTemperature: 36.5,
      spo2Level: 95.0),
  Patient(
      name: "Charlie Brown",
      age: 60,
      description: "Retired, enjoys gardening and has diabetes.",
      condition: "Diabetes",
      heartRate: 120,
      bodyTemperature: 39.5,
      spo2Level: 85.0),
  Patient(
      name: "David Wilson",
      age: 35,
      description: "Sports enthusiast with a history of knee injuries.",
      condition: "Orthopedic Injury",
      heartRate: 100,
      bodyTemperature: 38.0,
      spo2Level: 92.0),
  Patient(
      name: "Emily Davis",
      age: 50,
      description:
          "Works as a teacher, and recently had surgery on her shoulder.",
      condition: "Shoulder Injury",
      heartRate: 50,
      bodyTemperature: 34.5,
      spo2Level: 89.0),
  Patient(
      name: "Frank White",
      age: 40,
      description:
          "A busy professional who enjoys cycling and has a history of back pain.",
      condition: "Back Pain",
      heartRate: 50,
      bodyTemperature: 34.5,
      spo2Level: 89),
];

// Feedback messages
final List<String> feedbackMessages = [
  "Great service! The doctor was very attentive. - Alice",
  "Easy appointment booking. Loved the experience! - Bob",
  "Very professional and kind staff.  - Charlie",
  "Helpful guidance and excellent treatment.  - David",
  "Fast response time and efficient service.  - Emily",
];

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  double heartRate = 72; // Example value (can be fetched dynamically)
  double bodyTemperature = 37.0; // Example value
  double spo2Level = 98; // Example value

  // Notification count example
  final Map<int, int> _notificationCounts = {
    2: 5, // Messages tab has 5 unread notifications
  };

  get get => null;

  bool _isVitalsCritical(
      double heartRate, double bodyTemperature, double spo2Level) {
    return heartRate < 50 ||
        heartRate > 120 ||
        bodyTemperature < 35 ||
        bodyTemperature > 40 ||
        spo2Level < 90;
  }

  // Determine if vitals are in a warning state
  bool _isVitalsWarning(
      double heartRate, double bodyTemperature, double spo2Level) {
    return (heartRate < 60 || heartRate > 100) ||
        (bodyTemperature < 36.5 || bodyTemperature > 37.5) ||
        (spo2Level < 95);
  }

  // Get the color based on the vitals
  Color _getBorderColor(
      double heartRate, double bodyTemperature, double spo2Level) {
    if (_isVitalsCritical(heartRate, bodyTemperature, spo2Level)) {
      return Colors.red; // Critical - Red border
    }
    if (_isVitalsWarning(heartRate, bodyTemperature, spo2Level)) {
      return Colors.yellow; // Warning - Yellow border
    }
    return Colors.green; // Stable - Green border
  }

  @override
  void initState() {
    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      // Clear notification count when the Messages tab is opened
      if (_notificationCounts.containsKey(index)) {
        _notificationCounts[index] = 0;
      }
    });

    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(),
          ),
        );
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PatientScheduleScreen(),
          ),
        );
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatListingScreen(),
          ),
        );
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProfilePage(),
          ),
        );
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0)),
            Text(
              "Hi, Dr. Navin B",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Carousel for Feedback
              Container(
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.blue.shade100,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: CarouselSlider.builder(
                  itemCount: feedbackMessages.length,
                  itemBuilder: (context, index, realIdx) => Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        feedbackMessages[index],
                        style: const TextStyle(
                          fontSize: 16,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  options: CarouselOptions(
                    height: 80,
                    autoPlay: true,
                    autoPlayInterval: const Duration(seconds: 3),
                    enlargeCenterPage: true,
                    enableInfiniteScroll: true,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "Patients under Supervision",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 8, 149, 243),
                ),
              ),
              const SizedBox(height: 16),
              // Horizontal sliding list of patient profiles
              SizedBox(
                height: 120,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: patients.length,
                  itemBuilder: (context, index) => GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              PatientDetailPage(patient: patients[index]),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: SizedBox(
                        width: 120,
                        height: 150,
                        child: Card(
                          color: Color.fromRGBO(100, 193, 255, 1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 10,
                          child: Center(
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: CircleAvatar(
                                    radius: 35,
                                    backgroundColor: Colors.grey.shade300,
                                    child: const Icon(
                                      Icons.person,
                                      size: 40,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                Text(
                                  patients[index].name,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Color.fromARGB(255, 248, 248, 248),
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const Text(
                "Patient Vitals",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              // Display Patient Cards
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: patients.length,
                itemBuilder: (context, index) {
                  final patient = patients[index];
                  final borderColor = _getBorderColor(patient.heartRate,
                      patient.bodyTemperature, patient.spo2Level);

                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white, // Neutral background
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: borderColor, // Apply only border color
                        width: 3, // Border thickness
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              patient.name,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 13, horizontal: 25),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: const Color.fromARGB(255, 221, 217, 217),
                              ),
                              child: Text(
                                "Files",
                                style: TextStyle(
                                  color: Colors.black38,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Heart Rate:",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Text("${patient.heartRate} bpm"),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Body Temperature:",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Text("${patient.bodyTemperature} °C"),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("SpO2 Level:",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Text("${patient.spo2Level}%"),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Color.fromARGB(255, 8, 149, 243),
        unselectedItemColor: Color.fromARGB(133, 39, 39, 39),
        type: BottomNavigationBarType.fixed,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: "Home",
            backgroundColor: Colors.blue.shade100,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.schedule),
            label: "Schedule",
            backgroundColor: Colors.blue.shade100,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.message,
              color: (_notificationCounts.containsKey(2) &&
                      _notificationCounts[2]! > 0)
                  ? Colors.red
                  : Colors.black,
            ),
            label: "Messages",
            backgroundColor: Colors.blue.shade100,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person),
            label: "Profile",
            backgroundColor: Colors.blue.shade100,
          ),
        ],
      ),
    );
  }
}
