import 'package:ecom_user_flutter/app/models/ecom/auth/customer_model.dart';
import 'package:ecom_user_flutter/app/repositories/auth_repositories.dart';
import 'package:ecom_user_flutter/app/routes/app_pages.dart';
import 'package:ecom_user_flutter/app/services/auth_service.dart';
import 'package:ecom_user_flutter/app/services/firebase_messaging_service%20copy.dart';
import 'package:ecom_user_flutter/app/services/location_service.dart';
import 'package:ecom_user_flutter/app/services/store_context_service.dart';
import 'package:ecom_user_flutter/common/ui.dart';
import 'package:ecom_user_flutter/service/shared_pref.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:device_info_plus/device_info_plus.dart';

import 'package:permission_handler/permission_handler.dart';

class LoginController extends GetxController {
  final imeiNumber = ''.obs;
  final phoneName = ''.obs;
  final phoneModel = ''.obs;
  final name = ''.obs;
  final email = ''.obs;
  final password = ''.obs;
  final role = 'customer'.obs; // default
  final mobile = ''.obs;
  final address = ''.obs;

  final deviceToken = ''.obs;
  final formKey = GlobalKey<FormState>();
  final hidePassword = true.obs;
  final isLoading = false.obs;
  final loginTime = DateTime.now().obs;
  bool isSupported = true;
  late GlobalKey<FormState> loginFormKey;
  @override
  void onInit() {
    mobile.value = Get.arguments ?? '';
    loginFormKey = GlobalKey<FormState>();
    imeiNumber.value = Get.find<LocationService>().imei.value;
    getDeviceToken();
    askingPhonePermission();
    super.onInit();
  }

  Future<String> askingPhonePermission() async {
    final PermissionStatus permissionStatus = await _getPhonePermission();
    return permissionStatus.name;
  }

  Future<PermissionStatus> _getPhonePermission() async {
    final PermissionStatus permission = await Permission.phone.status;

    print(
        "kaj ekhane hocche location service permissioon status  ${PermissionStatus.granted}");
    if (permission != PermissionStatus.granted &&
        permission == PermissionStatus.denied) {
      final Map<Permission, PermissionStatus> permissionStatus =
          await [Permission.phone].request();
      return permissionStatus[Permission.phone] ?? PermissionStatus.restricted;
    } else {
      final Map<Permission, PermissionStatus> permissionStatus =
          await [Permission.phone].request();
      print("device info is coming from login controller");
      getDeviceInfo();

      return permissionStatus[Permission.phone] ?? PermissionStatus.restricted;
    }
  }

  Future<void> getDeviceInfo() async {
    final deviceInfo = DeviceInfoPlugin();
    try {
      final androidInfo = await deviceInfo.androidInfo;
      print('Android ID: ${androidInfo.id}');
      print('Model: ${androidInfo.model}');

      phoneName.value = androidInfo.id; // unique per device+signing key
      phoneModel.value = androidInfo.model;
    } catch (e) {
      print('Failed to get device info: $e');
    }
  }

  // getSimNumber()async{
  //  bool isPermissionGranted = await MobileNumber.hasPhonePermission;
  //  if (isPermissionGranted) {
  //    final List<SimCard>? simCards = await MobileNumber.getSimCards;
  //    print("numbe are ${simCards!.first.number}");
  //    return simCards;
  //  } else {
  //    //Request Phone Permission
  //  }
  // }
  // void printSimCardsData() async {
  //   print("phone info is start");
  //   try {
  //
  //     final List<SimDataModel> simData = await _simData.getSimData();
  //     print("sim data info is ${simData.first.countryCode}");
  //     print("sim data info is ${simData.first.phoneNumber}");
  //   } on PlatformException catch (e) {
  //     debugPrint("error! code: ${e.code} - message: ${e.message}");
  //   }
  // }
  getDeviceToken() async {
    print("fcm is called");
    await FirebaseMessaging.instance.getToken().then((e) {
      deviceToken.value = e!;
      print("fcm is called 344 ${deviceToken.value}");
    });
  }

  bool _isValidEmail(String value) {
    return RegExp(
      r'^[\w\.-]+@([\w-]+\.)+[\w-]{2,}$',
    ).hasMatch(value);
  }

  bool _isValidPhone(String value) {
    return RegExp(r'^\d{11}$').hasMatch(value);
  }

  Future<void> loginWithEmailOrPhone({String? loginInput}) async {
    final input = (loginInput ?? mobile.value).trim();
    final pass = password.value.trim();

    if (input.isEmpty) {
      Get.showSnackbar(
        Ui.ErrorSnackBar(
          message: 'Please enter email or mobile number'.tr,
          title: 'Error'.tr,
        ),
      );
      return;
    }

    if (pass.isEmpty) {
      Get.showSnackbar(
        Ui.ErrorSnackBar(
          message: 'Please enter password'.tr,
          title: 'Error'.tr,
        ),
      );
      return;
    }

    final bool isPhone = _isValidPhone(input);
    final bool isEmail = _isValidEmail(input);

    if (!isPhone && !isEmail) {
      Get.showSnackbar(
        Ui.ErrorSnackBar(
          message: 'Enter a valid email or 11 digit mobile number'.tr,
          title: 'Error'.tr,
        ),
      );
      return;
    }

    final Map<String, dynamic> data = {
      if (isPhone) 'phone': input,
      if (isEmail) 'email': input,
      'password': pass,
      'fcm_token': deviceToken.value,
    };

    loginFormKey.currentState?.save();
    Get.find<AuthService>().setFirstLoggedOrNot();

    Ui.customLoaderDialog();

    try {
      print("Attempting login with ${isPhone ? 'phone' : 'email'}...");
      print("Login payload: $data");

      final resp = await AuthRepository().userLogin(data);
      print("Login response: $resp");

      if (resp['status'] == 'success') {
        try {
          UserLoginResModel model = UserLoginResModel.fromJson(resp);

          Get.find<AuthService>().setUser(model);
          Get.back();
          final redirect = Get.find<StoreContextService>().consumeLoginRedirect();
          if (redirect != null) {
            Get.offAllNamed(
              redirect['route'].toString(),
              arguments: redirect['arguments'],
            );
          } else {
            Get.offAllNamed(Routes.ROOT);
          }
        } catch (e) {
          Get.back();
          Get.showSnackbar(
            Ui.ErrorSnackBar(
              message: e.toString(),
              title: 'Parse Error'.tr,
            ),
          );
        }
      } else {
        Get.back();
        Get.showSnackbar(
          Ui.ErrorSnackBar(
            message: resp['message'] ?? 'Login failed',
            title: 'Error'.tr,
          ),
        );
      }
    } catch (e) {
      Get.back();
      Get.showSnackbar(
        Ui.ErrorSnackBar(
          message: e.toString(),
          title: 'Error'.tr,
        ),
      );
    }
  }

  void signUp() async {
    getDeviceToken();
    print("Device token (IMEI): ${imeiNumber.value}");

    Get.find<AuthService>().setFirstLoggedOrNot();
    print("Attempting signUp... ${deviceToken.value}");
    Ui.customLoaderDialog(); // Show loading dialog
    Map data = {
      'name': name.value,
      'email': email.value,
      'password': password.value,
      'role': 'customer',
      'mobile': mobile.value,
      'address': address.value,
      //'fcm_token' : ,
    };
    try {
      print("Attempting signUp... ${deviceToken.value}");
      final resp = await AuthRepository().signUp(data);
      print("signUp response: $resp");

      if (resp['status'] == 'success') {
        try {
          email.value = resp['data']['email'];
          //   password.value = resp['data']['password'];
          await loginWithEmailOrPhone(loginInput: email.value);
        } catch (e) {
          Get.back(); // Close loader
          Get.showSnackbar(
            Ui.ErrorSnackBar(message: e.toString(), title: 'Parse Error'.tr),
          );
        }
      } else {
        Get.back(); // Close loader
        Get.showSnackbar(
          Ui.ErrorSnackBar(
              message: resp['message'] ?? 'Login failed', title: 'Error'.tr),
        );
      }
    } catch (e) {
      Get.back(); // Close loader
      Get.showSnackbar(
        Ui.ErrorSnackBar(message: e.toString(), title: 'Error'.tr),
      );
    }
  }
}
