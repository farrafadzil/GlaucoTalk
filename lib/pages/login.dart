import 'package:apptalk/pages/home_page.dart';
import 'package:apptalk/pages/register.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:apptalk/components/my_button.dart';
import 'package:apptalk/components/my_text_field.dart';
import 'package:apptalk/components/square_tile.dart';
import 'package:apptalk/firebase/auth_service.dart';

class LoginPage extends StatefulWidget {

  final Function()? onTap;
  LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();

}

class _LoginPageState extends State<LoginPage> {
  Color myCustomColor = const Color(0xFF00008B);
  Color myTextColor = const Color(0xF6F5F5FF);


  // text editing controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // user login method
  void userLogin() async {
    // show loading circle
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    // try login
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      // pop loading circle before user logged in
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      showErrorMessage();
    }
  }

  // show error message to user
  void showErrorMessage() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Login Failed'),
          content: const Text('Invalid username or password'),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.pop(context);
                // pop loading circle after show error messageg
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: myCustomColor,
      // safe area of the screen - guarantee visible to user
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              // allign everything to the middle of the screen
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                // logo
                Image.asset("assets/logo.png",
                  width: 200,
                  height: 200,),
                const SizedBox(height:2),

                // text under the lock icon
                const Text(
                  'Welcome back !',
                  style: TextStyle(
                    //color: Colors.white,
                    color: Color(0xF6F5F5FF),
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 25),

                // username textfield
                MyTextField(
                  controller: emailController,
                  hintText: 'Email',
                  obscureText: false,
                ),
                const SizedBox(height: 10),

                // password textfield
                MyTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true,
                ),
                const SizedBox(height: 10),

                // forgot password
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Forgot Password?',
                        style: TextStyle(color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),

                // log in button
                MyButton(
                  text: "Log In",
                  onTap: (){
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HomePage(),)
                    );
                  },
                ),

                const SizedBox(height: 15),

                // other login method
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 1.5,
                          color: Colors.deepOrange,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          'Or continue with',
                          style: TextStyle(color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                      ),

                      Expanded(
                        child: Divider(
                          thickness: 1.5,
                          color: Colors.deepOrange[400],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),

                // google + fb login buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // google button
                    SquareTile(
                        onTap: () => AuthService().signInWithGoogle(),
                        imagePath: 'lib/images/google.png'),

                    const SizedBox(width: 10.0),

                    // facebook button
                    SquareTile(
                        onTap: (){},
                        imagePath: 'lib/images/facebook.png'),

                  ],
                ),
                const SizedBox(height: 25),

                // doesn't have an account
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Doesn\'t have an account?',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.normal,
                          fontSize: 20),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => RegisterPage(onTap: (){}),)
                        );
                      },
                      child: const Text(
                        'Create Account',
                        style: TextStyle(
                            color: Colors.deepOrangeAccent,
                            fontWeight: FontWeight.bold,
                            fontSize: 20
                        ),
                      ),
                    ),
                  ],
                )

              ],
            ),
          ),
        ),
      ),
    );
  }
}