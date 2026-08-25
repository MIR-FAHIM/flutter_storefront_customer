// lib/app/modules/home/views/profile_view.dart
import 'package:ecom_user_flutter/app/modules/home/controllers/home_controller.dart';
import 'package:ecom_user_flutter/app/routes/app_pages.dart';
import 'package:ecom_user_flutter/app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Change the import path if your HomeController is elsewhere


class ProfileView extends GetView<HomeController> {
  const ProfileView({super.key});

  static const Color _navy = Color(0xFF1F214C);
  static const Color _navy2 = Color(0xFF15173B);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Obx(() {
      if (controller.profileData.value.name == null) {
        return Center(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 18),
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.grey.shade200),
              boxShadow: [
                BoxShadow(
                  blurRadius: 18,
                  offset: const Offset(0, 10),
                  color: Colors.black.withOpacity(0.06),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF4F5FA),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Icon(
                    Icons.person_off_outlined,
                    color: Colors.grey.shade700,
                    size: 30,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  "Profile not available",
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 6),
                Text(
                  "Please login again to continue.",
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.black54,
                    fontWeight: FontWeight.w600,
                    height: 1.3,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 14),

                // Primary action (Login again)
                SizedBox(
                  height: 44,
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1F214C),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      Get.offAllNamed(Routes.LOGIN);
                    },
                    child: const Text(
                      "Go to Login",
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 10),
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

                SizedBox(
                  height: 44,
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF588D26),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      Get.offAllNamed(Routes.SIGNUP);
                    },
                    child: const Text(
                      "Register",
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
            SizedBox(
              height: 10,),

                // Secondary action (Logout/clear session)
                SizedBox(
                  height: 44,
                  width: double.infinity,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.grey.shade300),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      foregroundColor: Colors.black87,
                    ),
                    onPressed: () async {
                      // safer: clear user then reset navigation
                      Get.find<AuthService>().removeCurrentUser();
                      Get.offAllNamed(Routes.SPLASHSCREEN);
                    },
                    child: Text(
                      "Logout",
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w900,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      } else {
        return Scaffold(
          backgroundColor: const Color(0xFFF6F7FB),
          body: Stack(
            children: [
              // Header background
              Container(
                height: 260,
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [_navy, _navy2],
                  ),
                ),
              ),

              SafeArea(
                child: Column(
                  children: [
                    // Top bar
                    Padding(
                      padding: const EdgeInsets.fromLTRB(14, 8, 14, 8),
                      child: Row(
                        children: [
                          const Spacer(),
                          InkWell(
                            borderRadius: BorderRadius.circular(999),
                            onTap: () => Get.back(),
                            child: Container(
                              width: 38,
                              height: 38,
                              alignment: Alignment.center,
                              child: const Icon(Icons.close,
                                  color: Colors.white, size: 22),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Header content
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
                      child: Row(
                        children: [
                          // Avatar
                          Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(28),
                              border: Border.all(
                                  color: Colors.white.withOpacity(0.25)),
                            ),
                            child: const Icon(Icons.image_outlined,
                                color: Colors.white70, size: 26),
                          ),
                          const SizedBox(width: 12),

                          // Name and email
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  controller.profileData.value.name!,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                controller.profileData.value.email == null ? Container():
                                Text(
                                  controller.profileData.value.email!,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: Colors.white.withOpacity(0.75),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Logout button
                          OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(
                                  color: Colors.white.withOpacity(0.45)),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 10),
                              foregroundColor: Colors.white,
                            ),
                            onPressed: () {
                              Get.find<AuthService>().removeCurrentUser();
                              Get.toNamed(Routes.SPLASHSCREEN);
                            },
                            child: Text(
                              "Logout",
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    Expanded(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(14, 8, 14, 16),
                        child: Column(
                          children: [
                            // Quick actions card (grid)
                            _CardShell(
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 14, 10, 10),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: InkWell(
                                            onTap: () {
                                              Get.toNamed(Routes.ORDER_HISTORY);
                                            },
                                            child: _QuickAction(
                                              icon: Icons.receipt_long_outlined,
                                              label: "Orders",
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: _QuickAction(
                                            icon: Icons.favorite_border,
                                            label: "My Wishlist",
                                          ),
                                        ),
                                        Expanded(
                                          child: _QuickAction(
                                            icon: Icons.request_quote_outlined,
                                            label: "Refund Requests",
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      children: const [
                                        Expanded(
                                          child: _QuickAction(
                                            icon: Icons.chat_bubble_outline,
                                            label: "Messages",
                                          ),
                                        ),
                                        Expanded(
                                          child: _QuickAction(
                                            icon: Icons.groups_outlined,
                                            label: "Classified products",
                                          ),
                                        ),
                                        Expanded(
                                          child: _QuickAction(
                                            icon: Icons.cloud_download_outlined,
                                            label: "Downloads",
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      children: const [
                                        Expanded(
                                          child: _QuickAction(
                                            icon: Icons.cloud_upload_outlined,
                                            label: "Upload file",
                                          ),
                                        ),
                                        Expanded(child: SizedBox()),
                                        Expanded(child: SizedBox()),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            const SizedBox(height: 14),

                            // Menu list card
                            _CardShell(
                              child: Column(
                                children: const [
                                  _MenuRow(
                                      icon: Icons.inventory_2_outlined,
                                      title: "Top Selling Products"),
                                  _DividerLine(),
                                  _MenuRow(
                                      icon: Icons.cloud_download_outlined,
                                      title: "All Digital Products"),
                                  _DividerLine(),
                                  _MenuRow(
                                      icon: Icons.discount_outlined,
                                      title: "Coupons"),
                                  _DividerLine(),
                                  _MenuRow(
                                      icon: Icons.groups_outlined,
                                      title: "Classified Ads"),
                                  _DividerLine(),
                                  _MenuRow(
                                      icon: Icons.storefront_outlined,
                                      title: "Browse All Sellers"),
                                  _DividerLine(),
                                  _MenuRow(
                                      icon: Icons.store_mall_directory_outlined,
                                      title: "Followed Sellers"),
                                  _DividerLine(),
                                  _MenuRow(
                                    icon: Icons.delete_outline,
                                    title: "Delete my account",
                                    danger: true,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }
    });
  }
}

class _CardShell extends StatelessWidget {
  const _CardShell({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            blurRadius: 18,
            offset: const Offset(0, 10),
            color: Colors.black.withOpacity(0.05),
          )
        ],
      ),
      child: child,
    );
  }
}

class _QuickAction extends StatelessWidget {
  const _QuickAction({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
      child: Column(
        children: [
          Icon(icon, size: 26, color: Colors.black87),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuRow extends StatelessWidget {
  const _MenuRow(
      {required this.icon, required this.title, this.danger = false});

  final IconData icon;
  final String title;
  final bool danger;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = danger ? Colors.redAccent : Colors.black87;

    return InkWell(
      onTap: () {
        // UI only
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
        child: Row(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.grey.shade400),
          ],
        ),
      ),
    );
  }
}

class _DividerLine extends StatelessWidget {
  const _DividerLine();

  @override
  Widget build(BuildContext context) {
    return Divider(height: 1, thickness: 1, color: Color(0xFFEDEFF5));
  }
}
