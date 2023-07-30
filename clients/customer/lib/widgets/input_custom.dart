import 'package:customer_app/utils/Google_Api_Key.dart';
import 'package:customer_app/widgets/suggestion_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import '../models/location_model.dart';
import '../models/place_auto_complate_response.dart';
import '../functions/networkUtility.dart';

class InputCustom extends StatefulWidget {
  const InputCustom(
      {super.key,
      required this.placeHolder,
      required this.choosePoint,
      required this.value});

  final String placeHolder;
  final String value;
  final void Function(LocationModel value) choosePoint;

  @override
  State<InputCustom> createState() => _InputCustomState();
}

class _InputCustomState extends State<InputCustom> {
  final inputController = TextEditingController();

  Future<List<LocationModel>> placeAutoComplate(String query) async {
    List<LocationModel> placePredictions = [];
    Uri uri =
        Uri.https('maps.googleapis.com', 'maps/api/place/autocomplete/json', {
      'input': query,
      'key': APIKey,
      'region': 'vn',
      'city': 'Ho Chi Minh City',
      'language': 'vi',
    });

    String? response = await NetworkUtility.fetchUrl(uri);

    if (response != null) {
      PlaceAutocompleteResponse result =
          PlaceAutocompleteResponse.parseAutocompleteResult(response);
      if (result.predictions != null) {
        setState(() {
          placePredictions = result.predictions!;
        });
      }
    }
    return placePredictions;
  }

  @override
  void initState() {
    inputController.text = widget.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TypeAheadFormField(
      textFieldConfiguration: TextFieldConfiguration(
        controller: inputController,
        style: Theme.of(context).textTheme.bodyMedium,
        decoration: InputDecoration(
          hintText: widget.placeHolder,
          hintStyle: Theme.of(context).textTheme.labelSmall,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          fillColor: const Color.fromARGB(255, 249, 249, 249),
          filled: true,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              width: 1,
              color: Color.fromARGB(255, 242, 242, 242),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              width: 1,
              color: Color.fromARGB(255, 242, 242, 242),
            ),
          ),
        ),
      ),
      animationStart: 0,
      animationDuration: Duration.zero,
      suggestionsBoxDecoration: const SuggestionsBoxDecoration(
        elevation: 3,
        shadowColor: Color.fromARGB(100, 212, 212, 212),
        borderRadius: BorderRadius.all(
          Radius.circular(6),
        ),
      ),
      noItemsFoundBuilder: (context) => Padding(
        padding: const EdgeInsets.all(15),
        child: Text(
          'Không tìm thấy...',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      hideOnLoading: true,
      onSuggestionSelected: (suggestion) {
        inputController.text = suggestion.structuredFormatting!.mainText!;
        widget.choosePoint(suggestion);
      },
      itemBuilder: (ctx, suggestion) => SuggestionItem(
        data: suggestion.structuredFormatting!,
      ),
      suggestionsCallback: (pattern) async {
        List<LocationModel> matches = await placeAutoComplate(pattern);
        return matches;
      },
    );
  }
}