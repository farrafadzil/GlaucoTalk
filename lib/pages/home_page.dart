import 'package:apptalk/camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:apptalk/camera/DisplayPictureScreen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}


class _HomePageState extends State<HomePage> {
Color myCustomColor = const Color(0xFF00008B);

  late CameraDescription? firstCamera;

  get floatingActionButton => null;

 // CameraDescription? get firstCamera => null;

//Function to navigate to TakePictureScreen

  void navigateToTakePictureScreen(BuildContext context, CameraDescription camera){

   if(camera != null){
     Navigator.push(
         context,
         MaterialPageRoute(builder: (context) => TakePictureScreen(camera: camera)
         ),
     );
   } else{
     // Handle the case when there is no camera
     ScaffoldMessenger.of(context).showSnackBar(
         const SnackBar(
           content: Text('No Camera Available.'),
         ),
     );
   }

  }

  @override
  void initState() {
    super.initState();
    // Initialize firstCamera in the initState method
    _initializeFirstCamera();
  }

  Future<void> _initializeFirstCamera() async {
    final cameras = await availableCameras();
    if (cameras.isNotEmpty) {
      setState(() {
        firstCamera = cameras.first;
      });
    }
  }
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
            color: Colors.white,
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

            IconButton(
              onPressed: () {
                navigateToTakePictureScreen(context, firstCamera!);
              },
              icon: const Icon(Icons.camera_alt),
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
