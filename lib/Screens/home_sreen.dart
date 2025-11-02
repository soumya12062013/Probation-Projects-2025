import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // 1. STATE VARIABLE: To track the currently selected tab
  int _selectedIndex = 0;

  // 2. WIDGET LIST: A list of widgets to display for each tab
  static const List<Widget> _widgetOptions = <Widget>[
    Center(child: Text('This is my home screen')),
    Center(child: Text('This is the Weather screen')),
    Center(child: Text('This is the Yield % screen')),
    Center(child: Text('This is the Settings screen')),
  ];

  // 3. ON-TAP HANDLER: Function to update the state when a tab is tapped
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 89, 165, 91),
        title: const Text(
          'Agrisense',
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: Center(
              child: Text(
                'Home',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontWeight: FontWeight.w300,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
      // 4. UPDATE BODY: Show the widget from the list based on the selected index
      body: _widgetOptions.elementAt(_selectedIndex),

      bottomNavigationBar: BottomNavigationBar(
        // 5. ITEMS: Your list of navigation items
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.wb_sunny), label: 'Weather'),
          BottomNavigationBarItem(
            icon: Icon(Icons.percent_outlined),
            label: 'Yield %',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],

        // 6. REQUIRED PROPERTIES:
        currentIndex: _selectedIndex, // Tells the bar which item is active
        onTap: _onItemTapped, // Calls your function when an item is tapped
        // 7. STYLING: Added to make sure it looks good and labels are visible
        selectedItemColor: const Color.fromARGB(
          255,
          89,
          165,
          91,
        ), // Match your AppBar color
        unselectedItemColor: Colors.grey, // Color for inactive tabs
        showUnselectedLabels:
            true, // Ensures all labels are visible, not just the active one
        type: BottomNavigationBarType
            .fixed, // Fixes layout issue when you have 4+ items
      ),
    );
  }
}
