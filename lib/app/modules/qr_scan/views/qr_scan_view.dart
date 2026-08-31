import 'package:ecom_user_flutter/common/Color.dart';
import 'package:ecom_user_flutter/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import '../controllers/qr_scan_controller.dart';

class QrScanView extends GetView<QrScanController> {
  const QrScanView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<QrScanController>();

    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.primaryColor,
          title: const Text(
            'Scan Store QR Code',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Get.back();
            },
          ),
          elevation: 0,
        ),
        body: FutureBuilder<PermissionStatus>(
          future: Permission.camera.request(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(height: 20),
                    Text(
                      'Requesting camera access...',
                      style: TextStyle(
                        color: AppColors.homeTextColor1,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              );
            }

            if (!snapshot.hasData ||
                snapshot.data != PermissionStatus.granted) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.camera_alt_outlined,
                      size: 80,
                      color: AppColors.primaryColor,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Camera Permission Required',
                      style: TextStyle(
                        color: AppColors.homeTextColor1,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Please grant camera permission to scan QR codes',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.homeTextColor2,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        openAppSettings();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 12,
                        ),
                      ),
                      child: const Text(
                        'Open Settings',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }

            return Stack(
              children: [
                // Camera scanner
                MobileScanner(
                  controller: controller.mobileScannerController,
                  onDetect: (capture) {
                    if (controller.isLoading.value) return;
                    final List<Barcode> barcodes = capture.barcodes;
                    for (final barcode in barcodes) {
                      if (barcode.rawValue != null &&
                          barcode.rawValue!.isNotEmpty) {
                        controller.mobileScannerController.stop();
                        controller.processQrCode(barcode.rawValue!).whenComplete(() {
                          if (context.mounted &&
                              Get.currentRoute == Routes.QR_SCAN) {
                            controller.restartScanner();
                          }
                        });
                        break;
                      }
                    }
                  },
                  errorBuilder: (context, error, child) {
                    return Container(
                      color: Colors.black,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.no_photography_outlined,
                            color: Colors.white,
                            size: 56,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Camera could not start',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            error.toString(),
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.white70),
                          ),
                          const SizedBox(height: 20),
                          Wrap(
                            spacing: 10,
                            alignment: WrapAlignment.center,
                            children: [
                              ElevatedButton.icon(
                                onPressed: controller.restartScanner,
                                icon: const Icon(Icons.refresh_rounded),
                                label: const Text('Retry'),
                              ),
                              OutlinedButton.icon(
                                onPressed: openAppSettings,
                                icon: const Icon(Icons.settings_outlined),
                                label: const Text('Settings'),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
                Obx(() {
                  if (!controller.isLoading.value) {
                    return const SizedBox.shrink();
                  }
                  return Container(
                    color: Colors.black54,
                    alignment: Alignment.center,
                    child: const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(color: Colors.white),
                        SizedBox(height: 14),
                        Text(
                          'Loading store...',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
                // Overlay with scanning frame
                Center(
                  child: Container(
                    width: 250,
                    height: 250,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: AppColors.primaryColor,
                        width: 3,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Stack(
                      children: [
                        // Corner decorations
                        Positioned(
                          top: 0,
                          left: 0,
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              border: Border(
                                top: BorderSide(
                                  color: AppColors.primaryColor,
                                  width: 4,
                                ),
                                left: BorderSide(
                                  color: AppColors.primaryColor,
                                  width: 4,
                                ),
                              ),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(8),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              border: Border(
                                top: BorderSide(
                                  color: AppColors.primaryColor,
                                  width: 4,
                                ),
                                right: BorderSide(
                                  color: AppColors.primaryColor,
                                  width: 4,
                                ),
                              ),
                              borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(8),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: AppColors.primaryColor,
                                  width: 4,
                                ),
                                left: BorderSide(
                                  color: AppColors.primaryColor,
                                  width: 4,
                                ),
                              ),
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(8),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: AppColors.primaryColor,
                                  width: 4,
                                ),
                                right: BorderSide(
                                  color: AppColors.primaryColor,
                                  width: 4,
                                ),
                              ),
                              borderRadius: const BorderRadius.only(
                                bottomRight: Radius.circular(8),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Dark overlay outside the frame
                Positioned.fill(
                  child: IgnorePointer(
                    child: CustomPaint(
                      painter: ScannerOverlayPainter(
                        frameSize: const Size(250, 250),
                        primaryColor: AppColors.primaryColor,
                      ),
                    ),
                  ),
                ),
                // Loading and error overlay
                Obx(
                  () => controller.isLoading.value
                      ? Container(
                          color: Colors.black.withOpacity(0.6),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                const Text(
                                  'Loading store...',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
                // Error message at bottom
                Obx(
                  () => controller.errorMessage.value.isNotEmpty
                      ? Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            color: Colors.red.withOpacity(0.9),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Error: ${controller.errorMessage.value}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 12),
                                ElevatedButton(
                                  onPressed: () => controller.clearError(),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                  ),
                                  child: Text(
                                    'Dismiss',
                                    style: TextStyle(
                                      color: AppColors.primaryColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
                // Instruction text at top
                Positioned(
                  top: 60,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Text(
                      'Position QR code in the frame',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.5),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class ScannerOverlayPainter extends CustomPainter {
  final Size frameSize;
  final Color primaryColor;

  ScannerOverlayPainter({
    required this.frameSize,
    required this.primaryColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withOpacity(0.4)
      ..style = PaintingStyle.fill;

    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final frameWidth = frameSize.width;
    final frameHeight = frameSize.height;

    final Path path = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: Offset(centerX, centerY),
            width: frameWidth,
            height: frameHeight,
          ),
          const Radius.circular(12),
        ),
      )
      ..fillType = PathFillType.evenOdd;

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(ScannerOverlayPainter oldDelegate) => false;
}
