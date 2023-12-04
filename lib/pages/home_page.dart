import 'package:apptalk/camera/camera.dart';
import 'package:apptalk/firebase/auth_service.dart';
import 'package:apptalk/pages/chat_page.dart';
import 'package:apptalk/pages/login.dart';
import 'package:apptalk/pages/profile_page.dart';
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

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Color myCustomColor = const Color(0xFF00008B);

  late CameraDescription? firstCamera;

  get floatingActionButton => null;

  // CameraDescription? get firstCamera => null;

  //Function to navigate to TakePictureScreen

  void navigateToTakePictureScreen(BuildContext context,
      CameraDescription camera) {
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
    else {
      // handle the case when there is no camera available
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No Camera Available'),
        ),
      );
    }
  }

  // sign user out
  void signOut() {
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
            onPressed: () async {
              try {
                await FirebaseAuth.instance.signOut();
                // Navigate to login page after sign out
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        LoginPage(onTap: () {},), // Navigate to your home page
                  ),
                );
              } catch (e) {
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
                MaterialPageRoute(builder: (context) => HomePage(),
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
          backgroundColor: const Color(0xFF00008B),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: AssetImage('lib/images/google.png'),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${widget.user.displayName}',
                            style: TextStyle(
                              fontSize: 30,
                              color: Color(0xF6F5F5FF),
                            ),
                          ),
                          SizedBox(height: 8,),
                          Text(
                            '@${widget.user.displayName}',
                            style: TextStyle(
                              fontSize: 20,
                              color: Color(0xF6F5F5FF),
                            ),
                          ),
                          SizedBox(height: 8,),
                          ElevatedButton(
                            onPressed: (){
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context)=>ProfilePage()
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepOrange,
                            ),
                            child: Row(
                              children: [
                                Text("Edit Profile",
                                  style: TextStyle(
                                    color: Color(0xF6F5F5FF),
                                    fontSize: 20,
                                  ),
                                ),
                                Icon(Icons.arrow_right),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: const Icon(
                  Icons.account_circle_outlined,
                  color: Color(0xF6F5F5FF),
                  size: 40,
                ),
                title: const Text('Account',
                  style: TextStyle(
                    fontSize: 30,
                    color: Color(0xF6F5F5FF),
                  ),
                ),
                selected: _selectedIndex == 0,
                onTap: () {
                  // Update the state of the app
                  _onItemTapped(0);
                  // Then close the drawer
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 8,),
              ListTile(
                leading: const Icon(
                  Icons.app_settings_alt_outlined,
                  color: Color(0xF6F5F5FF),
                  size: 40,
                ),
                title: const Text('Appearance',
                  style: TextStyle(
                    fontSize: 30,
                    color: Color(0xF6F5F5FF),),
                ),
                selected: _selectedIndex == 1,
                onTap: () {
                  // Update the state of the app
                  _onItemTapped(1);
                  // Then close the drawer
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 8,),
              ListTile(
                leading: const Icon(
                  Icons.chat_outlined,
                  color: Color(0xF6F5F5FF),
                  size: 40,
                ),
                title: const Text('Chats',
                  style: TextStyle(
                    fontSize: 30,
                    color: Color(0xF6F5F5FF),),
                ),
                selected: _selectedIndex == 2,
                onTap: () {
                  // Update the state of the app
                  _onItemTapped(2);
                  // Then close the drawer
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 8,),
              ListTile(
                leading: const Icon(
                  Icons.notifications_active_outlined,
                  color: Color(0xF6F5F5FF),
                  size: 40,
                ),
                title: const Text('Notifications',
                  style: TextStyle(
                    fontSize: 30,
                    color: Color(0xF6F5F5FF),),
                ),
                selected: _selectedIndex == 3,
                onTap: () {
                  // Update the state of the app
                  _onItemTapped(3);
                  // Then close the drawer
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 8,),
              ListTile(
                leading: const Icon(
                  Icons.question_mark_outlined,
                  color: Color(0xF6F5F5FF),
                  size: 40,
                ),
                title: const Text('Help',
                  style: TextStyle(
                    fontSize: 30,
                    color: Color(0xF6F5F5FF),),
                ),
                selected: _selectedIndex == 4,
                onTap: () {
                  // Update the state of the app
                  _onItemTapped(4);
                  // Then close the drawer
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 8,),
              ListTile(
                leading: const Icon(
                  Icons.exit_to_app_outlined,
                  color: Color(0xF6F5F5FF),
                  size: 40,
                ),
                title: const Text('Sign Out',
                  style: TextStyle(
                    fontSize: 30,
                    color: Color(0xF6F5F5FF),),
                ),
                selected: _selectedIndex == 5,
                onTap: () {
                  // Update the state of the app
                  _onItemTapped(5);
                  // Then close the drawer
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 8,),
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
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('Error');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
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
  Widget _buildUserListItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

    // display all users except current user
    if (_auth.currentUser!.email != data['email']) {
      return ListTile(
        title: Text(data['email']),
        onTap: () {
          // pass the clicked user's UID to the chat page
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>
                ChatPage(
                  receiverUserEmail: data['email'] ?? '',
                  receiverUserID: data['uid'] ?? '',
                ),
            ),
          );
        },
      );
    } else {
      // Return empty container
      return Container();
    }
  }
}
