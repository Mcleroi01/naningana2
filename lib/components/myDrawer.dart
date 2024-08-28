import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  void logout(){
    FirebaseAuth.instance.signOut();
  }


  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
         Column(
           children: [
             DrawerHeader(child: Icon(Icons.work_history_outlined,
               color: Theme.of(context).colorScheme.inversePrimary,),),
             const SizedBox(height: 25,),
             Padding(
               padding: const EdgeInsets.only(left: 25.0),
               child: ListTile(
                 title: Text('H O M E'),
                 leading: Icon(Icons.home_rounded,
                     color: Theme.of(context).colorScheme.inversePrimary),
                 onTap: (){
                   Navigator.pop(context);
                 },
               ),
             ),
             Padding(
               padding: const EdgeInsets.only(left: 25.0),
               child: ListTile(
                 title: Text('P R O F I L E'),
                 leading: Icon(Icons.person,
                     color: Theme.of(context).colorScheme.inversePrimary),
                 onTap: (){
                   Navigator.pushNamed(context, '/profile_page');
                 },
               ),
             ),
             Padding(
               padding: const EdgeInsets.only(left: 25.0),
               child: ListTile(
                 title: Text('U S E R S'),
                 leading: Icon(Icons.home_rounded,
                     color: Theme.of(context).colorScheme.inversePrimary),
                 onTap: (){
                   Navigator.pushNamed(context, '/users_page');
                 },
               ),
             ),
           ],
         ),

          Padding(
            padding: const EdgeInsets.only(left: 25.0, bottom: 25),
            child: ListTile(
              title: const Text('L O G O U T'),
              leading: Icon(Icons.logout,
                  color: Theme.of(context).colorScheme.inversePrimary),
              onTap: (){
                logout();
              },
            ),
          ),
        ],
      ),
    );
  }
}
