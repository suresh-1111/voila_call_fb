import 'package:flutter/material.dart';
import 'package:voila_call_fb/widgets/database_helper.dart';

class VoilaCallScreen extends StatefulWidget {
  final String phoneNumber;

  VoilaCallScreen({required this.phoneNumber});

  @override
  _VoilaCallScreenState createState() => _VoilaCallScreenState();
}


class _VoilaCallScreenState extends State<VoilaCallScreen> {



  String selectedLead = 'not responding';
  String selectedCallType = 'incoming'; // Default to incoming call
  String selectedCallTag = 'unanswered'; // Default to unanswered
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  @override
  void initState() {
    super.initState();
    phoneNumberController.text = widget.phoneNumber;
  }
  TextEditingController commentController = TextEditingController();

  void submitData() async {
    String name = nameController.text;
    String phoneNumber = phoneNumberController.text;
    String comment = commentController.text;
    String callType = selectedCallType;
    String callTag = selectedCallTag;
    // Get current date and time
    DateTime now = DateTime.now();
    String callDate = now.toString();
    print('Data inserted into SQLite database: Name: $name, Lead: $selectedLead, Phone Number: $phoneNumber, Comment: $comment, Call Type: $callType, Call Tag: $callTag, Call Date: $callDate');
    await DatabaseHelper().insertCustomer({
      DatabaseHelper.colName: name,
      DatabaseHelper.colPhoneNumber: phoneNumber,
      DatabaseHelper.colComment: comment,
      DatabaseHelper.colCallType: callType,
      DatabaseHelper.colCallTag: callTag,
      DatabaseHelper.colDate: callDate,
      DatabaseHelper.colLead: selectedLead,
    });// Store customer data in the database
    nameController.clear();
    phoneNumberController.clear();
    commentController.clear();
    setState(() {
      selectedLead = 'not responding';
      selectedCallType = 'incoming';
      selectedCallTag = 'unanswered';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Status of call'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Name:',
                style: TextStyle(fontSize: 18),
              ),
              TextField(
                controller: nameController,
              ),
              SizedBox(height: 20),
              Text(
                'Phone Number:',
                style: TextStyle(fontSize: 18),
              ),
              TextField(
                controller: phoneNumberController,
              ),
              SizedBox(height: 20),
              Text(
                'Comment:',
                style: TextStyle(fontSize: 18),
              ),
              TextField(
                controller: commentController,
              ),
              SizedBox(height: 20),
              Text(
                'Select Lead:',
                style: TextStyle(fontSize: 18),
              ),
              Column(
                children: [
                  RadioListTile(
                    title: Text('Not Responding'),
                    value: 'not responding',
                    groupValue: selectedLead,
                    onChanged: (value) {
                      setState(() {
                        selectedLead = value.toString();
                      });
                    },
                  ),
                  RadioListTile(
                    title: Text('Open Lead'),
                    value: 'open lead',
                    groupValue: selectedLead,
                    onChanged: (value) {
                      setState(() {
                        selectedLead = value.toString();
                      });
                    },
                  ),
                  RadioListTile(
                    title: Text('Warm Lead'),
                    value: 'warm lead',
                    groupValue: selectedLead,
                    onChanged: (value) {
                      setState(() {
                        selectedLead = value.toString();
                      });
                    },
                  ),
                  RadioListTile(
                    title: Text('Cold Lead'),
                    value: 'cold lead',
                    groupValue: selectedLead,
                    onChanged: (value) {
                      setState(() {
                        selectedLead = value.toString();
                      });
                    },
                  ),
                  RadioListTile(
                    title: Text('Hot Lead'),
                    value: 'hot lead',
                    groupValue: selectedLead,
                    onChanged: (value) {
                      setState(() {
                        selectedLead = value.toString();
                      });
                    },
                  ),
                  RadioListTile(
                    title: Text('Customer'),
                    value: 'customer',
                    groupValue: selectedLead,
                    onChanged: (value) {
                      setState(() {
                        selectedLead = value.toString();
                      });
                    },
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text(
                'Select Call Type:',
                style: TextStyle(fontSize: 18),
              ),
              Column(
                children: [
                  RadioListTile(
                    title: Text('Incoming'),
                    value: 'incoming',
                    groupValue: selectedCallType,
                    onChanged: (value) {
                      setState(() {
                        selectedCallType = value.toString();
                      });
                    },
                  ),
                  RadioListTile(
                    title: Text('Outgoing'),
                    value: 'outgoing',
                    groupValue: selectedCallType,
                    onChanged: (value) {
                      setState(() {
                        selectedCallType = value.toString();
                      });
                    },
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text(
                'Select Call Tag:',
                style: TextStyle(fontSize: 18),
              ),
              Column(
                children: [
                  RadioListTile(
                    title: Text('Answered'),
                    value: 'answered',
                    groupValue: selectedCallTag,
                    onChanged: (value) {
                      setState(() {
                        selectedCallTag = value.toString();
                      });
                    },
                  ),
                  RadioListTile(
                    title: Text('Unanswered'),
                    value: 'unanswered',
                    groupValue: selectedCallTag,
                    onChanged: (value) {
                      setState(() {
                        selectedCallTag = value.toString();
                      });
                    },
                  ),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: submitData,
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
