import 'package:apptalk/camera/camera.dart';
import 'package:apptalk/firebase/auth_service.dart';
import 'package:apptalk/pages/chat_page.dart';
import 'package:apptalk/pages/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
//import 'package:provider/provider.dart';


class HomePage extends StatefulWidget {
   HomePage({super.key});

  final user = FirebaseAuth.instance.currentUser!;

  @override
  State<HomePage> createState() => _HomePageState();
}


class _HomePageState extends State<HomePage> {
  // instance of auth
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String name = "";
  String email = "";
  AuthService authService = AuthService();




Color myCustomColor = const Color(0xFF00008B);

  late CameraDescription? firstCamera;

  get floatingActionButton => null;

 // CameraDescription? get firstCamera => null;

//Function to navigate to TakePictureScreen

  void navigateToTakePictureScreen(BuildContext context, CameraDescription camera){

   Navigator.push(
       context,
       MaterialPageRoute(builder: (context) => TakePictureScreen(camera: camera)
       ),
   );

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
    else{
      // handle the case when there is no camera available
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No Camera Available'),
          ),
      );
    }
  }
 // Color myCustomColor = const Color(0xFF00008B);

  // sign user out
  void signOut(){
  FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black38,
        title: const Text(
          'CHAT',
          style: TextStyle(
            fontWeight: FontWeight.bold,
        fontSize: 24,
            color: Colors.white,
          ),
      ),
          actions: [
            // Sign out button
            IconButton(
              onPressed: ()async{
                try{
                  await FirebaseAuth.instance.signOut();
                  // Navigate to login page after sign out
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginPage(onTap: () {  },), // Navigate to your home page
                    ),
                  );
                } catch(e){
                  // Handle any errors that might occur during sign-out
                  print("Error signing out: $e");
                }
              },
              icon: const Icon(Icons.logout, size: 24,
                color: Colors.white,),
            ),

            // Search button
            IconButton(
              onPressed: () {
                // Add your search functionality here
                Navigator.push(context,
                MaterialPageRoute(builder: (context) =>  HomePage(),
                ),
                );
              },
              icon: const Icon(Icons.search,
              size: 24,
                color: Colors.white,

              ),
            ),

            IconButton(
              onPressed: () {
                navigateToTakePictureScreen(context, firstCamera!);
              },
              icon: const Icon(Icons.camera_alt,
                color: Colors.white,),
            ),
          ],
      ),
      body: Column(
        children: [
          //display user's name and email
          Column(
            children: [
              // display user's name
              Text('Logged in as: ${widget.user.displayName ?? 'No Name'}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              // display user's email
              Text(
                'Email: ${widget.user.email}',
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
              Expanded(
              child: _buildUserList(),
              ),
        ],
      ),

      //Add a Drawer for sidebar navigation
      drawer: Drawer(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 50),
          children: <Widget>[
            Icon(
              Icons.account_circle,
              size: 150,
              color: Colors.grey[700],
            ),
            const SizedBox(height: 15),
          ],
        ),
      ),

      /* body: ChatPage(),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.deepOrangeAccent,
        unselectedItemColor: Colors.grey.shade600,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.message),
            label: "Chats",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: "Groups",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: "Profile",
          ),
        ],
      ), */


      /* drawer: Drawer(
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
      */
    );
  }

  //build a list of users for the current logged in users.
  Widget _buildUserList() {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot){
          if(snapshot.hasError){
            return const Text('Error');
          }
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Text('loading . . .');
          }

          return ListView(
            children: snapshot.data!.docs
                .map<Widget>((doc) => _buildUserListItem(doc)).toList(),
          );
        },
    );
  }

  //build individual user list items
Widget _buildUserListItem(DocumentSnapshot document){
    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

    // display all users except current user
  if(_auth.currentUser!.email != data['email']){
    return ListTile(
      title: Text(data['email']),
      onTap: (){
        // pass the clicked user's UID to the chat page
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ChatPage(
            receiverUserEmail: data['email'] ?? '',
            receiverUserID: data['uid'] ?? '',
          ),
          ),
        );
      },
    );
  } else{
    // Return empty container
    return Container();
  }
}
}
