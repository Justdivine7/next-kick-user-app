import 'package:flutter/material.dart';
import 'package:next_kick/common/colors/app_colors.dart';
import 'package:next_kick/utilities/extensions/app_extensions.dart';

class FixtureCard extends StatelessWidget {
  final String teamA;
  final String teamB;
  final String date;
  final String time; // backend format: "07:59:50.67400"
  final String venue;

  const FixtureCard({
    super.key,
    required this.teamA,
    required this.teamB,
    required this.date,
    required this.time,
    required this.venue,
  });

  @override
  Widget build(BuildContext context) {
    // Parse the backend time string safely
    final dateTime = _parseBackendTime(time);

    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.lightBackgroundGradient,
            AppColors.lightBackgroundColor.withOpacity(0.6),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            spreadRadius: 2,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          /// DATE
          Text(
            date,
            style: context.textTheme.titleMedium?.copyWith(
              color: AppColors.boldTextColor,
              fontWeight: FontWeight.w600,
            ),
          ),

          SizedBox(height: 10),

          /// TEAMS
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _teamBlock(teamA, AppColors.boldTextColor),
              Text(
                "VS",
                style: context.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.boldTextColor,
                  fontSize: 18,
                ),
              ),
              _teamBlock(teamB, AppColors.boldTextColor),
            ],
          ),

          SizedBox(height: 20),

          /// VENUE + TIME
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.location_on, color: AppColors.appBGColor, size: 18),
              SizedBox(width: 5),
              Flexible(
                child: Text(
                  venue,
                  softWrap: true,
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: AppColors.boldTextColor,
                  ),
                ),
              ),
              SizedBox(width: 12),
              Icon(Icons.access_time, color: AppColors.appBGColor, size: 18),
              SizedBox(width: 5),
              Text(
                dateTime.formattedTime,
                style: context.textTheme.bodyMedium?.copyWith(
                  color: AppColors.boldTextColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _teamBlock(String name, Color color) {
    return Column(
      children: [
        SizedBox(height: 6),
        Text(
          name.toUpperCase(),
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14,
            color: color,
          ),
        ),
      ],
    );
  }

  /// Helper to parse backend time string like "07:59:50.67400"
  DateTime _parseBackendTime(String time) {
    try {
      final parts = time.split(':');
      final hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);
      final second = int.parse(parts[2].split('.')[0]); // ignore milliseconds
      return DateTime(0, 1, 1, hour, minute, second);
    } catch (_) {
      // fallback in case parsing fails
      return DateTime(0, 1, 1, 0, 0, 0);
    }
  }
}
