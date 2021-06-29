import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:health_care/MainScreen/SearchResult.dart';

var suggest = [
  "covid 19",
  "ho khan",
  "nhiệt miệng",
  "mất ngủ",
  "trầm cảm",
  "thoái hóa cột sống",
  "bitcoin",
  "cảm cúm",
  "ho có đờm",
  "huyết áp cao",
];

var recentSearch = [
  "cảm cúm",
  "ho có đờm",
  "huyết áp cao",
  "mất ngủ",
];

class DataSearch extends SearchDelegate<String> {
  List<String> suggesion = [];

  DataSearch({
    String hintText,
    TextStyle textStyle,
  }) : super(
          searchFieldDecorationTheme: null,
          searchFieldLabel: hintText,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.search,
          searchFieldStyle: textStyle,
        );

  @override
  ThemeData appBarTheme(BuildContext context) {
    return ThemeData(
      primarySwatch: Colors.indigo,
      scaffoldBackgroundColor: Colors.white,
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = "";
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: transitionAnimation,
        ),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    return Center(
      child: Container(
        height: 100.0,
        width: 100.0,
        child: Card(
          color: Colors.white,
          child: Center(
            child: Text(
              query,
              style: TextStyle(color: Colors.black),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
/*     final suggestionList = query.isEmpty
        ? recentSearch
        : suggest.where((p) => p.contains(query)).toList();
    return ListView.builder(
      itemBuilder: (context, index) => ListTile(
        onTap: () {
          query = suggestionList[index];
          bool temp = true; //todo: add recent search, checking
          for (var n in recentSearch) {
            if (query == n) temp = false;
          }
          if (temp) {
            recentSearch.insert(0, query);
            if (recentSearch.length >= 7) {
              recentSearch.removeAt(7);
            }
          }
          else {
            recentSearch.remove(query);
            recentSearch.insert(0, query);
          }
          showResults(context);
          //TODO: Information for search result aka new screen
        },
        tileColor: Colors.white,
        leading: Icon(Icons.history),
        title: Text(
          suggestionList[index],
          style: TextStyle(color: Colors.grey),
        ),
      ),
      itemCount: suggestionList.length,
    );*/
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('diseases').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData)
          return Container(
              alignment: FractionalOffset.center,
              child: CircularProgressIndicator());

        suggesion = [];
        final results = snapshot.data.docs
            .where((a) => a['tenBenh'].toLowerCase().contains(query.toLowerCase()))
            .toList();
        for (var temp in results) {
          suggesion.add(temp.get('tenBenh').toString().toLowerCase());
        }
        return ListView.builder(
          itemBuilder: (context, index) => ListTile(
            onTap: () {
              query = suggesion[index];
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => SearchResult(
                            query: query,
                          )));
            },
            tileColor: Colors.white,
            leading: Icon(Icons.history),
            title: Text(
              suggesion[index],
              style: TextStyle(color: Colors.grey),
            ),
          ),
          itemCount: suggesion.length,
        );
      },
    );
  }
}
