import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';

import 'package:band_names/models/band.dart';
import 'package:band_names/services/socket_service.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<Band> bands = [
    // Band(id: '1', name: 'Band 01', votes: 0),
    // Band(id: '2', name: 'Band 02', votes: 0),
    // Band(id: '3', name: 'Band 03', votes: 0),
    // Band(id: '4', name: 'Band 04', votes: 0),
    // Band(id: '5', name: 'Band 05', votes: 0)
  ];

  @override
  void initState() {
    final socketService = Provider.of<SocketService>(context, listen: false);

    socketService.socket.on('active-bands', _handleActiveBands);
    super.initState();
  }

  _handleActiveBands(dynamic payload) {
    this.bands = (payload as List)
      .map((band) => Band.fromMap(band))
      .toList();
    setState(() {});
  }

  @override
  void dispose() {
    final socketService = Provider.of<SocketService>(context, listen: false);
    socketService.socket.off('active-bands');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {    

    final socketService = Provider.of<SocketService>(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        actions: [
          Container(
            margin: EdgeInsets.only(right: 10),
            child: (socketService.serverStatus == ServerStatus.Online) 
              ? Icon(Icons.check_circle, color: Colors.green):
              Icon(Icons.offline_bolt, color: Colors.red),
          )
        ],
        title: const Text('Band Names', style: TextStyle(color: Colors.black87)),
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          _showGraph(),
          Expanded(
            child: ListView.builder(
              itemCount: bands.length,
              itemBuilder: (context, i) => BandTile(bands[i])
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 1,
        child: const Icon(Icons.add),
        onPressed: addNewBand
      ),
    );
  }

  Widget BandTile(Band band) {

    final socketService = Provider.of<SocketService>(context);

    return Dismissible(
      key: Key(band.id),
      direction: DismissDirection.startToEnd,
      onDismissed: ( _ ) => socketService.socket.emit('delete-band', {'id': band.id}),
      background: Container(
        padding: EdgeInsets.only(left: 8.0),
        color: Colors.red,
        child: Align(
          alignment: Alignment.centerLeft,
          child: ListTile(
            leading: Icon(Icons.delete, color: Colors.white,),
            title: Text("Delete Band", style: TextStyle(color: Colors.white)),
          )
        )
      ),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(band.name.substring(0, 2)),
          backgroundColor: Colors.blue[100],
        ),
        title: Text(band.name),
        trailing: Text('${band.votes}', style: TextStyle(fontSize: 20)),
        onTap: () => socketService.socket.emit('vote-band', {'id': band.id}),
      )
    );
  }

  addNewBand() {

    final textController = new TextEditingController();

    if(Platform.isAndroid) {
      // Para Android
      return showDialog(
        context: context, 
        builder: (context) => AlertDialog(
          title: Text('new Band Name: '),
          content: TextField(
            controller: textController
          ),
          actions: <Widget> [
            MaterialButton(
              child: Text('Add'),
              elevation: 5,
              textColor: Colors.blue,
              onPressed: () => addBandToList(textController.text)
            ),
            MaterialButton(
              child: Text('Dismiss'),
              elevation: 5,
              textColor: Colors.blue,
              onPressed: () => Navigator.pop(context)
            )
          ]
        )
      );
    }

    if(Platform.isIOS) {
      showCupertinoDialog(
        context: context, 
        builder: ( _ ) => CupertinoAlertDialog(
          title: Text("New Band Name"),
          content: CupertinoTextField(
            controller: textController,
          ),
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              child: Text("Add"),
              onPressed: () => addBandToList(textController.text),          
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              child: Text("Dismiss"),
              onPressed: () => Navigator.pop(context),          
            )
          ],
        )
      );
    }
  }

  void addBandToList(String name) {
    if(name.length > 1) {
      //this.bands.add(new Band(id: DateTime.now().toString(), name: name, votes: 0));
      //setState(() {});
      final socketService = Provider.of<SocketService>(context, listen: false);
      socketService.socket.emit('add-band', {'name': name});
    }

    Navigator.pop(context);
  }

  Widget _showGraph() {
    Map<String, double> dataMap = new Map();
    //{
      //'Flutter': 5,
      //'React': 3,
      //'Xamarin': 2,
      //'Ionic': 2,
    //};
    bands.forEach((band) {
      // dataMap[band.name] = band.votes.toDouble();
      dataMap.putIfAbsent(band.name, () => band.votes.toDouble());
    });
    return Container(
      width: double.infinity,
      height: 200,
      child: PieChart(
        centerText: "BANDS",
        dataMap: dataMap,
        chartValuesOptions: ChartValuesOptions(
          decimalPlaces: 0,
        ),
      )
    );
  }
}