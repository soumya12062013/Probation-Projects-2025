import 'package:flutter/material.dart';
import 'bottom_navBar.dart';
import 'disease_detectionscreen.dart';
import 'results_screen.dart';
import 'yield_screen.dart';
import 'health_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void _onTabSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _screens = [
    const HomeContent(),
    const DiseaseDetectionScreen(),
    const CropHealthAnalysis(),
    const CropYieldForm(),
    const ReportsScreen(),

    // Center(
    //   child: Text(
    //     'Yield Data Coming Soon...',
    //     style: TextStyle(fontSize: 20, color: Colors.black),
    //   ),
    // ),
    // Center(
    //   child: Text(
    //     'Reports Section',
    //     style: TextStyle(fontSize: 20, color: Colors.black),
    //   ),
    // ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 23, 79, 25),

      // appBar: AppBar(
      //   backgroundColor: const Color.fromARGB(255, 89, 165, 91),
      //   title: const Text(
      //     'Agrisense',
      //     style: TextStyle(
      //       fontSize: 20,
      //       color: Colors.white,
      //       fontWeight: FontWeight.bold,
      //     ),
      //   ),

      // ),
      body: _screens[_selectedIndex],

      bottomNavigationBar: BottomNavigation(
        currentIndex: _selectedIndex,
        onTabSelected: _onTabSelected,
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.all(5),
            child: Text(
              'Welcome !',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: 'cursive',
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(10, 5, 5, 5),
            child: Text(
              'Empowering Farmers with \nthe power of AI',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w300,
                color: Colors.white,
                fontFamily: 'cursive',
              ),
            ),
          ),
          const SizedBox(height: 10),
          const Padding(
            padding: EdgeInsets.all(5),
            child: Text(
              'Find the Health of your crop in 3 easy steps',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25,
                color: Colors.white,
                fontFamily: 'cursive',
              ),
            ),
          ),
          const SizedBox(height: 5),
          Container(
            alignment: Alignment.centerLeft,
            child: const Text(
              'Let’s get started',
              style: TextStyle(
                fontWeight: FontWeight.w100,
                fontSize: 20,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.all(5),
            child: Card(
              elevation: 7,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              clipBehavior: Clip.antiAlias,
              child: Stack(
                children: [
                  Image.asset(
                    'Assets/Images/background.jpg',
                    fit: BoxFit.cover,
                    height: 600,
                    width: 375,
                  ),
                  const Positioned(
                    height: 70,
                    width: 200,
                    top: 20,
                    left: 10,
                    child: Card(
                      elevation: 7,
                      color: Color.fromARGB(255, 89, 165, 91),
                      child: Center(
                        child: Text(
                          'Select the affected crop',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontFamily: 'cursive',
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Positioned(
                    top: 30,
                    right: 10,
                    child: Text(
                      'Step 01',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 36,
                      ),
                    ),
                  ),
                  const Positioned(
                    height: 70,
                    width: 200,
                    top: 140,
                    right: 20,
                    child: Card(
                      elevation: 7,
                      color: Color.fromARGB(255, 100, 186, 104),
                      child: Center(
                        child: Text(
                          'Upload image of leaf',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontFamily: 'cursive',
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Positioned(
                    top: 150,
                    left: 20,
                    child: Text(
                      'Step 02',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 36,
                      ),
                    ),
                  ),
                  const Positioned(
                    height: 70,
                    width: 200,
                    top: 270,
                    left: 20,
                    child: Card(
                      elevation: 7,
                      color: Color.fromARGB(255, 42, 121, 46),
                      child: Center(
                        child: Text(
                          'Get results instantly',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontFamily: 'cursive',
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Positioned(
                    top: 280,
                    right: 20,
                    child: Text(
                      'Step 03',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 36,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 170,
                    left: 150,
                    child: ElevatedButton(
                      onPressed: () {
                        // Navigate to scan/disease detection screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const DiseaseDetectionScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 7,
                        backgroundColor: const Color.fromARGB(
                          255,
                          40,
                          120,
                          186,
                        ),
                      ),
                      child: const Text(
                        'Start',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
