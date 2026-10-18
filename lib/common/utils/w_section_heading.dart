
// import 'package:barber_shop/common/constant/app_textstyle.dart';
// import 'package:flutter/material.dart';
// import 'package:get/instance_manager.dart';
// import 'package:get/route_manager.dart';


// class wheadingtitle extends StatelessWidget {
//   wheadingtitle({
//     super.key,
//     required this.title,
//     this.ontap,
//     this.showall = false,
//     this.titlecolor,
//     this.showtext = 'showall',
//     this.showtextstyle,
//     this.titlestyle,
//   });
//   final String title;
//   final bool? showall;
//   final Color? titlecolor;
//   final String? showtext;
//   final VoidCallback? ontap;
//   final TextStyle? showtextstyle;
//   final TextStyle? titlestyle;

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Text(title, style: titlestyle ?? AppTextStyles.mediumblack),
//         if (showall == true)
//           TextButton(
//             onPressed:
//                 ontap ??
//                 () {
//                   // Get.to(() => Allproductsscreen());
//                 },
//             child: Text(showtext!, style: showtextstyle),
//           ),
//       ],
//     );
//   }
// }
