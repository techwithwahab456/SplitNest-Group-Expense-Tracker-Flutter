import 'package:cloud_firestore/cloud_firestore.dart';

class Usermodel {
  final String id;
  String firstname;
  String lastname;
  final String username;
  final String email;
  final String phonenumber;
  String profilepicture;

  Usermodel({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.username,
    required this.email,
    required this.phonenumber,
    required this.profilepicture,
  });

  // Empty helper
  static Usermodel empty() => Usermodel(
    id: '', firstname: '', lastname: '', username: '', email: '', phonenumber: '', profilepicture: ''
  );

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstname': firstname,
      'lastname': lastname,
      'username': username,
      'email': email,
      'phonenumber': phonenumber,
      'profilepicture': profilepicture,
    };
  }

  // Factory constructor for Firestore
  factory Usermodel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data()!;
      return Usermodel(
        id: document.id,
        firstname: data['firstname'] ?? '',
        lastname: data['lastname'] ?? '',
        username: data['username'] ?? '',
        email: data['email'] ?? '',
        phonenumber: data['phonenumber'] ?? '',
        profilepicture: data['profilepicture'] ?? '',
      );
    } else {
      return Usermodel.empty();
    }
  }
}