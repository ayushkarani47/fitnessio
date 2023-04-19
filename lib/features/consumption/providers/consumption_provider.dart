import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smart_home_app/model/meal_model.dart';

class ConsumptionProvider with ChangeNotifier {
  final List<MealModel> _meals = [];
  List<MealModel> get meals {
    return [..._meals];
  }

  Future<void> addNewMeal({
    required String title,
    required double amount,
    required double calories,
    required double fats,
    required double carbs,
    required double proteins,
    required DateTime dateTime,
  }) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      await FirebaseFirestore.instance
          .collection('meals')
          .doc(user!.uid)
          .collection('mealData')
          .doc()
          .set({
        'title': title,
        'amount': amount,
        'calories': calories,
        'fats': fats,
        'carbs': carbs,
        'proteins': proteins,
        'dateTime': dateTime,
      });
      notifyListeners();
    } catch (e) {
      print(e);
      notifyListeners();
    }
  }

  Future fetchAndSetMeals() async {
    User? user = FirebaseAuth.instance.currentUser;

    try {
      final mealsSnapshot = await FirebaseFirestore.instance
          .collection('meals')
          .doc(user!.uid)
          .collection('mealData')
          .get();

      final List<MealModel> loadedMeals = [];

      for (var doc in mealsSnapshot.docs) {
        final mealData = doc.data();
        loadedMeals.add(MealModel(
          id: doc.id,
          title: mealData['title'],
          amount: mealData['amount'],
          calories: mealData['calories'],
          fats: mealData['fats'],
          carbs: mealData['carbs'],
          proteins: mealData['proteins'],
          dateTime: (mealData['dateTime'] as Timestamp).toDate(),
        ));
      }
      _meals.clear();
      _meals.addAll(loadedMeals);
      notifyListeners();
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<void> clearMealsIfDayChanges(DateTime lastDateTime) async {
    DateTime now = DateTime.now();
    if (isLastDateTimeDifferent(now, lastDateTime)) {
      try {
        User? user = FirebaseAuth.instance.currentUser;

        await FirebaseFirestore.instance
            .collection('meals')
            .doc(user!.uid)
            .collection('mealData')
            .get()
            .then((querySnapshot) {
          for (var doc in querySnapshot.docs) {
            DateTime mealDateTime = (doc['dateTime'] as Timestamp).toDate();
            if (isMealDateDifferent(now, mealDateTime)) {
              doc.reference.delete();
            }
          }
        });
      } catch (e) {
        print(e);
      }
    }
  }

  bool isLastDateTimeDifferent(DateTime now, DateTime lastDateTime) {
    return now.year != lastDateTime.year ||
        now.month != lastDateTime.month ||
        now.day != lastDateTime.day;
  }

  bool isMealDateDifferent(DateTime now, DateTime mealDateTime) {
    return now.year != mealDateTime.year ||
        now.month != mealDateTime.month ||
        now.day != mealDateTime.day;
  }
}
