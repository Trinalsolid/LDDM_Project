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
      appBar: AppBar(
        title: Text("Mapa"),
      ),
      body: SfMaps(
        layers: [
          MapShapeLayer(
            source: _mapSource,
          ),
        ],
      ),
    );
  }
}
