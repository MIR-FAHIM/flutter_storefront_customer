import 'package:ecom_user_flutter/app/modules/review/controller/shop_reviews_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddReviewSheet extends StatefulWidget {
  const AddReviewSheet({required this.controller, super.key});

  final ShopReviewsController controller;

  @override
  State<AddReviewSheet> createState() => _AddReviewSheetState();
}

class _AddReviewSheetState extends State<AddReviewSheet> {
  final _commentController = TextEditingController();
  int _rating = 0;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final comment = _commentController.text.trim();
    if (_rating == 0) {
      Get.snackbar('Review', 'Please select a rating');
      return;
    }
    if (comment.isEmpty) {
      Get.snackbar('Review', 'Please write a comment');
      return;
    }

    final submitted = await widget.controller.submitReview(
      starCount: _rating,
      comment: comment,
    );
    if (!mounted) return;
    if (submitted) {
      Get.back();
      Get.snackbar('Review', 'Review added successfully');
    } else {
      Get.snackbar('Review', widget.controller.error.value);
    }
  }

  @override
  Widget build(BuildContext context) {
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final maxSheetHeight = keyboardHeight > 0
        ? MediaQuery.of(context).size.height * 0.62
        : MediaQuery.of(context).size.height * 0.88;

    return Material(
      color: Theme.of(context).scaffoldBackgroundColor,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      child: SafeArea(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: maxSheetHeight),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.fromLTRB(20, 18, 20, keyboardHeight + 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Add your review',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      IconButton(
                          onPressed: Get.back,
                          icon: const Icon(Icons.close)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text('Your rating'),
                  const SizedBox(height: 4),
                  Row(
                    children: List.generate(5, (index) {
                      final selected = index < _rating;
                      return IconButton(
                        tooltip: '${index + 1} star${index == 0 ? '' : 's'}',
                        onPressed: () => setState(() => _rating = index + 1),
                        icon: Icon(
                          selected
                              ? Icons.star_rounded
                              : Icons.star_border_rounded,
                          color: Colors.amber.shade700,
                          size: 34,
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _commentController,
                    minLines: 3,
                    maxLines: 5,
                    textInputAction: TextInputAction.newline,
                    scrollPadding: EdgeInsets.only(
                      bottom: keyboardHeight + 120,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Comment',
                      hintText: 'Tell others about your experience',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Obx(
                    () => SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: widget.controller.isSubmitting.value
                            ? null
                            : _submit,
                        icon: widget.controller.isSubmitting.value
                            ? const SizedBox(
                                height: 18,
                                width: 18,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Icon(Icons.send_rounded),
                        label: Text(
                          widget.controller.isSubmitting.value
                              ? 'Submitting...'
                              : 'Submit review',
                        ),
                      ),
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
