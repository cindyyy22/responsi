import 'package:flutter/material.dart';
import 'package:responsi_pam/models/amiibo_model.dart';

class DetailScreen extends StatelessWidget {
  final Amiibo amiibo;

  DetailScreen({required this.amiibo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(amiibo.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
           
            Image.network(amiibo.imageUrl),
            SizedBox(height: 20),
            
         
            Text(
              amiibo.name,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),

          
            Text(
              'Game Series: ${amiibo.gameSeries}',
              style: TextStyle(fontSize: 18, color: Colors.grey[700]),
            ),
            SizedBox(height: 10),

           
            Text(
              'Head: ${amiibo.head}',
              style: TextStyle(fontSize: 18, color: Colors.grey[700]),
            ),
          ],
        ),
      ),
    );
  }
}
