import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'providers/feed_provider.dart';
import 'screens/home_feed_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // forces the status bar icons to be dark (black) on a white background
  // without this, status bar icons may appear white and be invisible
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // no colored status bar background
      statusBarIconBrightness:
          Brightness.dark, // dark icons on light background
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => FeedProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Instagram Clone',
        theme: ThemeData(
          brightness: Brightness.light,
          scaffoldBackgroundColor: Colors.white,
          // removes the default blue splash/highlight on icon buttons
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            elevation: 0,
            // makes the AppBar not push the status bar down with extra padding
            scrolledUnderElevation: 0,
          ),
          // makes BottomNavigationBar background pure white with no tint
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            backgroundColor: Colors.white,
            elevation: 1,
          ),
        ),
        home: const HomeFeedScreen(),
      ),
    );
  }
}
