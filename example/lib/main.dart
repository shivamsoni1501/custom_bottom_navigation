import 'package:flutter/material.dart';
import 'package:custom_bottom_navigation/custom_bottom_navigation.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Custom Bottom Box Navigation Bar Example',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: const MyHomePage(title: 'Custom Bottom Box Bar'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int selectedPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.title),
      ),
      body: Center(
        child: Text('Page Index : $selectedPageIndex'),
      ),
      bottomNavigationBar: CustomBottomBoxBar(
        onIndexChange: (int val) {
          setState(() {
            selectedPageIndex = val;
          });
        },
        inicialIndex: selectedPageIndex,
        items: [
          CustomBottomBoxBarItem(Icons.home_filled, Text('Home')),
          CustomBottomBoxBarItem(Icons.home_max, Text('Max')),
          CustomBottomBoxBarItem(Icons.home_mini, Text('Mini')),
          CustomBottomBoxBarItem(Icons.work_outline_rounded, Text('Work')),
          CustomBottomBoxBarItem(Icons.person, Text('Profile')),
        ],
      ),
    );
  }
}
