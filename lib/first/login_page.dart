import 'package:flutter/material.dart';
import 'primary_button.dart';
import 'auth.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title, this.auth, this.onSignIn}) : super(key: key);

  final String title;
  final BaseAuth auth;
  final VoidCallback onSignIn;

  @override
  _LoginPageState createState() => _LoginPageState();
}

enum FormType {
  login,
  register,
}

class _LoginPageState extends State<LoginPage> {
  static final formKey = GlobalKey<FormState>();

  String _email;
  String _password;
  FormType _formType = FormType.login;
  String _authHint = '';

  bool validateAndSave() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void validateAndSubmit() async {
    if (validateAndSave()) {
      try {
        String userId = _formType == FormType.login
            ? await widget.auth.signIn(_email, _password)
            : await widget.auth.createUser(_email, _password);
        setState(() {
          _authHint = 'Signed In\n\nUser id: $userId';
        });
        widget.onSignIn();
      } catch (e) {
        setState(() {
          _authHint = 'Sign In Error\n\n${e.toString()}';
        });
        print(e);
      }
    } else {
      setState(() {
        _authHint = '';
      });
    }
  }

  void moveToRegister() {
    formKey.currentState.reset();
    setState(() {
      _formType = FormType.register;
      _authHint = '';
    });
  }

  void moveToLogin() {
    formKey.currentState.reset();
    setState(() {
      _formType = FormType.login;
      _authHint = '';
    });
  }

  List<Widget> usernameAndPassword() {
    return [
      padded(
        child: TextFormField(
          key: Key('email'),
          decoration: InputDecoration(labelText: 'Email'),
          autocorrect: false,
          validator: (val) => val.isEmpty ? 'Email can\'t be empty.' : null,
          onSaved: (val) => _email = val,
        ),
      ),
      padded(
        child: TextFormField(
          key: Key('password'),
          decoration: InputDecoration(labelText: 'Password'),
          obscureText: true,
          autocorrect: false,
          validator: (val) => val.isEmpty ? 'Password can\'t be empty.' : null,
          onSaved: (val) => _password = val,
        ),
      ),
    ];
  }

  List<Widget> submitWidgets() {
    switch (_formType) {
      case FormType.login:
        return [
          PrimaryButton(
            key: Key('login'),
            text: 'Login',
            height: 44.0,
            onPressed: validateAndSubmit,
          ),
          FlatButton(
            key: Key('need-account'),
            child: Text("Need an account? Register"),
            onPressed: moveToRegister,
          ),
        ];
      case FormType.register:
        return [
          PrimaryButton(
            key: Key('register'),
            text: 'Create an account',
            height: 44.0,
            onPressed: validateAndSubmit,
          ),
          FlatButton(
            key: Key('need-login'),
            child: Text("Have an account? Login"),
            onPressed: moveToLogin,
          ),
        ];
    }
    return null;
  }

  Widget hintText() {
    return Container(
        //height: 80.0,
        padding: const EdgeInsets.all(32.0),
        child: Text(_authHint,
            key: Key('hint'),
            style: TextStyle(fontSize: 18.0, color: Colors.grey),
            textAlign: TextAlign.center));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        backgroundColor: Colors.grey[300],
        body: SingleChildScrollView(
            child: Container(
                padding: const EdgeInsets.all(16.0),
                child: Column(children: [
                  Card(
                      child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                        Container(
                            padding: const EdgeInsets.all(16.0),
                            child: Form(
                                key: formKey,
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children:
                                      usernameAndPassword() + submitWidgets(),
                                ))),
                      ])),
                  hintText()
                ]))));
  }

  Widget padded({Widget child}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: child,
    );
  }
}
