import 'package:flutter/material.dart';
import 'package:voila_call_fb/screens/call_log_screen.dart';
import 'package:voila_call_fb/screens/dialpad_screen.dart';
import 'package:voila_call_fb/screens/voila_call_screen.dart';
import 'package:voila_call_fb/screens/statistics_page.dart';

class DashboardScreen extends StatelessWidget {
  final String username;

  DashboardScreen({required this.username});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Voila_Call - Welcome $username'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Call Log'),
              Tab(text: 'Dialpad'),
              Tab(text: 'Status of call'),
              Tab(text: 'Statistics'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            CallLogScreen(),
            DialpadScreen(),
            VoilaCallScreen(phoneNumber: '0000000000'),
            StatisticsPage(),
          ],
        ),
      ),
    );
  }
}
