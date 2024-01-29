import 'package:flutter/material.dart';
import 'package:eproject_watchub/data/model/response/order_model.dart';
import 'package:eproject_watchub/helper/responsive_helper.dart';
import 'package:eproject_watchub/localization/language_constraints.dart';
import 'package:eproject_watchub/provider/order_provider.dart';
import 'package:eproject_watchub/utill/dimensions.dart';
import 'package:eproject_watchub/utill/images.dart';
import 'package:eproject_watchub/view/base/custom_loader.dart';
import 'package:eproject_watchub/view/base/footer_view.dart';
import 'package:eproject_watchub/view/base/no_data_screen.dart';
import 'package:eproject_watchub/view/screens/order/widget/order_card.dart';
import 'package:provider/provider.dart';

class OrderView extends StatelessWidget {
  final bool isRunning;
  const OrderView({Key? key, required this.isRunning}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Consumer<OrderProvider>(
        builder: (context, order, index) {
          List<OrderModel>? orderList;
          if (order.runningOrderList != null) {
            orderList = isRunning ? order.runningOrderList!.reversed.toList() : order.historyOrderList!.reversed.toList();
          }

          return orderList != null ? orderList.isNotEmpty ? RefreshIndicator(
            onRefresh: () async {
              await Provider.of<OrderProvider>(context, listen: false).getOrderList(context);
              },

            backgroundColor: Theme.of(context).primaryColor,
            child: ListView(
              children: [
                Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: ResponsiveHelper.isDesktop(context) ? MediaQuery.of(context).size.height - 400 : MediaQuery.of(context).size.height),
                    child: SizedBox(
                      width: Dimensions.webScreenWidth,
                      child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                        itemCount: orderList.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
                            child: OrderCard(orderList: orderList,index: index),
                          );
                          },
                      ),
                    ),
                  ),
                ),

                ResponsiveHelper.isDesktop(context) ? const FooterView() : const SizedBox(),
              ],
            ),
          ) : NoDataScreen(
            image: Images.emptyOrderImage, title: getTranslated('no_order_history', context),
            subTitle: getTranslated('buy_something_to_see', context),
            isShowButton: true,
          ) : Center(child: CustomLoader(color: Theme.of(context).primaryColor));
        },
      ),
    );
  }
}

