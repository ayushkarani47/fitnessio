import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:smart_home_app/utils/managers/color_manager.dart';
import 'package:smart_home_app/utils/managers/string_manager.dart';
import 'package:smart_home_app/utils/managers/style_manager.dart';
import 'package:smart_home_app/utils/managers/value_manager.dart';

class AuthProvider with ChangeNotifier {
  User? _user;
  bool? _isNewUser;
  bool? _hasAgeParameter;

  AuthProvider() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      _user = user;
      if (_user != null) {
        _checkUserData();
      } else {
        _resetUserState();
      }
    });
  }

  // --- User State ---
  User? get user => _user;
  bool? get isNewUser => _isNewUser;
  bool? get hasAgeParameter => _hasAgeParameter;

  void callAuth() =>
      FirebaseAuth.instance.authStateChanges().listen((User? user) {
        _user = user;
        if (_user != null) {
          _checkUserData();
        } else {
          _resetUserState();
        }
      });

  void _checkUserData() {
    FirebaseFirestore.instance
        .collection('users')
        .doc(_user!.uid)
        .get()
        .then((docSnapshot) {
      _hasAgeParameter =
          docSnapshot.exists && docSnapshot.data()!.containsKey('age');
      _isNewUser =
          _user!.metadata.creationTime == _user!.metadata.lastSignInTime &&
              !_hasAgeParameter!;
      notifyListeners();
    });
  }

  void _resetUserState() {
    _hasAgeParameter = null;
    _isNewUser = null;
    notifyListeners();
  }

  // --- Auth Operations ---
  Future<void> forgotPassword({
    required String email,
    required BuildContext context,
  }) async {
    _showLoadingDialog(context);

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      Navigator.pop(context);
      _showMessageDialog(
          context, StringsManager.success, StringsManager.pwResetLinkSent);
    } catch (e) {
      Navigator.pop(context);
      _showMessageDialog(context, StringsManager.error, e.toString());
    }
    notifyListeners();
  }

  Future<void> signIn({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    _showLoadingDialog(context);

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      Navigator.pop(context);
      notifyListeners();
    } catch (e) {
      Navigator.pop(context);
      _showMessageDialog(context, StringsManager.error, e.toString());
    }
  }

  Future<void> register({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    _showLoadingDialog(context);

    try {
      UserCredential credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      print("User created: ${credential.user!.email}");
      Navigator.pop(context);
      notifyListeners();
    } catch (e) {
      Navigator.pop(context);
      _showMessageDialog(context, StringsManager.error, e.toString());
    }
  }

  // --- User Data Operations ---
  Future<void> addUserData({
    required String email,
    required String name,
    required String surname,
    required int age,
    required BuildContext context,
    required String gender,
    required double height,
    required double weight,
    required String activity,
    required double bmr,
    required String goal,
    required double bmi,
  }) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(_user!.uid).set({
        'email': email,
        'name': name,
        'surname': surname,
        'age': age,
        'gender': gender,
        'height': height,
        'weight': weight,
        'activity': activity,
        'bmr': bmr,
        'goal': goal,
        'bmi': bmi,
      });
      print('User data added successfully!');
    } catch (e) {
      print('Error adding user data: $e');
    }
  }
  void _showLoadingDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (_) => Center(
              child: Padding(
                padding: const EdgeInsets.all(50),
                child: SpinKitSpinningLines(color: ColorManager.limerGreen2),
              ),
            ));
  }

  void _showMessageDialog(BuildContext context, String title, String message) {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              backgroundColor: ColorManager.darkGrey,
              title: Text(
                title,
                textAlign: TextAlign.center,
                style: StyleManager.forgotPWErrorTextStyle,
              ),
              content: Text(
                message,
                textAlign: TextAlign.center,
                style: StyleManager.forgotPWErrorContentTextStyle,
              ),
            ));
  }
}
