import 'package:ecom_user_flutter/app/modules/gamification/controller/gamification_controller.dart';
import 'package:ecom_user_flutter/common/Color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CartGamificationNudge extends GetWidget<GamificationController> {
  final double cartTotal;
  const CartGamificationNudge({super.key, required this.cartTotal});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final challenge = controller.activeChallenge.value;

      if (challenge == null ||
          !controller.hasJoinedActiveChallenge ||
          challenge.earningRules == null) {
        return const SizedBox.shrink();
      }

      final rules = challenge.earningRules!;
      if (rules.spendAmount <= 0) return const SizedBox.shrink();

      // Calculate how much more needed to reach next multiple
      final remainder = cartTotal % rules.spendAmount;
      final amountNeeded = rules.spendAmount - remainder;

      if (cartTotal == 0) return const SizedBox.shrink();

      return Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.golden.withValues(alpha: 0.15),
          border: Border.all(
            color: AppColors.golden.withValues(alpha: 0.5),
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(Icons.stars_rounded, color: AppColors.golden, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                amountNeeded > 0
                    ? "Add ৳${amountNeeded.toStringAsFixed(0)} more to earn an extra ${rules.pointsAwarded} points!"
                    : "You're earning points for this order!",
                style: TextStyle(
                  color: AppColors.homeTextColor1,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
