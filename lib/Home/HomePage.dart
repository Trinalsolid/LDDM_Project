import 'package:flutter/material.dart';
import '../gpt/chatScreen.dart'; // Assuming you have the ChatScreen in its own file.

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'Pesquisar',
                prefixIcon: Icon(Icons.search),
                suffixIcon: Icon(Icons.close),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildIconButton('Hospitals', Icons.local_hospital, Colors.red),
                _buildIconButton('Mapa', Icons.map, Colors.green),
                _buildIconButton('Vacina', Icons.vaccines, Colors.orange),
              ],
            ),
            SizedBox(height: 20),
            // Here we add ChatScreen inside a Card
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  height: 350, // You can adjust the height as necessary
                  child: ChatScreen(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconButton(String label, IconData icon, Color color) {
    return Column(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: Colors.grey[100],
          child: Icon(icon, color: color, size: 30),
        ),
        SizedBox(height: 5),
        Text(label),
      ],
    );
  }
}
