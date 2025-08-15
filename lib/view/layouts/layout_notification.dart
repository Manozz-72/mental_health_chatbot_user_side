import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserNotificationsScreen extends StatefulWidget {
  @override
  _UserNotificationsScreenState createState() => _UserNotificationsScreenState();
}

class _UserNotificationsScreenState extends State<UserNotificationsScreen> {
  @override
  Widget build(BuildContext context) {
    final userEmail = FirebaseAuth.instance.currentUser?.email;

    if (userEmail == null) {
      return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: const Text("Notifications", style: TextStyle(fontSize: 18)),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: const Center(child: Text("No user is logged in.")),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text("Notifications", style: TextStyle(fontSize: 18)),
        backgroundColor: Color(0xff21AF85),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 6.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 50),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(userEmail)
                  .collection('notifications')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text(
                      "No notifications available.",
                      style: TextStyle(fontSize: 16),
                    ),
                  );
                }

                final notifications = snapshot.data!.docs;

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: notifications.length,
                  itemBuilder: (context, index) {
                    final notification = notifications[index];
                    final title = notification['title'] ?? "No Title";
                    final message = notification['message'] ?? "No Message";
                    final timestamp = (notification['timestamp'] as Timestamp?)?.toDate();

                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: ListTile(
                        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(message),
                            if (timestamp != null)
                              Text(
                                "${_formatTimestamp(timestamp)}",
                                style: TextStyle(color: Colors.grey[600], fontSize: 12),
                              ),
                          ],
                        ),
                        onTap: () => _showDeleteConfirmationDialog(notification.id),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // Function to format the timestamp with relative time like "1 minute ago", "Yesterday", "1 month ago"
  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return "Just now";
    } else if (difference.inMinutes < 60) {
      return "${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago";
    } else if (difference.inHours < 24) {
      return "${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago";
    } else if (difference.inDays < 2) {
      return "Yesterday";
    } else if (difference.inDays < 30) {
      return "${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago";
    } else if (difference.inDays < 365) {
      return "${(difference.inDays / 30).floor()} month${(difference.inDays / 30).floor() > 1 ? 's' : ''} ago";
    } else {
      return "${(difference.inDays / 365).floor()} year${(difference.inDays / 365).floor() > 1 ? 's' : ''} ago";
    }
  }

  // Function to show a delete confirmation dialog when a notification is tapped
  Future<void> _showDeleteConfirmationDialog(String notificationId) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Delete Notification", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          content: const Text("Are you sure you want to delete this notification?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Close the dialog
                await _deleteNotification(notificationId); // Delete the notification
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  // Function to delete a notification
  Future<void> _deleteNotification(String notificationId) async {
    final userEmail = FirebaseAuth.instance.currentUser?.email;

    if (userEmail != null) {
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userEmail)
            .collection('notifications')
            .doc(notificationId)
            .delete();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Notification deleted successfully")),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error deleting notification: $e")),
        );
      }
    }
  }
}
