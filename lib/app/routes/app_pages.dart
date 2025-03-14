import 'package:get/get.dart';

import '../modules/binding/chat_binding.dart';
import '../modules/binding/home_view_binding.dart';
import '../modules/summary/bindings/summary_binding.dart';
import '../modules/summary/bindings/summary_binding.dart';
import '../modules/summary/views/summary_view.dart';
import '../modules/summary/views/summary_view.dart';
import '../modules/transcript/bindings/transcript_binding.dart';
import '../modules/transcript/views/transcript_view.dart';
import '../modules/view/chat_view.dart';
import '../modules/view/home_view.dart';

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
    GetPage(
      name: _Paths.SUMMARY,
      page: () => const SummaryView(),
      binding: SummaryBinding(),
    ),
    GetPage(
      name: _Paths.TRANSCRIPT,
      page: () => const TranscriptView(),
      binding: TranscriptBinding(),
    ),
  ];
}
