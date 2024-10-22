import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:naningana/components/afficherMessageInfo.dart';
import 'package:naningana/mail/sendMailController.dart';
import 'package:naningana/orderpage/OrderPage.dart';
import 'package:naningana/services/firestoreService.dart';
import 'package:naningana/user/userProfile.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Naningana"),
      ),
      drawer: Drawer(
        child: FutureBuilder(
          future: Future.value(user?.email), // Wrap the email in a Future
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              return _drawer(context, snapshot.data); // Pass email data to drawer
            }
          },
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,  // Full screen width
        height: MediaQuery.of(context).size.height, // Full screen height
        decoration: BoxDecoration(
          color: Colors.black12,
          image: const DecorationImage(
            image: AssetImage('assets/images/background.webp'),
            fit: BoxFit.cover,
          ),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12.0, sigmaY: 12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                ),
              ),
              const SizedBox(height: 80),
              buildLogo(),
              const SizedBox(height: 18),
              buildTitle(),
              const SizedBox(height: 18),
              buildActionButtons(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildButton(BuildContext context, String text, Color textColor, Color buttonColor, VoidCallback onPressed) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(100.0),
      ),
      child: TextButton(
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(color: buttonColor),
        ),
      ),
    );
  }

  Widget buildLogo() {
    return Container(
      width: 200,
      height: 200,
      decoration: const BoxDecoration(
        image: DecorationImage(image: AssetImage('assets/images/logo.png')),
      ),
    );
  }

  Widget buildTitle() {
    return const Text(
      "Na ningana",
      style: TextStyle(
        fontSize: 50,
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget buildActionButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, '/intro_page');
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          ),
          child: const Text("Jouer", style: TextStyle(color: Colors.white)),
        ),
        const SizedBox(width: 20),
        ElevatedButton(
          onPressed: () {
            SystemNavigator.pop();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          ),
          child: const Text("Quitter", style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }

  Widget _drawer(BuildContext context, String? email) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildDrawerHeader(context, email),
            _buildDrawerItems(context),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerHeader(BuildContext context, String? email) {
    return Material(
      color: Colors.blueAccent,
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
          Navigator.push(context, MaterialPageRoute(builder: (context) => UserProfile()));
        },
        child: Container(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top,
            bottom: 24,
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 52,
                  backgroundImage:  NetworkImage(
                    'https://static.vecteezy.com/system/resources/previews/005/129/844/non_2x/profile-user-icon-isolated-on-white-background-eps10-free-vector.jpg',
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  email ?? '',
                  style: const TextStyle(fontSize: 14, color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerItems(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.home_outlined),
          title: const Text('Home'),
          onTap: () {
            Navigator.pop(context);
            Navigator.pushReplacementNamed(context, '/home');
          },
        ),
        ListTile(
          leading: const Icon(Icons.shopping_cart),
          title: const Text('Commander'),
          onTap: () {
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (context) => OrderPage()));
          },
        ),
        ListTile(
          leading: const Icon(Icons.workspaces),
          title: const Text('Workflow'),
          onTap: () {},
        ),
        ListTile(
          leading: const Icon(Icons.update),
          title: const Text('Updates'),
          onTap: () {},
        ),
        const Divider(color: Colors.black45),
        ListTile(
          leading: const Icon(Icons.account_tree_outlined),
          title: const Text('Plugins'),
          onTap: () {},
        ),
        ListTile(
          leading: const Icon(Icons.notifications_outlined),
          title: const Text('Notifications'),
          onTap: () {},
        ),
      ],
    );
  }

  void _showAlert(BuildContext context) {
    FirestoreService fire = FirestoreService();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
          ),
          title: const Center(child: Text("Quitter")),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text("Êtes-vous sûr de vouloir quitter ?"),
              const Text("Cela mettra fin à la partie."),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    onPressed: () async {
                     // await fire.logout();
                      Navigator.pushNamed(context, '/login_register');
                      afficherMessageInfo(context, "Déconnexion effectuée avec succès", Colors.orangeAccent, Colors.black);
                    },
                    child: const Text("Quitter"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text("Annuler"),
                  ),
                ],
              ),
            ],
          ),
        );
      },
      barrierDismissible: false,
    );
  }
}
