import 'package:flutter/material.dart';
import 'package:eproject_watchub/helper/price_converter.dart';
import 'package:eproject_watchub/localization/language_constraints.dart';
import 'package:eproject_watchub/provider/order_provider.dart';
import 'package:eproject_watchub/provider/splash_provider.dart';
import 'package:eproject_watchub/utill/dimensions.dart';
import 'package:eproject_watchub/utill/styles.dart';
import 'package:eproject_watchub/view/base/custom_directionality.dart';
import 'package:provider/provider.dart';

class DeliveryOptionButton extends StatelessWidget {
  final String value;
  final String? title;
  final bool kmWiseFee;
  final bool freeDelivery;
  const DeliveryOptionButton({Key? key, required this.value, required this.title, required this.kmWiseFee, this.freeDelivery = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderProvider>(
      builder: (context, order, child) {
        return InkWell(
          onTap: () => order.setOrderType(value),
          child: Row(
            children: [
              Radio(
                value: value,
                groupValue: order.orderType,
                activeColor: Theme.of(context).primaryColor,
                onChanged: (String? value) => order.setOrderType(value),
              ),
              const SizedBox(width: Dimensions.paddingSizeSmall),

              Text(title!, style: order.orderType == value ? poppinsSemiBold.copyWith(fontSize: Dimensions.fontSizeSmall)
                  : poppinsRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),
              const SizedBox(width: 5),

              freeDelivery ? CustomDirectionality(child: Text('(${getTranslated('free', context)})', style: poppinsMedium))
                  :  kmWiseFee  ? const SizedBox() : Text('(${value == 'delivery' && !freeDelivery
                  ? PriceConverter.convertPrice(context, Provider.of<SplashProvider>(context, listen: false).configModel!.deliveryCharge)
                  : getTranslated('free', context)})', style: poppinsMedium,
              ),

            ],
          ),
        );
      },
    );
  }
}
