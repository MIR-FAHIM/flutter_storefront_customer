import 'package:get/get.dart';
import 'package:ecom_user_flutter/app/models/ecom/gamification/gamification_models.dart';
import 'package:ecom_user_flutter/app/repositories/gamification_repository.dart';
import 'package:ecom_user_flutter/app/services/store_context_service.dart';
import 'package:ecom_user_flutter/app/services/auth_service.dart';
import 'package:flutter/material.dart';

class GamificationController extends GetxController {
  final GamificationRepository _repository = GamificationRepository();
  final StoreContextService _storeService = Get.find<StoreContextService>();

  // State for active store challenge
  final Rx<ChallengeModel?> activeChallenge = Rx<ChallengeModel?>(null);
  final Rx<ChallengeParticipantModel?> activeParticipant =
      Rx<ChallengeParticipantModel?>(null);
  final Rx<RewardRaceProgressModel?> activeRewardRace =
      Rx<RewardRaceProgressModel?>(null);
  final RxBool isLoadingChallenge = false.obs;
  final RxBool isLoadingStoreRelation = false.obs;
  final RxBool isStoreRelationResolved = false.obs;
  final RxBool isJoining = false.obs;

  // State for My Challenges dashboard
  final RxList<MyChallengeItem> myChallenges = <MyChallengeItem>[].obs;
  final RxBool isLoadingMyChallenges = false.obs;
  final RxBool isClaimingReward = false.obs;
  late final Worker _storeSlugWorker;
  late final Worker _storeIdWorker;
  int _challengeRequestToken = 0;
  int _relationRequestToken = 0;

  bool get hasJoinedActiveChallenge => isStoreRelationResolved.value
      ? activeRewardRace.value != null
      : activeParticipant.value != null;

  int get activeCurrentPoints =>
      activeRewardRace.value?.currentPoints ??
      activeParticipant.value?.currentPoints ??
      0;

  int get activeTargetPoints =>
      activeRewardRace.value?.targetPoints ??
      activeChallenge.value?.targetPoints ??
      0;

  double get activeProgress {
    final relationProgress = activeRewardRace.value?.progressPercentage;
    if (relationProgress != null) {
      return (relationProgress / 100).clamp(0.0, 1.0);
    }

    final target = activeTargetPoints;
    return target <= 0 ? 0 : (activeCurrentPoints / target).clamp(0.0, 1.0);
  }

  @override
  void onInit() {
    super.onInit();
    // Listen to active store changes
    _storeSlugWorker = ever<String>(_storeService.activeStoreSlug, (slug) {
      if (slug.isNotEmpty) {
        activeChallenge.value = null;
        activeParticipant.value = null;
        fetchStoreChallenge(slug);
      } else {
        _challengeRequestToken++;
        activeChallenge.value = null;
        activeParticipant.value = null;
      }
    });
    _storeIdWorker = ever<int?>(_storeService.activeStoreId, (storeId) {
      activeRewardRace.value = null;
      isStoreRelationResolved.value = false;
      fetchStoreRelation(storeId);
    });

    if (_storeService.activeStoreSlug.value.isNotEmpty) {
      fetchStoreChallenge(_storeService.activeStoreSlug.value);
    }
    fetchStoreRelation(_storeService.activeStoreId.value);
  }

  @override
  void onClose() {
    _storeSlugWorker.dispose();
    _storeIdWorker.dispose();
    super.onClose();
  }

  Future<void> fetchStoreChallenge(String slug) async {
    final cleanSlug = slug.trim();
    if (cleanSlug.isEmpty) {
      _challengeRequestToken++;
      activeChallenge.value = null;
      activeParticipant.value = null;
      return;
    }

    final requestToken = ++_challengeRequestToken;
    try {
      isLoadingChallenge.value = true;
      final res = await _repository.getShopChallenge(cleanSlug);

      if (requestToken != _challengeRequestToken) return;

      if (res is Map) {
        final parsed = ChallengeResponse.fromJson(
          Map<String, dynamic>.from(res),
        );
        if (parsed.success) {
          activeChallenge.value = parsed.data;
          activeParticipant.value = parsed.participant;
        } else {
          activeChallenge.value = null;
          activeParticipant.value = null;
        }
      } else {
        activeChallenge.value = null;
        activeParticipant.value = null;
      }
    } catch (_) {
      if (requestToken == _challengeRequestToken) {
        activeChallenge.value = null;
        activeParticipant.value = null;
      }
    } finally {
      if (requestToken == _challengeRequestToken) {
        isLoadingChallenge.value = false;
      }
    }
  }

  Future<void> fetchStoreRelation(int? storeId) async {
    final requestToken = ++_relationRequestToken;
    final authService = Get.find<AuthService>();
    if (storeId == null || authService.currentUser.value.data == null) {
      activeRewardRace.value = null;
      isStoreRelationResolved.value = true;
      isLoadingStoreRelation.value = false;
      return;
    }

    try {
      isLoadingStoreRelation.value = true;
      final res = await _repository.getCustomerStoreRelation(storeId);

      if (requestToken != _relationRequestToken) return;

      if (res is Map) {
        final parsed = StoreRelationResponse.fromJson(
          Map<String, dynamic>.from(res),
        );
        activeRewardRace.value = parsed.success ? parsed.rewardRace : null;
        isStoreRelationResolved.value = parsed.success;
      } else {
        activeRewardRace.value = null;
        isStoreRelationResolved.value = false;
      }
    } catch (_) {
      if (requestToken == _relationRequestToken) {
        activeRewardRace.value = null;
        isStoreRelationResolved.value = false;
      }
    } finally {
      if (requestToken == _relationRequestToken) {
        isLoadingStoreRelation.value = false;
      }
    }
  }

  Future<void> refreshActiveStoreChallenge() async {
    await Future.wait([
      fetchStoreChallenge(_storeService.activeStoreSlug.value),
      fetchStoreRelation(_storeService.activeStoreId.value),
    ]);
  }

  Future<void> joinChallenge() async {
    if (activeChallenge.value == null) return;

    // Check if user is logged in
    final authService = Get.find<AuthService>();
    if (authService.currentUser.value.data == null) {
      Get.snackbar('Login Required', 'Please login to join the challenge.');
      return;
    }

    try {
      isJoining.value = true;
      final userId = authService.currentUser.value.data!.user!.id!;
      final res =
          await _repository.joinChallenge(activeChallenge.value!.id, userId);

      if (res != null &&
          (res['success'] == true ||
              res['status'] == 'success' ||
              res['status'] == true)) {
        Get.snackbar('Success', 'Successfully joined the challenge!',
            backgroundColor: Colors.green, colorText: Colors.white);
        await refreshActiveStoreChallenge();
      } else {
        Get.snackbar('Error', res?['message'] ?? 'Failed to join challenge',
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (_) {
      Get.snackbar('Error', 'An error occurred while joining the challenge',
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isJoining.value = false;
    }
  }

  Future<void> fetchMyChallenges() async {
    final authService = Get.find<AuthService>();
    if (authService.currentUser.value.data == null) return;

    final userId = authService.currentUser.value.data!.user!.id!;

    try {
      isLoadingMyChallenges.value = true;
      final res = await _repository.getMyChallenges(userId);

      if (res is Map) {
        final parsed = MyChallengesResponse.fromJson(
          Map<String, dynamic>.from(res),
        );
        if (parsed.success) {
          myChallenges.assignAll(parsed.data);
        }
      }
    } catch (_) {
    } finally {
      isLoadingMyChallenges.value = false;
    }
  }

  Future<bool> claimReward(int claimId) async {
    try {
      isClaimingReward.value = true;
      final res = await _repository.claimReward(claimId);

      if (res != null &&
          (res['success'] == true ||
              res['status'] == 'success' ||
              res['status'] == true)) {
        Get.snackbar('Success', 'Reward claimed successfully!',
            backgroundColor: Colors.green, colorText: Colors.white);
        await fetchMyChallenges();
        return true;
      } else {
        Get.snackbar('Error', res?['message'] ?? 'Failed to claim reward',
            backgroundColor: Colors.red, colorText: Colors.white);
        return false;
      }
    } catch (_) {
      Get.snackbar('Error', 'An error occurred while claiming reward',
          backgroundColor: Colors.red, colorText: Colors.white);
      return false;
    } finally {
      isClaimingReward.value = false;
    }
  }
}
