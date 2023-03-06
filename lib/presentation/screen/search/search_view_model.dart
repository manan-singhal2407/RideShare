import 'package:flutter/material.dart';
import 'package:google_maps_webservice/places.dart';

class SearchViewModel extends ChangeNotifier {
  final BuildContext _context;

  final TextEditingController _searchQueryController = TextEditingController();
  late List<Prediction> _searchedPredictions = [];
  final _searchedPlaces = GoogleMapsPlaces(
    apiKey: 'AIzaSyDschydseXpu7lOGtBorLzIzWl-rEr2a24',
  );

  SearchViewModel(this._context) {
    _searchQueryController.addListener(() {
      if (_searchQueryController.text.isNotEmpty && _searchQueryController.text.length >= 3) {
        _searchPlaces(_searchQueryController.text.trim());
      } else {
        notifyListeners();
      }
    });
  }

  TextEditingController get searchQueryController => _searchQueryController;

  List<Prediction> get searchedPredictions => _searchedPredictions;

  void _searchPlaces(String searchQuery) async {
    final predictions = await _searchedPlaces.autocomplete(
      searchQuery,
      language: 'en',
      radius: 10000,
      location: Location(lat: 30.7191, lng: 76.7487),
      strictbounds: true,
    );
    _searchedPredictions = predictions.predictions;
    notifyListeners();
  }
}
