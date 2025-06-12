import 'package:ecom_app/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  bool isLoading = false;

  void registerUser() async {
    setState(() => isLoading = true);
    try {
      await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Successfully registered',
            style: TextStyle(
              color: Colors.green,
            ),
          ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoginScreen()));
      
      }on FirebaseAuthException catch (e) {
    String errorMsg;
    switch (e.code) {
      case 'email-already-in-use':
        errorMsg = 'This email is already registered, try login.';
        break;
      case 'invalid-email':
        errorMsg = 'The email address is invalid.';
        break;
      case 'weak-password':
        errorMsg = 'The password is too weak.';
        break;
      default:
        errorMsg = 'Please recheck your Email and Password!';
    }

showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Sign Up Failed',
          style: TextStyle(
              color: Colors.red,
            ),
          ),
        content: Text(errorMsg),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  } catch (e) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Please recheck your Email and Password!'),
        content: Text(e.toString()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  } finally {
    setState(() => isLoading = false);
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFFFFCA28),
        shadowColor: Colors.blueGrey,
        title: Text(
          "Sign Up",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: const Color.fromARGB(255, 203, 17, 17),
          ),),
        ),
      body: SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/app_icon.png', 
              width: 100,
              height: 100,
            ),
            Text(
              'Shopit',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 203, 17, 17),
              ),
            ),          
            Text(
              'Click. Shopit. Repeat.',
              style: TextStyle(
                fontSize: 20,
                fontStyle: FontStyle.italic,
                color: const Color.fromARGB(255, 203, 17, 17),
              ),
            ),
            SizedBox(height: 5),
            TextField(controller: _emailController, decoration: InputDecoration(labelText: "Email")),
            TextField(controller: _passwordController, obscureText: true, decoration: InputDecoration(labelText: "Password")),
            SizedBox(height: 20),
            isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(onPressed: registerUser, child: Text("Sign Up")),
          ],
        ),
      ),
      )
    );
  }
}
