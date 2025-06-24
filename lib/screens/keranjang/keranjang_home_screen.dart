import 'package:flutter/material.dart';

class KeranjangHomeScreen extends StatefulWidget {
  const KeranjangHomeScreen({super.key});

  @override
  State<KeranjangHomeScreen> createState() => _KeranjangHomeScreen();
}

class _KeranjangHomeScreen extends State<KeranjangHomeScreen> {
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
