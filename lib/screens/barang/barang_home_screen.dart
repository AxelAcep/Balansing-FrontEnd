import 'package:flutter/material.dart';

class BarangHomeScreen extends StatefulWidget {
  const BarangHomeScreen({super.key});

  @override
  State<BarangHomeScreen> createState() => _BarangHomeScreen();
}

class _BarangHomeScreen extends State<BarangHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Keranjang'),
        centerTitle: true,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 1,
            color: Colors.grey.withOpacity(0.5),
          ),
        ),
      ),
      body: Center(
        child: Text("Ini Keranjang"),
      ),
    );
  }
}
