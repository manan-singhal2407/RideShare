import 'package:btp/presentation/extension/google_maps_api_key.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_webservice/places.dart';

class SearchViewModel extends ChangeNotifier {
  final BuildContext _context;

  final TextEditingController _searchQueryController = TextEditingController();
  late List<Prediction> _searchedPredictions = [];
  final _searchedPlaces = GoogleMapsPlaces(
    apiKey: googleMapsApiKey,
  );

  SearchViewModel(this._context) {
    _searchQueryController.addListener(() {
      if (_searchQueryController.text.isNotEmpty &&
          _searchQueryController.text.length >= 3) {
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
      radius: 60000,
      location: Location(lat: 30.7191, lng: 76.7487),
      components: [
        Component(Component.country, 'in'),
      ],
      strictbounds: true,
    );
    _searchedPredictions = predictions.predictions;
    notifyListeners();
  }
}
