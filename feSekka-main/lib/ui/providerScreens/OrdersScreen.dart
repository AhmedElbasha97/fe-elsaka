import 'package:FeSekka/I10n/app_localizations.dart';
import 'package:FeSekka/globals/utils.dart';
import 'package:FeSekka/model/provider/providerOrders.dart';
import 'package:FeSekka/services/serviceProvider.dart';
import 'package:FeSekka/ui/providerScreens/orderDetail.dart';
import 'package:FeSekka/widgets/loader.dart';
import 'package:FeSekka/widgets/provider/providerDrawer.dart';
import 'package:flutter/material.dart';

import 'addProduct.dart';

class OrderScreen extends StatefulWidget {
  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  bool isLoading = true;
  List<ProviderOrders> orders = [];
  getOrders() async {
    orders = await ServiceProviderService().getOrders();
    isLoading = false;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: ProviderDrawer(),
      body: isLoading
          ?Loader()
          : orders.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height*0.3,
                        width: MediaQuery.of(context).size.width*0.9,
                        child: Image.asset("assets/photos/Car accesories-amico.png",fit: BoxFit.fitHeight,),
                      ),
                      SizedBox(height: 10,),
                      Text(
                          "${AppLocalizations.of(context)!.translate('noOrders')}",  style: TextStyle(fontSize: 20, color: Colors.grey)),
                      SizedBox(height: 10,),
                      InkWell(
                        onTap: (){pushPage(context, AddProdcut());},
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: Container(
                            height: 50,
                            width: MediaQuery.of(context).size.width*0.7,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Color(0xFF66a5b4),
                                  width: 2.0,
                                  style: BorderStyle.solid
                              ),
                              borderRadius: BorderRadius.circular(10),

                            ),
                            child:  Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children:  [
                                  Text(
                                      "${AppLocalizations.of(context)!.translate('addNewProduct')}",  style: TextStyle(fontSize: 20, color:Color(0xFF66a5b4),)),
                                  const SizedBox(width: 10,),
                                  Icon(Icons.add,color: Color(0xFF66a5b4),),
                                ],

                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: orders.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () {
                          pushPage(
                              context,
                              OrderDetails(
                                order: orders[index],
                              ));
                        },
                        child: ListTile(
                          title: Text("${orders[index].id}"),
                          trailing: Text("${orders[index].created}"),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
