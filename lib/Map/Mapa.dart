import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/services.dart'; // Para carregar arquivos
import 'package:geolocator/geolocator.dart'; // Para obter a localização

class Mapa extends StatefulWidget {
  @override
  _MapaState createState() => _MapaState();
}

class _MapaState extends State<Mapa> {
  bool _isLocationLoading = true;
  Map<String, dynamic>? _arboviroseData; // Para armazenar os dados de risco por estado
  Map<String, Color> _estadoColors = {}; // Para armazenar as cores dos estados
  String _selectedDisease = 'dengue'; // Doença selecionada (inicialmente 'dengue')
  String _userRegion = 'Carregando...'; // Região do usuário

  // Mapeamento do nome do estado para o ID no SVG
  final Map<String, String> _estadoIdMap = {
    "São Paulo": "BR-SP",
    "Rio de Janeiro": "BR-RJ",
    "Minas Gerais": "BR-MG",
    "Bahia": "BR-BA",
    "Pernambuco": "BR-PE",
    "Piauí": "BR-PI",
    "Maranhão": "BR-MA",
    "Rio Grande do Norte": "BR-RN",
    "Paraíba": "BR-PB",
    "Ceará": "BR-CE",
    "Paraná": "BR-PR",
    "Santa Catarina": "BR-SC",
    "Rio Grande do Sul": "BR-RS",
    "Goiás": "BR-GO",
    "Mato Grosso": "BR-MT",
    "Mato Grosso do Sul": "BR-MS",
    "Espírito Santo": "BR-ES",
    "Amazonas": "BR-AM",
    "Amapá": "BR-AP",
    "Pará": "BR-PA",
    "Acre": "BR-AC",
    "Rondônia": "BR-RO",
    "Tocantins": "BR-TO",
    "Roraima": "BR-RR",
    "Sergipe": "BR-SE",
    "Alagoas": "BR-AL",
    "Distrito Federal": "BR-DF"
  };

  @override
  void initState() {
    super.initState();
    _loadArboviroseData(); // Carregar os dados de risco
    _getUserLocation(); // Obter a localização do usuário
  }

  // Função para carregar o arquivo JSON com os dados de arboviroses
  Future<void> _loadArboviroseData() async {
    String jsonString = await rootBundle.loadString('assets/arbovirose_data.json');
    setState(() {
      _arboviroseData = jsonDecode(jsonString);
      _estadoColors = _getEstadoColors(_arboviroseData!, _selectedDisease); // Calcular as cores com base na doença selecionada
    });
  }

  // Função para calcular as cores dos estados com base no risco da doença selecionada
  Map<String, Color> _getEstadoColors(Map<String, dynamic> data, String disease) {
    Map<String, Color> estadoColors = {};

    data.forEach((estado, info) {
      // Soma dos casos da doença selecionada
      int totalCasos = info[disease];

      // Determinando a cor com base no total de casos
      if (totalCasos > 2000) {
        estadoColors[estado] = Colors.red; // Risco alto
      } else if (totalCasos > 1000) {
        estadoColors[estado] = Colors.orange; // Risco médio
      } else {
        estadoColors[estado] = Colors.green; // Risco baixo
      }
    });

    return estadoColors;
  }

  // Função para atualizar a doença selecionada e as cores do mapa
  void _onDiseaseChanged(String? disease) {
    setState(() {
      _selectedDisease = disease!;
      _estadoColors = _getEstadoColors(_arboviroseData!, _selectedDisease); // Atualiza as cores do mapa
    });
  }

  // Função para obter a localização do usuário
  Future<void> _getUserLocation() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    // Aqui você pode adicionar lógica para determinar a região com base na latitude e longitude
    setState(() {
      _userRegion = 'Localização: Latitude ${position.latitude}, Longitude ${position.longitude}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mapa do Brasil'),
      ),
      body: Center(
        child: _arboviroseData == null
            ? CircularProgressIndicator()
            : Stack(
                children: [
                  FutureBuilder<String>(
                    future: _loadSvgString(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Erro ao carregar o SVG');
                      } else if (snapshot.hasData) {
                        return SvgPicture.string(
                          snapshot.data!,
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                          fit: BoxFit.contain,
                        );
                      } else {
                        return Text('Erro desconhecido');
                      }
                    },
                  ),
                  Positioned(
                    top: 20,
                    left: 20,
                    child: Text(
                      _userRegion,
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                    left: 20,
                    child: Container(
                      padding: EdgeInsets.all(10),
                      color: Colors.white.withOpacity(0.7),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Legenda:', style: TextStyle(fontWeight: FontWeight.bold)),
                          Row(
                            children: [
                              Container(
                                width: 20,
                                height: 20,
                                color: Colors.red,
                              ),
                              SizedBox(width: 5),
                              Text('Risco Alto (acima de 2000 casos)', style: TextStyle(fontSize: 12)),
                            ],
                          ),
                          Row(
                            children: [
                              Container(
                                width: 20,
                                height: 20,
                                color: Colors.orange,
                              ),
                              SizedBox(width: 5),
                              Text('Risco Médio (entre 1000-2000 casos)', style: TextStyle(fontSize: 12)),
                            ],
                          ),
                          Row(
                            children: [
                              Container(
                                width: 20,
                                height: 20,
                                color: Colors.green,
                              ),
                              SizedBox(width: 5),
                              Text('Risco Baixo (abaixo de 1000 casos)', style: TextStyle(fontSize: 12)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 20,
                    right: 20,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      child: DropdownButton<String>(
                        value: _selectedDisease,
                        onChanged: _onDiseaseChanged,
                        dropdownColor: Colors.blue, // Background color of the dropdown
                        underline: Container(), // Remove underline
                        icon: Icon(Icons.arrow_downward, color: Colors.white),
                        items: [
                          DropdownMenuItem(value: 'dengue', child: Text('Dengue', style: TextStyle(color: Colors.white))),
                          DropdownMenuItem(value: 'zika', child: Text('Zika', style: TextStyle(color: Colors.white))),
                          DropdownMenuItem(value: 'chikungunya', child: Text('Chikungunya', style: TextStyle(color: Colors.white))),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  // Função para carregar o SVG e manipular as cores dos estados
  Future<String> _loadSvgString() async {
    String svgString = await rootBundle.loadString('assets/brazil.svg');
    
    // Substituindo as cores no SVG conforme os dados e adicionando borda preta
    _estadoColors.forEach((estado, color) {
      String? id = _estadoIdMap[estado];
      if (id != null) {
        svgString = svgString.replaceAll(
          'id="$id"',
          'id="$id" fill="#${color.value.toRadixString(16).substring(2)}" stroke="#000000" stroke-width="1"',
        );
      }
    });

    return svgString;
  }
}
