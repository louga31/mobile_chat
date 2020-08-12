import 'package:flutter/material.dart';
import 'package:mobile_chat/screens/seach_users_screen.dart';
import 'package:mobile_chat/services/auth_service.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.exit_to_app),
          onPressed: Provider.of<AuthService>(context, listen: false).logout,
        ),
        title: Text('Chats'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => SearchUsersScreen()),
            ),
          ),
        ],
      ),
    );
  }
}
