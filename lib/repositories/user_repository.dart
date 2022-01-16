import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

class UserRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  FirebaseFirestore get firestore => _firestore;
  FirebaseAuth get auth => _auth;

  Future<void> upload(File imageFile, String fileName) async {
    try {
      await _storage
          .ref(_auth.currentUser!.uid + '/' + fileName)
          .putFile(imageFile);
    } on FirebaseException catch (error) {
      if (kDebugMode) {
        print(error);
      }
    } catch (err) {
      if (kDebugMode) {
        print(err);
      }
    }
    // await _firestore.collection('users').doc(_auth.currentUser!.uid).update('':);
  }

  Future<List<Map<String, dynamic>>> loadImages() async {
    List<Map<String, dynamic>> _files = [];

    final ListResult result = await _storage.ref(_auth.currentUser!.uid).list();
    final List<Reference> allFiles = result.items;

    await Future.forEach<Reference>(allFiles, (file) async {
      final String fileUrl = await file.getDownloadURL();

      _files.add({
        "url": fileUrl,
        "path": file.fullPath,
      });
    });

    return _files;
  }
}
