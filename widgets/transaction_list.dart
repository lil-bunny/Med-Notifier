import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:flutter/rendering.dart';
import '../models/transaction.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function deleteTx;

  TransactionList(this.transactions, this.deleteTx);

  @override
  Widget build(BuildContext context) {
    GlobalKey imageKey = GlobalKey();
    return RepaintBoundary(
      key: imageKey,
      child: Container(
          height: 450,
          child: transactions.isEmpty
              ? Column(
                  children: <Widget>[
                    Text(
                      'No Medicines added yet!',
                      style: Theme.of(context).textTheme.title,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                        height: 200,
                        child: Image.asset(
                          'assets/images/waiting.png',
                          fit: BoxFit.cover,
                        )),
                  ],
                )
              : Column(
                  children: [
                    Expanded(
                        child: ListView.builder(
                      itemBuilder: (ctx, index) {
                        return Card(
                          elevation: 5,
                          color: Colors.white,
                          margin: EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 5,
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              radius: 30,
                              child: Padding(
                                padding: EdgeInsets.all(6),
                                child: FittedBox(
                                  child: Text(
                                    '${transactions[index].amount} Tab',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                            title: Text(
                              transactions[index].title,
                              style: Theme.of(context).textTheme.title,
                            ),
                            subtitle: Text(
                              DateFormat.yMMMd()
                                      .format(transactions[index].date) +
                                  ' ${transactions[index].time.format(context)}',
                            ),
                            trailing: IconButton(
                              icon: Icon(Icons.delete),
                              color: Theme.of(context).errorColor,
                              onPressed: () => deleteTx(transactions[index].id),
                            ),
                          ),
                        );
                      },
                      itemCount: transactions.length,
                    )),
                    IconButton(
                        icon: Icon(Icons.share),
                        onPressed: () async {
                          RenderRepaintBoundary imageObject =
                              imageKey.currentContext.findRenderObject();
                          final image =
                              await imageObject.toImage(pixelRatio: 3);
                          ByteData byteData = await image.toByteData(
                              format: ImageByteFormat.png);
                          final pngBytes = byteData.buffer.asUint8List();
                          await Share.file(
                              'esys image', 'esys.png', pngBytes, 'image/png',
                              text: 'Want this list of medicine soon');
                        })
                  ],
                )),
    );
  }
}
