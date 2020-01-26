import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'db.dart';
import 'models.dart';

class HeroScreen extends StatelessWidget {
  final db = DatabaseService();

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<FirebaseUser>(context);
    bool loggedIn = user != null;

    return Expanded(
      child: Column(
        children: <Widget>[
          if (loggedIn)
            StreamProvider<SuperHero>.value(
              // All children will have access to SuperHero data
              value: db.streamHero(user.uid),
              child: HeroProfile(),
            ),
          if (loggedIn)
            StreamProvider<List<Weapon>>.value(
              // All children will have access to weapons data
              value: db.streamWeapons(user),
              initialData: [],
              child: WeaponsList(),
            ),
        ],
      ),
    );
  }
}

class WeaponsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final weapons = Provider.of<List<Weapon>>(context);

    return Expanded(
      child: ListView.builder(
        itemBuilder: (ctx, ind) {
          return Container(
            color: Colors.amber[100],
            child: ListTile(
              leading: Container(
                child: FittedBox(
                  child: Text(
                    weapons[ind].img,
                    style: TextStyle(fontSize: 40),
                  ),
                ),
              ),
              title: Text(weapons[ind].name),
              subtitle: Text('Deals ${weapons[ind].hitpoints} of damage'),
            ),
          );
        },
        itemCount: weapons.length,
      ),
    );
  }
}

class HeroProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var user = Provider.of<FirebaseUser>(context);
    var hero = Provider.of<SuperHero>(context);

    if (hero == null) {
      return Column(
        children: <Widget>[],
      );
    }

    return Column(
      children: <Widget>[
        Text('Hi ${user.displayName}'),
        Text('Name: ${hero.name}, str: ${hero.strength}, dmg: ${hero.damage}'),
      ],
    );
  }
}
