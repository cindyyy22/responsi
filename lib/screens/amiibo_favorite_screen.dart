import 'package:flutter/material.dart';
import 'package:responsi_pam/network/amiibo_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:responsi_pam/models/amiibo_model.dart';
import 'package:responsi_pam/screens/detail_screen.dart';

class FavoriteScreen extends StatefulWidget {
  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  Set<Amiibo> favorites = {};

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  // Method to load favorites from SharedPreferences
  _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteHeads = prefs.getStringList('favorites') ?? [];

    List<Amiibo> favoriteAmiibos = [];
    for (String head in favoriteHeads) {
      try {
        // Use the service to get the Amiibo by head
        final amiibo = await AmiiboService ().getAmiiboByHead(head); // Fix service call

        favoriteAmiibos.add(amiibo);
      } catch (e) {
        continue;
      }
    }

    setState(() {
      favorites = favoriteAmiibos.toSet();
    });
  }

  // Method to remove favorite Amiibo
  _removeFavorite(Amiibo amiibo) async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteHeads = prefs.getStringList('favorites') ?? [];

    favoriteHeads.remove(amiibo.head);
    prefs.setStringList('favorites', favoriteHeads);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${amiibo.name} has been removed from favorites!'),
        duration: Duration(seconds: 2),
      ),
    );

    setState(() {
      favorites.remove(amiibo);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite Amiibos'),
      ),
      body: favorites.isEmpty
          ? Center(child: Text('No favorites yet.'))
          : ListView.builder(
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final amiibo = favorites.toList()[index];

                return Dismissible(
                  key: Key(amiibo.head),
                  direction: DismissDirection.horizontal,
                  onDismissed: (direction) {
                    _removeFavorite(amiibo);
                  },
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 16.0),
                      child: Icon(Icons.delete, color: Colors.white),
                    ),
                  ),
                  secondaryBackground: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: EdgeInsets.only(right: 16.0),
                      child: Icon(Icons.delete, color: Colors.white),
                    ),
                  ),
                  child: ListTile(
                    leading: Image.network(amiibo.imageUrl),
                    title: Text(amiibo.name),
                    subtitle: Text(amiibo.gameSeries),
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
              },
            ),
    );
  }
}
