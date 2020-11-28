import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final Dio _dio = Dio();
  final String _url = 'http://10.0.0.176:3338/check';
  List _funcionarios = [
    'Emilson Lima',
    'Walmir Carvalho',
    'Moises',
    'Ricardo',
    'Filipe Nogueira',
    'Pablo Costa'
  ];
  List<DropdownMenuItem<String>> _dropDownMenuItems;
  String _setCurrentFuncionario;
  String codeScannerValue = '';
  String _numped = '';
  String _posicao = '';

  Future<void> postNumped() async {
    await _dio.post(_url, data: {
      "nome": _setCurrentFuncionario,
      "numped": _numped,
      "posicao": _posicao
    });
  }

  Future<void> getBarcode() async {
    codeScannerValue = await FlutterBarcodeScanner.scanBarcode(
      "#ff6666",
      "Canclear",
      false,
      ScanMode.DEFAULT,
    );

    if (codeScannerValue == '-1') codeScannerValue = '';

    setState(() {
      _numped = codeScannerValue;
    });
  }

  String horaFormat = DateFormat.HOUR24_MINUTE_SECOND;
  String _hrinico;

  @override
  void initState() {
    _hrinico = '';
    _dropDownMenuItems = getDropDownMenuItems();
    _setCurrentFuncionario = _dropDownMenuItems[0].value;
    super.initState();
  }

  List<DropdownMenuItem<String>> getDropDownMenuItems() {
    List<DropdownMenuItem<String>> items = new List();
    for (String funcionario in _funcionarios) {
      items.add(new DropdownMenuItem(
          value: funcionario,
          child: new Text(
            funcionario,
            style: TextStyle(fontSize: 25),
          )));
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Produtividade embalador'),
      ),
      body: Container(
        child: Column(
          children: [
            Center(
              child: Container(
                height: 50,
                child: DropdownButton(
                  value: _setCurrentFuncionario,
                  icon: Icon(Icons.arrow_downward),
                  iconSize: 20,
                  elevation: 16,
                  items: _dropDownMenuItems,
                  onChanged: changedDropDownItem,
                  isExpanded: false,
                  style: TextStyle(color: Colors.redAccent),
                ),
              ),
            ),
            Container(
                margin: EdgeInsets.only(top: 10),
                child: Text(
                  '$_numped $_hrinico',
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),
            Divider(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orangeAccent,
        child: Icon(
          Icons.add_circle_outline,
          size: 28,
        ),
        onPressed: () async {
          await getBarcode();
          var min = DateTime.now().minute;
          var hor = DateTime.now().hour;
          var sec = DateTime.now().second;
          String horAtual = ('$hor:$min:$sec');

          if (_setCurrentFuncionario != '') {
            postNumped();
          }

          setState(() {
            _hrinico = horAtual;
          });
        },
      ),
    );
  }

  void changedDropDownItem(String selectFuncionario) {
    setState(() {
      _setCurrentFuncionario = selectFuncionario;
    });
  }
}
