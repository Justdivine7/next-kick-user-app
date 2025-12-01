import 'package:flutter/material.dart';
import 'package:next_kick/common/colors/app_colors.dart';
import 'package:next_kick/common/widgets/app_button.dart';
import 'package:next_kick/data/models/tournament_model.dart';
import 'package:next_kick/features/team/tournament/view/team_tournament_terms_and_condition.dart';
import 'package:next_kick/utilities/constants/app_text_strings.dart';
import 'package:next_kick/utilities/extensions/app_extensions.dart';

class TournamentNameAndLocationRegistrationWidget extends StatelessWidget {
  final TournamentModel tournament;

  const TournamentNameAndLocationRegistrationWidget({
    super.key,
    required this.tournament,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.whiteColor,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Tournament info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tournament.title?.capitalizeFirstLetter() ?? '',
                    style: context.textTheme.titleMedium?.copyWith(
                      color: AppColors.boldTextColor,

                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        color: AppColors.subTextcolor,
                        size: 18,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          tournament.location?.capitalizeFirstLetter() ?? '',
                          style: context.textTheme.bodyMedium?.copyWith(
                            color: AppColors.subTextcolor,
                            fontSize: 14,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(width: 16),

            // Register button
            Expanded(
              child: SizedBox(
                height: 40,
                child: AppButton(
                  label: AppTextStrings.register,
                  backgroundColor: AppColors.boldTextColor,
                  textColor: AppColors.whiteColor,
                  onButtonPressed: () {
                    Navigator.pushNamed(
                      context,
                      TeamTournamentTermsAndCondition.routeName,
                      arguments: tournament
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
