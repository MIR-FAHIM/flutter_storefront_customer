// lib/app/api_providers/api_client.dart

import 'package:ecom_user_flutter/app/api_providers/company_data.dart';

class ApiClient {
  static const String baseUrl = CompanyData.baseUrl;

  // ==============================
  // AUTH
  // ==============================
  static const String login = '$baseUrl/api/auth/login';
  static const String logout = '$baseUrl/api/auth/logout';
  static const String authTokens = '$baseUrl/api/auth/tokens';
  static const String revokeToken = '$baseUrl/api/auth/tokens/'; // {id}

  // ==============================
  // CHAT
  // ==============================
  static const String chatUnreadCount = '$baseUrl/api/chat/unread-count';
  static const String chatConversations = '$baseUrl/api/chat/conversations';
  static const String chatMessages = '$baseUrl/api/chat/messages';
  static const String chatConversationsRead = '$baseUrl/api/chat/conversations';

  // ==============================
  // USERS
  // ==============================
  static const String createUser = '$baseUrl/api/users/create';
  static const String listUsers = '$baseUrl/api/users/list';
  static const String customers = '$baseUrl/api/users/customers';
  static const String vendors = '$baseUrl/api/users/vendors';
  static const String deliveryMen = '$baseUrl/api/users/delivery-men';
  static const String userDetails = '$baseUrl/api/users/details/'; // {id}
  static const String updateUser = '$baseUrl/api/users/update/'; // {id}
  static const String banUser = '$baseUrl/api/users/ban/'; // {id}
  static const String unbanUser = '$baseUrl/api/users/unban/'; // {id}
  static const String deleteUser = '$baseUrl/api/users/delete/'; // {id}

  // ==============================
  // CATEGORIES
  // ==============================
  static const String createCategory = '$baseUrl/api/categories/create';
  static const String getCategory = '$baseUrl/api/categories/list';
  static const String publicStoreCategories =
      '$baseUrl/api/public/stores/'; // {slug}/categories
  static const String categoryDetails =
      '$baseUrl/api/categories/details/'; // {id}
  static const String categoryChildren =
      '$baseUrl/api/categories/children/'; // {id}
  static const String updateCategory =
      '$baseUrl/api/categories/update/'; // {id}
  static const String deleteCategory =
      '$baseUrl/api/categories/delete/'; // {id}

  // ==============================
  // BRANDS
  // ==============================
  static const String createBrand = '$baseUrl/api/brands/create';
  static const String listBrands = '$baseUrl/api/brands/list';
  static const String brandDetails = '$baseUrl/api/brands/details/'; // {id}
  static const String updateBrand = '$baseUrl/api/brands/update/'; // {id}
  static const String deleteBrand = '$baseUrl/api/brands/delete/'; // {id}

  // ==============================
  // PRODUCTS
  // ==============================
  static const String createProduct = '$baseUrl/api/products/create';
  static const String listProducts = '$baseUrl/api/products/list';
  static const String featuredProduct = '$baseUrl/api/products/list/featured';
  static const String todayDealProducts =
      '$baseUrl/api/products/list/today-deal';
  static const String productDetails = '$baseUrl/api/products/details/'; // {id}
  static const String updateProduct = '$baseUrl/api/products/update/'; // {id}
  static const String deleteProduct = '$baseUrl/api/products/delete/'; // {id}

  // Product images
  static const String productImageUpload =
      '$baseUrl/api/products/images/upload/'; // {productId}
  static const String addProductImage =
      '$baseUrl/api/products/images/add/'; // {id}
  static const String deleteProductImage =
      '$baseUrl/api/products/images/delete/'; // {imageId}

  // ==============================
  // SHOPS
  // ==============================
  static const String createShop = '$baseUrl/api/shops/create';
  static const String listShops = '$baseUrl/api/shops/list';
  static const String shopDetails = '$baseUrl/api/shops/details/'; // {id}
  static const String findShopByCode =
      '$baseUrl/api/shops/find-by-code/'; // {code}
  static const String shopProducts = '$baseUrl/api/shops/products/'; // {id}
  static const String updateShop = '$baseUrl/api/shops/update/'; // {id}
  static const String updateShopStatus = '$baseUrl/api/shops/status/'; // {id}
  static const String deleteShop = '$baseUrl/api/shops/delete/'; // {id}
  static const String addSellerPreference =
      '$baseUrl/api/customer-preferences-store/add-seller-preference';
  static const String preferredStores =
      '$baseUrl/api/customer-preferences-store/sellers-by-customer';
  static const String setActiveSellerPreference =
      '$baseUrl/api/customer-preferences-store/set-active';
  static const String removeSellerPreference =
      '$baseUrl/api/customer-preferences-store/remove';

  // Notifications
  static const String notifications = '$baseUrl/api/notifications';
  static const String notificationUnreadCount =
      '$baseUrl/api/notifications/unread-count';
  static const String notificationOrders = '$baseUrl/api/notifications/orders/';
  static const String notificationRead = '$baseUrl/api/notifications/';
  static const String notificationReadAll =
      '$baseUrl/api/notifications/read-all';

  // ==============================
  // CART
  // ==============================
  static const String activeCart = '$baseUrl/api/carts/active/'; // {userId}
  static const String addToCart = '$baseUrl/api/carts/items/add';
  static const String updateCartItem =
      '$baseUrl/api/carts/items/update/'; // {itemId}
  static const String deleteCartItem =
      '$baseUrl/api/carts/items/delete/'; // {itemId}
  static const String clearCart = '$baseUrl/api/carts/clear/'; // {userId}

  // ==============================
  // ORDERS
  // ==============================
  static const String checkout = '$baseUrl/api/orders/checkout';
  static const String initiateAamarPayPayment =
      '$baseUrl/api/payments/aamarpay/initiate';
  static const String userOrders = '$baseUrl/api/orders/list/'; // {userId}
  static const String allOrders = '$baseUrl/api/orders/all/orders';
  static const String completedOrders = '$baseUrl/api/orders/completed';
  static const String completedOrdersByUser =
      '$baseUrl/api/orders/completed/'; // {userId}

  static const String orderDetail = '$baseUrl/api/orders/details/'; // {id}
  static const String changeOrderStatus = '$baseUrl/api/orders/status/'; // {id}
  static const String changeOrderItemStatus =
      '$baseUrl/api/orders/item/status/'; // {id}

  // ==============================
  // DELIVERY ADDRESS
  // ==============================
  static const String addAddress = '$baseUrl/api/addresses/add';
  static const String userAddresses =
      '$baseUrl/api/addresses/user/'; // {userId}
  static const String deleteAddress = '$baseUrl/api/addresses/delete/'; // {id}
  static const String inactiveAddress =
      '$baseUrl/api/addresses/inactive/'; // {id}
  static const String updateAddress = '$baseUrl/api/addresses/update/'; // {id}

  // ==============================
  // WISHLIST
  // ==============================
  static const String addWishlist = '$baseUrl/api/wishlists/add';
  static const String wishlist = '$baseUrl/api/wishlists/list/'; // {userId}
  static const String deleteWishlist = '$baseUrl/api/wishlists/delete/'; // {id}

  // ==============================
  // RELATED PRODUCTS
  // ==============================
  static const String addRelatedProduct = '$baseUrl/api/related-products/add';
  static const String relatedProducts =
      '$baseUrl/api/related-products/list/'; // {productId}
  static const String removeRelatedProduct =
      '$baseUrl/api/related-products/remove/'; // {id}

  // ==============================
  // REVIEWS
  // ==============================
  static const String addReview = '$baseUrl/api/reviews/add';
  static const String allReviews = '$baseUrl/api/reviews/list';
  static const String productReviews =
      '$baseUrl/api/reviews/product/'; // {productId}
  static const String userReviews = '$baseUrl/api/reviews/user/'; // {userId}
  static const String updateReviewByUser =
      '$baseUrl/api/reviews/update-by-user/'; // {id}
  static const String deleteReview = '$baseUrl/api/reviews/remove/'; // {id}

  // ==============================
  // BANNERS
  // ==============================
  static const String getBanner = '$baseUrl/api/banners/active';
  static const String addBanner = '$baseUrl/api/banners/add';
  static const String removeBanner = '$baseUrl/api/banners/remove/'; // {id}

  // ==============================
  // ATTRIBUTES
  // ==============================
  static const String createAttribute = '$baseUrl/api/attributes/create';
  static const String listAttributes = '$baseUrl/api/attributes/list';
  static const String attributeDetails =
      '$baseUrl/api/attributes/details/'; // {id}
  static const String updateAttribute =
      '$baseUrl/api/attributes/update/'; // {id}
  static const String deleteAttribute =
      '$baseUrl/api/attributes/delete/'; // {id}

  static const String createAttributeValue =
      '$baseUrl/api/attributes/values/create';
  static const String updateAttributeValue =
      '$baseUrl/api/attributes/values/update/'; // {id}
  static const String deleteAttributeValue =
      '$baseUrl/api/attributes/values/delete/'; // {id}

  // ==============================
  // PRODUCT ATTRIBUTES
  // ==============================
  static const String createProductAttribute =
      '$baseUrl/api/product-attributes/create';
  static const String listProductAttributes =
      '$baseUrl/api/product-attributes/list';
  static const String productAttributeDetails =
      '$baseUrl/api/product-attributes/details/'; // {id}
  static const String updateProductAttribute =
      '$baseUrl/api/product-attributes/update/'; // {id}
  static const String deleteProductAttribute =
      '$baseUrl/api/product-attributes/delete/'; // {id}

  // ==============================
  // REPORTS
  // ==============================
  static const String dashboardReport = '$baseUrl/api/reports/dashboard';

  // ==============================
  // UPLOADS
  // ==============================
  static const String uploadImage = '$baseUrl/api/uploads/image';
  static const String uploadList = '$baseUrl/api/uploads/list';
  static const String uploadDetails = '$baseUrl/api/uploads/'; // {id}
  static const String deleteUpload = '$baseUrl/api/uploads/'; // {id}

  // ==============================
  // DELIVERY
  // ==============================
  static const String assignDelivery = '$baseUrl/api/deliveries/assign';
  static const String unassignDelivery = '$baseUrl/api/deliveries/unassign';
  static const String allDelivery =
      '$baseUrl/api/deliveries/all/'; // {deliveryManId}
  static const String deliveredDelivery =
      '$baseUrl/api/deliveries/delivered/'; // {deliveryManId}
  static const String assignedDelivery =
      '$baseUrl/api/deliveries/assigned/'; // {deliveryManId}
  static const String completedDelivery =
      '$baseUrl/api/deliveries/completed/'; // {deliveryManId}
  static const String reportDelivery =
      '$baseUrl/api/deliveries/report/'; // {deliveryManId}

  // ==============================
  // TRANSACTIONS
  // ==============================
  static const String creditTransaction = '$baseUrl/api/transactions/credit';
  static const String debitTransaction = '$baseUrl/api/transactions/debit';
  static const String transactionReport = '$baseUrl/api/transactions/report';
}
