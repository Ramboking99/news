import 'dart:async';
import 'package:flutter/material.dart';
import 'package:news/models/item_model.dart';
import 'package:html/parser.dart';
import 'loading_container.dart';

class Comment extends StatelessWidget {
  final int itemId;
  final Map<int, Future<ItemModel>> itemMap;
  final int depth;

  Comment({this.itemId, this.itemMap, this.depth});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: itemMap[itemId],
      builder: (context, AsyncSnapshot<ItemModel> snapshot) {
        if(!snapshot.hasData) {
          return LoadingContainer();
        }

        final item = snapshot.data;

        final children = <Widget>[
          ListTile(
            title: buildText(item),
            subtitle: item.by == "" ? Text("Deleted") : Text(item.by),
            contentPadding: EdgeInsets.only(left: (depth + 1) * 16.0, right: 16.0),
          ),
          Divider(),
        ];
        item.kids.forEach((kidId) {
          children.add(Comment(
            itemId: kidId,
            itemMap: itemMap,
            depth: depth +1,
          ));
        });
        
        return Column(
          children: children,
        );
      },
    );
  }

  Widget buildText(ItemModel item) {
    final text = item.text;
    var document = parse(text);
    String parsedString = parse(document.body.text).documentElement.text;

    return Text(parsedString);
  }

}