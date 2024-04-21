
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Star Wars App',
      theme: ThemeData(
        secondaryHeaderColor: Colors.yellow,
        scaffoldBackgroundColor: Colors.black,
        textTheme: TextTheme(
          bodyMedium: TextStyle(color: Colors.white),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.yellow,
        ), colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.yellow).copyWith(background: Colors.black),
      ),
      home: PlanetsPage(),
    );
  }
}

//-----Page Planets-----//

class PlanetsPage extends StatefulWidget {
  @override
  _PlanetsPageState createState() => _PlanetsPageState();
}

class _PlanetsPageState extends State<PlanetsPage> {
  late Future<List<dynamic>> planets;

  //-Récupération données api-//
  Future<List<dynamic>> fetchPlanets() async {
    try {
      var response = await Dio().get('https://swapi.py4e.com/api/planets');
      return response.data['results'];
    } catch (error) {
      throw Exception('Failed to load planets: $error');
    }
  }

  @override
  void initState() {
    super.initState();
    planets = fetchPlanets();
  }

  //-Contenue Page planet-//
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'PLANETES',
          style: TextStyle(
            fontFamily: 'Starwars'
          ),),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.black,
                image: DecorationImage(
                  image: AssetImage( "assets/images/bgplanets.jpg"),
                  fit: BoxFit.cover),
              ),
              child: Text(
                'STAR WARS PLANETS',
                style: TextStyle(
                  color: Colors.yellow,
                  fontSize: 24,
                  fontFamily: 'Starwars',
                ),
              ),
            ),
            ListTile(
              title: Text(
                'Films',
                style:
                    TextStyle(color: const Color.fromARGB(255, 26, 25, 25)),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FilmsPage()),
                );
              },
            ),
            ListTile(
              title: Text(
                'Personnages',
                style: TextStyle(color: Colors.black),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CharactersPage()),
                );
              },
            ),
          ],
        ),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: planets,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var planet = snapshot.data![index];
                return Tooltip(
                  message: 'Climate: ${planet['climate']}\n'
                      'Diameter: ${planet['diameter']}\n'
                      'Population: ${planet['population']}\n'
                      'Surface Water: ${planet['surface_water']}\n'
                      'Terrain: ${planet['terrain']}',
                  child: ListTile(
                    title: Text(
                      planet['name'],
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text(planet['name'], 
                            style: TextStyle(color: Colors.white),),
                            content: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _buildInfoRow(
                                    icon: Icons.thermostat_outlined,
                                    label: 'Climate:',
                                    value: planet['climate']),
                                _buildInfoRow(
                                    icon: Icons.circle,
                                    label: 'Diameter:',
                                    value: planet['diameter']),
                                _buildInfoRow(
                                    icon: Icons.people,
                                    label: 'Population:',
                                    value: planet['population']),
                                _buildInfoRow(
                                    icon: Icons.water,
                                    label: 'Surface Water:',
                                    value: planet['surface_water']),
                                _buildInfoRow(
                                    icon: Icons.terrain,
                                    label: 'Terrain:',
                                    value: planet['terrain']),
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('Close'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Text(
              '${snapshot.error}',
              style: TextStyle(color: Colors.white),
            );
          }
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.yellow),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoRow(
      {required IconData icon, required String label, required String value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.yellow),
          SizedBox(width: 8.0),
          Text(
            '$label $value',
            style: TextStyle(fontSize: 16.0),
          ),
        ],
      ),
    );
  }
}
//-----Page Film-----//

class FilmsPage extends StatefulWidget {
  @override
  _FilmsPageState createState() => _FilmsPageState();
}

class _FilmsPageState extends State<FilmsPage> {
  late Future<List<dynamic>> films;

  //-Récupération données api-//

  Future<List<dynamic>> fetchFilms() async {
    try {
      var response = await Dio().get('https://swapi.py4e.com/api/films');
      return response.data['results'];
    } catch (error) {
      throw Exception('Failed to load films: $error');
    }
  }

  @override
  void initState() {
    super.initState();
    films = fetchFilms();
  }

  //-Contenue Page films-//

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'FILMS',
          style: TextStyle(
            fontFamily: 'Starwars'
          ),),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.black,
                image: DecorationImage(
                  image: AssetImage( "assets/images/bgfilms.jpg"),
                  fit: BoxFit.cover),
              ),
              child: Text(
                'STAR WARS FILMS',
                style: TextStyle(
                  color: Colors.yellow,
                  fontSize: 24,
                  fontFamily: "Starwars"
                ),
              ),
            ),
            ListTile(
              title: Text(
                'Planetes',
                style: TextStyle(color: Colors.black),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PlanetsPage()),
                );
              },
            ),
            ListTile(
              title: Text(
                'Personnages',
                style: TextStyle(color: Colors.black),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CharactersPage()),
                );
              },
            ),
          ],
        ),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: films,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    snapshot.data![index]['title'],
                    style: TextStyle(color: Colors.white),
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Text(
              '${snapshot.error}',
              style: TextStyle(color: Colors.white),
            );
          }
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.yellow),
            ),
          );
        },
      ),
    );
  }
}

//-----Page Characters-----//

class CharactersPage extends StatefulWidget {
  @override
  _CharactersPageState createState() => _CharactersPageState();
}

class _CharactersPageState extends State<CharactersPage> {
  late Future<List<dynamic>> characters;

  //-Récupération données api-//

  Future<List<dynamic>> fetchCharacters() async {
    try {
      var response = await Dio().get('https://swapi.py4e.com/api/people');
      return response.data['results'];
    } catch (error) {
      throw Exception('Failed to load characters: $error');
    }
  }

  @override
  void initState() {
    super.initState();
    characters = fetchCharacters();
  }

  //-Contenue Page Characters-//

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'PERSONNAGES',
          style: TextStyle(
            fontFamily: 'Starwars'
          ),),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.black,
                image: DecorationImage(
                  image: AssetImage( "assets/images/bgcharacters.jpg"),
                  fit: BoxFit.cover),
              ),
              child: Text(
                'STAR WARS PERSONNAGES',
                style: TextStyle(
                  color: Colors.yellow,
                  fontSize: 24,
                  fontFamily: 'Starwars'
                ),
              ),
            ),
            ListTile(
              title: Text(
                'Planetes',
                style: TextStyle(color: Colors.black),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PlanetsPage()),
                );
              },
            ),
            ListTile(
              title: Text(
                'Films',
                style: TextStyle(color: Colors.black),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FilmsPage()),
                );
              },
            ),
          ],
        ),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: characters,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    snapshot.data![index]['name'],
                    style: TextStyle(color: Colors.white),
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Text(
              '${snapshot.error}',
              style: TextStyle(color: Colors.white),
            );
          }
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.yellow),
            ),
          );
        },
      ),
    );
  }
}
