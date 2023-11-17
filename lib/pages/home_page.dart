import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}
Color myCustomColor = const Color(0xFF00008B);
class _HomePageState extends State<HomePage> {
 // Color myCustomColor = const Color(0xFF00008B);
  // sign user out
  void signOut(){
    // get auth service
   //final authService = Provider.of<AuthService>(context, listen: false);
    //authService.signOut();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: myCustomColor,
      appBar: AppBar(
        backgroundColor: Colors.black38,
        title: const Text(
          'CHAT',
          style: TextStyle(
        fontSize: 35,
          ),
      ),
          actions: [
            // Sign out button
            IconButton(
              onPressed: signOut,
              icon: const Icon(Icons.logout, size: 24,),
            ),
            // Search button
            IconButton(
              onPressed: () {
                // Add your search functionality here
              },
              icon: const Icon(Icons.search,
              size: 24,
              ),
            ),
          ],
      ),

      //Add a Drawer for sidebar navigation
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xFF00008B),
              ),
              child: Text('MORE',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 60,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(
                  Icons.perm_contact_cal_rounded,
                  size: 60,),
              title:const Text('PROFILE',
              style: TextStyle(fontSize: 32),),
              onTap: (){
                // handle home menu item
                Navigator.pop(context); // close the drawer
                //add more functionality later here
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.settings_applications_sharp,
                size: 60,),
              title:const Text('SETTINGS',
              style: TextStyle(fontSize: 32),
              ),
              onTap: (){
                // handle settings menu item
                Navigator.pop(context); // close the drawer
                //add more functionality later here
              },
            ),
          ],
        ),
      ),
    );
  }
}
