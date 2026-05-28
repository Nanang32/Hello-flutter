import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {

  // FUNGSI TELEPON
  Future<void> panggilNomor() async {

    final Uri telepon = Uri(
      scheme: 'tel',
      path: '08123456789',
    );

    await launchUrl(telepon);
  }

  // FUNGSI WHATSAPP
  Future<void> bukaWhatsApp() async {

    final Uri whatsapp = Uri.parse(
      'https://wa.me/6281343535034?text=Halo%20Admin'
    );

    await launchUrl(
      whatsapp,
      mode: LaunchMode.externalApplication,
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: Text("Telepon dan WhatsApp"),
      ),

      body: Center(

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            ElevatedButton(

              onPressed: panggilNomor,

              child: Text("Hubungi"),
            ),

            SizedBox(height: 20),

            ElevatedButton(

              onPressed: bukaWhatsApp,

              child: Text("Chat WhatsApp"),
            ),

          ],
        ),
      ),
    );
  }
}