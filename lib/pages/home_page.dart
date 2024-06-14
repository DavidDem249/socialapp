import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:socialapp/components/my_drawer.dart';
import 'package:socialapp/components/text_field_custum.dart';
import 'package:socialapp/components/wall_post.dart';
import 'package:socialapp/helper/helper_methods.dart';

import 'profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser!;

  // text controller
  final textController = TextEditingController();

  // post message
  void postMessage() {
    // print("jhhhh");
    // only post if there is something in the textfield
    if(textController.text.isNotEmpty){
      // store in firebase
      FirebaseFirestore.instance.collection("User Posts").add({
        "UserEmail": user.email,
        "Message": textController.text,
        "TimeStamp": Timestamp.now(),
        "Likes": [],
      });
    }

    //textController.text = "";
    // Clear the texfield
    setState(() {
      textController.clear();
    });
  }

  // navigate to profile page
  void goToProfilePage() {
    // pop menu drawer
    Navigator.pop(context);

    // go to profile page
    Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfilePage()));
  }

  void signUserOut(){
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.grey.shade300,
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        //iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        //iconTheme: I,  style: TextStyle(color: Colors.white) color: Colors.white,
        title: const Text('The Wall',),
        actions: [
          IconButton(onPressed: signUserOut, icon: const Icon(Icons.logout,))
        ],
      ),

      drawer: MyDrawer(
        onProfileTap: goToProfilePage,
        onSignTap: signUserOut,
      ),
      body: Center(
        child: Column(
          children: [

            // The Wall
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection("User Posts").orderBy("TimeStamp", descending: false).snapshots(), 
                builder: (context, snapshot){
                  if(snapshot.hasData){
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index){
                        // get the message
                        final post = snapshot.data!.docs[index];
                        return WallPost(
                          message: post['Message'], 
                          user: post['UserEmail'],
                          postId: post.id,
                          likes: List<String>.from(post['Likes'] ?? []),
                          time: formatDate(post['TimeStamp']),
                        );
                      }
                    );
                  }else if(snapshot.hasError){
                    return Center(
                      child: Text("Error: ${snapshot.error}"),
                    );
                  }

                  return const Center(child: CircularProgressIndicator(),);
                }
              )
            ),

            // Post message
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 25,),
              child: Row(
                children: [
                  // TextField
                  Expanded(
                    child: TextFieldCustum(
                      controller: textController, 
                      hintText: "Write spùething on the wall...", 
                      obscureText: false, 
                      onTapValidate: null
                    )
                  ),
              
                  // Post button
                  IconButton(
                    onPressed: postMessage, 
                    icon: const Icon(Icons.arrow_circle_up)
                  )
                ],
              ),
            ),

            // Logged in as
            Text("Logged in as: ${user.email}", style: TextStyle(color: Colors.grey),),
            const SizedBox(height: 50,),
          ],
        )
      ),
    );
  }
}