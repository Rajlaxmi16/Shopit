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
       showDialog(
      context: context,
      barrierDismissible: false, 
      builder: (context) {
        Future.delayed(Duration(seconds: 2), () {
          Navigator.pop(context);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => ShopitHome()),
          );
        });
        return AlertDialog(
          title: Text(
            'Login Successful',
              style: TextStyle(
              color: Colors.green,
            ),
            ),
          content: Text('Redirecting...'),
        );
      },
    );
    } on FirebaseAuthException catch (e) {
    String errorMsg;
    switch (e.code) {
      case 'user-not-found':
        errorMsg = 'No user found for that email.';
        break;
      case 'The supplied auth credential is incorrect, malformed or has expired.':
        errorMsg = 'Incorrect Email or password';
        break;
      case 'invalid-email':
        errorMsg = 'Invalid email format.';
        break;
      case 'user-disabled':
        errorMsg = 'This user has been disabled.';
        break;
      case 'signInWithEmailAndPassword':
        errorMsg = 'Please Enter Email and Password';
        break;  
      default:
        errorMsg = 'Login failed: ${e.message}';
    }
    
  //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorMsg)));
  // } catch (e) {
  //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Something went wrong: $e")));
  // } finally {
  //   setState(() => isLoading = false);
  // }
  showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Login Failed',
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
        title: Text('Something went wrong'),
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
          "Login",
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
