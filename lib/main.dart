import 'package:easytrip/data/provider/repository/loginrepository.dart';
import 'package:easytrip/data/provider/server/loginserver.dart';
import 'package:easytrip/logic/loginbloc/bloc/login_bloc.dart';
import 'package:easytrip/presentation/Onboboarding/onboarding_view.dart';
import 'package:easytrip/presentation/screens/mainscreen.dart';
import 'package:easytrip/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easytrip/l10n/app_localizations.dart'; // Import generated localizations
import 'logic/blocObserver/blocobserver.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final onboarding = prefs.getBool("onboarding") ?? false;
  final Locale locale = await _fetchPreferredLocale();

  Bloc.observer = MyBlocObserver();

  // Create and initialize the UiProvider
  final uiProvider = UiProvider();
  await uiProvider.init();

  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider.value(value: uiProvider)],
      child: MyApp(onboarding: onboarding, locale: locale),
    ),
  );
}

Future<Locale> _fetchPreferredLocale() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? languageCode = prefs.getString('languageCode');

  if (languageCode != null) {
    return Locale(languageCode);
  } else {
    return WidgetsBinding.instance.platformDispatcher.locale;
  }
}

class MyApp extends StatefulWidget {
  final bool onboarding;
  final Locale locale;

  const MyApp({super.key, this.onboarding = false, required this.locale});

  static void setLocale(BuildContext context, Locale newLocale) async {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('languageCode', newLocale.languageCode);
    state?.setLocale(newLocale);
  }

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Locale _locale;

  @override
  void initState() {
    super.initState();
    _locale = widget.locale;
  }

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => LoginRepository(loginserver: Loginserver()),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                LoginBloc(loginRepository: context.read<LoginRepository>()),
          ),
        ],
        child: Consumer<UiProvider>(
          builder: (context, uiProvider, child) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: uiProvider.lightTheme,
              darkTheme: uiProvider.darkTheme,
              themeMode: uiProvider.isDark ? ThemeMode.dark : ThemeMode.light,

              // Add localization support
              locale: _locale,
              supportedLocales: const [
                Locale('en'), // English
                Locale('fr'), // French
              ],
              localizationsDelegates: const [
                AppLocalizations.delegate, // Generated localizations delegate
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],

              home: widget.onboarding
                  ? const MainScreen()
                  : const OnboardingView(),
              // onGenerateRoute: AppRoute.generateRoute,
            );
          },
        ),
      ),
    );
  }
}
