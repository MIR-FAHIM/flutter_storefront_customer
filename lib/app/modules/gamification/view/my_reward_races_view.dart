import 'package:ecom_user_flutter/app/models/ecom/gamification/gamification_models.dart';
import 'package:ecom_user_flutter/app/modules/gamification/controller/gamification_controller.dart';
import 'package:ecom_user_flutter/common/Color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:confetti/confetti.dart';

class MyRewardRacesView extends StatefulWidget {
  const MyRewardRacesView({super.key});

  @override
  State<MyRewardRacesView> createState() => _MyRewardRacesViewState();
}

class _MyRewardRacesViewState extends State<MyRewardRacesView> {
  final GamificationController controller = Get.find<GamificationController>();
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 2));
    controller.fetchMyChallenges();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void _handleClaim(int claimId) async {
    final success = await controller.claimReward(claimId);
    if (success) {
      _confettiController.play();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: const Text(
          'My Reward Races',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Obx(() {
            if (controller.isLoadingMyChallenges.value) {
              return const Center(child: CircularProgressIndicator());
            }

            if (controller.myChallenges.isEmpty) {
              return Center(
                child: Text(
                  'No active reward races found.\nStart shopping to join races!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.homeTextColor2,
                    fontSize: 16,
                  ),
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: controller.fetchMyChallenges,
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: controller.myChallenges.length,
                separatorBuilder: (context, index) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  return _ChallengeCard(
                    item: controller.myChallenges[index],
                    onClaim: _handleClaim,
                    isClaiming: controller.isClaimingReward.value,
                  );
                },
              ),
            );
          }),
          
          // Confetti overlay
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              colors: const [
                Colors.green,
                Colors.blue,
                Colors.pink,
                Colors.orange,
                Colors.purple
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ChallengeCard extends StatelessWidget {
  final MyChallengeItem item;
  final Function(int) onClaim;
  final bool isClaiming;

  const _ChallengeCard({
    required this.item,
    required this.onClaim,
    required this.isClaiming,
  });

  @override
  Widget build(BuildContext context) {
    final target = item.targetPoints;
    final current = item.currentPoints;
    final percent = target > 0 ? (current / target).clamp(0.0, 1.0) : 0.0;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withValues(alpha: 0.05),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Row(
              children: [
                Icon(Icons.flag, color: AppColors.primaryColor),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "${item.shopName} - ${item.title}",
                    style: TextStyle(
                      color: AppColors.homeTextColor1,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.golden.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    "$current / $target pts",
                    style: TextStyle(
                      color: AppColors.golden,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Progress bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LinearPercentIndicator(
                  padding: EdgeInsets.zero,
                  lineHeight: 10.0,
                  percent: percent,
                  backgroundColor: Colors.grey.shade200,
                  progressColor: AppColors.primaryColor,
                  barRadius: const Radius.circular(5),
                ),
                const SizedBox(height: 16),
                const Text(
                  "Rewards Timeline",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 12),
                
                // Rewards List
                ...item.rewards.map((reward) => _buildRewardItem(reward)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRewardItem(RewardClaimModel reward) {
    IconData icon;
    Color color;
    
    switch (reward.status) {
      case 'claimed':
        icon = Icons.check_circle;
        color = Colors.green;
        break;
      case 'unlocked':
        icon = Icons.lock_open;
        color = AppColors.golden;
        break;
      default: // locked
        icon = Icons.lock_outline;
        color = Colors.grey;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  reward.title,
                  style: TextStyle(
                    color: reward.status == 'locked' ? Colors.grey : AppColors.homeTextColor1,
                    fontWeight: reward.status == 'unlocked' ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                Text(
                  "${reward.pointsRequired} pts required",
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          if (reward.status == 'unlocked')
            ElevatedButton(
              onPressed: isClaiming ? null : () => onClaim(reward.claimId ?? reward.id),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.golden,
                foregroundColor: Colors.black87,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                minimumSize: const Size(0, 32),
              ),
              child: const Text("Claim", style: TextStyle(fontSize: 12)),
            ),
        ],
      ),
    );
  }
}
