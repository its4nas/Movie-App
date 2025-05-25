import 'package:flutter/material.dart';
import 'package:movie_app/screens/pages/home_page.dart';
import 'package:movie_app/screens/pages/top_rated_movies_page.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  static const Color primaryColor = Color.fromARGB(255, 214, 28, 28);
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _pageController = PageController(initialPage: 0);
  int _selectedIndex = 0;

  
  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      drawer: Drawer(
          backgroundColor: const Color.fromARGB(255, 45, 45, 45),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              Container(
                height: 40, // Shorter header
                decoration: BoxDecoration(
                  color: HomeScreen.primaryColor,
                ),
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 16),
                leading: Icon(Icons.home, color: HomeScreen.primaryColor),
                title: Text('Home', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              // Add more ListTiles for other drawer items
            ],
          ),
        ),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text('Movie App', style: TextStyle(color: Colors.white)),
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.white),
          actions: [
            IconButton(
              onPressed: () {
                // Add your action here
              },
              icon: Icon(Icons.notifications, color: Colors.white),
            ),
          ],
        ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: [
          Container(
            child: HomePage(),
          ),
          Center(
            child: TopRatedMoviesPage(),
          )
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
            _pageController.animateToPage(
              index,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          });
        },
      ),
    );
  }
}

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 30),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(60),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _buildNavItem(Icons.home, 0),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _buildNavItem(Icons.book, 1),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _buildNavItem(Icons.favorite, 2),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _buildNavItem(Icons.person, 3),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _buildNavItem(Icons.search, 4),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, int index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: currentIndex == index ? HomeScreen.primaryColor : Colors.transparent,
      ),
      child: IconButton(
        icon: Icon(
          icon,
          color: currentIndex == index ? Colors.white : Colors.grey[600],
          size: 35,
        ),
        onPressed: () => onTap(index),
      ),
    );
  }
}
