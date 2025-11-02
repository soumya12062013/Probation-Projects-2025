import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  // static const List<Widget> _widgetOptions = <Widget>[
  //   Center(child: Text('This is my home screen')),
  //   Center(child: Text('This is the Weather screen')),
  //   Center(child: Text('This is the Yield % screen')),
  //   Center(child: Text('This is the Settings screen')),
  // ];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 23, 79, 25),
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsetsGeometry.all(5),
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
            Padding(
              padding: EdgeInsetsGeometry.fromLTRB(10, 5, 5, 5),
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
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsetsGeometry.all(5),
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
            SizedBox(height: 5),
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                'Lets get started',
                style: TextStyle(
                  fontWeight: FontWeight.w100,
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 5),
            Padding(
              padding: EdgeInsetsGeometry.all(5),
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
                    Positioned(
                      height: 70,
                      width: 200,
                      top: 20,
                      left: 10,
                      child: Card(
                        elevation: 7,
                        color: Colors.green.shade300,
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
                    Positioned(
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
                    //SizedBox(height: 30),
                    Positioned(
                      height: 70,
                      width: 200,
                      top: 140,
                      right: 20,
                      child: Card(
                        elevation: 7,
                        color: const Color.fromARGB(255, 100, 186, 104),
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
                    Positioned(
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
                    Positioned(
                      height: 70,
                      width: 200,
                      top: 270,
                      left: 20,
                      child: Card(
                        elevation: 7,
                        color: const Color.fromARGB(255, 42, 121, 46),
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
                    Positioned(
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
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          elevation: 7,
                          backgroundColor: const Color.fromARGB(
                            255,
                            40,
                            120,
                            186,
                          ),
                        ),
                        child: Text(
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
      ),

      bottomNavigationBar: BottomNavigationBar(
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

        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: const Color.fromARGB(255, 89, 165, 91),
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
