import 'package:flutter/material.dart';
import 'package:eproject_watchub/data/model/response/product_model.dart';
import 'package:eproject_watchub/helper/product_type.dart';
import 'package:eproject_watchub/helper/responsive_helper.dart';
import 'package:eproject_watchub/localization/language_constraints.dart';
import 'package:eproject_watchub/provider/flash_deal_provider.dart';
import 'package:eproject_watchub/provider/product_provider.dart';
import 'package:eproject_watchub/provider/splash_provider.dart';
import 'package:eproject_watchub/utill/dimensions.dart';
import 'package:eproject_watchub/utill/images.dart';
import 'package:eproject_watchub/view/base/custom_app_bar.dart';
import 'package:eproject_watchub/view/base/custom_loader.dart';
import 'package:eproject_watchub/view/base/footer_view.dart';
import 'package:eproject_watchub/view/base/no_data_screen.dart';
import 'package:eproject_watchub/view/base/product_widget.dart';
import 'package:eproject_watchub/view/base/title_row.dart';
import 'package:eproject_watchub/view/base/title_widget.dart';
import 'package:eproject_watchub/view/base/web_app_bar/web_app_bar.dart';
import 'package:provider/provider.dart';

class HomeItemScreen extends StatefulWidget {
  final String? productType;

  const HomeItemScreen({Key? key, this.productType}) : super(key: key);

  @override
  State<HomeItemScreen> createState() => _HomeItemScreenState();
}

class _HomeItemScreenState extends State<HomeItemScreen> {
  late int pageSize;
  final ScrollController scrollController = ScrollController();


  @override
  void initState() {
    //todo flashsell need to pagination impliment

    if(widget.productType != ProductType.flashSale){
      Provider.of<ProductProvider>(context, listen: false).popularOffset = 1;
      Provider.of<ProductProvider>(context, listen: false).getItemList('1', false, widget.productType);

      final productProvider = Provider.of<ProductProvider>(context, listen: false);
      scrollController.addListener(() {
        if (scrollController.position.maxScrollExtent == scrollController.position.pixels &&
            ( productProvider.dailyItemList != null) && !productProvider.isLoading
        ) {
          pageSize = (productProvider.popularPageSize! / 10).ceil();
          if (productProvider.popularOffset < pageSize) {
            productProvider.popularOffset++;
            productProvider.showBottomLoader();

            productProvider.getItemList(productProvider.popularOffset.toString(), false, widget.productType);
          }
        }
      });
    }

    super.initState();
  }
  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: (ResponsiveHelper.isDesktop(context) ? const PreferredSize(
          preferredSize: Size.fromHeight(120),
          child: WebAppBar())
          : CustomAppBar(title:  getTranslated(widget.productType, context),
      )) as PreferredSizeWidget?,
      body: SingleChildScrollView(
          controller: scrollController,
          child: Center(
              child: Column(
                children: [
                  ConstrainedBox(
                    constraints: BoxConstraints(minHeight: ResponsiveHelper.isDesktop(context) ? MediaQuery.of(context).size.height - 400 : MediaQuery.of(context).size.height),
                    child: Column(children: [
                      ResponsiveHelper.isDesktop(context) ? const SizedBox(height: 20) : const SizedBox.shrink(),

                      if(ResponsiveHelper.isDesktop(context) && widget.productType != ProductType.flashSale)
                        SizedBox(width: 1170,child: TitleWidget(
                          title:  getTranslated('${widget.productType}', context),
                        )),

                      if(widget.productType == ProductType.flashSale)
                        SizedBox(width: Dimensions.webScreenWidth, child: Column(children: [
                          Consumer<FlashDealProvider>(builder: (context, flashDealProvider, _) {
                            return flashDealProvider.flashDealModel != null ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(Dimensions.radiusSizeDefault),
                                child: FadeInImage.assetNetwork(
                                  width: double.maxFinite,
                                  height: MediaQuery.of(context).size.height * ( ResponsiveHelper.isDesktop(context) ? 0.3 : 0.2),
                                  placeholder: Images.getPlaceHolderImage(context),
                                  image: '${Provider.of<SplashProvider>(context,listen: false).baseUrls!.flashSaleImageUrl}'
                                      '/${flashDealProvider.flashDealModel?.flashDeal?.banner ?? ''}',
                                  fit: BoxFit.cover,
                                  imageErrorBuilder: (c, o, s) => Image.asset(Images.getPlaceHolderImage(context), fit: BoxFit.cover),
                                ),
                              ),
                            ) : const SizedBox();
                          }),

                          Consumer<FlashDealProvider>(builder: (context, flashDealProvider, _) {
                            return Padding(
                              padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                              child: TitleRow(
                                isDetailsPage: true,
                                title: getTranslated('flash_deal', context),
                                eventDuration: flashDealProvider.duration,
                              ),
                            );
                          }
                          ),
                        ])),

                      SizedBox(width: 1170, child: Consumer<FlashDealProvider>(
                          builder: (context, flashDealProvider, child) {
                            return Consumer<ProductProvider>(
                              builder: (context, productProvider, child) {
                                List<Product>? productList;

                                switch(widget.productType) {

                                  case ProductType.dailyItem :
                                    productList = productProvider.dailyItemList;
                                    break;
                                  case ProductType.featuredItem :
                                    productList = productProvider.featuredProductList;
                                    break;
                                  case ProductType.mostReviewed :
                                    productList = productProvider.mostViewedProductList;
                                    break;

                                  case ProductType.flashSale :
                                    productList = flashDealProvider.flashDealModel?.products;
                                    break;
                                }

                                return productList != null ? productList.isNotEmpty ? Column(children: [
                                  GridView.builder(
                                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisSpacing: ResponsiveHelper.isDesktop(context) ? 13 : 10,
                                      mainAxisSpacing: ResponsiveHelper.isDesktop(context) ? 13 : 10,
                                      childAspectRatio: ResponsiveHelper.isDesktop(context) ? (1/1.4) : (1/1.6),
                                      crossAxisCount: ResponsiveHelper.isDesktop(context) ? 5 : ResponsiveHelper.isTab(context) ? 2 : 2,
                                    ),

                                    padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                                    physics: const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: productList.length,
                                    itemBuilder: (context ,index) {
                                      return ProductWidget(product: productList![index], isGrid: true, isCenter: true);
                                    },
                                  ),

                                  if(productProvider.isLoading) Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Center(child: CustomLoader(color: Theme.of(context).primaryColor)),
                                  ),

                                ]) :  NoDataScreen(title: getTranslated('product_not_found', context)) : SizedBox(height: MediaQuery.of(context).size.height*0.5,child: Center(child: CustomLoader(color: Theme.of(context).primaryColor)));
                              },
                            );
                          }
                      )),
                      SizedBox(height: ResponsiveHelper.isDesktop(context) ? 40 : 0),
                    ]),
                  ),

                  ResponsiveHelper.isDesktop(context) ? const FooterView() : const SizedBox(),
                ],
              ))),
    );
  }
}
