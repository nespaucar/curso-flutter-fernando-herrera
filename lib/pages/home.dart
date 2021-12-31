import 'dart:io';

import 'package:band_names/models/band.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<Band> bands = [
    Band(id: '1', name: 'Band 01', votes: 0),
    Band(id: '2', name: 'Band 02', votes: 0),
    Band(id: '3', name: 'Band 03', votes: 0),
    Band(id: '4', name: 'Band 04', votes: 0),
    Band(id: '5', name: 'Band 05', votes: 0)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: const Text('Band Names', style: TextStyle(color: Colors.black87)),
        backgroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: bands.length,
        itemBuilder: (context, i) => BandTile(bands[i])
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 1,
        child: const Icon(Icons.add),
        onPressed: addNewBand
      ),
    );
  }

  Widget BandTile(Band band) {
    return Dismissible(
      key: Key(band.id),
      direction: DismissDirection.startToEnd,
      onDismissed: (DismissDirection direction) {
        print("direction: $direction");
        print("id: ${band.id}");
        // LLamar el borrado en el web service
      },
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
        onTap: () {
          print(band.name);
        },
      )
    );
  }

  addNewBand() {

    final textController = new TextEditingController();

    if(Platform.isAndroid) {
      // Para Android
      return showDialog(
        context: context, 
        builder: (context) {
          return AlertDialog(
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
          );
        }
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
      this.bands.add(new Band(id: DateTime.now().toString(), name: name, votes: 0));
      setState(() {});
    }

    Navigator.pop(context);
  }
}