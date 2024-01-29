import 'package:flutter/material.dart';
import 'package:eproject_watchub/helper/responsive_helper.dart';
import 'package:eproject_watchub/localization/app_localization.dart';
import 'package:eproject_watchub/localization/language_constraints.dart';
import 'package:eproject_watchub/provider/auth_provider.dart';
import 'package:eproject_watchub/provider/wishlist_provider.dart';
import 'package:eproject_watchub/utill/dimensions.dart';
import 'package:eproject_watchub/utill/styles.dart';
import 'package:eproject_watchub/utill/images.dart';
import 'package:eproject_watchub/view/base/app_bar_base.dart';
import 'package:eproject_watchub/view/base/footer_view.dart';
import 'package:eproject_watchub/view/base/no_data_screen.dart';
import 'package:eproject_watchub/view/base/not_login_screen.dart';
import 'package:eproject_watchub/view/base/product_widget.dart';
import 'package:eproject_watchub/view/base/web_app_bar/web_app_bar.dart';
import 'package:provider/provider.dart';

class WishListScreen extends StatefulWidget {
  const WishListScreen({Key? key}) : super(key: key);

  @override
  State<WishListScreen> createState() => _WishListScreenState();
}

class _WishListScreenState extends State<WishListScreen> {
  bool _isLoggedIn = false;
  @override
  void initState() {
    super.initState();
    _isLoggedIn = Provider.of<AuthProvider>(context, listen: false).isLoggedIn();
  }
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: ResponsiveHelper.isMobilePhone()? null: (ResponsiveHelper.isDesktop(context)? const PreferredSize(preferredSize: Size.fromHeight(120), child: WebAppBar()) : const AppBarBase()) as PreferredSizeWidget?,
      body: _isLoggedIn ? Consumer<WishListProvider>(
        builder: (context, wishlistProvider, child) {
          if(wishlistProvider.isLoading) {
           return Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)));
          }
          return wishlistProvider.wishList != null ? wishlistProvider.wishList!.isNotEmpty ? RefreshIndicator(
            onRefresh: () async {
              await Provider.of<WishListProvider>(context, listen: false).getWishList();
            },
            backgroundColor: Theme.of(context).primaryColor,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minHeight: !ResponsiveHelper.isDesktop(context) && height < 600 ? height : height - 400),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 1, vertical:  Dimensions.paddingSizeDefault),
                        child: SizedBox(
                          width: 1170,
                          child:  Column(
                            children: [

                              ResponsiveHelper.isDesktop(context) ? Padding(
                                padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeExtraLarge),
                                child: Text("favourite_list".tr, style: poppinsSemiBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
                              ) : const SizedBox(),

                              GridView.builder(
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisSpacing: ResponsiveHelper.isDesktop(context) ? 13 : 10,
                                    mainAxisSpacing: ResponsiveHelper.isDesktop(context) ? 13 : 10,
                                    childAspectRatio: ResponsiveHelper.isDesktop(context) ? (1/1.41) : (1/1.6),
                                    crossAxisCount: ResponsiveHelper.isDesktop(context) ? 5 : ResponsiveHelper.isTab(context) ? 2 : 2),
                                itemCount: wishlistProvider.wishList!.length,
                                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (BuildContext context, int index) {
                                  return ProductWidget(product: wishlistProvider.wishList![index], isGrid: true, isCenter: true);
                                },
                              ),
                            ],
                          )
                        ),
                      ),
                    ),
                  ),
                  if(ResponsiveHelper.isDesktop(context)) const FooterView(),
                ],
              ),
            ),
          ): NoDataScreen(title: getTranslated('not_product_found', context), image: Images.favouriteNoDataImage) : Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)));
        },
      ) : const NotLoggedInScreen(),
    );
  }
}
