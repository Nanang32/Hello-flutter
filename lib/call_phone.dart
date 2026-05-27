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

  // FUNGSI PANGGILAN
  Future<void> panggilNomor() async {

    final Uri telepon = Uri(
      scheme: 'tel',
      path: '08123456789',
    );

    await launchUrl(telepon);
  }

  // FUNGSI SMS
  Future<void> kirimPesan() async {

    final Uri sms = Uri(
      scheme: 'sms',
      path: '08123456789',
      queryParameters: {
        'body': 'Halo Admin, saya ingin bertanya.'
      },
    );

    await launchUrl(sms);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: Text("Fitur Panggilan dan SMS"),
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

              onPressed: kirimPesan,

              child: Text("Kirim SMS"),
            ),

          ],
        ),
      ),
    );
  }
}