import 'package:flutter/material.dart';

class PendaftaranHomeScreen extends StatefulWidget {
  const PendaftaranHomeScreen({super.key});

  @override
  State<PendaftaranHomeScreen> createState() => _PendaftaranHomeScreenState();
}

class _PendaftaranHomeScreenState extends State<PendaftaranHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Progres'),
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
        child: Text("Ini Pendaftaran"),
      ),
    );
  }
}
