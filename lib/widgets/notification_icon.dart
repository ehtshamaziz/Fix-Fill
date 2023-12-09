import 'package:flutter/material.dart';

class NotificationIcon extends StatelessWidget {
  final int notificationCount;

  NotificationIcon({required this.notificationCount});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        const Icon(Icons.notifications), // Notification icon
        if (notificationCount > 0) // Show badge only if there are notifications
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              padding: EdgeInsets.all(1),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(6),
              ),
              constraints: BoxConstraints(
                minWidth: 12,
                minHeight: 12,
              ),
              child: Text(
                '$notificationCount',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 8,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }
}
