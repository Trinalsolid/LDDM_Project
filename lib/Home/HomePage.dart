import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // Import the url_launcher package
import '../news/noticias.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
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
              children: [
                Expanded(
                  child: _buildRectangularButton('Hospitals', Icons.local_hospital, Colors.red, context, "hospitals"),
                ),
                SizedBox(width: 10), // Space between buttons
                Expanded(
                  child: _buildRectangularButton('Postos de saúde', Icons.add_location_outlined, Colors.green, context, "health_centers"),
                ),
                SizedBox(width: 10), // Space between buttons
                Expanded(
                  child: _buildRectangularButton('Vacina', Icons.vaccines, Colors.orange, context, "vacinas"),
                ),
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
                  height: screenHeight * 0.55, // You can adjust the height as necessary
                  child: Noticias(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Function to open Google Maps with a search query
  Future<void> _launchMaps(String type) async {
    String query = '';
    if (type == "hospitals") {
      query = 'hospitals near me';
    } else if (type == "health_centers") {
      query = 'health centers near me';
    } else if (type == "vacinas") {
      query = 'vaccines near me';
    }

    final String googleMapsUrl = 'https://www.google.com/maps/search/?q=$query';
    
    if (await canLaunch(googleMapsUrl)) {
      await launch(googleMapsUrl);
    } else {
      throw 'Could not launch $googleMapsUrl';
    }
  }

  Widget _buildRectangularButton(String label, IconData icon, Color color, BuildContext context, String type) {
    return ElevatedButton(
      onPressed: () {
        _launchMaps(type); // Pass the type to the function to open the corresponding map search
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12), // Slightly rounded corners
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 36), // Increased icon size
          SizedBox(height: 8), // Adds spacing between the icon and text
          Text(label, style: TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}
