import 'package:erp_sample/pages/dashboard_page.dart';
import 'package:erp_sample/pages/payments_and_approvals_page.dart';
import 'package:erp_sample/pages/project_list_page.dart';
import 'package:erp_sample/pages/task_and_team_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/tab_navigation_provider.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

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
    final nav = context.watch<TabNavigationProvider>();

    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          nav.setIndex(0);
        }
      },
      child: Scaffold(
        body: IndexedStack(
          index: nav.currentIndex,
          children: _pages,
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: nav.currentIndex,
          onTap: nav.setIndex,
          items: buildBottomNavBar(bottomNavBarItems),
        ),
      ),
    );
  }
}
