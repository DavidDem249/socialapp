import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../components/button_custum.dart';
import '../components/square_title.dart';
import '../components/text_field_custum.dart';
import '../services/auth_service.dart';

class RegisterPage extends StatefulWidget {

  final Function()? onTapFunc;
  const RegisterPage({super.key, required this.onTapFunc});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPassworController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  void signUserUp() async {
    // show loading circle
    if(formKey.currentState!.validate())
    {
      showDialog(
        context: context, 
        builder: (context){
          return const Center(
            child: CircularProgressIndicator(color: Colors.blueAccent,),
          );
        }
      );

      try{

        // check if password is confirmed
        if(passwordController.text == confirmPassworController.text){

          // create the user
          UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: emailController.text, 
            password: passwordController.text
          );

          // After creating the user, create a new document in cloud firestore called Users
          FirebaseFirestore.instance.collection("Users").doc(userCredential.user!.email).set({
            "username": emailController.text.split('@')[0], // initial username
            "bio": "Empty bie...",
            // add any additionam fields as needed
          });

        }else{
          // Show error message, passwords don't match
          wrongMessage("Passwords don't match !");
        }

        // pop the loading circle
        Navigator.pop(context);

      }on FirebaseAuthException catch (e){
        // pop the loading circle
        Navigator.pop(context);

        // Wrong email

        wrongMessage(e.code);
      }catch (e) {
        wrongMessage(e.toString());
      }

    }
  }

  void wrongMessage(String message){
    showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          backgroundColor: Colors.deepOrange,
          title: Center(child: Text(message, style: const TextStyle(color: Colors.white),)),
        );
      }
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 25,),
                  // logo
                  const Icon(Icons.lock, size: 80,),
                  
                  const SizedBox(height: 25,),
                  // Let\'s create an account for you !
                  Text("Let\'s create an account for you !", style: TextStyle(color: Colors.grey.shade700, fontSize: 16.0),),
                        
                  const SizedBox(height: 25,),
                  // username textfield
                  TextFieldCustum(
                    controller: emailController, 
                    hintText: "Adresse Email", 
                    obscureText: false, 
                    onTapValidate: (email){
                      if (email!.isEmpty){
                        return "Email please";
                      }
                    },
                    ),
                        
                        
                  // password textfield
                  const SizedBox(height: 10,),
                  TextFieldCustum(
                    controller: passwordController, 
                    hintText: "Mot de passe", 
                    obscureText: true,
                    onTapValidate: (password){
                      if (password!.isEmpty){
                        return "Password please";
                      }
                    },
                  ),

                  // Confirm password textfield
                  const SizedBox(height: 10,),
                  TextFieldCustum(
                    controller: confirmPassworController, 
                    hintText: "Confirm mot de passe", 
                    obscureText: true,
                    onTapValidate: (password){
                      if (password!.isEmpty){
                        return "Confirm Password please";
                      }
                    },
                  ),
              
                  //sign in button
                  const SizedBox(height: 25.0,),
                  ButtonCustum(onTapFunc: signUserUp, text: "Sign Up",),
              
                  // or continue with
                  const SizedBox(height: 50.0,),
                  //Divider(thickness: 5, color: Colors.grey[400],)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Divider(thickness: 0.9, color: Colors.grey[400],)
                        ),
                    
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text("Or continus with", style: TextStyle(color: Colors.grey.shade700),),
                        ),
                    
                        Expanded(
                          child: Divider(thickness: 0.9, color: Colors.grey[400],)
                        ),
                      ],
                    ),
                  ),
                        
                  // google + apple  sign in button
                  const SizedBox(height: 30,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SquareTitle(imagePath: "images/google.png", onTapFunc: () => AuthService().signInWithGoogle(),),
                      const SizedBox(width: 10,),
                      SquareTitle(imagePath: "images/apple.png", onTapFunc: () => null,),
                    ],
                  ),
                        
                        
                  // not a member ? register now
                  const SizedBox(height: 30,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Already have an account ?", style: TextStyle(color: Colors.grey.shade700),),
                      const SizedBox(width: 4,),
                      GestureDetector(
                        onTap: widget.onTapFunc,
                        child: const Text(
                          "Login now", 
                          style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                        )
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        )
      ),
    );
  }
}