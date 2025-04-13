// In schedule_model.dart
class PatientScheduleModel {
  String name;
  String problem;
  String profile;
  String date;
  String time;
  String meetingLink;

  PatientScheduleModel({
    required this.name,
    required this.problem,
    required this.profile,
    required this.date,
    required this.time,
    this.meetingLink = '',
  });
}

final List<PatientScheduleModel> schedulePatients = [
  PatientScheduleModel(
    name: "Max Verstappen",
    problem: "Being a F1 G.O.A.T",
    time: '06:30 PM - 08:30 PM',
    date: 'Tomorrow',
    profile:
        "https://th.bing.com/th?id=OIF.19x%2bigHGtb%2brvwEWys2a5Q&w=316&h=180&c=7&r=0&o=5&dpr=1.3&pid=1.7",
    meetingLink: 'https://meet.google.com/net-wxfc-eua',
  ),
  PatientScheduleModel(
    name: "Claire Williams",
    problem: "Dental Braces",
    time: '02:30 PM - 03:30 PM',
    date: '12/02/2025',
    profile:
        "https://th.bing.com/th/id/OIP.3gDpMmmFRNjdvrd6Ar4h_AHaJW?w=136&h=180&c=7&r=0&o=5&dpr=1.3&pid=1.7",
  ),
  PatientScheduleModel(
    name: "Dr. Skylar Korsgaard",
    problem: "General Practitioner",
    time: '01:30 PM - 03:30 PM',
    date: '15/02/2025',
    profile:
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ6F_dcVRDHxwT9RWoHyHA_Wnt9EPNJStZ0Ww&s",
  ),
  PatientScheduleModel(
    name: "Dr. Peter James",
    problem: "General Practitioner",
    time: '10:30 AM - 11:30 AM',
    date: '10/03/2025',
    profile:
        "https://media.istockphoto.com/id/1307543618/photo/team-of-doctors-and-nurses-in-hospital.jpg?s=612x612&w=0&k=20&c=-t6j5lmy_DFWtXb5HdDe0Kj6dXZwsviihuOA2lvXX5Q=",
  ),
];
