import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ecom_user_flutter/app/modules/baki/controller/baki_controller.dart';
import 'package:ecom_user_flutter/common/Color.dart';
import 'package:intl/intl.dart';

class BakiLedgerView extends GetView<BakiController> {
  const BakiLedgerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: const Text('Store Ledger (Baki)', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.ledgerHistory.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        final bakiData = controller.bakiData.value;
        final totalBaki = bakiData?.totalBaki ?? 0;

        return Column(
          children: [
            // Top Summary Card
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),
              child: Column(
                children: [
                  const Text(
                    'Total Due Amount',
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '৳$totalBaki',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            
            // Transactions List
            Expanded(
              child: controller.ledgerHistory.isEmpty
                  ? Center(
                      child: Text(
                        'No ledger history found.',
                        style: TextStyle(color: AppColors.homeTextColor2),
                      ),
                    )
                  : NotificationListener<ScrollNotification>(
                      onNotification: (ScrollNotification scrollInfo) {
                        if (!controller.isLoading.value &&
                            scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
                          controller.fetchBakiLedger();
                        }
                        return true;
                      },
                      child: ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount: controller.ledgerHistory.length + (controller.isLoading.value ? 1 : 0),
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          if (index == controller.ledgerHistory.length) {
                            return const Center(child: CircularProgressIndicator());
                          }
                          
                          final item = controller.ledgerHistory[index];
                          final isPayment = item.type == 'PAYMENT';
                          
                          // Format date
                          String dateStr = item.createdAt ?? '';
                          if (dateStr.isNotEmpty) {
                            try {
                              final dt = DateTime.parse(dateStr);
                              dateStr = DateFormat('MMM dd, yyyy - hh:mm a').format(dt);
                            } catch (_) {}
                          }

                          return Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey.shade200),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: isPayment ? Colors.green.shade50 : Colors.red.shade50,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    isPayment ? Icons.arrow_downward : Icons.arrow_upward,
                                    color: isPayment ? Colors.green : Colors.red,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        isPayment ? 'Payment' : 'Due Added',
                                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                      ),
                                      if (item.note != null && item.note!.isNotEmpty) ...[
                                        const SizedBox(height: 4),
                                        Text(
                                          item.note!,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(fontSize: 12, color: Colors.black54),
                                        ),
                                      ],
                                      const SizedBox(height: 4),
                                      Text(
                                        dateStr,
                                        style: const TextStyle(fontSize: 12, color: Colors.black38),
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      isPayment ? '+৳${item.paidAmount}' : '-৳${item.dueAmount}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: isPayment ? Colors.green : Colors.red,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Bal: ৳${item.runningBalance}',
                                      style: const TextStyle(fontSize: 12, color: Colors.black54),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
            ),
          ],
        );
      }),
    );
  }
}
