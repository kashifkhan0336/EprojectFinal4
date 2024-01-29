import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kDebugMode, kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:eproject_watchub/helper/responsive_helper.dart';
import 'package:eproject_watchub/helper/route_helper.dart';
import 'package:eproject_watchub/provider/auth_provider.dart';
import 'package:eproject_watchub/provider/banner_provider.dart';
import 'package:eproject_watchub/provider/cart_provider.dart';
import 'package:eproject_watchub/provider/category_provider.dart';
import 'package:eproject_watchub/provider/chat_provider.dart';
import 'package:eproject_watchub/provider/coupon_provider.dart';
import 'package:eproject_watchub/provider/flash_deal_provider.dart';
import 'package:eproject_watchub/provider/language_provider.dart';
import 'package:eproject_watchub/provider/localization_provider.dart';
import 'package:eproject_watchub/provider/location_provider.dart';
import 'package:eproject_watchub/provider/news_letter_provider.dart';
import 'package:eproject_watchub/provider/notification_provider.dart';
import 'package:eproject_watchub/provider/onboarding_provider.dart';
import 'package:eproject_watchub/provider/order_provider.dart';
import 'package:eproject_watchub/provider/product_provider.dart';
import 'package:eproject_watchub/provider/profile_provider.dart';
import 'package:eproject_watchub/provider/search_provider.dart';
import 'package:eproject_watchub/provider/splash_provider.dart';
import 'package:eproject_watchub/provider/theme_provider.dart';
import 'package:eproject_watchub/provider/wallet_provider.dart';
import 'package:eproject_watchub/provider/wishlist_provider.dart';
import 'package:eproject_watchub/theme/dark_theme.dart';
import 'package:eproject_watchub/theme/light_theme.dart';
import 'package:eproject_watchub/utill/app_constants.dart';
import 'package:eproject_watchub/view/base/third_party_chat_widget.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:url_strategy/url_strategy.dart';
import 'di_container.dart' as di;
import 'helper/notification_helper.dart';
import 'localization/app_localization.dart';
import 'view/base/cookies_view.dart';



final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();


AndroidNotificationChannel? channel;
Future<void> main() async {
  if(ResponsiveHelper.isMobilePhone()) {
    HttpOverrides.global = MyHttpOverrides();
  }
  setPathUrlStrategy();
  WidgetsFlutterBinding.ensureInitialized();



  if(!kIsWeb) {
    await Firebase.initializeApp();
    if(defaultTargetPlatform == TargetPlatform.android){
      FirebaseMessaging.instance.requestPermission();
    }
  } else {
    await Firebase.initializeApp(options: const FirebaseOptions(
        apiKey: "AIzaSyCkCr-aPft7PslEQ8YxVSzabcdQaxZYcaQ",
        authDomain: "eproject4-4ce3c.firebaseapp.com",
        projectId: "eproject4-4ce3c",
        storageBucket: "eproject4-4ce3c.appspot.com",
        messagingSenderId: "297549518164",
        appId: "1:297549518164:web:180df1395f5ec0847d24c1",
        measurementId: "G-S7BB40W8EX"
    ));

    await FacebookAuth.instance.webAndDesktopInitialize(
      appId: "YOUR_FACEBOOK_KEY_HERE",
      cookie: true,
      xfbml: true,
      version: "v13.0",
    );
  }

  await di.init();
  int? orderID;
  try {
    if(!kIsWeb) {
      channel = const AndroidNotificationChannel(
        'high_importance_channel',
        'High Importance Notifications',
        importance: Importance.high,
      );
    }
    final RemoteMessage? remoteMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (remoteMessage != null) {
      orderID = remoteMessage.notification!.titleLocKey != null ? int.parse(remoteMessage.notification!.titleLocKey!) : null;
    }
    await NotificationHelper.initialize(flutterLocalNotificationsPlugin);
    FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);

  }catch(e){
    if (kDebugMode) {
      print('error---> ${e.toString()}');
    }
  }

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => di.sl<ThemeProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<LocalizationProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<SplashProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<OnBoardingProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<CategoryProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<ProductProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<SearchProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<ChatProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<AuthProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<CartProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<CouponProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<LocationProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<ProfileProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<OrderProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<BannerProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<NotificationProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<LanguageProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<NewsLetterProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<WishListProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<WalletProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<FlashDealProvider>()),
    ],
    child: MyApp(orderID: orderID, isWeb: !kIsWeb),
  ));
}

class MyApp extends StatefulWidget {
  final int? orderID;
  final bool isWeb;
  const MyApp({Key? key, required this.orderID,required this.isWeb}) : super(key: key);


  @override
  State<MyApp> createState() => _MyAppState();

}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    RouteHelper.setupRouter();

    if(kIsWeb){
      Provider.of<SplashProvider>(context, listen: false).initSharedData();
      Provider.of<CartProvider>(context, listen: false).getCartData();
      _route();
    }
  }
  void _route() {
    Provider.of<SplashProvider>(context, listen: false).initConfig().then((bool isSuccess) {
      if (isSuccess) {
        Timer(Duration(seconds: ResponsiveHelper.isMobilePhone() ? 1 : 0), () async {
          if (Provider.of<AuthProvider>(context, listen: false).isLoggedIn()) {
            Provider.of<AuthProvider>(context, listen: false).updateToken();
          }
        });
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    List<Locale> locals = [];
    for (var language in AppConstants.languages) {
      locals.add(Locale(language.languageCode!, language.countryCode));
    }
    return Consumer<SplashProvider>(
      builder: (context, splashProvider,child){
        return (kIsWeb && splashProvider.configModel == null) ? const SizedBox():
        MaterialApp(
          title: splashProvider.configModel != null ? splashProvider.configModel!.ecommerceName ?? '' : AppConstants.appName,
          initialRoute: ResponsiveHelper.isMobilePhone() ? widget.orderID == null ? RouteHelper.splash :
          RouteHelper.getOrderDetailsRoute('${widget.orderID}'): splashProvider.configModel!.maintenanceMode!
              ? RouteHelper.getmaintenanceRoute() : RouteHelper.menu,
          onGenerateRoute: RouteHelper.router.generator,
          debugShowCheckedModeBanner: false,
          navigatorKey: navigatorKey,
          theme: Provider.of<ThemeProvider>(context).darkTheme ? dark : light,
          locale: Provider.of<LocalizationProvider>(context).locale,
          localizationsDelegates: const [
            AppLocalization.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: locals,
          scrollBehavior: const MaterialScrollBehavior().copyWith(dragDevices: {
            PointerDeviceKind.mouse,
            PointerDeviceKind.touch,
            PointerDeviceKind.stylus,
            PointerDeviceKind.unknown
          }),
          builder: (context, widget)=> MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1)),
            child: Material(child: Stack(children: [
              widget!,

              if(ResponsiveHelper.isDesktop(context))  Positioned.fill(
                child: Align(alignment: Alignment.bottomRight, child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
                  child: ThirdPartyChatWidget(configModel: splashProvider.configModel!),
                )),
              ),
              if(kIsWeb && splashProvider.configModel!.cookiesManagement != null &&
                  splashProvider.configModel!.cookiesManagement!.status!
                  && !splashProvider.getAcceptCookiesStatus(splashProvider.configModel!.cookiesManagement!.content)
                  && splashProvider.cookiesShow)
                const Positioned.fill(child: Align(alignment: Alignment.bottomCenter, child: CookiesView())),

            ])),
          ),

        );
      },

    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}

class Get {
 static BuildContext? get context => navigatorKey.currentContext;
 static NavigatorState? get navigator => navigatorKey.currentState;
}
