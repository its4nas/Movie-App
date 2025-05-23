import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isSearching = false;

  Widget searchBar() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(36),
      ),
      child: TextField(
        onTap: () => setState(() => _isSearching = true),
        onSubmitted: (_) => setState(() => _isSearching = false),
        decoration: InputDecoration(
          hintText: 'Search',
          prefixIcon: const Icon(Icons.search),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (_isSearching) {
          setState(() => _isSearching = false);
          FocusScope.of(context).unfocus();
        }
      },
      child: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                height: _isSearching ? 50 : 0,
              ),
              searchBar(),
            ],
          ),
        ),
      ),
    );
  }
}