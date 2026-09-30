import 'package:get/get.dart';
import 'package:ecom_user_flutter/app/models/ecom/baki/baki_models.dart';
import 'package:ecom_user_flutter/app/repositories/baki_repository.dart';
import 'package:ecom_user_flutter/app/services/auth_service.dart';

class BakiController extends GetxController {
  final BakiRepository _repository = BakiRepository();
  final int shopId;

  BakiController({required this.shopId});

  final Rx<BakiLedgerData?> bakiData = Rx<BakiLedgerData?>(null);
  final RxList<BakiLedgerHistory> ledgerHistory = <BakiLedgerHistory>[].obs;
  final RxBool isLoading = false.obs;
  
  int _currentPage = 1;
  bool _hasMoreData = true;
  
  @override
  void onInit() {
    super.onInit();
    fetchBakiLedger(isRefresh: true);
  }

  Future<void> fetchBakiLedger({bool isRefresh = false}) async {
    final authService = Get.find<AuthService>();
    final user = authService.currentUser.value.data?.user;
    if (user == null || user.id == null) return;
    
    if (isRefresh) {
      _currentPage = 1;
      _hasMoreData = true;
      ledgerHistory.clear();
      isLoading.value = true;
    } else {
      if (!_hasMoreData || isLoading.value) return;
    }

    try {
      final res = await _repository.getCustomerBakiLedger(shopId, user.id!, _currentPage);
      if (res != null && (res['status'] == 'success' || res['success'] == true)) {
        final parsed = BakiLedgerResponse.fromJson(res);
        if (parsed.data != null) {
          bakiData.value = parsed.data;
          if (parsed.data!.ledgerHistory.isEmpty) {
            _hasMoreData = false;
          } else {
            ledgerHistory.addAll(parsed.data!.ledgerHistory);
            _currentPage++;
          }
        }
      } else {
        _hasMoreData = false;
      }
    } catch (e) {
      print('Error fetching baki ledger: $e');
      _hasMoreData = false;
    } finally {
      isLoading.value = false;
    }
  }
}
