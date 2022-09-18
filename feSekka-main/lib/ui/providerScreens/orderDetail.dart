// ignore_for_file: must_be_immutable

import 'package:FeSekka/I10n/app_localizations.dart';
import 'package:FeSekka/model/provider/providerOrders.dart';
import 'package:flutter/material.dart';

class OrderDetails extends StatefulWidget {
  ProviderOrders? order;
  OrderDetails({this.order});
  _OrderDetailsState createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.order!.no}"),
      ),
      body: ListView(
        children: [
           Container(
                  color: Colors.grey[300],
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.45,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "${AppLocalizations.of(context)!.translate('status')}:",
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.45,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "${widget.order!.status}",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.45,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "${AppLocalizations.of(context)!.translate('totalPrice')}:",
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.45,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "${widget.order!.total}",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
           Container(
                  color: Colors.grey[300],
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.45,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "${AppLocalizations.of(context)!.translate('address')}:",
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.45,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "${widget.order!.address}",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.45,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "${AppLocalizations.of(context)!.translate('name')}:",
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.45,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "${widget.order!.name}",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),

                
               
        ],
      ),
    );
  }
}
