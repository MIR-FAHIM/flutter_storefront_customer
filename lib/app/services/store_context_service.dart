import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class StoreContextService extends GetxService {
  StoreContextService() {
    _box = GetStorage();
  }

  static const _slugKey = 'active_store_slug';
  static const _idKey = 'active_store_id';
  static const _sellerIdKey = 'active_seller_id';
  static const _nameKey = 'active_store_name';
  static const _logoKey = 'active_store_logo';
  static const _bannerKey = 'active_store_banner';
  static const redirectRouteKey = 'store_redirect_route';
  static const redirectArgumentsKey = 'store_redirect_arguments';

  late GetStorage _box;

  final activeStoreSlug = ''.obs;
  final activeStoreId = RxnInt();
  final activeSellerId = RxnInt();
  final activeStoreName = ''.obs;
  final activeStoreLogo = ''.obs;
  final activeStoreBanner = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _box = GetStorage();
    _restore();
  }

  bool get hasActiveStore => activeStoreSlug.value.trim().isNotEmpty;

  String? get storeSlugOrNull {
    final slug = activeStoreSlug.value.trim();
    return slug.isEmpty ? null : slug;
  }

  Future<void> setActiveStore({
    required String slug,
    int? id,
    int? sellerId,
    String? name,
    String? logo,
    String? banner,
  }) async {
    final cleanSlug = slug.trim();
    if (cleanSlug.isEmpty) return;

    final storeChanged = activeStoreSlug.value != cleanSlug;
    activeStoreSlug.value = cleanSlug;
    activeStoreId.value = id ?? (storeChanged ? null : activeStoreId.value);
    activeSellerId.value = sellerId ??
        (storeChanged ? null : activeSellerId.value);
    activeStoreName.value = name?.trim() ?? '';
    activeStoreLogo.value = logo?.trim() ?? '';
    activeStoreBanner.value = banner?.trim() ?? '';

    await _box.write(_slugKey, activeStoreSlug.value);
    await _box.write(_idKey, activeStoreId.value);
    await _box.write(_sellerIdKey, activeSellerId.value);
    await _box.write(_nameKey, activeStoreName.value);
    await _box.write(_logoKey, activeStoreLogo.value);
    await _box.write(_bannerKey, activeStoreBanner.value);
  }

  Future<void> setActiveStoreFromRoute(String? slug) async {
    final cleanSlug = slug?.trim();
    if (cleanSlug == null || cleanSlug.isEmpty) return;

    await setActiveStore(slug: cleanSlug);
  }

  Future<void> clearActiveStore() async {
    activeStoreSlug.value = '';
    activeStoreId.value = null;
    activeSellerId.value = null;
    activeStoreName.value = '';
    activeStoreLogo.value = '';
    activeStoreBanner.value = '';

    await _box.remove(_slugKey);
    await _box.remove(_idKey);
    await _box.remove(_sellerIdKey);
    await _box.remove(_nameKey);
    await _box.remove(_logoKey);
    await _box.remove(_bannerKey);
  }

  Future<void> saveLoginRedirect({
    required String route,
    Map<String, dynamic>? arguments,
  }) async {
    await _box.write(redirectRouteKey, route);
    await _box.write(redirectArgumentsKey, arguments ?? <String, dynamic>{});
  }

  Map<String, dynamic>? consumeLoginRedirect() {
    final route = _box.read(redirectRouteKey)?.toString();
    final rawArguments = _box.read(redirectArgumentsKey);

    _box.remove(redirectRouteKey);
    _box.remove(redirectArgumentsKey);

    if (route == null || route.trim().isEmpty) return null;

    return {
      'route': route,
      'arguments': rawArguments is Map
          ? Map<String, dynamic>.from(rawArguments)
          : <String, dynamic>{},
    };
  }

  void _restore() {
    activeStoreSlug.value = _box.read(_slugKey)?.toString() ?? '';
    activeStoreId.value = _asInt(_box.read(_idKey));
    activeSellerId.value = _asInt(_box.read(_sellerIdKey));
    activeStoreName.value = _box.read(_nameKey)?.toString() ?? '';
    activeStoreLogo.value = _box.read(_logoKey)?.toString() ?? '';
    activeStoreBanner.value = _box.read(_bannerKey)?.toString() ?? '';
  }

  int? _asInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is double) return value.toInt();
    return int.tryParse(value.toString());
  }
}
