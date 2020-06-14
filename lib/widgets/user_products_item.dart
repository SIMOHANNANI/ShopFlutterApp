import 'package:flutter/material.dart';

class UserProductItem extends StatelessWidget {
  final String title;
  final String imageUrl;

  UserProductItem({this.title, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5.0,
      child: ListTile(
        title: Text(title),
        leading: CircleAvatar(
          backgroundImage: NetworkImage(imageUrl),
        ),
        trailing: Container(
          width: 100.0,
          child: Row(
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.edit,color: Theme.of(context).accentColor,),
                onPressed: null,
              ),
              IconButton(
                icon: Icon(
                  Icons.delete,
                  color: Theme.of(context).errorColor,
                ),
                onPressed: null,
              )
            ],
          ),
        ),
      ),
    );
  }
}
