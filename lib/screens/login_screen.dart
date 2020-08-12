import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_chat/services/auth_service.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _loginFormKey = GlobalKey<FormState>();
  final _signupFormKey = GlobalKey<FormState>();
  String _name, _email, _password;
  int _selectedIndex = 0;

  Form _buildLoginForm() {
    return Form(
      key: _loginFormKey,
      child: Column(
        children: [
          _buildEmailTF(),
          _buildPasswordTF(),
        ],
      ),
    );
  }

  Form _buildSignUpForm() {
    return Form(
      key: _signupFormKey,
      child: Column(
        children: [
          _buildNameTF(),
          _buildEmailTF(),
          _buildPasswordTF(),
        ],
      ),
    );
  }

  Widget _buildNameTF() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
      child: TextFormField(
        decoration: const InputDecoration(labelText: 'Name'),
        validator: (value) =>
            value.trim().isEmpty ? 'Please enter a name' : null,
        onSaved: (newValue) => _name = newValue,
      ),
    );
  }

  Widget _buildEmailTF() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
      child: TextFormField(
        decoration: const InputDecoration(labelText: 'Email'),
        validator: (value) => !EmailValidator.validate(value)
            ? 'Please enter a valid Email'
            : null,
        onSaved: (newValue) => _email = newValue,
      ),
    );
  }

  Widget _buildPasswordTF() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
      child: TextFormField(
        decoration: const InputDecoration(labelText: 'Password'),
        validator: (value) =>
            value.length < 6 ? 'Password must be at least 6 characters' : null,
        onSaved: (newValue) => _password = newValue,
        obscureText: true,
      ),
    );
  }

  _submit() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    try {
      if (_selectedIndex == 0 && _loginFormKey.currentState.validate()) {
        _loginFormKey.currentState.save();
        await authService.login(_email, _password);
      } else if (_selectedIndex == 1 &&
          _signupFormKey.currentState.validate()) {
        _signupFormKey.currentState.save();
        await authService.signup(_name, _email, _password);
      }
    } on PlatformException catch (err) {
      _showErrorDialog(err.message);
    }
  }

  _showErrorDialog(String errorMessage) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(errorMessage),
          actions: [
            FlatButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Ok'),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome to our chat !',
              style: TextStyle(
                fontSize: 30.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: 150.0,
                  child: FlatButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    color: _selectedIndex == 0 ? Colors.blue : Colors.grey[300],
                    onPressed: () {
                      setState(() {
                        _selectedIndex = 0;
                      });
                    },
                    child: Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 20.0,
                        color: _selectedIndex == 0 ? Colors.white : Colors.blue,
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 150.0,
                  child: FlatButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    color: _selectedIndex == 1 ? Colors.blue : Colors.grey[300],
                    onPressed: () {
                      setState(() {
                        _selectedIndex = 1;
                      });
                    },
                    child: Text(
                      'Sign Up',
                      style: TextStyle(
                        fontSize: 20.0,
                        color: _selectedIndex == 1 ? Colors.white : Colors.blue,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            _selectedIndex == 0 ? _buildLoginForm() : _buildSignUpForm(),
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
                  'Submit',
                  style: TextStyle(color: Colors.white, fontSize: 20.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
