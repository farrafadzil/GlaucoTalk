import 'package:apptalk/components/square_tile.dart';
import 'package:apptalk/pages/home_page.dart';
import 'package:apptalk/pages/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:apptalk/firebase/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:apptalk/components/my_text_field.dart';
import 'package:apptalk/components/my_button.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? onTap;
  const RegisterPage({
    super.key,
    required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  Color myCustomColor = const Color(0xFF00008B);
  Color myTextColor = const Color(0xF6F5F5FF);


  //text controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  //Sign Up user
  void signUp() async {
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try{
      //check if password is same
      if(passwordController.text == confirmPasswordController.text){
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
        // show error message
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const HomePage(), // Navigate to your home page
          ),
        );
      }
      else{
        showErrorMessage();
      }

    } on FirebaseAuthException catch(e){
      showErrorMessage();
    }

    //get the authentication service
   // final authService = Provider.of<AuthService>(context, listen: false);

    /*try{
      await authService.signUpWithEmailAndPassword(
          emailController.text,
          passwordController.text);

    } catch(e){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString()),
      ),
      );
    }*/
  }

  void showErrorMessage(){
    showDialog(
      context: context,
      builder: (context)
      {
        return AlertDialog(
          title: const Text('Login Failed'),
          content: const Text('Invalid Email or Password'),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.pop(context);
                // pop loading circle after show error message
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
     // safe area of the screen - guarantee visible to the user
     body: SafeArea(
       child: Center(
         child: SingleChildScrollView(
           child: Column(
             // Allign everything to the middle of the screen
             mainAxisAlignment: MainAxisAlignment.center,
             children: [
               const SizedBox(height:10),
               // logo
               Image.asset("assets/logo.png",
                 width: 200,
                 height: 200,),
               
               //Welcome Back Message
               const SizedBox(height: 2),
               const Text("Hi There!",
                 style: TextStyle(
                   fontSize: 24,
                   color: Colors.white,
                   fontWeight: FontWeight.bold,
                 ),
               ),
               const SizedBox(height:20),
               
               // email textfield
               MyTextField(
                   controller: emailController,
                   hintText: 'Email', // hint text
                   obscureText: false
               ),
               
               // password textfield
               const SizedBox(height: 20),
               MyTextField(
                   controller: passwordController,
                   hintText: 'Password', // hint text
                   obscureText: true //akan jadi hidden.
               ),
               const SizedBox(height: 20),
               
               //confirm password 
               //const SizedBox(height: 20),
               MyTextField(
                   controller: confirmPasswordController,
                   hintText: 'Confirm Password', // hint text
                   obscureText: true //akan jadi hidden.
               ),
               const SizedBox(height: 10),
               
               // register button
               MyButton(
                  text: 'Sign Up',
                   onTap: signUp, 
                   ),
               const SizedBox(height: 15),
               
               // other login method
               const Padding(
                   padding: EdgeInsets.symmetric(horizontal: 25.0),
               child: Row(
                 children: [
                   Expanded(
                       child: Divider(
                         thickness: 1.5,
                         color: Colors.deepOrange,
                       ),
                   ),
                   Padding(
                       padding: EdgeInsets.symmetric(horizontal: 10.0),
                   child: Text(
                     'Or continue with',
                     style: TextStyle(
                         color: Color(0xF6F5F5FF),
                     fontWeight: FontWeight.bold,
                     fontSize: 20),
                   ),
                   ),

                   Expanded(
                       child: Divider(
                         thickness: 1.5,
                         color: Colors.deepOrange,
                       ),
                   ),
                 ],
               ),
               ),
               const SizedBox(height:20),
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
               const SizedBox(height: 10),

               // doesn't have an account
               Row(
                 mainAxisAlignment: MainAxisAlignment.center,
                 children: [
                   const Text('Already have an account?',
                     style: TextStyle(
                         color: Colors.white,
                          fontWeight: FontWeight.normal,
                          fontSize: 20),
                   ),
                   const SizedBox(width: 4),
                   TextButton(
                     child: const Text('Log In',
                       style: TextStyle(
                           fontWeight: FontWeight.bold,
                           color: Colors.orange,
                           fontSize: 20),
                     ),
                     onPressed: (){
                       Navigator.push(
                         context,
                         MaterialPageRoute(
                           builder: (context) => LoginPage(onTap: () {  },),
                         ),
                       );
                     },
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
