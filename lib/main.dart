import 'package:database_app/database/db_controller.dart';
import 'package:database_app/prefs/shared_pref_controller.dart';
import 'package:database_app/provider/cart_provider.dart';
import 'package:database_app/provider/language_provider.dart';
import 'package:database_app/provider/products_provider.dart';
import 'package:database_app/screens/app/cart/cart_screen.dart';
import 'package:database_app/screens/app/product_add_screen.dart';
import 'package:database_app/screens/auth/login_screen.dart';
import 'package:database_app/screens/auth/register_screen.dart';
import 'package:database_app/screens/core/launch_screen.dart';
import 'package:database_app/screens/app/products_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
 await SharedPrefController().initPreferences();
 await DbController().initDatabase();
  return runApp(MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(375,812),
        minTextAdapt: true,
        builder: (context,child){
          return MultiProvider(
              providers:[
                ChangeNotifierProvider<LanguageProvider>(create: (context)=>LanguageProvider()),
                ChangeNotifierProvider<ProductsProvider>(create: (context)=>ProductsProvider()),
                ChangeNotifierProvider<CartProvider>(create: (context)=>CartProvider())
              ],
            builder: (context,widget){
                return MaterialApp(
                  theme: ThemeData(
                    appBarTheme: AppBarTheme(
                      centerTitle: true,
                      elevation: 0,
                      backgroundColor: Colors.transparent,
                      iconTheme: IconThemeData(color: Colors.black),
                      titleTextStyle: GoogleFonts.cairo(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black
                      ),
                    ),
                  ),
                  debugShowCheckedModeBanner: false,
                  localizationsDelegates: [
                    AppLocalizations.delegate,
                    GlobalMaterialLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                  ],
                  supportedLocales: [
                    Locale('ar'),
                    Locale('en'),
                  ],
                  locale: Locale(Provider.of<LanguageProvider>(context).language),
                  initialRoute: '/launch_screen',
                  routes: {
                    '/launch_screen':(context)=>const LaunchScreen(),
                    '/login_screen':(context)=>const LoginScreen(),
                    '/register_screen':(context)=>const RegisterScreen(),
                    '/product_screen':(context)=>const ProductScreen(),
                    '/product_add_screen':(context)=>const ProductsAddScreen(),
                    '/cart_screen' : (context)=>const CartScreen()
                  },
                );

            }
          );
        }
    );
  }
}
