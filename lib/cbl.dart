import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        title: Text("Home Page"),
      ),

      body: Center(
        child: ElevatedButton(

          child: Text("Halaman Profil"),

          onPressed: () {

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProfilPage(),
              ),
            );

          },
        ),
      ),
    );
  }
}

class ProfilPage extends StatelessWidget {
  const ProfilPage({super.key});


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 21, 218, 11),
      appBar: AppBar(
        title: Text("Profil Page"),
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Text(
              "Ini Halaman Profil",
              style: TextStyle(fontSize: 22),
            ),

            

            SizedBox(height: 10),

            ElevatedButton(

              child: Text("Kembali ke Home"),

              onPressed: () {

                Navigator.pop(context);

              },
            )

          ],
        ),
      ),
    );
  }
}