import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:erp_sample/pages/dashboard_page.dart';
import 'package:erp_sample/pages/payments_and_approvals_page.dart';
import 'package:erp_sample/pages/project_list_page.dart';
import 'package:erp_sample/pages/task_and_team_page.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    DashboardPage(),
    ProjectListPage(),
    TaskTeamPage(),
    PaymentsApprovalsPage(),
    DashboardPage(),
  ];
  
  final List<Map<String, dynamic>> bottomNavBarItems = const [
    {"icon": Icon(Icons.dashboard), "label": "Dashboard",},
    {"icon": Icon(Icons.business), "label": "Projects",},
    {"icon": Icon(Icons.task), "label": "Tasks",},
    {"icon": Icon(Icons.attach_money_rounded), "label": "Payments",},
    {"icon": Icon(Icons.person), "label": "Profile",},
  ];
  
  List<BottomNavigationBarItem> buildBottomNavBar(List<Map<String, dynamic>> items) {
    return items.map((item) {
      return BottomNavigationBarItem(
        icon: item["icon"],
        label: item["label"],
        backgroundColor: Color(0xFF112117),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: buildBottomNavBar(bottomNavBarItems),
      ),
    );
  }
}
