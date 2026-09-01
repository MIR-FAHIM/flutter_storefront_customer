import 'package:ecom_user_flutter/app/api_providers/company_data.dart';

class AppInfo {
  AppInfo._();

  static const String version = CompanyData.version;
  static const String versionLabel = 'Version $version';
}
