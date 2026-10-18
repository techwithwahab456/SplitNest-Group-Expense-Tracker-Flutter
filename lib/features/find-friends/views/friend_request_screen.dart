import 'package:expense_tracker_app/common/constant/app_colors.dart';
import 'package:expense_tracker_app/features/find-friends/controllers/friend_request_controler.dart';
import 'package:expense_tracker_app/features/find-friends/model/friend_request_model.dart';
// Ensure this path is correct
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FriendRequestsScreen extends StatelessWidget {
  const FriendRequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // We use find because it should be initialized in bindings or search screen
    // If not, Get.put(FriendRequestController()) is fine
    final controller = Get.put(FriendRequestController());

    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        title: const Text("Friend Requests", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: StreamBuilder<List<FriendRequestModel>>(
        // FIX: Use the typed stream from our controller
        stream: controller.incomingRequests, 
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: AppColors.primaryTeal));
          }
          
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}", style: const TextStyle(color: Colors.red)));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.mail_outline, size: 60, color: Colors.grey),
                  SizedBox(height: 16),
                  Text("No pending requests", style: TextStyle(color: Colors.grey)),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            padding: const EdgeInsets.all(16),
            itemBuilder: (context, index) {
              final request = snapshot.data![index];

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.surfaceColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white.withOpacity(0.05)),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: AppColors.primaryTeal.withOpacity(0.2),
                      child: Text(
                        request.senderName[0].toUpperCase(),
                        style: const TextStyle(color: AppColors.primaryTeal, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            request.senderName, 
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
                          ),
                          Text(
                            request.senderEmail, 
                            style: const TextStyle(color: Colors.grey, fontSize: 12)
                          ),
                        ],
                      ),
                    ),
                    // Accept Button
                    IconButton(
                      icon: const Icon(Icons.check_circle, color: AppColors.primaryTeal),
                      onPressed: () => controller.acceptFriend(request),
                    ),
                    // Decline Button (You can add logic to delete the doc)
                    IconButton(
                      icon: const Icon(Icons.cancel, color: Colors.red),
                      onPressed: () => Get.snackbar("Info", "Decline logic coming soon"),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}