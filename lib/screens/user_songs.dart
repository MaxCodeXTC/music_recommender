import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:music_recommender/utils/database_helper.dart';
import 'package:music_recommender/models/my_track.dart';

class UserSongsScreen extends StatefulWidget {
  @override
  _UserSongsScreenState createState() => _UserSongsScreenState();
}

class _UserSongsScreenState extends State<UserSongsScreen> {
  // Database helper object
  DatabaseHelper databaseHelper = DatabaseHelper();
  // Empty list for user songs
  List<MyTrack> trackList;
  // Default count value
  int count = 0;

  @override
  Widget build(BuildContext context) {
    // If not updated, update list
    if (trackList == null) {
      trackList = List<MyTrack>();
      updateListView();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('My Songs'),
        centerTitle: true,
      ),
      // Main body
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: getTrackListView(),
      ),
      // FAB that takes user to search screen
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushReplacementNamed(context, '/search');
        },
        tooltip: 'Search new songs',
        child: Icon(Icons.search),
      ),
    );
  }

  ListView getTrackListView() {
    // Custom text style from theme
    TextStyle titleStyle = Theme.of(context).textTheme.subtitle1;
    // ListView builder
    return ListView.builder(
      // Number of elements
      itemCount: count,
      itemBuilder: (BuildContext context, int index) {
        // Main Card widget
        return Padding(
          padding: const EdgeInsets.fromLTRB(0, 2.0, 0, 2.0),
          child: Card(
            // Card color from theme
            color: Theme.of(context).cardColor,
            // Elevation of the card
            elevation: 5.0,
            // ListTile Widget
            child: ListTile(
              // Leading widget showing first letter of song
              leading: CircleAvatar(
                backgroundColor: Theme.of(context).accentColor,
                child: Text(this.trackList[index].name[0]),
              ),
              // Main title of the widget
              title: Text(this.trackList[index].name, style: titleStyle),
              // Trailing icon for deleting song
              trailing: GestureDetector(
                child: Icon(Icons.delete, color: Colors.red[500]),
                onTap: () {
                  _delete(context, trackList[index]);
                },
              ),
              // TODO: Navigate to details page
              onTap: () {
                debugPrint('You clicked ${this.trackList[index].name}');
              },
            ),
          ),
        );
      },
    );
  }

  // Delete Track from database
  void _delete(BuildContext context, MyTrack myTrack) async {
    await databaseHelper.deleteTrack(myTrack.id);
    _showSnackBar(context, 'Deleted ${myTrack.name}');
    updateListView();
  }

  // Show snackbar
  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    Scaffold.of(context).showSnackBar(snackBar);
  }

  // Fetch data from database and update List View
  void updateListView() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();

    dbFuture.then((database) {
      Future<List<MyTrack>> trackListFuture = databaseHelper.getTrackList();
      // Update local variables
      trackListFuture.then((trackList) {
        setState(() {
          this.trackList = trackList;
          this.count = trackList.length;
        });
      });
    });
  }
}
