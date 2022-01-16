import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  FirebaseAuth get auth => _auth;

  String _verificationID = '';
  String _number = '';

  String get number => _number;

  void _setVerificationId(String verificationId) =>
      _verificationID = verificationId;

  void _setNumber(String number) => _number = number;

  Future<void> login(String number) async {
    _setNumber(number);
    await _auth.verifyPhoneNumber(
      phoneNumber: _number,
      verificationCompleted: (phoneAuthCredential) async {
        await _auth.signInWithCredential(phoneAuthCredential);
      },
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          print('The provided phone number is not valid.');
        }
      },
      codeSent: (verificationId, [forceResendingToken]) {
        print('code sent');
        _setVerificationId(verificationId);
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        print('code timeout');
      },
      timeout: const Duration(seconds: 60),
    );
  }

  Future<void> signIn(String smsCode) async {
    await _auth.signInWithCredential(PhoneAuthProvider.credential(
      verificationId: _verificationID,
      smsCode: smsCode,
    ));
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<void> setUser() async {
    bool _userExist = false;
    await _firestore
        .collection('users')
        .where('number', isEqualTo: _number)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        _userExist = true;
        print('user exist');
      }
    });
    if (!_userExist) {
      await _firestore.collection('users').doc(_auth.currentUser!.uid).set({
        'phone_number': _number,
      }, SetOptions(merge: true));
    }
  }

  Future<bool> checkUser(String number) async {
    await _firestore
        .collection('users')
        .where('phone_number', isEqualTo: number)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        return true;
      }
    });
    return false;
  }
}
