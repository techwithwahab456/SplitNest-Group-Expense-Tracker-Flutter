
# SplitNest - Group Expense Sharing App

Group expense sharing app for 4+ friends with real-time balance calculation and monthly analytics.

**Live Problem Solved:** When 1 friend deleted expense of 2500 PKR, total for other 3 became wrong by 625 PKR each. Fixed with Cloud Functions recalculation. Improved speed 40% from 1.2s to 0.7s.

## Features
- Group creation for 4+ friends
- Expense tracking with real-time Firestore sync
- Cloud Functions for automatic recalculation on delete/edit - Fixed 625 PKR error
- Monthly analytics with fl_chart - Bar chart and pie chart
- Balance settlement: Who owes whom
- Performance: 40% faster recalculation (1.2s → 0.7s)

## Technologies
- Flutter 3.16
- Firebase Firestore, Firebase Auth, Cloud Functions
- fl_chart for analytics
- Provider state management

## Screenshots




## Problem and Solution
**Problem:** Deleting expense caused wrong total for 3 users, error 625 PKR each.
**Solution:** Added Firebase Cloud Function onDelete trigger that recalculates all balances. Added transaction for consistency.
**Result:** 0 errors now, 40% faster.

## How to run
flutter pub get
flutter run

GitHub: github.com/YOURUSERNAME/splitnest
Developer: Abdul Wahab - 3 years Flutter
