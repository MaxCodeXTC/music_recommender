import 'package:flutter/material.dart';
import 'package:spotify/spotify.dart';

class SpotifyHelper {

  // Spotify Credentials
  static var _credentials = SpotifyApiCredentials(
    // client id
    '2b8e7fc5026f4421b3035f5820f801ff',
    // client secret
    '0630c8ba40924d96952ffeab53ee583c'
  );
  // Spotify object
  var _spotify = SpotifyApi(_credentials);

  // Function that returns a list of tracks from search results
  Future<List<TrackSimple>> getSearchResults(String searchText) async {
    // Search result
    var _results = await _spotify.search
      .get(searchText)
      .first(10)
      .catchError((err) => debugPrint((err as SpotifyException).message));
    // Empty list for all tracks retrieved from results
    List<TrackSimple> resultTracks = [];

    // Iterate through each page
    _results.forEach((_pages) {
      // Iterate through each item
      _pages.items.forEach((_item) {
        // search result item is a track
        if (_item is TrackSimple) {
          // Add it to resultTrack
          resultTracks.add(_item);
        }
      });
    });
    // return final list of all track items
    return resultTracks;
  }
}