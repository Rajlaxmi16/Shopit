import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'signup.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  bool isLoading = false;

  void loginUser() async {
    setState(() => isLoading = true);
    try {
      await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => ShopitHome()));
    } on FirebaseAuthException catch (e) {
    String errorMsg;
    switch (e.code) {
      case 'user-not-found':
        errorMsg = 'No user found for that email.';
        break;
      case 'wrong-password':
        errorMsg = 'Wrong password provided.';
        break;
      case 'invalid-email':
        errorMsg = 'Invalid email format.';
        break;
      case 'user-disabled':
        errorMsg = 'This user has been disabled.';
        break;
      default:
        errorMsg = 'Login failed: ${e.message}';
    }
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorMsg)));
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Something went wrong: $e")));
  } finally {
    setState(() => isLoading = false);
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 221, 244, 243),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 153, 236, 232),
        shadowColor: Colors.blueGrey,
        title: Text(
          "Login",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: const Color.fromARGB(255, 46, 92, 171),
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
                color: const Color.fromARGB(255, 46, 92, 171),
              ),
            ),
            
            Text(
              'Click. Shopit. Repeat.',
              style: TextStyle(
                fontSize: 20,
                fontStyle: FontStyle.italic,
                color: const Color.fromARGB(255, 57, 106, 191),
              ),
            ),
            
            TextField(controller: _emailController, decoration: InputDecoration(labelText: "Email")),
            TextField(controller: _passwordController, obscureText: true, decoration: InputDecoration(labelText: "Password")),
            SizedBox(height: 20),
            isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(onPressed: loginUser, child: Text("Login")),
            TextButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => SignUpScreen())),
              child: Text("Don't have an account? Sign up"),
            ),
          ],
        ),
      ),
    ),
      
    );
  }
}
