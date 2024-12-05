
import 'package:flutter/material.dart';
import 'package:responsi_pam/models/amiibo_model.dart';
import 'package:responsi_pam/screens/detail_screen.dart';


class AmiiboTile extends StatelessWidget {
  final Amiibo amiibo;
  final Function()? onFavoriteTapped; 

  AmiiboTile({
    required this.amiibo,
    this.onFavoriteTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      elevation: 4.0,
      child: ListTile(
        leading: Image.network(amiibo.imageUrl),
        title: Text(amiibo.name),
        subtitle: Text(amiibo.gameSeries),
        trailing: IconButton(
          icon: Icon(Icons.favorite_border),
          onPressed: onFavoriteTapped,
        ),
        onTap: () {
        
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailScreen(amiibo: amiibo),
            ),
          );
        },
      ),
    );
  }
}
