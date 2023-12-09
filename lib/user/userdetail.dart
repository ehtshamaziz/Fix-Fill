import 'package:firebase_auth/firebase_auth.dart';
import 'package:fix_fill/model/ListedUsersModel.dart';
import 'package:flutter/material.dart';
class UserDetailsScreen extends StatefulWidget {
  @override
  _UserDetailsScreenState createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    // final cred = EmailAuthProvider.credential(
    //   email: user!.email!,
    //   password: currentPassword,
    // );
    if (user != null) {
      _emailController.text = user.email ?? ''; // Set the email in the text field
      // _passwordController.text=user.password??'';
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _updateUserDetails() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Update email
        if (_emailController.text.isNotEmpty) {
          await user.updateEmail(_emailController.text);
        }

        // Update password
        if (_passwordController.text.isNotEmpty) {
          await user.updatePassword(_passwordController.text);
        }

        // Show a success message
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("User details updated successfully")));
      }
    } catch (e) {
      // Handle errors, e.g., show an error message
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error updating user details: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    print(_passwordController.text);
    return Scaffold(
      appBar: AppBar(
        title: Text("User Details"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: "Email"),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: "New Password"),
              obscureText: true,
            ),
            ElevatedButton(
              onPressed: _updateUserDetails,
              child: Text("Update Details"),
            ),
          ],
        ),
      ),
    );
  }
}
