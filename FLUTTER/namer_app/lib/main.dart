import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]).then((_) {
    runApp(MyApp());
  });
}
 
class MyApp extends StatelessWidget {
  const MyApp({super.key});
 
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      
      child: MaterialApp(
        title: 'Namer App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        ),
        home: MyHomePage(),
      ),
    );
  }
}
 
class MyAppState extends ChangeNotifier {
  var current = WordPair.random();
  late List<WordPair> favorites;
  var initialized = false;

  static String _wordPairsToJson(List<WordPair> favorites) {
    return json.encode(
      favorites.map((pair) => {'first': pair.first, 'second': pair.second}).toList(),
    );
  }

  static List<WordPair> _wordPairsFromJson(String jsonStr) {
    final List<dynamic> list = json.decode(jsonStr);
    return list.map((item) => WordPair(item['first'], item['second'])).toList();
  }

  Future<void> init() async {
    if (initialized) {
      return;
    }

    final storage = await SharedPreferences.getInstance();
    final data = storage.getString('favorites');

    if (data == null) {
      favorites = <WordPair>[];
    } else {
      favorites = _wordPairsFromJson(data);
    }

    initialized = true;
  }

  Future<bool> _saveToStorage() async {
    var storage = await SharedPreferences.getInstance();
    return await storage.setString('favorites', _wordPairsToJson(favorites));
  }

  void getNext() {
    current = WordPair.random();
    notifyListeners();
  }

  void toggleFavorite() {
    if (favorites.contains(current)) {
      favorites.remove(current);
    } else {
      favorites.add(current);
    }
    _saveToStorage();
    notifyListeners();
  }

  void removeFavorite(WordPair pair) {
    favorites.remove(pair);
    _saveToStorage();
    notifyListeners();
  }
}

 
class GeneratorPage extends StatelessWidget {
  const GeneratorPage({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    
    var pair = appState.current;
 
    IconData icon;
    if (appState.favorites.contains(pair)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }
 
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BigCard(pair: pair),
          SizedBox(height: 10.0),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  appState.toggleFavorite();
                },
                icon: Icon(icon),
                label: Text("J'aime"),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  appState.getNext();
                },
                child: Text('Suivant'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
 
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}
 
class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;
  Future<void>? initializer;

  @override
  void initState() {
    super.initState();
    var appState = context.read<MyAppState>();
    initializer = appState.init();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: initializer,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        return LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth > 600) {
              return Scaffold(
                body: SafeArea(
                  child: Row(
                    children: [
                      NavigationRail(
                        selectedIndex: selectedIndex,
                        onDestinationSelected: (index) {
                          setState(() {
                            selectedIndex = index;
                          });
                        },
                        destinations: [
                          NavigationRailDestination(
                            icon: Icon(Icons.home),
                            label: Text('Accueil'),
                          ),
                          NavigationRailDestination(
                            icon: Icon(Icons.favorite),
                            label: Text('Favoris'),
                          ),
                        ],
                      ),
                      Expanded(child: _getPage(selectedIndex)),
                    ],
                  ),
                ),
              );
            } else {
              return Scaffold(
                body: _getPage(selectedIndex),
                bottomNavigationBar: BottomNavigationBar(
                  items: [
                    BottomNavigationBarItem(
                        icon: Icon(Icons.home), label: 'Accueil'),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.favorite), label: 'Favoris'),
                  ],
                  currentIndex: selectedIndex,
                  onTap: (value) {
                    setState(() {
                      selectedIndex = value;
                    });
                  },
                ),
              );
            }
          },
        );
      },
    );
  }

  Widget _getPage(int index) {
    switch (index) {
      case 0:
        return GeneratorPage();
      case 1:
        return FavoritesPage();
      default:
        return GeneratorPage();
    }
  }
}

 
class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    if (appState.favorites.isEmpty) {
      return Center(child: Text("Aucun favori enregistré."));
    }

    return ListView(
      children: [
        for (var pair in appState.favorites)
          ListTile(
            leading: Icon(Icons.favorite),
            title: Text(pair.asPascalCase),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                appState.removeFavorite(pair);
              },
            ),
          ),
      ],
    );
  }
}
 
class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.pair,
  });
 
  final WordPair pair;
 
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );
 
    return Card(
      color: theme.colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(
          pair.asLowerCase,
          style: style,
          semanticsLabel: pair.asPascalCase,
        ),
      ),
    );
  }
}