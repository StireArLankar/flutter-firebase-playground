import 'package:cloud_firestore/cloud_firestore.dart';

class SuperHero {
  final String name;
  final int strength;
  final int damage;

  SuperHero({this.name, this.strength, this.damage});

  factory SuperHero.fromMap(Map data) {
    data = data ?? {};
    return SuperHero(
      name: data['name'] ?? '',
      strength: data['strength'] ?? 100,
      damage: data['damage'] ?? 10,
    );
  }
}

class Weapon {
  final String id;
  final String name;
  final int hitpoints;
  final String img;

  Weapon({
    this.id,
    this.name,
    this.hitpoints,
    this.img,
  });

  factory Weapon.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;

    return Weapon(
      id: doc.documentID,
      name: data['name'] ?? '',
      hitpoints: int.parse(data['hitpoints']) ?? 0,
      img: data['img'] ?? '',
    );
  }
}
