import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:socialapp/components/button_custum.dart';
import 'package:socialapp/components/square_title.dart';
import 'package:socialapp/components/text_field_custum.dart';
import 'package:socialapp/services/auth_service.dart';

class LoginPage extends StatefulWidget {

  final Function()? onTapFunc;
  const LoginPage({super.key, required this.onTapFunc});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  void signUserIn() async {
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
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text, 
          password: passwordController.text
        );

        // pop the loading circle
        Navigator.pop(context);

      }on FirebaseAuthException catch (e){

        print("==================== ${e.code} =====================");

        // pop the loading circle
        Navigator.pop(context);

        // Wrong email

        wrongMessage(e.code);
        /*if(e.code == 'user-not-found'){
          wrongEmailMessage();
          print("No user found for that email");
        }

        // Worng Password
        else if (e.code == "wrong-password"){
          wrongEmailMessage();
          print("Wrong password buddy");
        }
        else{
          wrongMessage("Email ou Mot de passe invalide");
        }*/

      }catch (e) {
        print(e);
      }

      // pop the loading circle
      // ignore: use_build_context_synchronously
      //Navigator.pop(context);
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

  void wrongEmailMessage(){
    showDialog(
      context: context, 
      builder: (context){
        return const AlertDialog(
          title: Text('Incorrect Email'),
        );
      }
    );
  }

  void wrongPasswordMessage(){
    showDialog(
      context: context, 
      builder: (context){
        return const AlertDialog(
          title: Text('Incorrect Password'),
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
                  const SizedBox(height: 50,),
                  // logo
                  const Icon(Icons.lock, size: 100,),
                  
                  const SizedBox(height: 50,),
                  // welcome back, you're been missed !
                  Text("Welcome back you're been missed", style: TextStyle(color: Colors.grey.shade700, fontSize: 16.0),),
                        
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
                        
                  // forgot password ?
                  const SizedBox(height: 10,),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Text(
                        "Forgot Password ?", style: TextStyle(color: Colors.grey[600]),
                      ),
                    )
                  ),
                  
              
                  //sign in button
                  const SizedBox(height: 25.0,),
                  ButtonCustum(onTapFunc: signUserIn, text: "Sign In",),
              
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
                      Text("Not a member ?", style: TextStyle(color: Colors.grey.shade700),),
                      const SizedBox(width: 4,),
                      GestureDetector(
                        onTap: widget.onTapFunc,
                        child: const Text(
                          "Register now", 
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