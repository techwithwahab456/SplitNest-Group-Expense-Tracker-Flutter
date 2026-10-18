import 'package:expense_tracker_app/common/constant/app_colors.dart';
import 'package:expense_tracker_app/common/utils/custom_textfield.dart';
import 'package:expense_tracker_app/datas/repositories/group_repository.dart';
import 'package:expense_tracker_app/features/find-friends/controllers/search_friend_controller.dart';
import 'package:expense_tracker_app/features/find-friends/views/friend_detail_screen.dart';
import 'package:expense_tracker_app/features/find-friends/views/friend_request_screen.dart';
import 'package:expense_tracker_app/features/find-friends/widget/edit-dialogue.dart';
import 'package:expense_tracker_app/features/friends_group/model/group_model.dart';
import 'package:expense_tracker_app/features/friends_group/views/create_group_screen.dart';
import 'package:expense_tracker_app/features/friends_group/views/group_detail_screen.dart';
import 'package:expense_tracker_app/features/profile/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:expense_tracker_app/common/constant/app_colors.dart';
import 'package:expense_tracker_app/common/utils/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SocialHubScreen extends StatelessWidget {
  const SocialHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SocialHubController());

    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        title: const Text("Budget Buddy Hub", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.white),
            onPressed: () => Get.to(() => const FriendRequestsScreen()),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- SEARCH SECTION ---
            Row(
              children: [
                Expanded(
                  child: buildCustomTextField(
                    controller: controller.searchController,
                    label: "Search email...",
                    icon: Icons.search,
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () => controller.searchUser(),
                  child: Container(
                    height: 55, width: 55,
                    decoration: BoxDecoration(color: AppColors.primaryTeal, borderRadius: BorderRadius.circular(12)),
                    child: const Icon(Icons.search, color: Colors.white),
                  ),
                )
              ],
            ),

            // --- SEARCH RESULT (OBX) ---
          // --- SEARCH RESULT (OBX) ---
Obx(() {
  if (controller.isLoading.value) return const LinearProgressIndicator();
  if (controller.rxFoundUser.value == null) return const SizedBox.shrink();
  
  final user = controller.rxFoundUser.value!;
  final bool isFriend = controller.rxIsAlreadyFriend.value;

  return Container(
    margin: const EdgeInsets.only(top: 15),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: AppColors.surfaceColor, 
      borderRadius: BorderRadius.circular(12),
      border: isFriend ? Border.all(color: AppColors.primaryTeal, width: 0.5) : null,
    ),
    child: ListTile(
      leading: const CircleAvatar(backgroundColor: AppColors.primaryTeal, child: Icon(Icons.person, color: Colors.white)),
      title: Text("${user.firstname} ${user.lastname}", style: const TextStyle(color: Colors.white)),
      subtitle: Text(isFriend ? "Already Friends" : user.email, style: TextStyle(color: isFriend ? AppColors.primaryTeal : Colors.grey)),
      trailing: isFriend 
        ? const Icon(Icons.check_circle, color: AppColors.primaryTeal) // Show Friend Icon
        : IconButton(
            icon: const Icon(Icons.person_add, color: AppColors.primaryTeal),
            onPressed: controller.processSendRequest,
          ),
      onTap: () {
        if (isFriend) {
          // Future: Navigate to private chat or specific friend details
          Get.snackbar("Friend", "You are already connected with ${user.firstname}");
        }
      },
    ),
  );
}),

            const SizedBox(height: 30),

            // --- FRIENDS SECTION ---
            const Text("My Friends", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            StreamBuilder<List<Usermodel>>(
              stream: controller.myFriends,
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text("No friends added yet.", style: TextStyle(color: Colors.grey));
                }
                return SizedBox(
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final friend = snapshot.data![index];
                      return Padding(
                        padding: const EdgeInsets.only(right: 15),
                        child: GestureDetector(
                          onTap: () => Get.to(() => FriendDetailScreen(friend: friend)),
                          child: Column(
                            children: [
                              CircleAvatar(radius: 30, backgroundImage: friend.profilepicture.isNotEmpty ? NetworkImage(friend.profilepicture) : null, child: friend.profilepicture.isEmpty ? const Icon(Icons.person) : null),
                              const SizedBox(height: 5),
                              Text(friend.firstname, style: const TextStyle(color: Colors.white, fontSize: 12)),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),

            const SizedBox(height: 30),

            // --- GROUPS SECTION ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Groups", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                TextButton(onPressed: () { 
                  Get.to(()=>CreateGroupScreen());

                }, child: const Text("Create Group", style: TextStyle(color: AppColors.primaryTeal))),
              ],
            ),
            const SizedBox(height: 15),
            // Placeholder for Groups - We will build this next!
          
            // Inside SocialHubScreen Column:

// 1. --- GROUP INVITES (New Section) ---
StreamBuilder<List<GroupModel>>(
  stream: controller.groupInvites,
  builder: (context, snapshot) {
    if (!snapshot.hasData || snapshot.data!.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Group Invites", style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold)),
        ...snapshot.data!.map((group) => ListTile(
          title: Text(group.groupName, style: const TextStyle(color: Colors.white)),
          subtitle: const Text("You were invited", style: TextStyle(color: Colors.grey)),
          trailing: IconButton(
            icon: const Icon(Icons.check_circle, color: AppColors.primaryTeal),
            onPressed: () => controller.acceptGroup(group.id),
          ),
        )),
        const Divider(color: Colors.white10),
      ],
    );
  },
),

// 2. --- ACTIVE GROUPS SECTION ---
const Text("Active Groups", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
const SizedBox(height: 15),
StreamBuilder<List<GroupModel>>(
  stream: controller.myGroups,
  builder: (context, snapshot) {
    if (!snapshot.hasData || snapshot.data!.isEmpty) {
      return _buildEmptyState(Icons.group_work_outlined, "No active groups.");
    }
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: snapshot.data!.length,
      itemBuilder: (context, index) {
        final group = snapshot.data![index];
        final isCreator = group.creatorId == controller.currentUserId;

        return GestureDetector(
          onTap: () {
            Get.to(() => GroupDetailScreen(groupId: group.id));
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(color: AppColors.surfaceColor, borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading: const CircleAvatar(backgroundColor: AppColors.primaryTeal, child: Icon(Icons.group, color: Colors.white)),
              title: Text(group.groupName, style: const TextStyle(color: Colors.white)),
              subtitle: Text("${group.members.length} members", style: const TextStyle(color: Colors.grey)),
              trailing: isCreator ? PopupMenuButton(
                icon: const Icon(Icons.more_vert, color: Colors.white),
                itemBuilder: (context) => [
                  const PopupMenuItem(value: 'edit', child: Text("Edit Name")),
                  const PopupMenuItem(value: 'delete', child: Text("Delete Group", style: TextStyle(color: Colors.red))),
                ],
                onSelected: (val) {
                  if (val == 'delete') GroupRepository.instance.deleteGroup(group.id);
                  if (val == 'edit') showEditDialog(context, group);
                },
              ) : null,
            ),
          ),
        );
      },
    );
  },
),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(IconData icon, String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(color: AppColors.surfaceColor, borderRadius: BorderRadius.circular(15)),
      child: Column(
        children: [
          Icon(icon, color: Colors.grey, size: 40),
          const SizedBox(height: 10),
          Text(text, textAlign: TextAlign.center, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}

// class FriendSearchScreen extends StatelessWidget {
//   const FriendSearchScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.put(FriendSearchController());

//     return Scaffold(
//       backgroundColor: AppColors.bgColor,
//       appBar: AppBar(
//         title: const Text("Find Friends", style: TextStyle(color: Colors.white)),
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         iconTheme: const IconThemeData(color: Colors.white),
//         actions: [ 
//           TextButton(onPressed: (){ 
//             Get.to(()=>FriendRequestsScreen());
//           }, child: Text("See Friend Requests", style: TextStyle(color: Colors.white)),)
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(24.0),
//         child: Column(
//           children: [
//             // Search Input Row
//             Row(
//               children: [
//                 Expanded(
//                   child: buildCustomTextField(
//                     controller: controller.searchController,
//                     label: "Search by Email",
//                     icon: Icons.search,
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 GestureDetector(
//                   onTap: () => controller.searchUser(),
//                   child: Container(
//                     height: 55,
//                     width: 55,
//                     decoration: BoxDecoration(
//                       color: AppColors.primaryTeal,
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: const Icon(Icons.arrow_forward_ios, color: Colors.white),
//                   ),
//                 )
//               ],
//             ),
//             const SizedBox(height: 30),


//             // Search Results Section
//             Obx(() {
//               if (controller.isLoading.value) {
//                 return const Center(child: CircularProgressIndicator(color: AppColors.primaryTeal));
//               }

//               if (controller.rxUser.value == null) {
//                 return const Column(
//                   children: [
//                     Icon(Icons.person_search, size: 80, color: AppColors.surfaceColor),
//                     SizedBox(height: 16),
//                     Text("Search for friends to start splitting!", style: TextStyle(color: Colors.grey)),
//                   ],
//                 );
//               }

//               final user = controller.rxUser.value!;
//               return Container(
//                 padding: const EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   color: AppColors.surfaceColor,
//                   borderRadius: BorderRadius.circular(16),
//                   border: Border.all(color: AppColors.primaryTeal.withOpacity(0.3)),
//                 ),
//                 child: Row(
//                   children: [
//                     CircleAvatar(
//                       radius: 30,
//                       backgroundImage: user.profilepicture.isNotEmpty ? NetworkImage(user.profilepicture) : null,
//                       child: user.profilepicture.isEmpty ? const Icon(Icons.person) : null,
//                     ),
//                     const SizedBox(width: 16),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text("${user.firstname} ${user.lastname}", 
//                             style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
//                           Text("@${user.username}", style: const TextStyle(color: Colors.grey)),
//                         ],
//                       ),
//                     ),
//                     IconButton(
//                       onPressed: () => controller.processSendRequest(),
//                       icon: const Icon(Icons.person_add_alt_1, color: AppColors.primaryTeal, size: 28),
//                     )
//                   ],
//                 ),
//               );
//             }),
//           ],
//         ),
//       ),
//     );
//   }
// }