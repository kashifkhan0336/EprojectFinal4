import 'package:flutter/material.dart';
import 'package:eproject_watchub/data/model/response/cart_model.dart';
import 'package:eproject_watchub/data/model/response/order_model.dart';
import 'package:eproject_watchub/helper/date_converter.dart';
import 'package:eproject_watchub/helper/order_helper.dart';
import 'package:eproject_watchub/helper/responsive_helper.dart';
import 'package:eproject_watchub/helper/route_helper.dart';
import 'package:eproject_watchub/localization/app_localization.dart';
import 'package:eproject_watchub/localization/language_constraints.dart';
import 'package:eproject_watchub/main.dart';
import 'package:eproject_watchub/provider/order_provider.dart';
import 'package:eproject_watchub/provider/product_provider.dart';
import 'package:eproject_watchub/provider/theme_provider.dart';
import 'package:eproject_watchub/utill/color_resources.dart';
import 'package:eproject_watchub/utill/dimensions.dart';
import 'package:eproject_watchub/utill/styles.dart';
import 'package:eproject_watchub/view/base/custom_loader.dart';
import 'package:eproject_watchub/view/screens/order/order_details_screen.dart';
import 'package:eproject_watchub/view/screens/order/widget/re_order_dialog.dart';
import 'package:provider/provider.dart';

class OrderCard extends StatelessWidget {
  const OrderCard({Key? key, required this.orderList, required this.index}) : super(key: key);

  final List<OrderModel>? orderList;
  final int index;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      hoverColor: Colors.transparent,
      onTap: () {
        Navigator.of(context).pushNamed(
          RouteHelper.getOrderDetailsRoute('${orderList![index].id}'),
          arguments: OrderDetailsScreen(orderId: orderList![index].id, orderModel: orderList![index]),
        );
      },
      child: Container(
        padding: EdgeInsets.all(ResponsiveHelper.isDesktop(context) ? Dimensions.paddingSizeExtraLarge : Dimensions.paddingSizeSmall),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          boxShadow: [BoxShadow(
            color: Colors.grey[Provider.of<ThemeProvider>(context).darkTheme ? 900 : 300]!,
            spreadRadius: 1, blurRadius: 5,
          )],
          borderRadius: BorderRadius.circular(10),
        ),
        child: ResponsiveHelper.isDesktop(context) ? Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

          Expanded(
            child: Row(children: [
              Text('${getTranslated('order_id', context)} #', style: poppinsRegular.copyWith(fontSize: Dimensions.fontSizeDefault)),

              Text(orderList![index].id.toString(), style: poppinsSemiBold.copyWith(fontSize: Dimensions.fontSizeDefault)),
            ]),
          ),

          Expanded(
            child: Center(
              child: Text(
                '${'date'.tr}: ${DateConverter.isoStringToLocalDateOnly(orderList![index].updatedAt!)}',
                style: poppinsMedium
              ),
            ),
          ),

          Expanded(
            child: Center(
              child: Text(
                '${orderList![index].totalQuantity} ${getTranslated(orderList![index].totalQuantity == 1 ? 'item' : 'items', context)}', style: poppinsRegular.copyWith(color: Theme.of(context).disabledColor),
              ),
            ),
          ),

          Expanded(child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OrderStatusCard(orderList: orderList, index: index),
            ],
          )),

          orderList![index].orderType != 'pos' ? Consumer<ProductProvider>(builder: (context, productProvider, _)=> Consumer<OrderProvider>(builder: (context, orderProvider, _) {
            bool isReOrderAvailable = orderProvider.getReOrderIndex == null || (orderProvider.getReOrderIndex != null &&  productProvider.product != null);

            return (orderProvider.isLoading || productProvider.product == null) && index == orderProvider.getReOrderIndex && !orderProvider.isActiveOrder ? Expanded(child: Row(
                  mainAxisAlignment: MainAxisAlignment.end, children: [CustomLoader(color: Theme.of(context).primaryColor),])) : Expanded(child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TrackOrderView(orderList: orderList, index: index, isReOrderAvailable: isReOrderAvailable),
                  ],
                ));
          })
          ) :  const Expanded(child: SizedBox()),

        ]) : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

          Row(children: [

            Text('${getTranslated('order_id', context)} #${orderList![index].id.toString()}', style: poppinsRegular.copyWith(fontSize: Dimensions.fontSizeDefault)),

            const Expanded(child: SizedBox.shrink()),

            Text(
              DateConverter.isoStringToLocalDateOnly(orderList![index].updatedAt!),
              style: poppinsMedium.copyWith(color: Theme.of(context).disabledColor),
            ),
          ]),
          const SizedBox(height: Dimensions.paddingSizeSmall),

          Text(
            '${orderList![index].totalQuantity} ${getTranslated(orderList![index].totalQuantity == 1 ? 'item' : 'items', context)}', style: poppinsRegular.copyWith(color: Theme.of(context).disabledColor),
          ),
          const SizedBox(height: Dimensions.paddingSizeSmall),


          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.end, children: [

            Padding(
              padding: const EdgeInsets.only(bottom: 3),
              child: OrderStatusCard(orderList: orderList, index: index),
            ),

            orderList![index].orderType != 'pos' ? Consumer<ProductProvider>(builder: (context, productProvider, _)=> Consumer<OrderProvider>(builder: (context, orderProvider, _) {
              bool isReOrderAvailable = orderProvider.getReOrderIndex == null || (orderProvider.getReOrderIndex != null &&  productProvider.product != null);

              return (orderProvider.isLoading || productProvider.product == null) && index == orderProvider.getReOrderIndex && !orderProvider.isActiveOrder ? CustomLoader(color: Theme.of(context).primaryColor)
                : TrackOrderView(orderList: orderList, index: index, isReOrderAvailable: isReOrderAvailable);
            })
            ) : const SizedBox.shrink(),

          ]),
        ]),
      ),
    );
  }
}

class TrackOrderView extends StatelessWidget {
  const TrackOrderView({Key? key, required this.orderList, required this.index, required this.isReOrderAvailable}) : super(key: key);

  final List<OrderModel>? orderList;
  final int index;
  final bool isReOrderAvailable;

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderProvider>(
      builder: (context, orderProvider, child) {
        return TextButton(
          style: TextButton.styleFrom(
            backgroundColor: Theme.of(context).primaryColor,
              padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
              shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Dimensions.radiusSizeDefault),
          )),
          onPressed: () async {
            if(orderProvider.isActiveOrder) {
              Navigator.of(context).pushNamed(RouteHelper.getOrderTrackingRoute(orderList![index].id, null));
            }else {
              if(!orderProvider.isLoading && isReOrderAvailable) {
                orderProvider.setReorderIndex = index;
                List<CartModel>? cartList =  await orderProvider.reorderProduct('${orderList![index].id}');
                if(cartList != null &&  cartList.isNotEmpty){
                  showDialog(context: Get.context!, builder: (context)=> const ReOrderDialog());
                }
              }
            }
          },
          child: Text(
            getTranslated( orderProvider.isActiveOrder ? 'track_order' : 're_order' , context),
            style: poppinsRegular.copyWith(
              color: Theme.of(context).cardColor,
              fontSize: Dimensions.fontSizeDefault,
            ),
          ),
        );
      }
    );
  }
}

class OrderStatusCard extends StatelessWidget {
  const OrderStatusCard({Key? key, required this.orderList, required this.index}) : super(key: key);

  final List<OrderModel>? orderList;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeExtraSmall),
      decoration: BoxDecoration(
        color: OrderStatus.pending.name == orderList![index].orderStatus ? ColorResources.colorBlue.withOpacity(0.08)
            : OrderStatus.out_for_delivery.name == orderList![index].orderStatus ? ColorResources.ratingColor.withOpacity(0.08)
            : OrderStatus.canceled.name == orderList![index].orderStatus ? ColorResources.redColor.withOpacity(0.08) : ColorResources.colorGreen.withOpacity(0.08),
        borderRadius: BorderRadius.circular(Dimensions.radiusSizeTen),
      ),
      child: Text(
        getTranslated(orderList![index].orderStatus, context),
        style: poppinsRegular.copyWith(color: OrderStatus.pending.name == orderList![index].orderStatus ? ColorResources.colorBlue
            : OrderStatus.out_for_delivery.name == orderList![index].orderStatus ? ColorResources.ratingColor
            : OrderStatus.canceled.name == orderList![index].orderStatus ? ColorResources.redColor : ColorResources.colorGreen),
      ),
    );
  }
}
