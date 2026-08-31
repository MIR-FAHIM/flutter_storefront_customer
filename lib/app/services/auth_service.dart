import 'package:ecom_user_flutter/app/models/ecom/auth/customer_model.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';



class AuthService extends GetxService {
  final currentUser = UserLoginResModel().obs;
  late GetStorage _box;
  final used = false.obs;
  final alreadyLogged = false.obs;

  AuthService() {
    _box = GetStorage();
  }

  @override
  void onInit() async {
    // TODO: implement onInit
    _box = GetStorage();
    getLogged();
    getUsed();
    getCurrentUser();
    super.onInit();
  }

  void setUser(UserLoginResModel customer) async {
    _box.write('current_user', customer.toJson());

    getCurrentUser();
  }

  void setFirstUseOrNot() async {
    _box.write('used', true);
    getUsed();
  }

  void setFirstLoggedOrNot() async {
    _box.write('alreadyLogged', true);
    getUsed();
  }

  getLogged() {
    if (_box.hasData('alreadyLogged')) {
      alreadyLogged.value = _box.read('alreadyLogged');
    }
  }


  Future getUsed() async {
    if (_box.hasData('used')) {
      used.value = await _box.read('used');
    }
  }

  Future getCurrentUser() async {
    if (_box.hasData('current_user')) {
      currentUser.value = UserLoginResModel.fromJson(await _box.read('current_user'));
    }

  }

  Future removeCurrentUser() async {
    currentUser.value = UserLoginResModel();
    await _box.remove('alreadyLogged');
    await _box.remove('current_user');
  }

  bool get isAuth => currentUser.value.data!.token == null ? false : true;
}
