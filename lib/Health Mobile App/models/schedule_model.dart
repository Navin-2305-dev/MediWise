class ScheduleModel {
  String name;
  String position;
  String time;
  String date;
  String profile;
  String? meetLink; // Added meetLink field

  ScheduleModel({
    required this.name,
    required this.position,
    required this.time,
    required this.date,
    required this.profile,
    this.meetLink, // Optional meetLink parameter
  });
}

final List<ScheduleModel> scheduleDoctors = [
  ScheduleModel(
    name: "Dr. Adison Schleifers",
    position: "Dental Specialist",
    time: '06:30 PM - 08:30 PM',
    date: 'Tomorrow', // We'll need to handle this special case
    profile:
        "https://static.vecteezy.com/system/resources/thumbnails/026/375/249/small_2x/ai-generative-portrait-of-confident-male-doctor-in-white-coat-and-stethoscope-standing-with-arms-crossed-and-looking-at-camera-photo.jpg",
    meetLink: "https://meet.google.com/net-wxfc-eua", // Replace with your link
  ),
  ScheduleModel(
    name: "Dr. Ruben Dorwart",
    position: "Dental Specialist",
    time: '02:30 PM - 03:30 PM',
    date: '26/03/2025',
    profile:
        "https://images.unsplash.com/photo-1612276529731-4b21494e6d71?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8ZG9jdG9yJTIwcG9ydHJhaXR8ZW58MHx8MHx8fDA%3D",
    meetLink:
        "https://meet.google.com/your-personal-link-2", // Replace with your link
  ),
  ScheduleModel(
    name: "Dr. Skylar Korsgaard",
    position: "General Practitioner",
    time: '01:30 PM - 03:30 PM',
    date: '30/03/2025',
    profile:
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ6F_dcVRDHxwT9RWoHyHA_Wnt9EPNJStZ0Ww&s",
    meetLink:
        "https://meet.google.com/your-personal-link-3", // Replace with your link
  ),
  ScheduleModel(
    name: "Dr. Peter James",
    position: "General Practitioner",
    time: '10:30 AM - 11:30 AM',
    date: '06/04/2025',
    profile:
        "https://media.istockphoto.com/id/1307543618/photo/team-of-doctors-and-nurses-in-hospital.jpg?s=612x612&w=0&k=20&c=-t6j5lmy_DFWtXb5HdDe0Kj6dXZwsviihuOA2lvXX5Q=",
    meetLink:
        "https://meet.google.com/your-personal-link-4", // Replace with your link
  ),
];
