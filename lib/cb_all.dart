import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LocationPage(),
    );
  }
}

class LocationPage extends StatelessWidget {

  final List<Map<String, String>> lokasi = [

    {
      "nama": "Pantai Losari",
      "gambar":
      "https://picsum.photos/200/300?1",
      "deskripsi": "Tempat wisata terkenal di Makassar",

      "detail":
      "Pantai Losari merupakan salah satu ikon wisata "
      "terkenal di Kota Makassar yang menjadi pusat "
      "aktivitas masyarakat dan wisatawan. Kawasan ini "
      "menawarkan pemandangan laut yang indah terutama "
      "pada saat matahari terbenam. Selain menjadi tempat "
      "rekreasi, Pantai Losari juga menyediakan berbagai "
      "fasilitas umum seperti area kuliner, tempat duduk, "
      "jalur pedestrian, serta akses transportasi yang "
      "mudah dijangkau. Dengan konsep Location Based "
      "Service, pengguna aplikasi dapat memperoleh "
      "informasi lokasi wisata, jarak tempuh, dan rute "
      "menuju Pantai Losari secara real-time."
    },

    {
      "nama": "Rumah Sakit",
      "gambar":
      "https://picsum.photos/200/300?2",
      "deskripsi": "Layanan kesehatan masyarakat",

      "detail":
      "Rumah sakit merupakan fasilitas kesehatan yang "
      "memberikan pelayanan medis kepada masyarakat "
      "secara menyeluruh. Dalam implementasi aplikasi "
      "berbasis lokasi, rumah sakit dapat ditampilkan "
      "berdasarkan posisi pengguna sehingga membantu "
      "masyarakat menemukan layanan kesehatan terdekat "
      "dengan cepat. Informasi seperti alamat, nomor "
      "telepon, jam operasional, hingga navigasi lokasi "
      "dapat diintegrasikan ke dalam aplikasi Flutter "
      "untuk meningkatkan efektivitas pelayanan dan "
      "aksesibilitas pengguna."
    },

    {
      "nama": "Kampus",
      "gambar":
      "https://picsum.photos/200/300?3",
      "deskripsi": "Pusat pendidikan mahasiswa",

      "detail":
      "Kampus merupakan lingkungan pendidikan tinggi "
      "yang menjadi tempat berlangsungnya proses belajar "
      "mengajar, penelitian, dan pengembangan teknologi. "
      "Melalui teknologi Location Based Service, aplikasi "
      "mobile dapat membantu mahasiswa menemukan gedung "
      "perkuliahan, laboratorium, perpustakaan, maupun "
      "fasilitas kampus lainnya secara lebih mudah. "
      "Integrasi Flutter dengan fitur navigasi lokasi "
      "memberikan pengalaman penggunaan aplikasi yang "
      "lebih interaktif dan modern dalam mendukung "
      "aktivitas akademik mahasiswa."
    },

  ];

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: Text("ListView Navigation"),
      ),

      body: ListView.builder(

        itemCount: lokasi.length,

        itemBuilder: (context, index) {

          return Card(

            margin: EdgeInsets.all(10),

            elevation: 5,

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Image.network(
                  lokasi[index]['gambar']!,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),

                Padding(
                  padding: EdgeInsets.all(10),

                  child: Row(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,

                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,

                    children: [

                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [

                            Text(
                              lokasi[index]['nama']!,
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            SizedBox(height: 8),

                            Text(
                              lokasi[index]['deskripsi']!,
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),

                          ],
                        ),
                      ),

                      IconButton(

                        icon: Icon(
                          Icons.arrow_forward_ios,
                        ),

                        onPressed: () {

                          Navigator.push(

                            context,

                            MaterialPageRoute(

                              builder: (context) => DetailPage(
                                nama: lokasi[index]['nama']!,
                                gambar: lokasi[index]['gambar']!,
                                detail: lokasi[index]['detail']!,
                              ),
                            ),
                          );
                        },
                      )

                    ],
                  ),
                )

              ],
            ),
          );
        },
      ),
    );
  }
}

// HALAMAN DETAIL
class DetailPage extends StatelessWidget {

  final String nama;
  final String gambar;
  final String detail;

  DetailPage({
    required this.nama,
    required this.gambar,
    required this.detail,
  });

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: Text(nama),
      ),

      body: SingleChildScrollView(

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Image.network(
              gambar,
              width: double.infinity,
              height: 250,
              fit: BoxFit.cover,
            ),

            Padding(
              padding: EdgeInsets.all(20),

              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [

                  Text(
                    nama,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 20),

                  Text(
                    detail,
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontSize: 18,
                      height: 1.5,
                    ),
                  ),

                  SizedBox(height: 30),

                  ElevatedButton(

                    onPressed: () {

                      Navigator.pop(context);

                    },

                    child: Text("Kembali"),
                  )

                ],
              ),
            )

          ],
        ),
      ),
    );
  }
}