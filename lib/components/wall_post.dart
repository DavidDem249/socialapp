import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:socialapp/components/comment.dart';
import 'package:socialapp/components/comment_button.dart';
import 'package:socialapp/components/delete_button.dart';
import 'package:socialapp/components/like_button.dart';
import 'package:socialapp/helper/helper_methods.dart';

class WallPost extends StatefulWidget {
  final String message;
  final String user;
  final String time;
  final String postId;
  final List<String> likes;
  //final String time;

  const WallPost({super.key, required this.message, required this.user, required this.postId, required this.likes, required this.time});

  @override
  State<WallPost> createState() => _WallPostState();
}

class _WallPostState extends State<WallPost> {

  // user
  final currentUser = FirebaseAuth.instance.currentUser!;
  bool isLiked = false;

  // comment text controller
  final _commentTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    isLiked = widget.likes.contains(currentUser.email);
  }

  // toggle like
  void toggleLike() {
    setState(() {
      isLiked = !isLiked;
    });

    // Access the document is Firebase
    DocumentReference postRef = FirebaseFirestore.instance.collection("User Posts").doc(widget.postId);

    if(isLiked) {
      // if the post is now liked, add the user's email to the Likes field
      postRef.update({
        'Likes': FieldValue.arrayUnion([currentUser.email])
      });
    }else {
      // if the post is now unliked, remove the user's email from the 'Likes' field
      postRef.update({
        "Likes": FieldValue.arrayRemove([currentUser.email])
      });
    }
  }

  // add a comment
  void addComment(String commentText) {
    // Write the comment to firebase under the comments collections for this post
    FirebaseFirestore.instance
      .collection("User Posts")
      .doc(widget.postId).
      collection("Comments")
      .add({
        "CommentText": commentText,
        "CommentedBy": currentUser.email,
        "CommentTime": Timestamp.now() // remember to format this when displaying
      });
  }

  // show a dialog box for adding comment
  void showCommentDialog() {
    showDialog(
      context: context, 
      builder: (context) => AlertDialog(
        shape: Border.all(strokeAlign: 1,width: 2, color: Colors.grey.shade500),
        backgroundColor: Colors.grey.shade900,
        title: const Text("Add Comment", style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: _commentTextController,
          decoration: const InputDecoration(hintText: "Write a comment...",hintStyle: TextStyle(color: Colors.grey)),
        ),

        actions: [
          // Cancel Button
          TextButton(
            onPressed: (){
              Navigator.pop(context);

              // clear comment controller
              _commentTextController.clear();
            }, 
            child: const Text(
              "Concel",
              style: TextStyle(color: Colors.white),
            )
          ),

          // save Button
          TextButton(
            onPressed: (){
              // add comment
              addComment(_commentTextController.text);

              // pop box
              Navigator.pop(context);

              // clear controlller
              _commentTextController.clear();
            }, 
            child: const Text(
              "Post",
              style: TextStyle(color: Colors.white),
            )
          )
        ],
        
      )
    );
  }

  void deletePost(){
    // show a dialog box asking confirmation before deleting the post
    showDialog(
      context: context, 
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        title: const Text("Delete Post"),
        content: const Text("Are you sure wont to delete this post ?"),

        actions: [
          // CONCEL BUTTON
          TextButton(
            onPressed: () => Navigator.pop(context), 
            child: const Text("Concel")
          ),

          // DELETE BUTTON
          TextButton(
            onPressed: () async{
              // delete the comments from firestore first( if you only delete the post, the comments will be stored if firestore)

              final commentDocs = await FirebaseFirestore.instance.collection("User Posts").doc(widget.postId).collection("Comments").get();

              for(var doc in commentDocs.docs) {
                await FirebaseFirestore.instance.collection("User Posts").doc(widget.postId).collection("Comments").doc(doc.id).delete();
              }
              // then delete the post
              FirebaseFirestore.instance.collection("User Posts").doc(widget.postId).delete().then((value) => print("Post deleted")).catchError(
                (error) => print("Failed to delete post: $error")
              );

              // dismiss the dialog
              Navigator.pop(context);

            }, 
            child: const Text("Delete")
          )
        ],
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        //color: Colors.grey[200],
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(8),
      ),
      margin: const EdgeInsets.only(top: 25, left: 25, right: 25),
      padding: const EdgeInsets.all(25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
    
          /*
          // profile pic
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey.shade400,
            ),
            padding: const EdgeInsets.all(10),
            child: const Icon(Icons.person, color: Colors.white,),
          ),
          const SizedBox(width: 20,), */

          // Walpost
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // group of text (message + user email)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
              
                  // Message
                  Text(widget.message),
                  const SizedBox(height: 5,),
                  // User info
                  //Text('${widget.user} ', style: TextStyle(color: Colors.grey[500]), maxLines: 1,),
                  Row(
                    children: [
                      Text(widget.user.substring(0, 10), overflow: TextOverflow.ellipsis,maxLines: 1, style: TextStyle(color: Colors.grey[400]),),
                      Text(' * ', style: TextStyle(color: Colors.grey[400]),),
                      Text(widget.time, style: TextStyle(color: Colors.grey[400]),),
                    ],
                  )
                  
                ],
              ),


              // delete button
              if (widget.user == currentUser.email) DeleteButton(onTap: deletePost),
            
            ],
          ),

          const SizedBox(height: 20,),

          // buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              
              // LIKE
              Column(
                children: [
                  // like button
                  LikeButton(
                    onTapFunc: toggleLike, 
                    isLiked: isLiked
                  ),

                  const SizedBox(height: 5,),

                  // like count
                  Text(widget.likes.length.toString(), style: const TextStyle(color: Colors.grey),)
                ],
              ),

              const SizedBox(width: 10,),

              // COMMENT
              Column(
                children: [
                  // comment button
                  CommentButton(onTap: showCommentDialog),

                  const SizedBox(height: 5,),

                  // like count
                  const Text(
                    "0", 
                    style: TextStyle(color: Colors.grey),
                  )
                ],
              ),
            ],
          ),

          // comments under the post

          StreamBuilder(
            stream: FirebaseFirestore.instance
              .collection("User Posts")
              .doc(widget.postId)
              .collection("Comments")
              .orderBy("CommentTime", descending: true).snapshots(), 
            builder: (context, snapshot){
              // show loading circle if no data yet
              if(!snapshot.hasData){
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              return ListView(
                shrinkWrap: true, // for nested lists
                physics: const NeverScrollableScrollPhysics(),
                children: snapshot.data!.docs.map((doc) {
                  // get the comment
                  // ignore: unnecessary_cast
                  final commentData = doc.data() as Map<String, dynamic>;
                  print(commentData);

                  // return the comment
                  return Comment(
                    text: commentData['CommentText'], 
                    user: commentData['CommentedBy'], 
                    time: formatDate(commentData['CommentTime'])
                  );
                }).toList(),
              );
            }
          )

        ],
      ),
    );
  }
}