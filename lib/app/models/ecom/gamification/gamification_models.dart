class ChallengeResponse {
  final bool success;
  final String? message;
  final ChallengeModel? data;
  final ChallengeParticipantModel? participant;

  const ChallengeResponse({
    required this.success,
    this.message,
    this.data,
    this.participant,
  });

  factory ChallengeResponse.fromJson(Map<String, dynamic> json) {
    final payload = _asMap(json['data']);
    final challengeJson = _asMap(payload?['challenge']) ?? payload;
    final participantJson =
        _asMap(json['participant']) ?? _asMap(payload?['participant']);

    return ChallengeResponse(
      success: json['status'] == 'success' || json['success'] == true,
      message: _asString(json['message']),
      data:
          challengeJson == null ? null : ChallengeModel.fromJson(challengeJson),
      participant: participantJson == null
          ? null
          : ChallengeParticipantModel.fromJson(participantJson),
    );
  }
}

class StoreRelationResponse {
  final bool success;
  final String? message;
  final RewardRaceProgressModel? rewardRace;

  const StoreRelationResponse({
    required this.success,
    this.message,
    this.rewardRace,
  });

  factory StoreRelationResponse.fromJson(Map<String, dynamic> json) {
    final data = _asMap(json['data']);
    final rewardRaceJson = _asMap(data?['reward_race']);

    return StoreRelationResponse(
      success: json['status'] == 'success' || json['success'] == true,
      message: _asString(json['message']),
      rewardRace: rewardRaceJson == null
          ? null
          : RewardRaceProgressModel.fromJson(rewardRaceJson),
    );
  }
}

class RewardRaceProgressModel {
  final int challengeId;
  final String title;
  final int currentPoints;
  final int targetPoints;
  final int remainingPoints;
  final double progressPercentage;

  const RewardRaceProgressModel({
    required this.challengeId,
    required this.title,
    required this.currentPoints,
    required this.targetPoints,
    required this.remainingPoints,
    required this.progressPercentage,
  });

  factory RewardRaceProgressModel.fromJson(Map<String, dynamic> json) {
    final current = _asInt(json['current_points']) ?? 0;
    final target = _asInt(json['target_points']) ?? 0;
    final calculatedRemaining = target > current ? target - current : 0;
    final calculatedProgress = target <= 0 ? 0.0 : (current / target) * 100;

    return RewardRaceProgressModel(
      challengeId: _asInt(json['challenge_id']) ?? 0,
      title: _asString(json['title']) ?? '',
      currentPoints: current,
      targetPoints: target,
      remainingPoints: _asInt(json['remaining_points']) ?? calculatedRemaining,
      progressPercentage:
          _asDouble(json['progress_percentage']) ?? calculatedProgress,
    );
  }
}

class ChallengeModel {
  final int id;
  final int shopId;
  final String title;
  final String description;
  final int targetPoints;
  final EarningRules? earningRules;
  final DateTime? startDate;
  final DateTime? endDate;
  final String status;
  final String? bannerUrl;
  final List<RewardClaimModel> rewards;

  const ChallengeModel({
    required this.id,
    required this.shopId,
    required this.title,
    required this.description,
    required this.targetPoints,
    this.earningRules,
    this.startDate,
    this.endDate,
    required this.status,
    this.bannerUrl,
    required this.rewards,
  });

  factory ChallengeModel.fromJson(Map<String, dynamic> json) {
    final parsedRewards = _modelList(
      json['rewards'],
      RewardClaimModel.fromJson,
    );
    final earningRulesJson = _asMap(json['earning_rules']);

    final target = _asInt(json['target_points']) ??
        (parsedRewards.isNotEmpty
            ? parsedRewards
                .map((reward) => reward.pointsRequired)
                .reduce((a, b) => a > b ? a : b)
            : 0);

    return ChallengeModel(
      id: _asInt(json['id']) ?? 0,
      shopId: _asInt(json['shop_id']) ?? 0,
      title: _asString(json['title']) ?? '',
      description: _asString(json['description']) ?? '',
      targetPoints: target,
      earningRules: earningRulesJson != null
          ? EarningRules.fromJson(earningRulesJson)
          : (json['spend_amount'] != null && json['points_awarded'] != null)
              ? EarningRules(
                  spendAmount: _asDouble(json['spend_amount']) ?? 0.0,
                  pointsAwarded: _asInt(json['points_awarded']) ?? 0,
                )
              : null,
      startDate: _asDate(json['start_date']),
      endDate: _asDate(json['end_date']),
      status: _asBool(json['is_active'])
          ? 'active'
          : (_asString(json['status']) ?? ''),
      bannerUrl: _asString(json['banner_url']),
      rewards: parsedRewards,
    );
  }
}

class EarningRules {
  final double spendAmount;
  final int pointsAwarded;

  const EarningRules({
    required this.spendAmount,
    required this.pointsAwarded,
  });

  factory EarningRules.fromJson(Map<String, dynamic> json) {
    return EarningRules(
      spendAmount: _asDouble(json['spend_amount']) ?? 0.0,
      pointsAwarded: _asInt(json['points_awarded']) ?? 0,
    );
  }
}

class ChallengeParticipantModel {
  final int id;
  final int challengeId;
  final int userId;
  final int currentPoints;
  final String status; // e.g., 'joined', 'completed'

  const ChallengeParticipantModel({
    required this.id,
    required this.challengeId,
    required this.userId,
    required this.currentPoints,
    required this.status,
  });

  factory ChallengeParticipantModel.fromJson(Map<String, dynamic> json) {
    return ChallengeParticipantModel(
      id: _asInt(json['id']) ?? 0,
      challengeId: _asInt(json['challenge_id']) ?? 0,
      userId: _asInt(json['user_id']) ?? 0,
      currentPoints: _asInt(json['current_points']) ?? 0,
      status: _asString(json['status']) ?? 'joined',
    );
  }
}

class MyChallengesResponse {
  final bool success;
  final List<MyChallengeItem> data;

  const MyChallengesResponse({
    required this.success,
    required this.data,
  });

  factory MyChallengesResponse.fromJson(Map<String, dynamic> json) {
    final payload = json['data'];
    final rawItems =
        payload is Map ? payload['data'] ?? payload['challenges'] : payload;
    return MyChallengesResponse(
      success: json['status'] == 'success' || json['success'] == true,
      data: _modelList(rawItems, MyChallengeItem.fromJson),
    );
  }
}

class MyChallengeItem {
  final int challengeId;
  final String shopName;
  final String shopSlug;
  final String title;
  final int currentPoints;
  final int targetPoints;
  final int remainingPoints;
  final double progressPercentage;
  final String status;
  final List<RewardClaimModel> rewards;

  const MyChallengeItem({
    required this.challengeId,
    required this.shopName,
    required this.shopSlug,
    required this.title,
    required this.currentPoints,
    required this.targetPoints,
    required this.remainingPoints,
    required this.progressPercentage,
    required this.status,
    required this.rewards,
  });

  factory MyChallengeItem.fromJson(Map<String, dynamic> json) {
    return MyChallengeItem(
      challengeId: _asInt(json['challenge_id']) ?? 0,
      shopName: _asString(json['shop_name']) ?? '',
      shopSlug: _asString(json['shop_slug']) ?? '',
      title: _asString(json['title']) ?? '',
      currentPoints: _asInt(json['current_points']) ?? 0,
      targetPoints: _asInt(json['target_points']) ?? 0,
      remainingPoints: _asInt(json['remaining_points']) ?? 0,
      progressPercentage: _asDouble(json['progress_percentage']) ?? 0.0,
      status: _asString(json['status']) ?? 'active',
      rewards: _modelList(json['rewards'], RewardClaimModel.fromJson),
    );
  }
}

class RewardClaimModel {
  final int id;
  final String title;
  final int pointsRequired;
  final String status; // 'locked', 'unlocked', 'claimed'
  final int? claimId;

  const RewardClaimModel({
    required this.id,
    required this.title,
    required this.pointsRequired,
    required this.status,
    this.claimId,
  });

  factory RewardClaimModel.fromJson(Map<String, dynamic> json) {
    return RewardClaimModel(
      id: _asInt(json['id']) ?? 0,
      title: _asString(json['name'] ?? json['title']) ?? '',
      pointsRequired: _asInt(json['points_required']) ?? 0,
      status: _asString(json['status']) ?? 'locked',
      claimId: _asInt(json['claim_id']),
    );
  }
}

int? _asInt(dynamic v) {
  if (v == null) return null;
  if (v is int) return v;
  if (v is num) return v.toInt();
  return int.tryParse(v.toString()) ?? double.tryParse(v.toString())?.toInt();
}

double? _asDouble(dynamic v) {
  if (v == null) return null;
  if (v is double) return v;
  if (v is int) return v.toDouble();
  if (v is String) return double.tryParse(v);
  return null;
}

DateTime? _asDate(dynamic v) {
  if (v == null) return null;
  if (v is DateTime) return v;
  if (v is String) return DateTime.tryParse(v);
  return null;
}

Map<String, dynamic>? _asMap(dynamic value) {
  return value is Map ? Map<String, dynamic>.from(value) : null;
}

String? _asString(dynamic value) {
  final text = value?.toString().trim();
  return text == null || text.isEmpty ? null : text;
}

bool _asBool(dynamic value) {
  if (value is bool) return value;
  if (value is num) return value != 0;
  final text = value?.toString().trim().toLowerCase();
  return text == 'true' || text == '1' || text == 'yes';
}

List<T> _modelList<T>(
  dynamic value,
  T Function(Map<String, dynamic>) parser,
) {
  if (value is! List) return const [];
  return value
      .map(_asMap)
      .whereType<Map<String, dynamic>>()
      .map(parser)
      .toList();
}
