import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: KalkulatorPage(),
    );
  }
}

class KalkulatorPage extends StatefulWidget {
  @override
  _KalkulatorPageState createState() => _KalkulatorPageState();
}

class _KalkulatorPageState extends State<KalkulatorPage> {

  TextEditingController angka1 = TextEditingController();
  TextEditingController angka2 = TextEditingController();

  int hasil = 0;

  void hitungPenjumlahan() {
    int a = int.parse(angka1.text);
    int b = int.parse(angka2.text);

    setState(() {
      hasil = a + b;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Kalkulator Sederhana"),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [

            TextField(
              controller: angka1,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Masukkan Angka Pertama",
                border: OutlineInputBorder(),
              ),
            ),

            SizedBox(height: 20),

            TextField(
              controller: angka2,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Masukkan Angka Kedua",
                border: OutlineInputBorder(),
              ),
            ),

            SizedBox(height: 20),

            ElevatedButton(
              onPressed: hitungPenjumlahan,
              child: Text("Hitung"),
            ),

            SizedBox(height: 20),

            Text(
              "Hasil: $hasil",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            )

          ],
        ),
      ),
    );
  }
}