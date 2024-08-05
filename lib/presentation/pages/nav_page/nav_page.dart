import 'package:beda_invest/presentation/pages/home/home_page.dart';
import 'package:beda_invest/presentation/pages/portfolio/portfolio_page.dart';
import 'package:beda_invest/presentation/pages/profile/profile_page.dart';
import 'package:beda_invest/presentation/pages/wallet/wallet_page.dart';
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
  Widget currentScreen = const HomePage();
  final List<Widget> screens = [
    const HomePage(),
    const WalletPage(),
    const PortfolioPage(),
    ProfilePage()
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
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_balance_wallet), label: 'Wallet'),
          BottomNavigationBarItem(
              icon: Icon(Icons.pie_chart), label: "Portfolio"),
          BottomNavigationBarItem(icon: Icon(Icons.person_2), label: "Profile"),
        ],
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        unselectedFontSize: 11,
        selectedFontSize: 11,
      ),
    );
  }
}
