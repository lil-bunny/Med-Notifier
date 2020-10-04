import 'package:finmed/models/transaction.dart';
import 'package:finmed/screen/grid_Screen.dart';
import 'package:finmed/widgets/transaction_list.dart';
import 'package:flutter/material.dart';

class GridDoc extends StatefulWidget {
  List<Transaction> store = [];

  // final List<Transaction> tx;

  // GridDoc(this.tx);

  @override
  _GridDocState createState() => _GridDocState();
}

class _GridDocState extends State<GridDoc> {
  @override
  Widget build(BuildContext context) {
    final routeArgs =
        ModalRoute.of(context).settings.arguments as Map<String, String>;

    void _deleteTransaction(String id) async {
      setState(() {
        widget.store.removeWhere((tx) => tx.id == id);
      });
    }

    return Scaffold(
        body: Container(
      child: Text('${routeArgs['l']}'),
    )
        // Container(
        //   child: ListView.builder(
        //     itemBuilder: (context, index) => Card(
        //       child: Text((widget.store.length == 0)
        //           ? routeArgs['l'][index].title
        //           : widget.store[index].title),
        //     ),
        //     itemCount: (widget.store.length == 0)
        //         ? routeArgs['l'].length
        //         : widget.store.length,
        //   ),
        // ),
        );
  }
}
