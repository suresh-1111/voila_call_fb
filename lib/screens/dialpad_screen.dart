import 'package:flutter/material.dart';
import 'package:call_log/call_log.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:voila_call_fb/call_log.dart'; // Import CallLogService
import 'package:voila_call_fb/screens/voila_call_screen.dart'; // Import VoilaCallScreen
import 'package:voila_call_fb/services/call_service.dart';
import 'package:voila_call_fb/widgets/custom_dialpad.dart'; // Import CustomDialpad

class DialpadScreen extends StatefulWidget {
  @override
  _DialpadScreenState createState() => _DialpadScreenState();
}

class _DialpadScreenState extends State<DialpadScreen> {
  List<CallLogEntry> _callLogs = [];
  List<String> _enteredDigits = [];

  @override
  void initState() {
    super.initState();
    _fetchCallLogs();
  }

  Future<void> _fetchCallLogs() async {
    List<CallLogEntry> callLogs = await CallLogService.getCallLogs();
    setState(() {
      _callLogs = callLogs;
    });
  }

  void _handleDigitPressed(String digit) {
    setState(() {
      _enteredDigits.add(digit);
    });
  }

  void _handleClearPressed() {
    setState(() {
      if (_enteredDigits.isNotEmpty) {
        _enteredDigits.removeLast();
      }
    });
  }

  void _makeCall() async {
    String phoneNumber = _enteredDigits.join();

    // Launch the call
    await launch('tel:$phoneNumber');

    // Navigate to the status of call page
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VoilaCallScreen(phoneNumber: phoneNumber),
      ),
    );
  }



  void _makeCallToContact(String phoneNumber) {
    launch('tel:$phoneNumber').then((value) {
      // Once the call is made, navigate to the VoilaCallScreen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VoilaCallScreen(phoneNumber: phoneNumber),
        ),
      );
    }).catchError((error) {
      // Handle error if call couldn't be initiated
      print('Error making call: $error');
      // Still navigate to the VoilaCallScreen even if call couldn't be initiated
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VoilaCallScreen(phoneNumber: phoneNumber),
        ),
      );
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dialpad'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _callLogs.length,
              itemBuilder: (context, index) {
                CallLogEntry log = _callLogs[index];
                return ListTile(
                  title: Text(log.name ?? 'Unknown'),
                  subtitle: Text(log.number ?? 'Unknown'),
                  trailing: Text(_formatTimestamp(log.timestamp) ?? 'Unknown'),
                  onTap: () {
                    _makeCallToContact(log.number ?? '');
                  },
                );
              },
            ),
          ),
          Text(
            _enteredDigits.join(), // Display entered digits
            style: TextStyle(fontSize: 20),
          ),
          CustomDialpad(
            onDigitPressed: _handleDigitPressed,
            onClearPressed: _handleClearPressed,
            onCallPressed: _makeCall,
          ),
        ],
      ),
    );
  }
}

String? _formatTimestamp(int? timestamp) {
  if (timestamp == null) return null;
  final DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
  final String hours = '${dateTime.hour}'.padLeft(2, '0');
  final String minutes = '${dateTime.minute}'.padLeft(2, '0');
  final String seconds = '${dateTime.second}'.padLeft(2, '0');
  return '$hours:$minutes:$seconds';
}