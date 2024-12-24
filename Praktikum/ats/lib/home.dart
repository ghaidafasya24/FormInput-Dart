import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFF075E54),
        elevation: 0,
      ),
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF075E54), // Hijau
                  Color(0xFF128C7E), // Hijau lebih cerah
                  Color(0xFFA8DADC), // Hijau pastel
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          // Profile card
          Align(
            alignment: Alignment.topCenter,
            child: Column(
              children: [
                SizedBox(height: 30),
                CircleAvatar(
                  radius: 60,
                  backgroundImage: AssetImage('images/ghaida.jpg'),
                ),
                SizedBox(height: 15),
                Text(
                  'Ghaida Fasya Yuthika Afifah',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'NPM: 714220031',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
                SizedBox(height: 30),
                // Profile details card
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ProfileDetailRow(
                        icon: Icons.class_rounded,
                        title: 'Kelas',
                        value: '3B',
                      ),
                      Divider(),
                      ProfileDetailRow(
                        icon: Icons.school_rounded,
                        title: 'Program Studi',
                        value: 'D4 Teknik Informatika',
                      ),
                      Divider(),
                      ProfileDetailRow(
                        icon: Icons.apartment_rounded,
                        title: 'Kampus',
                        value: 'Universitas Logistik dan Bisnis Internasional',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileDetailRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const ProfileDetailRow({
    Key? key,
    required this.icon,
    required this.title,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Color(0xFF075E54), size: 30), // Warna hijau
        SizedBox(width: 10),
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }
}
