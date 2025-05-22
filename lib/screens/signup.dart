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
      Navigator.pop(context);
      }on FirebaseAuthException catch (e) {
    String errorMsg;
    switch (e.code) {
      case 'email-already-in-use':
        errorMsg = 'This email is already in use.';
        break;
      case 'invalid-email':
        errorMsg = 'The email address is invalid.';
        break;
      case 'weak-password':
        errorMsg = 'The password is too weak.';
        break;
      default:
        errorMsg = 'Sign up failed: ${e.message}';
    }
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorMsg)));
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Something went wrong: $e")));
  } finally {
    setState(() => isLoading = false);
  }
}
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Sign up failed: $e")));
  //   } finally {
  //     setState(() => isLoading = false);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 221, 244, 243),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 153, 236, 232),
        shadowColor: Colors.blueGrey,
        title: Text(
          "Sign Up",
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
