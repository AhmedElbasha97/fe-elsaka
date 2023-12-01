import 'package:FeSekka/I10n/app_localizations.dart';
import 'package:FeSekka/globals/utils.dart';
import 'package:FeSekka/model/provider/product.dart';
import 'package:FeSekka/services/serviceProvider.dart';
import 'package:FeSekka/ui/providerScreens/addProduct.dart';
import 'package:FeSekka/widgets/loader.dart';
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
          ? Loader():products.length==0?Center(
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
                "${AppLocalizations.of(context)!.translate('noProductRecorded')}",  style: TextStyle(fontSize: 20, color: Colors.grey)),
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
