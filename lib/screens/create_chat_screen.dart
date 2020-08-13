import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_chat/models/user_data.dart';
import 'package:mobile_chat/models/user_model.dart';
import 'package:mobile_chat/screens/home_screen.dart';
import 'package:mobile_chat/services/database_service.dart';
import 'package:provider/provider.dart';

class CreateChatScreen extends StatefulWidget {
  final List<User> selectedUsers;

  const CreateChatScreen({this.selectedUsers});

  @override
  _CreateChatScreenState createState() => _CreateChatScreenState();
}

class _CreateChatScreenState extends State<CreateChatScreen> {
  final _nameFormKey = GlobalKey<FormFieldState>();
  String _name = '';
  File _image;
  bool _isLoading = false;

  _handleImageFromGallery() async {
    PickedFile imageFile =
        await Provider.of<ImagePicker>(context, listen: false)
            .getImage(source: ImageSource.gallery);

    if (imageFile != null) {
      setState(() => _image = File(imageFile.path));
    }
  }

  Widget _displayChatImage() {
    return GestureDetector(
      onTap: _handleImageFromGallery,
      child: CircleAvatar(
        radius: 80.0,
        backgroundColor: Colors.grey[300],
        backgroundImage: _image != null ? FileImage(_image) : null,
        child: _image == null
            ? const Icon(
                Icons.add_a_photo,
                size: 50.0,
              )
            : null,
      ),
    );
  }

  _submit() async {
    if (_nameFormKey.currentState.validate() && !_isLoading) {
      _nameFormKey.currentState.save();
      if (_image != null) {
        setState(() => _isLoading = true);
        List<String> userIds =
            widget.selectedUsers.map((user) => user.id).toList();
        userIds
            .add(Provider.of<UserData>(context, listen: false).currentUserID);
        await Provider.of<DatabaseService>(context, listen: false)
            .createChat(context, _name, _image, userIds);
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (_) => HomeScreen()), (route) => false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Chat'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _isLoading
                ? LinearProgressIndicator(
                    backgroundColor: Colors.blue[200],
                    valueColor: AlwaysStoppedAnimation(Colors.blue),
                  )
                : const SizedBox.shrink(),
            const SizedBox(height: 30.0),
            _displayChatImage(),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextFormField(
                key: _nameFormKey,
                decoration: InputDecoration(labelText: 'Chat Name'),
                validator: (value) =>
                    value.trim().isEmpty ? 'Please enter a chat name' : null,
                onSaved: (newValue) => _name = newValue,
              ),
            ),
            const SizedBox(height: 20.0),
            Container(
              width: 180.0,
              child: FlatButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                color: Colors.blue,
                onPressed: _submit,
                child: Text(
                  'Create',
                  style: const TextStyle(color: Colors.white, fontSize: 20.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
