import 'package:flutter/material.dart';

class ChatDetailPage extends StatefulWidget {
  const ChatDetailPage({super.key});

  @override
  State<ChatDetailPage> createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blue[900],
        flexibleSpace: SafeArea(
          child: Container(
            padding: const EdgeInsets.only(right: 16),
            child: Row(
              children: <Widget>[
                IconButton(
                    onPressed: (){
                      Navigator.pop(context);
                    },
                    icon:
                    const Icon(
                      Icons.arrow_back,
                    color: Colors.white,),
                ),
                const SizedBox(width: 2,),
                const CircleAvatar(
                  backgroundImage: NetworkImage("https://e0.pxfuel.com/wallpapers/76/715/desktop-wallpaper-barefaced-yunho-best-thing-ever-ateez-%EC%97%90%EC%9D%B4%ED%8B%B0%EC%A6%88-amino-amino.jpg"),
                  maxRadius: 20,
                ),
                const SizedBox(width: 12,),
                const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("Yunho",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600),),
                        //SizedBox(height:2,),
                        Text("Online",
                          style: TextStyle(
                            color: Colors.grey,
                              fontSize: 13,
                              fontWeight: FontWeight.w600),),
                      ],
                    ),
                ),
                const Icon(Icons.settings, color: Colors.white,),
              ],
            ),
          ),
        ),
      ),
      body: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              padding: const EdgeInsets.only(left:10, bottom: 10, top: 10),
              height: 70,
              width: double.infinity,
              color: Colors.blue[50],
              child: Row(
                children: <Widget>[
                  GestureDetector(
                    onTap: (){

                    },
                    child: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        color: Colors.blue[900],
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Icon(
                        Icons.add,
                      color: Colors.white,
                      size: 20,),
                    ),
                  ),
                  const SizedBox(width: 15,),
                  const Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "Write a message",
                          hintStyle: TextStyle(color: Colors.blueGrey),
                          border: InputBorder.none,
                        ),
                      ),
                  ),
                  const SizedBox(width: 15,),
                  FloatingActionButton(
                      onPressed: (){},
                  child:  Icon(
                    Icons.send,
                    color: Colors.pink[100],
                    size: 18,),
                  backgroundColor: Colors.blue[900],
                  elevation: 0,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
