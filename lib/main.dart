import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youtube_extracter/app/provider/admob_ads_provider.dart';
import 'package:youtube_extracter/app/routes/app_pages.dart';
import 'package:youtube_extracter/app/services/firestore_service.dart';
import 'package:youtube_extracter/app/services/remoteconfig_services.dart';
import 'package:youtube_extracter/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  RemoteConfigService().initialize();
  AdMobAdsProvider.instance.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    );
  }
}
