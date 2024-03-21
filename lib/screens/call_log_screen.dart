import 'package:flutter/material.dart';
import 'package:call_log/call_log.dart';
import 'contact_details_screen.dart'; // Import the ContactDetailsScreen
import 'package:url_launcher/url_launcher.dart';
import 'voila_call_screen.dart'; // Import the VoilaCallScreen

class CallLogScreen extends StatefulWidget {
  @override
  _CallLogScreenState createState() => _CallLogScreenState();
}

class _CallLogScreenState extends State<CallLogScreen> {
  DateTime? _startDate;
  DateTime? _endDate;
  Stream<List<CallLogEntry>>? _filteredCallLogsStream;

  @override
  void initState() {
    super.initState();
    _filteredCallLogsStream = _fetchFilteredCallLogsStream(DateTime.now(), DateTime.now());
  }

  Stream<List<CallLogEntry>> _fetchFilteredCallLogsStream(DateTime startDate, DateTime endDate) async* {
    while (true) {
      await Future.delayed(Duration(seconds: 1)); // Adjust the delay time as needed
      Iterable<CallLogEntry> callLogs = await CallLog.get();
      yield _filterCallLogs(callLogs, startDate, endDate);
    }
  }

  List<CallLogEntry> _filterCallLogs(Iterable<CallLogEntry> callLogs, DateTime startDate, DateTime endDate) {
    return callLogs.where((call) {
      final DateTime callDateTime = DateTime.fromMillisecondsSinceEpoch(call.timestamp ?? 0);
      return callDateTime.isAfter(startDate.subtract(Duration(days: 1))) && callDateTime.isBefore(endDate.add(Duration(days: 1)));
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Call Log'),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () => _showFilterDateRangePicker(),
          ),
        ],
      ),
      body: StreamBuilder<List<CallLogEntry>>(
        stream: _filteredCallLogsStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final callLogs = snapshot.data ?? [];
            return ListView.builder(
              itemCount: callLogs.length,
              itemBuilder: (context, index) {
                final call = callLogs[index];
                return ListTile(
                  leading: IconButton(
                    icon: Icon(Icons.call),
                    onPressed: () {
                      _makeCall(call.number ?? '');
                    },
                  ),
                  title: Text(call.name ?? 'Unknown'),
                  subtitle: Text(call.number ?? 'Unknown'),
                  trailing: Text(_formatTimestamp(call.timestamp)),
                  onTap: () {
                    // Navigate to ContactDetailsScreen when tapped
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ContactDetailsScreen(call),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }

  String _formatTimestamp(int? timestamp) {
    if (timestamp == null) {
      return 'Unknown';
    }
    final DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}:${dateTime.second.toString().padLeft(2, '0')}';
  }

  void _makeCall(String phoneNumber) async {
    try {
      final url = 'tel:$phoneNumber';
      await launch(url);
      // After the call ends, navigate to the status of call page
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VoilaCallScreen(phoneNumber: phoneNumber),
        ),
      );
    } catch (e) {
      // Handle error if call cannot be launched
      print('Error launching call: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not make a call'),
        ),
      );
    }
  }

  Future<void> _showFilterDateRangePicker() async {
    final DateTime? pickedStartDate = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (pickedStartDate != null) {
      final DateTime? pickedEndDate = await showDatePicker(
        context: context,
        initialDate: _endDate ?? pickedStartDate,
        firstDate: pickedStartDate,
        lastDate: DateTime.now(),
      );
      if (pickedEndDate != null) {
        setState(() {
          _startDate = pickedStartDate;
          _endDate = pickedEndDate;
          _filteredCallLogsStream = _fetchFilteredCallLogsStream(pickedStartDate, pickedEndDate);
        });
      }
    }
  }
}
