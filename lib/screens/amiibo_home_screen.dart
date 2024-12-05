import 'package:flutter/material.dart';
import 'package:responsi_pam/widget/amiibo_tile_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:responsi_pam/screens/amiibo_favorite_screen.dart';
import 'package:responsi_pam/models/amiibo_model.dart';
import 'package:responsi_pam/network/amiibo_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Amiibo>> amiiboList;
  Set<Amiibo> favorites = {};
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    amiiboList = AmiiboService().getAmiiboList();  
    _loadFavorites();
  }

  
  _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteHeads = prefs.getStringList('favorites') ?? [];
    setState(() {
      favorites = favoriteHeads
          .map((head) => Amiibo(head: head, name: '', gameSeries: '', imageUrl: ''))
          .toSet();
    });
  }

  // Toggle favorite status of Amiibo
  _toggleFavorite(Amiibo amiibo) async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteHeads = prefs.getStringList('favorites') ?? [];

    if (favorites.contains(amiibo)) {
      favoriteHeads.remove(amiibo.head);
      setState(() {
        favorites.remove(amiibo);
      });
    } else {
      favoriteHeads.add(amiibo.head);
      setState(() {
        favorites.add(amiibo);
      });
    }

    prefs.setStringList('favorites', favoriteHeads);
  }

  // Handle navigation item tap
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nintendo Amiibo')),
      body: _selectedIndex == 0
          ? FutureBuilder<List<Amiibo>>(
              future: amiiboList,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No data available'));
                } else {
                  final amiibo = snapshot.data!;
                  return ListView.builder(
                    itemCount: amiibo.length,
                    itemBuilder: (context, index) {
                      final amiibo = Amiibo [index];
                      return AmiiboTile(
                        amiibo: amiibo,
                        onFavoriteTap: (amiibo) => _toggleFavorite(amiibo),
                      );
                    },
                  );
                }
              },
            )
          : FavoriteScreen(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
        ],
      ),
    );
  }
}

