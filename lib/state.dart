import 'package:flutter/material.dart';

class NotificationState extends ChangeNotifier {
  int _unreadCount = 0;

  int get unreadCount => _unreadCount;

  void incrementUnreadCount() {
    _unreadCount++;
    notifyListeners();
  }

  void resetUnreadCount() {
    _unreadCount = 0;
    notifyListeners();
  }
}
