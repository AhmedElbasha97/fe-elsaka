import 'package:FeSekka/globals/utils.dart';
import 'package:FeSekka/model/provider/product.dart';
import 'package:FeSekka/services/serviceProvider.dart';
import 'package:FeSekka/ui/providerScreens/addProduct.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class ProductsScreen extends StatefulWidget {
  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  bool isLoading = true;
  List<ProviderProduct> products = [];
  @override
  void initState() {
    super.initState();
    getProduct();
  }

  getProduct() async {
    products = await ServiceProviderService().getProducts();
    isLoading = false;
    setState(() {});
  }

  deleteProduct(String? id) async {
    isLoading = true;
    setState(() {});
    await ServiceProviderService().deleteProduct(id);
    getProduct();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
                onPressed: () {
                  pushPage(context, AddProdcut());
                },
                icon: Icon(Icons.add)),
          )
        ],
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: products.length,
              itemBuilder: (BuildContext context, int index) {
                return AnimationConfiguration.staggeredList(
                    position: index,
                    duration: const Duration(milliseconds: 1500),
                    child: SlideAnimation(
                        verticalOffset: 50.0,
                        child: FadeInAnimation(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              title: Text(Localizations.localeOf(context)
                                          .languageCode ==
                                      "en"
                                  ? "${products[index].titleen}"
                                  : "${products[index].titlear}"),
                              leading: Container(
                                  width: 70,
                                  height: 70,
                                  child: Image.network(
                                      "${products[index].image}")),
                              trailing: IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  deleteProduct(products[index].productsId);
                                },
                              ),
                            ),
                          ),
                        )));
              },
            ),
    );
  }
}
