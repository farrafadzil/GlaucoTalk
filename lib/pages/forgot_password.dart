import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatefulWidget {
   ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
  Color myCustomColor = const Color(0xFF00008B);
  Color myTextColor = const Color(0xF6F5F5FF);
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose(){
    emailController.dispose();
    super.dispose();
  }
  
  Future passwordReset() async{
   try{
     await FirebaseAuth.instance
         .sendPasswordResetEmail(email: emailController.text.trim());
     showDialog(
         context: context,
         builder: (context) {
           return const AlertDialog(
             content: Text("Password successfully reset."),
           );
         },
     );
   } on FirebaseAuthException catch(e){
     String errorMessage;

     switch (e.code){
       case 'user-not-found':
         errorMessage = "No user found for that email.";
         break;
       case 'invalid-email':
         errorMessage = "The email is badly formatted.";
         break;
       case 'network-request-failed':
         errorMessage = "Network error, please try again.";
         break;
       default:
         errorMessage = e.message ?? "An unknown error occurred";
         break;
     }

     showDialog(
         context: context,
         builder: (context){
           return AlertDialog(
             content: Text(errorMessage),
           );
         },
     );
   }
   /*on FirebaseAuthException catch(e){
     if(e.code == 'user-not-found'){
       print(e);
       showDialog(
         context: context,
         builder: (context){
           return AlertDialog(
             content: Text(e.message.toString()),
           );
         },
       );
     } else{
       // handle other firebaseauth errors
       showDialog(
           context: context,
           builder: (context){
             return AlertDialog(
               content: Text(e.message.toString()),
             );
           },
       );
     }

   } */
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF00008B),
      appBar: AppBar(
        backgroundColor: const Color(0xFF00008B),
       ),

      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Padding(
              padding:  EdgeInsets.symmetric(horizontal: 25.0),
           child: Text(
               "Enter your Email, we will send the password reset link",
             style: TextStyle(fontSize: 20, color: Color(0xF6F5F5FF),),

             textAlign: TextAlign.center,

           ),
          ),
          const SizedBox(height: 10),


          //Email TextField
          Padding(
              padding:  const EdgeInsets.symmetric(horizontal: 25.0),
              child: TextField(
                controller: emailController,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(12),
                  ),
                 focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white),
                borderRadius: BorderRadius.circular(12),
                ),
                 hintText: 'Email',
                  fillColor: Colors.grey[200],
                  filled: true,
                  ),
                ),
              ),
               const SizedBox(height: 10),

          SizedBox(
            width: 200,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: Colors.deepOrangeAccent,
                  elevation: 10,
                  shape: StadiumBorder()
              ),
              child: const Text(
                "Reset Password",
                style: TextStyle(color: Color(0xF6F5F5FF), fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
              onPressed: (){
                passwordReset();
              },
            ),
          ),
        ],
      )
    );
  }
}
