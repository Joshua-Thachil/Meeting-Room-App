import 'package:flutter/material.dart';

class SideBarMenu extends StatelessWidget {
  final String currentRoute;
  final Function(String) onItemSelected;

  SideBarMenu(
      {super.key, required this.onItemSelected, required this.currentRoute});

  int _selectedIndex = 1;
  // Initialize to the default selected index (e.g., Weekly Schedule)
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 80.0, horizontal: 30),
            child: Image.network(
                "https://christuniversity.in/internationaloffice/logo.png"),
          ),
          _buildDrawerItem(
              // Reusable function for drawer items
              index: 0,
              icon: Icons.calendar_today_rounded,
              text: 'Daily Schedule',
              isSelected: currentRoute == '/dailySchedule',
              onTap: () => onItemSelected('/dailySchedule')),
          _buildDrawerItem(
              index: 1,
              icon: Icons.calendar_view_week_rounded,
              text: 'Weekly Schedule',
              isSelected: currentRoute == '/weeklySchedule',
              onTap: () => onItemSelected('/weeklySchedule')),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(
      {required int index,
      required IconData icon,
      required String text,
      required bool isSelected,
      required VoidCallback onTap}) {
    return GestureDetector(
      // Make drawer items tappable
      onTap: onTap,
      child: Container(
        width: 308,
        height: 72,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF04243E) : Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 50),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(icon,
                  size: 24, color: isSelected ? Colors.white : Colors.black),
              const SizedBox(width: 28),
              Text(
                text,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
                  fontSize: 20,
                  fontFamily: 'Instrument Sans',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
