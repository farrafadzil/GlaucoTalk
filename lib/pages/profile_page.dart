import 'package:apptalk/components/circle_avatar.dart';
import 'package:apptalk/components/my_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class ProfilePage extends StatefulWidget {
  ProfilePage({super.key});

  final user = FirebaseAuth.instance.currentUser!;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  String dropdownvalue = "Male"; // replace to stored user's gender

  TextEditingController nameController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Set the initial value for the nameController
    nameController.text = widget.user.displayName ?? "";
    usernameController.text = widget.user.displayName ?? "";
    passwordController.text = widget.user.email ?? "";
    // String? image = widget.user.photoURL;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        // backgroundColor: Color(0xFF00008B),
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text("Edit Profile"),
          backgroundColor: Colors.black38,
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              CircularAvatar(
                  imagePath: 'lib/images/google.png',
                  onTap: (){
                    // function change image
                  }
              ),
              const SizedBox(height: 12),
              // MyTextField(
              //     controller: nameController,
              //     hintText: "Name",
              //     obscureText: false
              // ),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: "Name",
                  filled: true,
                  fillColor: Color(0xF6F5F5FF),
                ),
              ),
              const SizedBox(height: 12),
              DropdownButton(
                value: dropdownvalue,
                // dropdownColor: const Color(0xF6F5F5FF),
                isExpanded: true,
                icon: const Icon(Icons.arrow_drop_down),
                items: <String>['Male', 'Female'].
                  map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                          value,
                          // style: const TextStyle(
                          //     color: Color(0xF6F5F5FF)
                          // ),
                      ),
                    );
                  }).toList(),
                onChanged: (String? newValue){
                    setState(() {
                      dropdownvalue = newValue!;
                    });
                },
              ),
              const SizedBox(height: 12),
              TextField(
                controller: usernameController,
                decoration: const InputDecoration(
                  labelText: "Username",
                  filled: true,
                  fillColor: Color(0xF6F5F5FF),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: passwordController,
                decoration: const InputDecoration(
                  labelText: "Password",
                  filled: true,
                  fillColor: Color(0xF6F5F5FF),
                  suffixIcon: Icon(Icons.password_outlined),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: dateController,
                decoration: const InputDecoration(
                  labelText: "Date of Birth",
                  filled: true,
                  fillColor: Color(0xF6F5F5FF),
                  suffixIcon: Icon(Icons.calendar_month_outlined),
                ),
                keyboardType: TextInputType.datetime,
                onTap: (){
                  _selectDate();
                },
              ),
              MyButton(
                  onTap: (){
                    // function update profile
                    Navigator.pop(context);
                  },
                  text: "Save changes"
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate() async{
    DateTime? selected = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime.now(),
    );

    if(selected != null){
      setState(() {
        dateController.text = selected.toString().split(" ")[0];
      });
    }
  }
}

/*

 */