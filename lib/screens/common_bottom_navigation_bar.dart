import 'package:flutter/material.dart';

class CommonBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTabTapped;
  final String profilePhotoUrl;

  CommonBottomNavigationBar({
    required this.currentIndex,
    required this.onTabTapped,
    required this.profilePhotoUrl,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTabTapped,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: CircleAvatar(
            backgroundImage: NetworkImage(profilePhotoUrl), // Use NetworkImage
            radius: 15,
          ),
          label: 'Profile',
        ),
      ],
    );
  }
}
