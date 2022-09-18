import 'package:FeSekka/I10n/AppLanguage.dart';
import 'package:FeSekka/I10n/app_localizations.dart';
import 'package:FeSekka/testUserScreen.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AppLanguage appLanguage = AppLanguage();
  await appLanguage.fetchLocale();

  runApp(
      DevicePreview(
        enabled: true,
        builder: (context) => MyApp(appLanguage: appLanguage) // Wrap your app
      ),
     );
}

class MyApp extends StatefulWidget {
  final AppLanguage? appLanguage;
  const MyApp({Key? key,this.appLanguage}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);    super.initState();
  }
  Widget build(BuildContext context) {

    return ChangeNotifierProvider(
        create: (_) => widget.appLanguage,
        child: Consumer<AppLanguage>(
          builder: (context, model, child) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              localizationsDelegates: [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
                DefaultCupertinoLocalizations.delegate
              ],
              supportedLocales: [
                Locale("en", "US"),
                Locale("ar", ""),
              ],
              locale: model.appLocal,
              title: 'Fe ElSekka',
              theme: ThemeData(
                primaryColor: Color(0xFF66a5b4),
                textTheme: Theme.of(context).textTheme.apply(
                      fontFamily: 'tajawal',
                    ),
              ),
              home: TestUserScreen(),
            );
          },
        ));
  }
}
