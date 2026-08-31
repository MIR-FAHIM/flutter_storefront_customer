part of 'app_pages.dart';
// DO NOT EDIT. This is code generated via package:get_cli/get_cli.dart

abstract class Routes {
  Routes._();

  static const ROOT = _Paths.ROOT;
  static const SPLASHSCREEN = _Paths.SPLASHSCREEN;

  static const LOGIN = _Paths.LOGIN;
  static const SIGNUP = _Paths.SIGNUP;
  static const FORGET_PASSWORD = _Paths.FORGET_PASSWORD;

  static const NOTIFICATIONVIEW = _Paths.NOTIFICATIONVIEW;
  static const ALL_DELIVERY_ORDER = _Paths.ALL_DELIVERY_ORDER;
  static const Completed_DELIVERY_ORDER = _Paths.Completed_DELIVERY_ORDER;
  static const Pending_DELIVERY_ORDER = _Paths.Pending_DELIVERY_ORDER;
  static const ORDER_DETAIL = _Paths.ORDER_DETAIL;
  static const DELIVERED_ORDER = _Paths.DELIVERED_ORDER;
  static const MY_DELIVERY = _Paths.MY_DELIVERY;
  static const PRODUCT_DETAIL = _Paths.PRODUCT_DETAIL;
  static const CART_VIEW = _Paths.CART_VIEW;
  static const PROCEED_ORDER = _Paths.PROCEED_ORDER;
  static const CHECKOUT_SUCCESS = _Paths.CHECKOUT_SUCCESS;
  static const WEBVIEW = _Paths.WEBVIEW;
  static const CATEGORY_VIEW = _Paths.CATEGORY_VIEW;
  static const ORDER_HISTORY = _Paths.ORDER_HISTORY;
  static const PRODUCT_FILTER = _Paths.PRODUCT_FILTER;
  static const CATEGORY_WISE_PRODUCT = _Paths.CATEGORY_WISE_PRODUCT;
  static const SHOP_LIST = _Paths.SHOP_LIST;
  static const BRAND_LIST = _Paths.BRAND_LIST;
  static const WISH_LIST = _Paths.WISH_LIST;
  static const SHOP_PRODUCT = _Paths.SHOP_PRODUCT;
  static const TODAY_DEAL_PRODUCT = _Paths.TODAY_DEAL_PRODUCT;
  static const ADD_ADDRESS = _Paths.ADD_ADDRESS;
  static const STORE_HOME = _Paths.STORE_HOME;
  static const STORE_PRODUCTS = _Paths.STORE_PRODUCTS;
  static const STORE_PRODUCT_DETAIL = _Paths.STORE_PRODUCT_DETAIL;
  static const STORE_CATEGORY_PRODUCTS = _Paths.STORE_CATEGORY_PRODUCTS;
  static const STORE_CART = _Paths.STORE_CART;
  static const STORE_CHECKOUT = _Paths.STORE_CHECKOUT;
  static const STORE_ORDERS = _Paths.STORE_ORDERS;
  static const STORE_ORDER_DETAIL = _Paths.STORE_ORDER_DETAIL;
  static const STORE_SEARCH = _Paths.STORE_SEARCH;
  static const STORE_TODAY_DEALS = _Paths.STORE_TODAY_DEALS;
  static const STORE_FEATURED_PRODUCTS = _Paths.STORE_FEATURED_PRODUCTS;
  static const PREFERRED_STORES = _Paths.PREFERRED_STORES;
  static const STORE_PROFILE = _Paths.STORE_PROFILE;
  static const QR_SCAN = _Paths.QR_SCAN;
}

abstract class _Paths {
  static const HOME = '/home';

  static const ROOT = '/root';

  static const LOGIN = '/LOGIN';
  static const SIGNUP = '/SIGNUP';
  static const FORGET_PASSWORD = '/FORGET_PASSWORD';
  static const SHOP_LIST = '/SHOP_LIST';

  static const SPLASHSCREEN = '/splashscreen';

  static const NOTIFICATIONVIEW = '/NOTIFICATIONVIEW';
  static const ALL_DELIVERY_ORDER = '/ALL_DELIVERY_ORDER';
  static const Completed_DELIVERY_ORDER = '/Completed_DELIVERY_ORDER';
  static const Pending_DELIVERY_ORDER = '/Pending_DELIVERY_ORDER';
  static const ORDER_DETAIL = '/ORDER_DETAIL';
  static const DELIVERED_ORDER = '/DELIVERED_ORDER';
  static const MY_DELIVERY = '/MY_DELIVERY';
  static const PRODUCT_DETAIL = '/PRODUCT_DETAIL';
  static const CART_VIEW = '/CART_VIEW';
  static const PROCEED_ORDER = '/PROCEED_ORDER';
  static const CHECKOUT_SUCCESS = '/CHECKOUT_SUCCESS';
  static const WEBVIEW = '/WEBVIEW';
  static const CATEGORY_VIEW = '/CATEGORY_VIEW';
  static const ORDER_HISTORY = '/ORDER_HISTORY';
  static const PRODUCT_FILTER = '/PRODUCT_FILTER';
  static const CATEGORY_WISE_PRODUCT = '/CATEGORY_WISE_PRODUCT';
  static const BRAND_LIST = '/BRAND_LIST';
  static const WISH_LIST = '/WISH_LIST';
  static const SHOP_PRODUCT = '/SHOP_PRODUCT';
  static const TODAY_DEAL_PRODUCT = '/TODAY_DEAL_PRODUCT';
  static const ADD_ADDRESS = '/ADD_ADDRESS';
  static const STORE_HOME = '/store/:store_slug';
  static const STORE_PRODUCTS = '/store/:store_slug/products';
  static const STORE_PRODUCT_DETAIL = '/store/:store_slug/products/:product_slug';
  static const STORE_CATEGORY_PRODUCTS =
      '/store/:store_slug/category/:category_id';
  static const STORE_CART = '/store/:store_slug/cart';
  static const STORE_CHECKOUT = '/store/:store_slug/checkout';
  static const STORE_ORDERS = '/store/:store_slug/orders';
  static const STORE_ORDER_DETAIL = '/store/:store_slug/order/:order_id';
  static const STORE_SEARCH = '/store/:store_slug/search';
  static const STORE_TODAY_DEALS = '/store/:store_slug/today-deals';
  static const STORE_FEATURED_PRODUCTS =
      '/store/:store_slug/featured-products';
  static const PREFERRED_STORES = '/customer/preferred-stores';
  static const STORE_PROFILE = '/store-profile';
  static const QR_SCAN = '/qr-scan';
}
