import 'package:btp/presentation/theme/color.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'search_view_model.dart';

class SearchPage extends StatefulWidget {
  final String type;

  const SearchPage({
    super.key,
    required this.type,
  });

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SearchViewModel>(
      create: (context) => SearchViewModel(context),
      child: Consumer<SearchViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: shimmerHighlightColor,
              titleSpacing: 0,
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              title: TextField(
                controller: viewModel.searchQueryController,
                decoration: InputDecoration(
                  hintText: 'Search ${widget.type} location',
                  hintStyle: GoogleFonts.openSans(
                    textStyle: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  labelStyle: GoogleFonts.openSans(
                    textStyle: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  fillColor: shimmerHighlightColor,
                  border: const OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                ),
                cursorColor: Colors.black,
              ),
            ),
            body: viewModel.searchQueryController.text.isEmpty
                ? Container()
                : viewModel.searchQueryController.text.length < 3
                    ? Container(
                        margin: const EdgeInsets.all(8),
                        alignment: Alignment.topCenter,
                        child: Text(
                          'Please enter minimum 3 letters to search',
                          style: GoogleFonts.openSans(
                            textStyle: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: viewModel.searchedPredictions.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            leading: const Icon(Icons.location_on),
                            title: Text(viewModel
                                .searchedPredictions[index].description
                                .toString()),
                            onTap: () {
                              // Select the prediction and close the search overlay
                              // _selectPlace(viewModel.searchedPredictions.predictions[index].placeId);
                            },
                          );
                        },
                      ),
          );
        },
      ),
    );
  }
}
