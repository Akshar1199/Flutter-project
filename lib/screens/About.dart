import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AboutUsPage(),
    );
  }
}

class AboutUsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About Us'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            buildTeamMember(
              'Akshar Parekh',
              'CE Student of Sem 5',
              'Akshar is a passionate entrepreneur with a vision for innovation. He loves creating solutions that make people\'s lives better.',
              'assets/images/akshar_parekh.jpg',
            ),
            buildTeamMember(
              'Dhruvin Pambhar',
              'CE Student of Sem 5',
              'Dhruvin is a talented developer with a knack for turning ideas into beautiful and functional apps.',
              'assets/images/dhruvin.jpg',
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTeamMember(
      String name, String role, String description, String imagePath) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          CircleAvatar(
            radius: 60,
            backgroundImage: AssetImage(imagePath),
          ),
          SizedBox(height: 16),
          Text(
            name,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            role,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              description,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
