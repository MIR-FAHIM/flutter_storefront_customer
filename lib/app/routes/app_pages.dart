import 'package:ecom_user_flutter/app/modules/auth/login/bindings/login_binding.dart';
import 'package:ecom_user_flutter/app/modules/auth/login/views/login_view.dart';
import 'package:ecom_user_flutter/app/modules/auth/login/views/register_view.dart';
import 'package:ecom_user_flutter/app/modules/cart/binding/cart_binding.dart';
import 'package:ecom_user_flutter/app/modules/cart/view/cart_view.dart';
import 'package:ecom_user_flutter/app/modules/cart/view/proceed_order.dart';
import 'package:ecom_user_flutter/app/modules/cart/view/widgets/success_page.dart';
import 'package:ecom_user_flutter/app/modules/cart/view/widgets/user_address.dart';
import 'package:ecom_user_flutter/app/modules/category/binding/category_binding.dart';
import 'package:ecom_user_flutter/app/modules/category/view/all_category_view.dart';
import 'package:ecom_user_flutter/app/modules/customer_chat/bindings/customer_chat_binding.dart';
import 'package:ecom_user_flutter/app/modules/customer_chat/views/customer_chat_thread_view.dart';
import 'package:ecom_user_flutter/app/modules/customer_chat/views/customer_conversation_list_view.dart';
import 'package:ecom_user_flutter/app/modules/delivery/binding/delivery_binding.dart';
import 'package:ecom_user_flutter/app/modules/delivery/view/assigned_delivery_view.dart';
import 'package:ecom_user_flutter/app/modules/delivery/view/completed_delivery_view.dart';
import 'package:ecom_user_flutter/app/modules/delivery/view/deliveredOrder.dart';
import 'package:ecom_user_flutter/app/modules/delivery/view/my_delivery_tab.dart';

import 'package:ecom_user_flutter/app/modules/delivery/view/pending_delivery_view.dart';
import 'package:ecom_user_flutter/app/modules/home/views/profile_view.dart';
import 'package:ecom_user_flutter/app/modules/order/binding/order_binding.dart';
import 'package:ecom_user_flutter/app/modules/order/view/order_details.dart';
import 'package:ecom_user_flutter/app/modules/preferred_store/binding/preferred_store_binding.dart';
import 'package:ecom_user_flutter/app/modules/preferred_store/view/preferred_store_code_lookup_page.dart';
import 'package:ecom_user_flutter/app/modules/preferred_store/view/preferred_store_screen.dart';
import 'package:ecom_user_flutter/app/modules/preferred_store/view/store_profile_view.dart';
import 'package:ecom_user_flutter/app/modules/products/binding/product_binding.dart';
import 'package:ecom_user_flutter/app/modules/products/view/category_wised_products.dart';
import 'package:ecom_user_flutter/app/modules/products/view/product_detail.dart';
import 'package:ecom_user_flutter/app/modules/products/view/search_product_view.dart';
import 'package:ecom_user_flutter/app/modules/products/view/shop_products.dart';
import 'package:ecom_user_flutter/app/modules/products/view/today_deal_products.dart';
import 'package:ecom_user_flutter/app/modules/shop/binding/shop_binding.dart';
import 'package:ecom_user_flutter/app/modules/shop/view/brand_list_view.dart';
import 'package:ecom_user_flutter/app/modules/shop/view/shop_list.dart';
import 'package:ecom_user_flutter/app/modules/webview/bindings/webview_binding.dart';
import 'package:ecom_user_flutter/app/modules/webview/views/webview_view.dart';
import 'package:ecom_user_flutter/app/modules/wishlist/binding/wishlist_binding.dart';
import 'package:ecom_user_flutter/app/modules/wishlist/view/wish_list_view.dart';
import 'package:ecom_user_flutter/app/modules/qr_scan/bindings/qr_scan_binding.dart';
import 'package:ecom_user_flutter/app/modules/qr_scan/views/qr_scan_view.dart';
import 'package:ecom_user_flutter/app/modules/notification/binding/notification_binding.dart';
import 'package:ecom_user_flutter/app/modules/notification/view/notification_center_view.dart';
import 'package:ecom_user_flutter/app/modules/notification/view/notification_detail_views.dart';
import 'package:ecom_user_flutter/app/services/store_context_service.dart';

import 'package:get/get.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/order/view/order_view.dart';
import '../modules/root/bindings/root_binding.dart';
import '../modules/root/views/root_view.dart';
import '../modules/splashscreen/bindings/splashscreen_binding.dart';
import '../modules/splashscreen/views/splashscreen_view.dart';
part 'app_routes.dart';

void _activateStoreFromRoute() {
  final slug = Get.parameters['store_slug'] ?? Get.parameters['slug'];
  if (slug != null && slug.trim().isNotEmpty) {
    Get.find<StoreContextService>().setActiveStoreFromRoute(slug);
  }
}

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASHSCREEN;
  // static const INITIAL = Routes.Test;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.ROOT,
      page: () => RootView(),
      binding: RootBinding(),
    ),
    GetPage(
      name: _Paths.BRAND_LIST,
      page: () => BrandListView(),
      binding: ShopBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.FORGET_PASSWORD,
      page: () => LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.SIGNUP,
      page: () => RegisterView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.SPLASHSCREEN,
      page: () => SplashscreenView(),
      binding: SplashscreenBinding(),
    ),
    GetPage(
      name: _Paths.ALL_DELIVERY_ORDER,
      page: () => AssignedAllDeliveryView(),
      binding: DeliveryBinding(),
    ),
    GetPage(
      name: _Paths.Completed_DELIVERY_ORDER,
      page: () => CompletedDeliveryView(),
      binding: DeliveryBinding(),
    ),
    GetPage(
      name: _Paths.Pending_DELIVERY_ORDER,
      page: () => PendingDeliveryView(
        status: 'assigned',
      ),
      binding: DeliveryBinding(),
    ),
    GetPage(
      name: _Paths.ORDER_DETAIL,
      page: () => OrderDetailsView(),
      binding: OrderBinding(),
    ),
    GetPage(
      name: _Paths.DELIVERED_ORDER,
      page: () => Deliveredorder(),
      binding: DeliveryBinding(),
    ),
    GetPage(
      name: _Paths.MY_DELIVERY,
      page: () => MyDeliveryTabView(),
      binding: DeliveryBinding(),
    ),
    GetPage(
      name: _Paths.PRODUCT_DETAIL,
      page: () => ProductDetailPage(),
      binding: ProductBinding(),
    ),
    GetPage(
      name: _Paths.SHOP_PRODUCT,
      page: () => ShopProducts(),
      binding: ProductBinding(),
    ),
    GetPage(
      name: _Paths.TODAY_DEAL_PRODUCT,
      page: () => TodayDealProducts(),
      binding: ProductBinding(),
    ),
    GetPage(
      name: _Paths.CART_VIEW,
      page: () => CartView(),
      binding: CartBinding(),
    ),
    GetPage(
      name: _Paths.ADD_ADDRESS,
      page: () => UserAddress(),
      binding: CartBinding(),
    ),
    GetPage(
      name: _Paths.PROCEED_ORDER,
      page: () => ProceedOrderPage(),
      binding: CartBinding(),
    ),
    GetPage(
      name: _Paths.CHECKOUT_SUCCESS,
      page: () => CheckoutSuccessView(),
      binding: CartBinding(),
    ),
    GetPage(
      name: _Paths.WEBVIEW,
      page: () => WebviewView(),
      binding: WebviewBinding(),
    ),
    GetPage(
      name: _Paths.CATEGORY_VIEW,
      page: () => AllCategoryView(),
      binding: CategoryBinding(),
    ),
    GetPage(
      name: _Paths.ORDER_HISTORY,
      page: () => OrderHistoryPage(),
      binding: OrderBinding(),
    ),
    GetPage(
      name: _Paths.PRODUCT_FILTER,
      page: () => ProductFilterPage(),
      binding: ProductBinding(),
    ),
    GetPage(
      name: _Paths.CATEGORY_WISE_PRODUCT,
      page: () => CategoryWisedProducts(),
      binding: ProductBinding(),
    ),
    GetPage(
      name: _Paths.SHOP_LIST,
      page: () => ShopListView(),
      binding: ShopBinding(),
    ),
    GetPage(
      name: _Paths.BRAND_LIST,
      page: () => BrandListView(),
      binding: ShopBinding(),
    ),
    GetPage(
      name: _Paths.WISH_LIST,
      page: () => WishListView(),
      binding: WishlistBinding(),
    ),
    GetPage(
      name: _Paths.PREFERRED_STORES,
      page: () => const PreferredStoreScreen(),
      binding: PreferredStoreBinding(),
    ),
    GetPage(
      name: _Paths.PREFERRED_STORE_CODE_LOOKUP,
      page: () => const PreferredStoreCodeLookupPage(),
      binding: PreferredStoreBinding(),
    ),
    GetPage(
      name: _Paths.STORE_PROFILE,
      page: () => const StoreProfileView(),
      binding: PreferredStoreBinding(),
    ),

    GetPage(
      name: _Paths.PROFILE,
      page: () => const ProfileView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.NOTIFICATIONVIEW,
      page: () => const NotificationCenterView(),
      binding: NotificationBinding(),
    ),
    GetPage(
      name: _Paths.ORDER_NOTIFICATION,
      page: () => const OrderNotificationView(),
      binding: NotificationBinding(),
    ),
    GetPage(
      name: _Paths.GENERAL_NOTIFICATION,
      page: () => const GeneralNotificationView(),
      binding: NotificationBinding(),
    ),
    GetPage(
      name: _Paths.STORE_HOME,
      page: () {
        _activateStoreFromRoute();
        return RootView();
      },
      binding: RootBinding(),
    ),
    GetPage(
      name: _Paths.STORE_PRODUCTS,
      page: () {
        _activateStoreFromRoute();
        return ProductFilterPage();
      },
      binding: ProductBinding(),
    ),
    GetPage(
      name: _Paths.STORE_PRODUCT_DETAIL,
      page: () {
        _activateStoreFromRoute();
        return ProductDetailPage();
      },
      binding: ProductBinding(),
    ),
    GetPage(
      name: _Paths.STORE_CATEGORY_PRODUCTS,
      page: () {
        _activateStoreFromRoute();
        return CategoryWisedProducts();
      },
      binding: ProductBinding(),
    ),
    GetPage(
      name: _Paths.STORE_CART,
      page: () {
        _activateStoreFromRoute();
        return CartView();
      },
      binding: CartBinding(),
    ),
    GetPage(
      name: _Paths.STORE_CHECKOUT,
      page: () {
        _activateStoreFromRoute();
        return ProceedOrderPage();
      },
      binding: CartBinding(),
    ),
    GetPage(
      name: _Paths.STORE_ORDERS,
      page: () {
        _activateStoreFromRoute();
        return OrderHistoryPage();
      },
      binding: OrderBinding(),
    ),
    GetPage(
      name: _Paths.STORE_ORDER_DETAIL,
      page: () {
        _activateStoreFromRoute();
        return OrderDetailsView();
      },
      binding: OrderBinding(),
    ),
    GetPage(
      name: _Paths.STORE_SEARCH,
      page: () {
        _activateStoreFromRoute();
        return ProductFilterPage();
      },
      binding: ProductBinding(),
    ),
    GetPage(
      name: _Paths.STORE_TODAY_DEALS,
      page: () {
        _activateStoreFromRoute();
        return TodayDealProducts();
      },
      binding: ProductBinding(),
    ),
    GetPage(
      name: _Paths.STORE_FEATURED_PRODUCTS,
      page: () {
        _activateStoreFromRoute();
        return ProductFilterPage();
      },
      binding: ProductBinding(),
    ),
    GetPage(
      name: _Paths.QR_SCAN,
      page: () => QrScanView(),
      binding: QrScanBinding(),
    ),
    GetPage(
      name: _Paths.SHOP_CHAT_CONVERSATIONS,
      page: () => const CustomerConversationListView(),
      binding: CustomerChatBinding(),
    ),
    GetPage(
      name: _Paths.SHOP_CHAT_THREAD,
      page: () => const CustomerChatThreadView(),
      binding: CustomerChatBinding(),
    ),
  ];
}
