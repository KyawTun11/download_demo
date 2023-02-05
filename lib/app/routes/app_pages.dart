import 'package:get/get.dart';
import '../modules/download/bindings/download_binding.dart';
import '../modules/download/views/download_items_view.dart';
import '../modules/download/views/download_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.DOWNLOAD;

  static final routes = [
    GetPage(
      name: _Paths.DOWNLOAD,
      page: () => DownloadView(),
      binding: DownloadBinding(),
    ),
    GetPage(
      name: _Paths.DOWNLOAD_ITEMS,
      page: () => DownloadItemsView(),
      binding: DownloadBinding(),
    ),
  ];
}
