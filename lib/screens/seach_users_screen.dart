import 'package:flutter/material.dart';
import 'package:mobile_chat/models/user_data.dart';
import 'package:mobile_chat/models/user_model.dart';
import 'package:mobile_chat/services/database_service.dart';
import 'package:provider/provider.dart';

class SearchUsersScreen extends StatefulWidget {
  @override
  _SearchUsersScreenState createState() => _SearchUsersScreenState();
}

class _SearchUsersScreenState extends State<SearchUsersScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<User> _users = [];
  List<User> _selectedUsers = [];

  _clearSearch() {
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _searchController.clear());
    setState(() => _users = []);
  }

  @override
  Widget build(BuildContext context) {
    final currentUserID =
        Provider.of<UserData>(context, listen: false).currentUserID;
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Users'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {},
          )
        ],
      ),
      body: Column(
        children: [
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 15.0),
              border: InputBorder.none,
              hintText: 'Search',
              prefixIcon: Icon(
                Icons.search,
                size: 30.0,
              ),
              suffixIcon:
                  IconButton(icon: Icon(Icons.clear), onPressed: _clearSearch),
              filled: true,
            ),
            onSubmitted: (value) async {
              if (value.trim().isNotEmpty) {
                List<User> users =
                    await Provider.of<DatabaseService>(context, listen: false)
                        .searchUsers(currentUserID, value);
                _selectedUsers.forEach((selectedUser) {
                  for (var i = 0; i < users.length; i++) {
                    final user = users[i];
                    if (user.id == selectedUser.id) {
                      users.remove(user);
                    }
                  }
                });
                setState(() => _users = users);
              }
            },
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _selectedUsers.length + _users.length,
              itemBuilder: (BuildContext context, int index) {
                if (index < _selectedUsers.length) {
                  //Display selected users
                  User selectedUser = _selectedUsers[index];
                  return ListTile(
                    title: Text(selectedUser.name),
                    trailing: Icon(Icons.check_circle),
                    onTap: () {
                      setState(() {
                        _selectedUsers.remove(selectedUser);
                        _users.insert(0, selectedUser);
                      });
                    },
                  );
                }

                // Display other users
                int userIndex = index - _selectedUsers.length;
                User user = _users[userIndex];
                return ListTile(
                  title: Text(user.name),
                  trailing: Icon(Icons.check_circle_outline),
                  onTap: () {
                    setState(() {
                      _selectedUsers.add(user);
                      _users.remove(user);
                    });
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
