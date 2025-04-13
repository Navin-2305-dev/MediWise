import 'dart:async';
import 'package:flutter/material.dart';
import 'chat_page.dart'; // Assuming this is your ChatScreen file

class ChatListingScreen extends StatefulWidget {
  const ChatListingScreen({super.key});

  @override
  _ChatListingScreenState createState() => _ChatListingScreenState();
}

class _ChatListingScreenState extends State<ChatListingScreen> {
  final List<String> doctors = [
    "Dr. Smith",
    "Dr. Johnson",
    "Dr. Lee",
    "Dr. Davis",
    "Dr. Brown",
    "Charlie Brown",
    "David Wilson",
    "Emily Davis",
    "Frank White",
  ];

  final Map<String, bool> unreadMessages = {}; // Stores unread message status
  final StreamController<Map<String, bool>> _messageStreamController =
      StreamController.broadcast();

  @override
  void initState() {
    super.initState();
    _simulateIncomingMessages();
  }

  void _simulateIncomingMessages() {
    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        unreadMessages["Dr. Johnson"] = true;
        unreadMessages["Dr. Brown"] = true;
        _messageStreamController.add(unreadMessages);
      });
    });

    Future.delayed(Duration(seconds: 6), () {
      setState(() {
        unreadMessages["David Wilson"] = true;
        _messageStreamController.add(unreadMessages);
      });
    });
  }

  void _markAsRead(String doctorName) {
    setState(() {
      unreadMessages[doctorName] = false;
      _messageStreamController.add(unreadMessages);
    });
  }

  @override
  void dispose() {
    _messageStreamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Doctor Chats'),
        backgroundColor: Color.fromRGBO(100, 193, 255, 1),
        elevation: 0,
      ),
      body: StreamBuilder<Map<String, bool>>(
        stream: _messageStreamController.stream,
        initialData: unreadMessages,
        builder: (context, snapshot) {
          final unreadStatus = snapshot.data ?? {};

          // Sort doctors list: Unread chats first
          List<String> sortedDoctors = List.from(doctors);
          sortedDoctors.sort((a, b) {
            bool aUnread = unreadStatus[a] ?? false;
            bool bUnread = unreadStatus[b] ?? false;
            return (bUnread ? 1 : 0)
                .compareTo(aUnread ? 1 : 0); // Sort so unread comes first
          });

          return ListView.builder(
            itemCount: sortedDoctors.length,
            itemBuilder: (context, index) {
              String doctorName = sortedDoctors[index];
              bool hasNewMessage = unreadStatus[doctorName] ?? false;

              return Card(
                margin:
                    const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
                child: ListTile(
                  leading: Stack(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Color.fromARGB(255, 8, 149, 243),
                        child: Text(
                          doctorName[0],
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      if (hasNewMessage)
                        Positioned(
                          right: 0,
                          top: 0,
                          child: Container(
                            padding: EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              "!",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                    ],
                  ),
                  title: Text(
                    doctorName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                  subtitle: Text(
                    hasNewMessage ? "New Message!" : "Last message...",
                    style: TextStyle(
                      fontSize: 14,
                      color: hasNewMessage ? Colors.red : Colors.black54,
                      fontWeight:
                          hasNewMessage ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward,
                    color: Color.fromARGB(255, 8, 149, 243),
                  ),
                  onTap: () {
                    _markAsRead(doctorName);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ChatScreen(doctorName: doctorName),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
