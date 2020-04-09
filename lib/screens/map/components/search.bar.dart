import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:maps/api/spot.api.dart';
import 'package:maps/blocs/page.bloc.dart';
import 'package:maps/screens/map/components/modal.spot.data.dart';
import 'package:maps/screens/map/components/search.result.item.dart';
import 'package:provider/provider.dart';

class SearchBar extends StatefulWidget {
  final Function addFunction;

  const SearchBar({Key key, this.addFunction}) : super(key: key);

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  @override
  Widget build(BuildContext context) {
    final pageBloc = Provider.of<PageBloc>(context);

    return TypeAheadFormField(
      textFieldConfiguration: TextFieldConfiguration(
        decoration: InputDecoration(
          hintText: 'Search here',
          hintStyle: TextStyle(
            fontSize: 16,
            fontFamily: 'Nunito',
            color: Color.fromRGBO(108, 108, 108, 0.5),
          ),
          prefixIcon: Icon(
            Icons.search,
            color: Color.fromRGBO(117, 118, 133, 1),
          ),
          suffixIcon: Container(
            decoration: BoxDecoration(
              border: BorderDirectional(
                start: BorderSide(
                  color: Color.fromRGBO(231, 231, 233, 1),
                  style: BorderStyle.solid,
                ),
              ),
            ),
            child: IconButton(
              icon: Icon(Icons.add),
              color: Color.fromRGBO(117, 118, 133, 1),
              onPressed: widget.addFunction,
            ),
          ),
          border: InputBorder.none,
        ),
      ),
      suggestionsCallback: (q) async {
        return await SpotApi().searchByName(q);
      },
      itemBuilder: (context, suggestion) {
        return SearchResultItem(
          spot: suggestion,
        );
      },
      onSuggestionSelected: (spot) {
        showBottomSheet(
          backgroundColor: Colors.transparent,
          context: context,
          builder: (BuildContext context) {
            pageBloc.changePage(PageState.RESUMED);
            pageBloc.setSpot(spot);

            return Container(
              margin: EdgeInsets.symmetric(horizontal: 15),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: ModalSpotData(
                  spot: spot,
                  key: Key("modal-spot-${pageBloc.currentSpot.id}"),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
