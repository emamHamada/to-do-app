import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';
import 'package:to_do_app/services/theme_services.dart';
import 'package:to_do_app/ui/pages/home_page.dart';
import 'package:to_do_app/ui/theme.dart';

import 'db/db_helper.dart';

void main() async {
  //to initialize the step between the widget and the rendering engine
  // The glue between the widgets layer and the Flutter engine.
  WidgetsFlutterBinding.ensureInitialized();
  //to initialize database class to be create it only you open the app
  await DBHelper.initDb();
  //initialize get storage to get it only when open the app
  await GetStorage.init();
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: Themes.light,
      darkTheme: Themes.dark,
      themeMode: ThemeServices().theme,
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}

//بعد كده لما تشيل النيو الموجوده جوا الجراديل مع البروبيرتي علشان الايرور يروح هتلاقي الايرور نطلك ف الرن علشان كده سيبهم نيو كما هم متغيرش حاجه خالص يا قمر انت يا قمر
//خد بالك من الايرور اللي بيجي علشان الايكون لازم يكون الmain flutter sdk ثابت وليكن مثلا 21 وبالتالي نروح لنقطه تانيه وهي نقطه ان انت معرف الباس بتاع الصور اصلا غلط
// Microsoft Windows [Version 10.0.19044.1526]
// (c) Microsoft Corporation. All rights reserved.
//
// C:\Users\computer center\StudioProjects\to_do_tasks>flutter pub get
// Running "flutter pub get" in to_do_tasks...                      2,302ms
//
// C:\Users\computer center\StudioProjects\to_do_tasks>flutter pub run flutter_launcher_icons:main
// ════════════════════════════════════════════
// FLUTTER LAUNCHER ICONS (v0.9.1)
// ════════════════════════════════════════════
//
//
// ✓ Successfully generated launcher icons
// Unhandled exception:
// FormatException: Invalid number (at character 1)
//
// ^
//
// #0      int._handleFormatError (dart:core-patch/integers_patch.dart:129:7)
// #1      int.parse (dart:core-patch/integers_patch.dart:55:14)
// #2      minSdk (package:flutter_launcher_icons/android.dart:309:18)
// #3      createIconsFromConfig (package:flutter_launcher_icons/main.dart:94:47)
// #4      createIconsFromArguments (package:flutter_launcher_icons/main.dart:60:7)
// #5      main (file:///C:/scr/flutter/.pub-cache/hosted/pub.dartlang.org/flutter_launcher_icons-0.9.2/bin/main.dart:6:26)
// #6      _delayEntrypointInvocation.<anonymous closure> (dart:isolate-patch/isolate_patch.dart:295:32)
// #7      _RawReceivePortImpl._handleMessage (dart:isolate-patch/isolate_patch.dart:192:12)
// pub finished with exit code 255
//
// C:\Users\computer center\StudioProjects\to_do_tasks>flutter pub run flutter_launcher_icons:main
// ════════════════════════════════════════════
// FLUTTER LAUNCHER ICONS (v0.9.1)
// ════════════════════════════════════════════
//
// • Creating default icons Android
//
// ✓ Successfully generated launcher icons
// Unhandled exception:
// FileSystemException: Cannot open file, path = 'assets/icons/appicon.jpeg' (OS Error: The system cannot find the file specified.
// , errno = 2)
// #0      _File.throwIfError (dart:io/file_impl.dart:635:7)
// #1      _File.openSync (dart:io/file_impl.dart:479:5)
// #2      _File.readAsBytesSync (dart:io/file_impl.dart:539:18)
// #3      decodeImageFile (package:flutter_launcher_icons/utils.dart:35:44)
// #4      createDefaultIcons (package:flutter_launcher_icons/android.dart:35:24)
// #5      createIconsFromConfig (package:flutter_launcher_icons/main.dart:103:28)
// #6      createIconsFromArguments (package:flutter_launcher_icons/main.dart:60:7)
// #7      main (file:///C:/scr/flutter/.pub-cache/hosted/pub.dartlang.org/flutter_launcher_icons-0.9.2/bin/main.dart:6:26)
// #8      _delayEntrypointInvocation.<anonymous closure> (dart:isolate-patch/isolate_patch.dart:295:32)
// #9      _RawReceivePortImpl._handleMessage (dart:isolate-patch/isolate_patch.dart:192:12)
// pub finished with exit code 255
//
// C:\Users\computer center\StudioProjects\to_do_tasks>flutter pub run flutter_launcher_icons:main
//
// ════════════════════════════════════════════
// FLUTTER LAUNCHER ICONS (v0.9.1)
// ════════════════════════════════════════════
//
// • Creating default icons Android
//
// ✓ Successfully generated launcher icons
// Unhandled exception:
// FileSystemException: Cannot open file, path = 'assets/icons/appicon.jpeg' (OS Error: The system cannot find the file specified.
// , errno = 2)
// #0      _File.throwIfError (dart:io/file_impl.dart:635:7)
// #1      _File.openSync (dart:io/file_impl.dart:479:5)
// #2      _File.readAsBytesSync (dart:io/file_impl.dart:539:18)
// #3      decodeImageFile (package:flutter_launcher_icons/utils.dart:35:44)
// #4      createDefaultIcons (package:flutter_launcher_icons/android.dart:35:24)
// #5      createIconsFromConfig (package:flutter_launcher_icons/main.dart:103:28)
// #6      createIconsFromArguments (package:flutter_launcher_icons/main.dart:60:7)
// #7      main (file:///C:/scr/flutter/.pub-cache/hosted/pub.dartlang.org/flutter_launcher_icons-0.9.2/bin/main.dart:6:26)
// #8      _delayEntrypointInvocation.<anonymous closure> (dart:isolate-patch/isolate_patch.dart:295:32)
// #9      _RawReceivePortImpl._handleMessage (dart:isolate-patch/isolate_patch.dart:192:12)
// pub finished with exit code 255
