// lib/app/modules/auth/views/login_view.dart
import 'dart:ui';
import 'package:ecom_user_flutter/app/app_info.dart';
import 'package:ecom_user_flutter/app/api_providers/company_data.dart';
import 'package:ecom_user_flutter/app/modules/global_widgets/block_button_widget.dart';
import 'package:ecom_user_flutter/app/modules/global_widgets/text_field_widget.dart';
import 'package:ecom_user_flutter/app/routes/app_pages.dart';
import 'package:ecom_user_flutter/common/Color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  static const Color _navy = Color(0xFF1F214C);
  static const Color _accent = Color(0xFF16A34A); // green accent

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      resizeToAvoidBottomInset: true,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Stack(
          children: [
            // Background
            _LoginBackground(height: size.height),

            // Foreground content
            SafeArea(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 18, 16, 22),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: size.height - 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 10),
                      _Header(
                        appName: CompanyData.appname,
                        subtitle: "Welcome back. Please login to continue.".tr,
                      ),
                      const SizedBox(height: 18),

                      Obx(() {
                        return _LoginCard(
                          loginFormKey: controller.loginFormKey,
                          hidePassword: controller.hidePassword.value,
                          initialMobileOrEmail: controller.mobile.value,
                          onMobileOrEmailChanged: (v) {
                            controller.mobile.value = v;
                            GetStorage().write('mobile_number', v);
                          },
                          onPasswordChanged: (v) => controller.password.value = v,
                          onTogglePassword: () => controller.hidePassword.value = !controller.hidePassword.value,
                          onLogin: controller.loginWithEmailOrPhone,
                          isLoading: controller.isLoading.value,
                        );
                      }),

                      const SizedBox(height: 14),

                      // Optional footer actions
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "New here?".tr,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.green,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(width: 6),
                          TextButton(
                            onPressed: () => Get.toNamed(Routes.SIGNUP),
                            child: Text(
                              "Create Account".tr,
                              style: const TextStyle(fontWeight: FontWeight.w900, color: Colors.green),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 6),
                      Text(
                        "By continuing, you agree to our Terms & Privacy Policy.".tr,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        AppInfo.versionLabel,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.white.withOpacity(0.78),
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LoginBackground extends StatelessWidget {
  const _LoginBackground({required this.height});

  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: Stack(
        children: [
          // Base gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF0F172A),
                  Color(0xFF1F214C),
                  Color(0xFF0B1220),
                ],
              ),
            ),
          ),

          // Soft blobs
          Positioned(
            top: -80,
            left: -60,
            child: _BlurBlob(
              color: const Color(0xFF16A34A).withOpacity(0.28),
              size: 220,
            ),
          ),
          Positioned(
            bottom: 60,
            right: -70,
            child: _BlurBlob(
              color: const Color(0xFFF4B73E).withOpacity(0.22),
              size: 240,
            ),
          ),

          // Glass overlay tint
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.18),
            ),
          ),
        ],
      ),
    );
  }
}

class _BlurBlob extends StatelessWidget {
  const _BlurBlob({required this.color, required this.size});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return ImageFiltered(
      imageFilter: ImageFilter.blur(sigmaX: 26, sigmaY: 26),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.appName, required this.subtitle});

  final String appName;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Logo placeholder (you can swap with Image.asset)
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.12),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.14)),
          ),
          child: const Icon(Icons.shopping_bag_outlined, color: Colors.white, size: 28),
        ),
        const SizedBox(height: 14),
        Text(
          "Login".tr,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w900,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          "Login to $appName",
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w800,
            color: Colors.white.withOpacity(0.92),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          subtitle,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: Colors.white.withOpacity(0.80),
            height: 1.25,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _LoginCard extends StatelessWidget {
  const _LoginCard({
    required this.loginFormKey,
    required this.hidePassword,
    required this.initialMobileOrEmail,
    required this.onMobileOrEmailChanged,
    required this.onPasswordChanged,
    required this.onTogglePassword,
    required this.onLogin,
    required this.isLoading,
  });

  final GlobalKey<FormState> loginFormKey;
  final bool hidePassword;
  final String initialMobileOrEmail;
  final ValueChanged<String> onMobileOrEmailChanged;
  final ValueChanged<String> onPasswordChanged;
  final VoidCallback onTogglePassword;
  final VoidCallback onLogin;
  final bool isLoading;

  static const Color _brand = Color(0xFF1F214C);
  static const Color _accent = Color(0xFF16A34A);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.92),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.65)),
            boxShadow: [
              BoxShadow(
                blurRadius: 26,
                offset: const Offset(0, 16),
                color: Colors.black.withOpacity(0.22),
              ),
            ],
          ),
          child: Form(
            key: loginFormKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: _accent,
                        borderRadius: BorderRadius.circular(99),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      "Sign in".tr,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w900,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                TextFieldWidget(
                  labelText: "Email or mobile".tr,
                  hintText: "Email/Mobile".tr,
                  keyboardType: TextInputType.text,
                  readOnly: false,
                  initialValue: initialMobileOrEmail,
                  onChanged: onMobileOrEmailChanged,
                  imageData: 'assets/icons/number_pad.png',
                ),

                const SizedBox(height: 10),

                TextFieldWidget(
                  labelText: "Password".tr,
                  hintText: "••••••".tr,
                  keyboardType: TextInputType.text,
                  obscureText: hidePassword,
                  onChanged: onPasswordChanged,
                  limit: 40,
                  counterText: "",
                  validator: (input) {
                    final v = (input ?? '').trim();
                    if (v.isEmpty) return "Password is required".tr;
                    if (v.length < 4) return "Password is too short".tr;
                    return null;
                  },
                  iconData: CupertinoIcons.lock,
                  suffixIcon: IconButton(
                    onPressed: onTogglePassword,
                    icon: Icon(
                      hidePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                      color: hidePassword ? Colors.grey : _brand,
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => Get.toNamed(Routes.FORGET_PASSWORD),
                    child: Text(
                      "Forgot password?".tr,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: _brand,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                // Smart loading button behavior
                IgnorePointer(
                  ignoring: isLoading,
                  child: Opacity(
                    opacity: isLoading ? 0.75 : 1,
                    child: BlockButtonWidget(
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        final ok = loginFormKey.currentState?.validate() ?? false;
                        if (!ok) return;
                        onLogin();
                      },
                      color: _accent,
                      text: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (isLoading) ...[
                            const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                            ),
                            const SizedBox(width: 10),
                          ],
                          Text(
                            isLoading ? "Please wait...".tr : "Login".tr,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                    ).paddingSymmetric(horizontal: 4),
                  ),
                ),

                const SizedBox(height: 14),

                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7F7FB),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.lock_outline, size: 18, color: Colors.black54),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          "Your data is encrypted and secured.".tr,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.black54,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
