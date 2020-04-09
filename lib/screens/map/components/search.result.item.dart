import 'package:flutter/material.dart';
import 'package:maps/models/spot.dart';

class SearchResultItem extends StatelessWidget {
  final Spot spot;

  const SearchResultItem({Key key, this.spot}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      leading: CircleAvatar(
        backgroundImage: NetworkImage(
          '${spot.image}',
        ),
      ),
      title: Text('${spot.name}'),
      subtitle: Text('Cristo Rei, Curitiba, Brasil'),
    );
  }
}
