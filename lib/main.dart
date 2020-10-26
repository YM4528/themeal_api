import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class Meals {
  final String strMeal;
  final String strMealThumb;

  Meals(this.strMeal, this.strMealThumb);
  
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Meals"),
        ),
        body: HomePage(),
      ),
      
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

Future<List<Meals>> getMeals() async {

  var data = await http.get(
    "https://themealdb.com/api/json/v1/1/filter.php?c=Seafood"
  );

  var jsonData = json.decode(data.body);

  var mealsData = jsonData['meals'];

  List<Meals> meals = [];

  for (var data in mealsData) {
    Meals mealsItem = Meals(data['strMeal'], data['strMealThumb']);
    meals.add(mealsItem);
  }
  return meals;

}

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
        future: getMeals(),
        builder: 
        (BuildContext context,AsyncSnapshot snapshot){
          if (snapshot.data == null) {
            return Center(
              child: CircularProgressIndicator());
          } else {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  child: Container(
                    padding: EdgeInsets.all(8),
                    margin: EdgeInsets.all(4),
                    child: Row(children: [
                      Image.network(
                        snapshot.data[index].strMealThumb,
                        height: 100,
                      ),
                      Text(snapshot.data[index].strMeal),
                    ],),
                  ),
                );
                
                
                
              },

            );
          }
        }
      ),
      
    );
  }
}


