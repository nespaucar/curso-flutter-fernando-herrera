import 'package:band_names/services/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class StatusPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final socketProvider = Provider.of<SocketService>(context);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Estado del Server: ${socketProvider.serverStatus}'),
          ],
        ),
     ),
     floatingActionButton: FloatingActionButton(
       child: Icon(Icons.message),
       elevation: 1,
       onPressed: () => {
         socketProvider.socket.emit("emitir-mensaje", "Mensaje de Flutter a Web")
       }
     )
   );
  }
}