import 'package:cloud_firestore/cloud_firestore.dart ';

import '../models/user.dart';

class FireStoreUser {
  final CollectionReference<Map<String, dynamic>> _userCollectionRefrence =
      FirebaseFirestore.instance.collection('Users');

  addUser(UserModel userModel) async {
    return await _userCollectionRefrence
        .doc(userModel.userId)
        .set(userModel.toJson());
  }
}
