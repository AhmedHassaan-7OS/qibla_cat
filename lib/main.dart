import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:hive_flutter/hive_flutter.dart'; // إضافة Hive
import 'screen/qiblah_screen.dart';
import 'package:qibla_task/screen/prayer_times_screen.dart';
import 'screen/settings_screen.dart';

void main() async {
WidgetsFlutterBinding.ensureInitialized(); 
  await Hive.initFlutter();
  await Hive.openBox('settingsBox'); 
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDarkMode = false;

  @override
  void initState() {
    super.initState();
    // استرجاع حالة الوضع المظلم من Hive
    final settingsBox = Hive.box('settingsBox');
    isDarkMode = settingsBox.get('darkMode', defaultValue: false);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Prayer Times App',
      debugShowCheckedModeBanner: false,
      theme: isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: HomeScreen(
        toggleDarkMode: () {
          setState(() {
            isDarkMode = !isDarkMode;
            // حفظ حالة الوضع المظلم في Hive
            final settingsBox = Hive.box('settingsBox');
            settingsBox.put('darkMode', isDarkMode);
          });
        },
        isDarkMode: isDarkMode,
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  final VoidCallback toggleDarkMode;
  final bool isDarkMode;

  const HomeScreen({required this.toggleDarkMode, required this.isDarkMode, Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  late final List<Widget> _pages = [
    const PrayerTimesScreen(),
    const QiblahScreen(),
    SettingsScreen(
      toggleDarkMode: widget.toggleDarkMode,
      isDarkMode: widget.isDarkMode,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: SalomonBottomBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          SalomonBottomBarItem(
            icon: const Icon(Icons.access_time),
            title: const Text("Prayer Times"),
            selectedColor: Colors.blue,
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.compass_calibration),
            title: const Text("Qiblah"),
            selectedColor: Colors.green,
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.settings),
            title: const Text("Settings"),
            selectedColor: Colors.orange,
          ),
        ],
      ),
    );
  }
}