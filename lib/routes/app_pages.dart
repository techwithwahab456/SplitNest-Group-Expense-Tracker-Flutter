// import 'package:get/get.dart';
// import '../routes/app_routes.dart';

// // Import your views here
// // import '../../features/auth/view/login_screen.dart';
// // import '../../features/home/view/dashboard_screen.dart';

// class AppPages {
//   static const initial = Routes.login;

//   static final List<GetPage> appRoutes = [
//     // Auth Flow
//     GetPage(
//       name: Routes.login,
//       page: () => const LoginScreen(), // Update with your actual widget
//       binding: AuthBinding(),
//     ),
//     GetPage(
//       name: Routes.signUp,
//       page: () => const SignupScreen(),
//       binding: AuthBinding(),
//     ),

//     // Main App (Usually a screen with the Bottom Navigation Bar)
//     GetPage(
//       name: Routes.dashboard,
//       page: () => const DashboardScreen(),
//       // binding: HomeBinding(), // Create this later for home logic
//     ),

//     // Specific Feature Pages
//     GetPage(
//       name: Routes.swipeRoom,
//       page: () => const SwipeRoomScreen(),
//     ),
//     GetPage(
//       name: Routes.addExpense,
//       page: () => const AddExpenseScreen(),
//     ),
//     GetPage(
//       name: Routes.groupDetails,
//       page: () => const GroupDetailsScreen(),
//     ),
//     GetPage(
//       name: Routes.analytics,
//       page: () => const AnalyticsScreen(),
//     ),
//   ];
// }