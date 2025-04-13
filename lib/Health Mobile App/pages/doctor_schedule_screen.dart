import 'package:flutter/material.dart';
import 'package:mediwise/Health%20Mobile%20App/models/schedule_model.dart';
import 'package:mediwise/Health%20Mobile%20App/utils/color.dart';
import 'package:iconsax/iconsax.dart';
import 'package:url_launcher/url_launcher.dart';

class DoctorScheduleScreen extends StatefulWidget {
  const DoctorScheduleScreen({super.key});

  @override
  State<DoctorScheduleScreen> createState() => _DoctorScheduleScreenState();
}

class _DoctorScheduleScreenState extends State<DoctorScheduleScreen> {
  String selectedOption = "Upcoming";

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      setState(() {});
      Future.doWhile(() async {
        await Future.delayed(const Duration(seconds: 30));
        if (mounted) setState(() {});
        return mounted;
      });
    });
  }

  bool isMeetTime(String date, String time) {
    try {
      DateTime appointmentDateTime;
      final now = DateTime.now();

      if (date.toLowerCase() == 'tomorrow') {
        appointmentDateTime = DateTime.now().add(const Duration(days: 1));
      } else {
        final dateParts = date.split('/');
        appointmentDateTime = DateTime(
          int.parse(dateParts[2]),
          int.parse(dateParts[1]),
          int.parse(dateParts[0]),
        );
      }

      final timeParts = time.split(' - ');
      final startTimeStr = timeParts[0];

      final timeFormat = RegExp(r'(\d+):(\d+)\s*(AM|PM)', caseSensitive: false);
      final match = timeFormat.firstMatch(startTimeStr);
      if (match != null) {
        int hour = int.parse(match.group(1)!);
        final minute = int.parse(match.group(2)!);
        final period = match.group(3)!.toUpperCase();

        if (period == 'PM' && hour != 12) hour += 12;
        if (period == 'AM' && hour == 12) hour = 0;

        final appointmentTime = DateTime(
          appointmentDateTime.year,
          appointmentDateTime.month,
          appointmentDateTime.day,
          hour,
          minute,
        );

        final endWindow = appointmentTime.add(const Duration(minutes: 30));
        return now.isAfter(appointmentTime) && now.isBefore(endWindow);
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<void> rescheduleAppointment(int index) async {
    // Show date picker
    DateTime? newDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (newDate == null) return;

    // Show start time picker
    TimeOfDay? newStartTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (newStartTime == null) return;

    // Calculate end time (1 hour after start time)
    final newEndTime = TimeOfDay(
      hour: (newStartTime.hour + 1) % 24,
      minute: newStartTime.minute,
    );

    // Format the date and time to match your existing format
    String formattedDate =
        "${newDate.day.toString().padLeft(2, '0')}/${newDate.month.toString().padLeft(2, '0')}/${newDate.year}";

    // Format times to match your existing "HH:MM AM/PM - HH:MM AM/PM" format
    String formatTimeOfDay(TimeOfDay time) {
      final now = DateTime.now();
      final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
      final format = dt.hour < 12 ? 'AM' : 'PM';
      final hour = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
      return "${hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')} $format";
    }

    String formattedTime =
        "${formatTimeOfDay(newStartTime)} - ${formatTimeOfDay(newEndTime)}";

    // Update the schedule with new values
    setState(() {
      scheduleDoctors[index].date = formattedDate;
      scheduleDoctors[index].time = formattedTime;
    });
  }

  void cancelAppointment(int index) {
    setState(() {
      scheduleDoctors.removeAt(index);
    });
  }

  Future<void> joinMeet(String doctorName, String? meetLink) async {
    final String urlToLaunch =
        meetLink ?? 'https://meet.google.com/net-wxfc-eua';
    final Uri url = Uri.parse(urlToLaunch);
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Could not launch meeting")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error launching meeting: $e")),
      );
    }
  }

  // Rest of your existing build methods remain the same
  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Schedule",
          style: TextStyle(
              fontSize: 22, fontWeight: FontWeight.w600, color: Colors.black),
        ),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              SizedBox(
                height: 50,
                width: deviceWidth,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    buildOption("Upcoming"),
                    buildOption("Complete"),
                    buildOption("Result"),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Expanded(child: buildContent()),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildOption(String option) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedOption = option;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 25),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: selectedOption == option ? kPrimaryColor : Colors.transparent,
        ),
        child: Text(
          option,
          style: TextStyle(
            color: selectedOption == option ? Colors.white : Colors.black38,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget buildContent() {
    if (selectedOption == "Upcoming") {
      return buildUpcoming();
    } else if (selectedOption == "Complete") {
      return buildComplete();
    } else if (selectedOption == "Result") {
      return buildResult();
    }
    return const SizedBox.shrink();
  }

  Widget buildUpcoming() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: scheduleDoctors.length,
      itemBuilder: (context, index) {
        final doctor = scheduleDoctors[index];
        final isActive = isMeetTime(doctor.date, doctor.time);

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Container(
            width: double.infinity,
            height: 245,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: secondaryBgColor,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(doctor.profile),
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            doctor.name,
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w600),
                          ),
                          Text(
                            doctor.position,
                            style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Colors.black45),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                      color: cardBgColor,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    height: 35,
                    width: 290,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Icon(Iconsax.calendar_1, color: Colors.black54),
                        Text(
                          doctor.date,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.black45,
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Icon(Iconsax.clock, color: Colors.black54),
                        Text(
                          doctor.time,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.black45,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () => cancelAppointment(index),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: kPrimaryColor),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 5),
                            child: Text("Cancel",
                                style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w500,
                                    color: kPrimaryColor)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: () => rescheduleAppointment(index),
                        child: Container(
                          decoration: BoxDecoration(
                            color: kPrimaryColor,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 5),
                            child: Text("Reschedule",
                                style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: isActive
                            ? () => joinMeet(doctor.name, doctor.meetLink)
                            : null,
                        child: Container(
                          decoration: BoxDecoration(
                            color: isActive ? Colors.green : Colors.grey,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 5),
                            child: Text(
                              "Join",
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w500,
                                color: isActive ? Colors.white : Colors.white70,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildComplete() =>
      const Center(child: Text("No completed appointments"));

  Widget buildResult() => const Center(child: Text("No results available"));
}
