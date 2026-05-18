import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        title: Text("Home Page"),
      ),

      body: Center(
        child: ElevatedButton(

          child: Text("Ke Halaman Profil"),

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

            SizedBox(height: 20),

            ElevatedButton(

              child: Text("Ke Halaman About"),

              onPressed: () {

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AboutPage(),
                  ),
                );

              },
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

class AboutPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 185, 15, 15),
      appBar: AppBar(
        title: Text("About Page"),
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Text(
              "Ini Halaman About",
              style: TextStyle(fontSize: 22),
            ),

            SizedBox(height: 20),

            ElevatedButton(

              child: Text("Kembali ke Profil"),

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