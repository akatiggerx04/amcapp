import 'package:amcapp/pages/gallery_page.dart';
import 'package:amcapp/pages/home_page.dart';
import 'package:amcapp/pages/more_page.dart';
import 'package:amcapp/pages/news_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 0, 50, 2),
          brightness: Brightness.dark,
        ),
        brightness: Brightness.dark,
      ),
      themeMode: ThemeMode.dark,
      title: "African Minifootball",
      home: AMCApp(),
    );
  }
}

class AMCApp extends StatefulWidget {
  const AMCApp({super.key});

  @override
  State<AMCApp> createState() => _AMCAppState();
}

class _AMCAppState extends State<AMCApp> {
  int _selectedIndex = 0;

  void _navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List _pages = const [
    HomePage(),
    NewsPage(),
    GalleryPage(),
    MorePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(
              color: Colors.grey.shade700.withOpacity(0.5),
              width: 0.3,
            ),
          ),
        ),
        child: NavigationBar(
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          height: 70,
          selectedIndex: _selectedIndex,
          onDestinationSelected: _navigateBottomBar,
          destinations: const [
            NavigationDestination(
              icon: Icon(
                Icons.home,
                weight: 500,
              ),
              label: "Home",
            ),
            NavigationDestination(
              icon: Icon(
                Icons.newspaper,
              ),
              label: "News",
            ),
            NavigationDestination(
              icon: Icon(
                Icons.image,
                weight: 500,
              ),
              label: "Gallery",
            ),
            NavigationDestination(
              icon: Icon(Icons.more_horiz_rounded),
              label: "More",
            ),
          ],
        ),
      ),
      body: _pages[_selectedIndex],
    );
  }
}
