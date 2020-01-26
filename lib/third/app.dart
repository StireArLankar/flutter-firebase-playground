import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth.dart';
import 'super_hero.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Make user stream available
        StreamProvider<FirebaseUser>(
          create: (_) => FirebaseAuth.instance.onAuthStateChanged,
          // value: FirebaseAuth.instance.onAuthStateChanged,
        ),
        Provider<AuthService>.value(
          value: AuthService(),
        )
        // See implementation details in next sections
        // StreamProvider<SuperHero>.value(value: firestoreStream),
      ],
      child: MaterialApp(
        title: 'FlutterBase',
        home: Scaffold(
          appBar: AppBar(
            title: Text('Flutterbase'),
            backgroundColor: Colors.amber,
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                LoginButton(), // <-- Built with StreamBuilder
                UserProfile(), // <-- Built with StatefulWidget
                HeroScreen()
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class UserProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);

    return Column(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(20),
          child: StreamBuilder(
            stream: auth.profile,
            builder: (context, snapshot) {
              return Text(snapshot.data.toString());
            },
          ),
        ),
        StreamBuilder(
          stream: auth.loading,
          builder: (context, snapshot) {
            return Text(snapshot.data.toString());
          },
        )
      ],
    );
  }
}

class LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);

    return StreamBuilder(
      stream: auth.user,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return MaterialButton(
            onPressed: () => auth.signOut(),
            color: Colors.red,
            textColor: Colors.white,
            child: Text('Signout'),
          );
        } else {
          return MaterialButton(
            onPressed: () => auth.googleSignIn(),
            color: Colors.white,
            textColor: Colors.black,
            child: Text('Login with Google'),
          );
        }
      },
    );
  }
}
