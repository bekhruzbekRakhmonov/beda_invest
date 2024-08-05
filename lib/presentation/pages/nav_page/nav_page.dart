import 'package:beda_invest/presentation/pages/home/home_page.dart';
import 'package:beda_invest/presentation/pages/portfolio/portfolio_page.dart';
import 'package:beda_invest/presentation/pages/profile/profile_page.dart';
import 'package:beda_invest/presentation/pages/share/shares_page.dart';
import 'package:flutter/material.dart';

class DashboardPage extends StatefulWidget {
  final int currentPage;

  const DashboardPage({super.key, required this.currentPage});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final PageStorageBucket bucket = PageStorageBucket();

  int currentTab = 0;
  Widget currentScreen = HomePage();
  final List<Widget> screens = [
    const HomePage(),
    const PortfolioPage(),
    const SharesPage(),
    const ProfilePage()
  ];

  @override
  void initState() {
    currentTab = widget.currentPage;
    currentTab == 2 ? currentScreen = const PortfolioPage() : const HomePage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageStorage(
        bucket: bucket,
        child: currentScreen,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentTab,
        onTap: (int index) {
          setState(() {
            currentScreen = screens[index];
            currentTab = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.graphic_eq_sharp), label: "Portfolio"),
          BottomNavigationBarItem(icon: Icon(Icons.share), label: "Share"),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_2_outlined), label: "Profile"),
        ],
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        unselectedFontSize: 11,
        selectedFontSize: 11,
      ),
    );
  }
}
