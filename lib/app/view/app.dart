import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_source/app/themes/app_themes.dart';
import 'package:flutter_source/l10n/l10n.dart';
import 'package:flutter_source/shares/dismiss_keyboard.dart';
import 'package:flutter_source/src/alarm/view/alarm_main_page.dart';
import 'package:home_widget/home_widget.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    setSTTBar();
    HomeWidget.setAppGroupId('group.com.lichviet');
    super.initState();
  }

  void setSTTBar() {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.lightTheme,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('vi'),
      debugShowCheckedModeBanner: false,
      home: DismissKeyboard(AlarmMainPage()),
    );
  }
}
