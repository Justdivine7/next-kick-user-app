// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:next_kick/common/colors/app_colors.dart';
// import 'package:next_kick/common/widgets/app_back_button.dart';
// import 'package:next_kick/common/widgets/next_kick_light_background.dart';
// import 'package:next_kick/features/player/tournaments/player_fixtures_view.dart';
// import 'package:next_kick/features/player/tournaments/player_standings_view.dart';
// import 'package:next_kick/features/home/widgets/player_standings_box.dart';
// import 'package:next_kick/features/home/widgets/player_tournament_box.dart';
// import 'package:next_kick/utilities/constants/app_image_strings.dart';
// import 'package:next_kick/utilities/constants/app_text_strings.dart';
// import 'package:next_kick/utilities/extensions/app_extensions.dart';

// class PlayerTournamentView extends StatefulWidget {
//   static const routeName = '/tournament';
//   const PlayerTournamentView({super.key});

//   @override
//   State<PlayerTournamentView> createState() => _PlayerTournamentViewState();
// }

// class _PlayerTournamentViewState extends State<PlayerTournamentView> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: AppColors.lightBackgroundColor,
//         // forceMaterialTransparency: true,
//         elevation: 0,
//         leadingWidth: 80.w,
//         toolbarHeight: 40.h,
//         leading: AppBackButton(),
//       ),
//       body: NextKickLightBackground(
//         image: AppImageStrings.lightSphere,
//         alignment: Alignment.center,
//         child: Column(
//           children: [
//             SizedBox(height: 30.h),
//             Text(
//               AppTextStrings.tournament,
//               style: context.textTheme.displayLarge?.copyWith(
//                 fontSize: 36,
//                 color: AppColors.boldTextColor,
//                 shadows: [
//                   Shadow(
//                     color: Colors.black.withOpacity(0.2),
//                     offset: Offset(0, 6),
//                     blurRadius: 3,
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(height: 30.h),

//             SingleChildScrollView(
//               scrollDirection: Axis.horizontal,
//               child: Row(
//                 children: [
//                   SizedBox(width: 20.w),

//                   // GestureDetector(
//                   //   onTap:
//                   //       () => Navigator.pushNamed(
//                   //         context,
//                   //         PlayerFixturesView.routeName,
//                   //       ),
//                   //   child: PlayerTournamentBox(),
//                   ),
//                   SizedBox(width: 20.w),
//                   GestureDetector(
//                     onTap:
//                         () => Navigator.pushNamed(
//                           context,
//                           PlayerStandingsView.routeName,
//                         ),
//                     child: PlayerStandingsBox(),
//                   ),
//                   SizedBox(width: 20.w),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
