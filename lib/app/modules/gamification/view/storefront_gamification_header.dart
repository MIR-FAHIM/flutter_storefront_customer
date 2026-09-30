import 'package:ecom_user_flutter/app/modules/gamification/controller/gamification_controller.dart';
import 'package:ecom_user_flutter/app/routes/app_pages.dart';
import 'package:ecom_user_flutter/common/Color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StorefrontRewardAction extends GetView<GamificationController> {
  const StorefrontRewardAction({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final challenge = controller.activeChallenge.value;
      final rewardRace = controller.activeRewardRace.value;

      if ((controller.isLoadingChallenge.value &&
              challenge == null &&
              rewardRace == null) ||
          controller.isLoadingStoreRelation.value) {
        return SizedBox(
          width: 28,
          height: 28,
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: AppColors.primaryColor,
            ),
          ),
        );
      }

      if (challenge == null && rewardRace == null) {
        return const SizedBox.shrink();
      }

      if (!controller.isStoreRelationResolved.value &&
          controller.activeParticipant.value == null) {
        return const SizedBox.shrink();
      }

      if (!controller.hasJoinedActiveChallenge) {
        if (challenge == null) return const SizedBox.shrink();

        return Tooltip(
          message: challenge.title,
          child: SizedBox(
            height: 32,
            child: OutlinedButton.icon(
              onPressed:
                  controller.isJoining.value ? null : controller.joinChallenge,
              icon: controller.isJoining.value
                  ? const SizedBox(
                      width: 14,
                      height: 14,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.emoji_events_outlined, size: 16),
              label: const Text('Join Reward'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primaryColor,
                padding: const EdgeInsets.symmetric(horizontal: 9),
                minimumSize: const Size(0, 32),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                side: BorderSide(
                  color: AppColors.primaryColor.withValues(alpha: 0.28),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                textStyle: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        );
      }

      final target = controller.activeTargetPoints;
      final current = controller.activeCurrentPoints;
      final progress = controller.activeProgress;
      final title = rewardRace?.title ?? challenge?.title ?? 'Reward Race';

      return Tooltip(
        message: '$current/$target points - $title',
        child: Material(
          color: AppColors.primaryColor.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(6),
          child: InkWell(
            onTap: () => Get.toNamed(Routes.MY_REWARD_RACES),
            borderRadius: BorderRadius.circular(6),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          value: progress,
                          strokeWidth: 2.5,
                          backgroundColor:
                              AppColors.primaryColor.withValues(alpha: 0.14),
                          color: AppColors.golden,
                        ),
                      ),
                      Icon(
                        Icons.emoji_events_rounded,
                        size: 12,
                        color: AppColors.primaryColor,
                      ),
                    ],
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'See Reward Progress',
                    style: TextStyle(
                      color: AppColors.primaryColor,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
