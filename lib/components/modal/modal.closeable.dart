import 'package:flutter/material.dart';
import 'package:maps/blocs/page.bloc.dart';
import 'package:provider/provider.dart';

class ModalCloseable extends StatefulWidget {
  final Widget child;

  const ModalCloseable({Key key, this.child}) : super(key: key);

  @override
  _ModalCloseableState createState() => _ModalCloseableState();
}

class _ModalCloseableState extends State<ModalCloseable> {
  @override
  Widget build(BuildContext context) {
    final pageBloc = Provider.of<PageBloc>(context);
    
    return Positioned(
      left: 15,
      right: 15,
      top: 20,
      bottom: 20,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(0),
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
            ),
            child: IconButton(
              icon: Icon(
                Icons.close,
              ),
              onPressed: () {
                if (Navigator.of(context).canPop()) {
                  Navigator.of(context).pop();
                }
                pageBloc.changePage(PageState.MAP);
              },
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Visibility(
            visible: widget.child != null,
            child: widget.child,
          ),
        ],
      ),
    );
  }
}
