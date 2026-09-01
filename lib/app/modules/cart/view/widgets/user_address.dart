
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Import your controller + models
import 'package:ecom_user_flutter/app/modules/cart/controller/cart_controller.dart';

class UserAddress extends GetWidget<CartController> {
  const UserAddress({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final addresses = controller.userAddress.value;

      return Scaffold(
        backgroundColor: const Color(0xFFF5F7FB),
        appBar: AppBar(
          title: const Text(
            'My Addresses',
            style: TextStyle(fontWeight: FontWeight.w900),
          ),
          actions: [
            IconButton(
              onPressed: () {
                _showAddAddressSheet(context);
              },
              icon: const Icon(Icons.add_location_alt_outlined),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            _showAddAddressSheet(context);
          },
          icon: const Icon(Icons.add),
          label: const Text(
            'Add Address',
            style: TextStyle(fontWeight: FontWeight.w900),
          ),
        ),
        body: addresses.isEmpty
            ? _EmptyAddressState(
          onAddTap: () {
            _showAddAddressSheet(context);
          },
        )
            : ListView.separated(
          padding: const EdgeInsets.fromLTRB(14, 14, 14, 90),
          itemCount: addresses.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final adrs = addresses[index];

            return _AddressCard(
              address: adrs.address.toString(),
              district: adrs.district.toString(),
              mobile: adrs.mobile.toString(),
              onTapMenu: () {
                Get.bottomSheet(
                  _AddressActionSheet(addressId: adrs.id.toString(),),
                  backgroundColor: Colors.white,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(22),
                    ),
                  ),
                );
              },
            );
          },
        ),
      );
    });
  }

  void _showAddAddressSheet(BuildContext context) {
    Get.bottomSheet(
      const _AddAddressSheet(),
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
    );
  }
}

class _AddressCard extends StatelessWidget {
  const _AddressCard({
    required this.address,
    required this.mobile,
    required this.district,
    required this.onTapMenu,
  });

  final String address;
  final String mobile;
  final String district;
  final VoidCallback onTapMenu;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 12, 6, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.035),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFF00509D).withOpacity(0.10),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.location_on_outlined,
              color: Color(0xFF00509D),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  address.isEmpty ? 'No address details' : address,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                    height: 1.35,
                  ),
                ),

                Text(
                  mobile.isEmpty ? 'No mobile' : mobile,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                    height: 1.35,
                  ),
                ),

                Text(
                  district.isEmpty ? 'No district' : district,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                    height: 1.35,
                  ),
                ),


              ],
            ),
          ),
          IconButton(
            onPressed: onTapMenu,
            icon: const Icon(Icons.more_vert_rounded),
          ),
        ],
      ),
    );
  }
}

class _EmptyAddressState extends StatelessWidget {
  const _EmptyAddressState({
    required this.onAddTap,
  });

  final VoidCallback onAddTap;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 86,
              height: 86,
              decoration: BoxDecoration(
                color: const Color(0xFF00509D).withOpacity(0.08),
                borderRadius: BorderRadius.circular(28),
              ),
              child: const Icon(
                Icons.location_off_outlined,
                color: Color(0xFF00509D),
                size: 44,
              ),
            ),
            const SizedBox(height: 14),
            const Text(
              'Add your address first',
              style: TextStyle(
                fontWeight: FontWeight.w900,
                color: Colors.black87,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'You need to add a delivery address before placing an order.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.black54,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: onAddTap,
              icon: const Icon(Icons.add_location_alt_outlined),
              label: const Text(
                'Add Address',
                style: TextStyle(fontWeight: FontWeight.w900),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AddAddressSheet extends StatefulWidget {
  const _AddAddressSheet();

  @override
  State<_AddAddressSheet> createState() => _AddAddressSheetState();
}

class _AddAddressSheetState extends State<_AddAddressSheet> {
  final mobileController = TextEditingController();
  final districtController = TextEditingController();
  final areaController = TextEditingController();
  final addressController = TextEditingController();

  CartController get controller => Get.find<CartController>();

  @override
  void dispose() {
    mobileController.dispose();
    districtController.dispose();
    areaController.dispose();
    addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 42,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Add Delivery Address',
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      color: Colors.black87,
                      fontSize: 18,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Get.back(),
                  icon: const Icon(Icons.close_rounded),
                ),
              ],
            ),

            const SizedBox(height: 10),

            _AddressTextField(
              controller: mobileController,
              label: 'Mobile',
              hint: 'Enter mobile number',
              icon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
            ),

            const SizedBox(height: 10),

            _AddressTextField(
              controller: districtController,
              label: 'District',
              hint: 'Enter district',
              icon: Icons.location_city_outlined,
            ),

            const SizedBox(height: 10),

            _AddressTextField(
              controller: areaController,
              label: 'Area',
              hint: 'Enter area',
              icon: Icons.map_outlined,
            ),

            const SizedBox(height: 10),

            _AddressTextField(
              controller: addressController,
              label: 'Full Address',
              hint: 'House, road, block, landmark',
              icon: Icons.home_work_outlined,
              maxLines: 3,
            ),

            const SizedBox(height: 16),

            Obx(() {
              return SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: controller.isAddressAdding.value
                      ? null
                      : () => controller.addAddress(
                            mobile: mobileController.text,
                            district: districtController.text,
                            area: areaController.text,
                            address: addressController.text,
                          ),
                  icon: controller.isAddressAdding.value
                      ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                      : const Icon(Icons.save_outlined),
                  label: Text(
                    controller.isAddressAdding.value
                        ? 'Saving...'
                        : 'Save Address',
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 15,
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _AddressTextField extends StatelessWidget {
  const _AddressTextField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.keyboardType,
    this.maxLines = 1,
  });

  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final TextInputType? keyboardType;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: const Color(0xFFF8FAFC),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(14)),
          borderSide: BorderSide(
            color: Color(0xFF00509D),
            width: 1.3,
          ),
        ),
      ),
    );
  }
}

class _AddressActionSheet extends GetWidget<CartController> {
final String addressId ;
  const _AddressActionSheet ({
  required this.addressId
});
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit_outlined),
              title: const Text(
                'Edit Address',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
              onTap: () {
                Get.back();
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.delete_outline,
                color: Colors.red,
              ),
              title: const Text(
                'Delete Address',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  color: Colors.red,
                ),
              ),
              onTap: () {
              controller.deleteUserAddress(addressId);
              },
            ),
          ],
        ),
      ),
    );
  }
}
