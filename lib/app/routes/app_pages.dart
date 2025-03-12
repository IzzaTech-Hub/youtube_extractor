import 'package:get/get.dart';
import 'package:youtube_extracter/app/modules/binding/chat_binding.dart';
import 'package:youtube_extracter/app/modules/binding/home_view_binding.dart';
import 'package:youtube_extracter/app/modules/view/chat_view.dart';
import 'package:youtube_extracter/app/modules/view/home_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOMEVIEW;

  static final routes = [
    GetPage(
      name: _Paths.HOMEVIEW,
      page: () => HomeView(),
      binding: HomeViewBinding(),
    ),
    GetPage(
      name: _Paths.CHAT,
      page: () => ChatView(),
      binding: ChatBinding(),
    ),
  ];
}
