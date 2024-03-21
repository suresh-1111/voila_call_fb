import 'package:flutter/material.dart';
import 'dashboard_screen.dart';
import 'database_helper.dart';
import 'package:voila_call_fb/auth//register_screen.dart';
class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Welcome', style: TextStyle(fontSize: 24)),
            SizedBox(height: 20),
            TextField(
              controller: usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: passwordController,
              obscureText: !_passwordVisible,
              decoration: InputDecoration(
                labelText: 'Password',
                suffixIcon: IconButton(
                  icon: Icon(
                    _passwordVisible ? Icons.visibility : Icons.visibility_off,
                    color: Theme.of(context).primaryColorDark,
                  ),
                  onPressed: () {
                    setState(() {
                      // Toggle the password visibility state
                      _passwordVisible = !_passwordVisible;
                    });
                  },
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // Implement login functionality
                String username = usernameController.text;
                String password = passwordController.text;

                // Check if username exists and password matches
                if (await _checkCredentials(username, password)) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>  DashboardScreen(username: '',),
                    ),
                  );
                } else {
                  // Show error message for invalid credentials
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Error'),
                        content: Text('Invalid username or password.'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              child: Text('Login'),
            ),
            SizedBox(height: 10),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterScreen(userCredentials: {})),
                );
              },
              child: Text('Register'),
            ),

          ],
        ),
      ),
    );
  }

  Future<bool> _checkCredentials(String username, String password) async {
    List<Map<String, dynamic>> users = await DatabaseHelper.getUsers();
    for (var user in users) {
      if (user['username'] == username && user['password'] == password) {
        return true;
      }
    }
    return false;
  }
}

