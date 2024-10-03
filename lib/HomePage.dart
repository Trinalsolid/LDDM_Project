import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Health App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
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
          Text(
            'Notícias',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildNewsCard(
                    title:
                        'Fortalecimento da saúde indígena é tema em comissão na Câmara',
                    content:
                        'Durante audiência, secretário da Sesai destacou avanços e desafios em um ano e meio de trabalho.',
                    tags: 'saúde indígena, missão yanomami, povos originários',
                    date: '28/08/2024 17h00',
                  ),
                  SizedBox(height: 20),
                  _buildNewsCard(
                    title:
                        'Tecnologia de ponta é apresentada em feira de inovações',
                    content:
                        'Especialistas discutem o futuro da inteligência artificial e suas aplicações no mercado brasileiro.',
                    tags: 'IA, inovações tecnológicas, futuro digital',
                    date: '15/08/2024 11h30',
                  ),
                  SizedBox(height: 20),
                  _buildNewsCard(
                    title:
                        'Plano de infraestrutura é aprovado em comissão do Senado',
                    content:
                        'O projeto visa melhorar a logística de transporte e comunicação em áreas remotas do país.',
                    tags: 'infraestrutura, logística, desenvolvimento regional',
                    date: '10/08/2024 09h45',
                  ),
                  SizedBox(height: 20),
                  _buildNewsCard(
                    title: 'Educação ambiental ganha força em escolas públicas',
                    content:
                        'Programa visa conscientizar jovens sobre a importância da preservação ambiental.',
                    tags: 'educação, preservação ambiental, sustentabilidade',
                    date: '05/08/2024 14h20',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton(String label, IconData icon, Color color) {
    return Column(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: Colors.grey[200],
          child: Icon(icon, color: color, size: 30),
        ),
        SizedBox(height: 5),
        Text(label),
      ],
    );
  }

  Widget _buildNewsCard({
    required String title,
    required String content,
    required String tags,
    required String date,
  }) {
    return Card(
      color: const Color.fromARGB(255, 243, 240, 255),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(content),
            SizedBox(height: 10),
            Text(
              'tags: $tags',
              style: TextStyle(color: Colors.blue),
            ),
            SizedBox(height: 10),
            Text('Publicado: $date Notícia'),
          ],
        ),
      ),
    );
  }
}
