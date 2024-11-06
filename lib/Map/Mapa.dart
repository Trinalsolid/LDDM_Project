import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_maps/maps.dart';

class Mapa extends StatefulWidget {
  @override
  _MapaState createState() => _MapaState();
}

class _MapaState extends State<Mapa> {
  late MapShapeSource _mapSource;

  @override
  void initState() {
    super.initState();
    _mapSource = MapShapeSource.asset(
      'assets/brazil-states.geojson',
      shapeDataField: 'STATE_NAME',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100], // Altere o fundo do Scaffold para cinza claro
      appBar: AppBar(
        backgroundColor: Colors.grey[100], // Cor de fundo do AppBar
        title: Text("Mapa", style: TextStyle(color: Colors.black)), // Cor do título para visibilidade
      ),
      body: Container(
        color: Colors.grey[100], // Garante que o fundo do corpo também seja cinza claro
        child: SfMaps(
          layers: [
            MapShapeLayer(
              source: _mapSource,
            ),
          ],
        ),
      ),
    );
  }
}
