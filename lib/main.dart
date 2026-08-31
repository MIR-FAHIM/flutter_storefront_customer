import 'package:ecom_user_flutter/common/Color.dart';
import 'package:overlay_support/overlay_support.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ecom_user_flutter/app/modules/settings/controllers/language_controller.dart';
import 'package:ecom_user_flutter/app/modules/settings/controllers/settings_controller.dart';
import 'package:ecom_user_flutter/app/services/auth_service.dart';
import 'package:ecom_user_flutter/app/services/firebase_messaging_service.dart';
import 'package:ecom_user_flutter/app/services/location_service.dart';
import 'package:ecom_user_flutter/app/services/settings_service.dart';
import 'package:ecom_user_flutter/app/services/store_context_service.dart';
import 'package:ecom_user_flutter/app/services/translation_service.dart';
import 'package:ecom_user_flutter/service/shared_pref.dart';
import 'app/routes/app_pages.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

String type = '';

Future<void> backgroundHander(RemoteMessage message) async {
  if (message.data.isNotEmpty) {
    type = message.data['notification_type'] != '' &&
        message.data['notification_type'] != null
        ? message.data['notification_type'].toString()
        : message.data['notification_sub_type'].toString();
    print('backgroundHander 4:${message.data['notification_type']}');
  }
}

///remove
const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    // 'This channel is used for important notifications.', // description
    importance: Importance.high,
    playSound: true);
//
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

///remove

initServices() async {

  Get.log('starting services ...');
  await GetStorage.init();

  await Firebase.initializeApp();
  await Permission.notification.status.then((value) {
    //ios  Permission.accessNotificationPolicy;
    if (value.isGranted) {
      print("hlw fahim 111 _______________________ notification request ");
    } else {
      print("hlw fahim 222_______________________ notification request ");

      Permission.notification.request();
    }
  });
  // await initPusher();
  // await Permission.notification.status.then((value) {
  //   //ios  Permission.accessNotificationPolicy;
  //   if (value.isGranted) {
  //     print("hlw fahim 111 _______________________ notification request ");
  //   } else {
  //     print("hlw fahim 222_______________________ notification request ");
  //
  //     Permission.notification.request();
  //   }
  // });

  ///remove
  // await flutterLocalNotificationsPlugin
  //     .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
  //     ?.createNotificationChannel(channel);

  ///remove
  ///
  await Get.putAsync<SettingsService>(() async => SettingsService());
  await Get.putAsync<SettingsController>(() async => SettingsController());
  await Get.putAsync<LanguageController>(() async => LanguageController());
  await Get.putAsync<AuthService>(() async => AuthService());
  await Get.putAsync<StoreContextService>(() async => StoreContextService());
  await Get.putAsync(() => TranslationService().init());

  await Get.putAsync<LocationService>(() async => LocationService());
  FirebaseMessaging.onBackgroundMessage(backgroundHander);
  await Get.putAsync(() => FireBaseMessagingService().init());

  // NotificationLocal.initialize(flutterLocalNotificationsPlugin);

  Get.log('All services started...');
}

void main() async {
  HttpOverrides.global = new MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreff.to.initial();
  await initServices();
  runApp(
    OverlaySupport(
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        defaultTransition: Transition.cupertino,
        transitionDuration: const Duration(milliseconds: 800),
        title: "PSWork",
        theme: ThemeData(
          useMaterial3: false,
          fontFamily: 'Roboto',
          scaffoldBackgroundColor: AppColors.scaffoldBackground,
          primaryColor: AppColors.primaryColor,

          colorScheme: ColorScheme.light(
            primary: AppColors.primaryColor,
            secondary: AppColors.offerYellow,
            surface: AppColors.cardBackground,
            background: AppColors.scaffoldBackground,
            error: AppColors.errorColor,
          ),

          appBarTheme: AppBarTheme(
            elevation: 0,
            centerTitle: false,
            backgroundColor: AppColors.primaryColor,
            foregroundColor: AppColors.textWhite,
            titleTextStyle: TextStyle(
              color: AppColors.textWhite,
              fontSize: 20,
              fontWeight: FontWeight.w900,
            ),
            iconTheme: IconThemeData(
              color: AppColors.textWhite,
            ),
          ),

          bottomNavigationBarTheme: BottomNavigationBarThemeData(
            backgroundColor: AppColors.backgroundColor,
            selectedItemColor: AppColors.primaryColor,
            unselectedItemColor: AppColors.textMuted,
            selectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 12,
            ),
            unselectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 11,
            ),
            type: BottomNavigationBarType.fixed,
            elevation: 8,
          ),



          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: AppColors.backgroundColor,
            hintStyle: TextStyle(
              color: AppColors.textMuted,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
            labelStyle: TextStyle(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w700,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(
                color: AppColors.borderColor,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(
                color: AppColors.borderColor,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(
                color: AppColors.primaryColor,
                width: 1.4,
              ),
            ),
          ),

          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              foregroundColor: AppColors.textWhite,
              elevation: 0,
              textStyle: const TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 14,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 13,
              ),
            ),
          ),

          outlinedButtonTheme: OutlinedButtonThemeData(
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primaryColor,
              side: BorderSide(
                color: AppColors.primaryColor.withOpacity(0.35),
              ),
              textStyle: const TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 14,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),

          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primaryColor,
              textStyle: const TextStyle(
                fontWeight: FontWeight.w900,
              ),
            ),
          ),

          textTheme: TextTheme(
            titleLarge: TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w900,
              fontSize: 22,
            ),
            titleMedium: TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w900,
              fontSize: 18,
            ),
            titleSmall: TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w800,
              fontSize: 15,
            ),
            bodyLarge: TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w700,
              fontSize: 15,
            ),
            bodyMedium: TextStyle(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
            bodySmall: TextStyle(
              color: AppColors.textMuted,
              fontWeight: FontWeight.w600,
              fontSize: 11,
            ),
          ),

          dataTableTheme: DataTableThemeData(
            headingRowColor: MaterialStateProperty.all(
              AppColors.primaryColor,
            ),
            headingTextStyle: TextStyle(
              color: AppColors.textWhite,
              fontWeight: FontWeight.w900,
            ),
            dataRowColor: MaterialStateProperty.all(
              AppColors.tableRowColor,
            ),
            dataTextStyle: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
            dividerThickness: 0.8,
          ),
        ),
        initialRoute: AppPages.INITIAL,
        getPages: AppPages.routes,
        localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: Get.find<TranslationService>().supportedLocales(),
        translationsKeys: Get.find<TranslationService>().translations,
        locale: Get.find<SettingsService>().getLocale(),
        fallbackLocale: Get.find<TranslationService>().fallbackLocale,
      ),
    ),
  );
}

///    <uses-permission android:name="android.permission.CALL_PHONE" />
///     <uses-permission android:name="android.permission.READ_PHONE_NUMBERS" />
