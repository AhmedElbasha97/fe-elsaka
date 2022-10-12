import 'package:FeSekka/I10n/app_localizations.dart';
import 'package:FeSekka/globals/utils.dart';
import 'package:FeSekka/model/provider/providerOrders.dart';
import 'package:FeSekka/services/serviceProvider.dart';
import 'package:FeSekka/ui/providerScreens/orderDetail.dart';
import 'package:FeSekka/widgets/loader.dart';
import 'package:FeSekka/widgets/provider/providerDrawer.dart';
import 'package:flutter/material.dart';

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
                  child: Text(
                      "${AppLocalizations.of(context)!.translate('noOrders')}"),
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
