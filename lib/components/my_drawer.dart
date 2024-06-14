import 'package:flutter/material.dart';
import 'package:socialapp/components/my_liste_title.dart';

class MyDrawer extends StatelessWidget {
  final void Function()? onProfileTap;
  final void Function()? onSignTap;

  const MyDrawer({super.key, required this.onProfileTap, required this.onSignTap});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.grey.shade900,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              // Header
              const DrawerHeader(child: Icon(Icons.person, color: Colors.white, size: 64,)),

              // Home list title
              MyListTitle(icon: Icons.home, text: "H O M E", onTap: () => Navigator.pop(context),),

              // Profile list title
              MyListTitle(icon: Icons.person, text: "P R O F I L E", onTap: onProfileTap,),
            ],
          ),

          // Logout list title
          Padding(
            padding: const EdgeInsets.only(bottom: 25.0),
            child: MyListTitle(icon: Icons.logout, text: "L O G O U T", onTap: onSignTap,),
          )

        ],
      ),
    );
  }
}