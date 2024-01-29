import 'package:flutter/material.dart';
import 'package:eproject_watchub/data/model/response/address_model.dart';
import 'package:eproject_watchub/data/model/response/config_model.dart';
import 'package:eproject_watchub/helper/checkout_helper.dart';
import 'package:eproject_watchub/localization/language_constraints.dart';
import 'package:eproject_watchub/provider/location_provider.dart';
import 'package:eproject_watchub/provider/order_provider.dart';
import 'package:eproject_watchub/provider/splash_provider.dart';
import 'package:eproject_watchub/utill/dimensions.dart';
import 'package:eproject_watchub/utill/styles.dart';
import 'package:eproject_watchub/view/base/custom_shadow_view.dart';
import 'package:eproject_watchub/view/screens/checkout/widget/add_address_dialog.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class DeliveryAddressView extends StatelessWidget {
  final bool selfPickup;

  const DeliveryAddressView({
    Key? key, required this.selfPickup,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ConfigModel configModel = Provider.of<SplashProvider>(context, listen: false).configModel!;

    return !selfPickup ? CustomShadowView(
      margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeSmall),
      child: Consumer<LocationProvider>(
        builder: (context, locationProvider, _) => Consumer<OrderProvider>(
            builder: (context, orderProvider, _) {
              bool isAvailable = false;

              AddressModel? deliveryAddress = CheckOutHelper.getDeliveryAddress(
                addressList: locationProvider.addressList,
                selectedAddress: orderProvider.addressIndex == -1 ? null : locationProvider.addressList?[orderProvider.addressIndex],
                lastOrderAddress: null,
              );

              if(deliveryAddress != null) {
                isAvailable = CheckOutHelper.isBranchAvailable(
                  branches: configModel.branches ?? [],
                  selectedBranch: configModel.branches![orderProvider.branchIndex],
                  selectedAddress: deliveryAddress,
                );

                if(!isAvailable) {
                  deliveryAddress = null;
                }
              }

              return locationProvider.addressList == null ? const DeliverySectionShimmer() :  Padding(
                padding:  const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeExtraSmall),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                    Text('${getTranslated('delivery_to', context)} -', style: poppinsMedium.copyWith(fontSize: Dimensions.fontSizeLarge)),
                    const Expanded(child: SizedBox()),
                    TextButton(
                      onPressed: ()=> showDialog(context: context, builder: (_)=> const AddAddressDialog()),
                      child: Text(getTranslated(deliveryAddress == null || orderProvider.addressIndex == -1  ? 'add' : 'change', context), style: poppinsBold.copyWith(color: Theme.of(context).primaryColor)),
                    ),
                  ]),
                  const SizedBox(height: Dimensions.paddingSizeDefault),

                  deliveryAddress == null || orderProvider.addressIndex == -1 ? Padding(
                    padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault),
                    child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Icon(Icons.info_outline_rounded, color: Theme.of(context).colorScheme.error),
                      const SizedBox(width: Dimensions.paddingSizeSmall),

                      Text(getTranslated('no_contact_info_added', context), style: poppinsRegular.copyWith(color: Theme.of(context).colorScheme.error)),
                    ]),
                  ) : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Row(children: [
                      Icon(Icons.person, color: Theme.of(context).primaryColor.withOpacity(0.5)),
                      const SizedBox(width: Dimensions.paddingSizeSmall),

                      Text(deliveryAddress.contactPersonName ?? ''),
                    ]),
                    const SizedBox(height: Dimensions.paddingSizeSmall),

                    Row(children: [
                      Icon(Icons.call, color: Theme.of(context).primaryColor.withOpacity(0.5)),
                      const SizedBox(width: Dimensions.paddingSizeSmall),

                      Text(deliveryAddress.contactPersonNumber ?? ''),
                    ]),

                    const Divider(height: Dimensions.paddingSizeDefault),

                    Text(deliveryAddress.address ?? '', maxLines: 1, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: Dimensions.paddingSizeSmall),

                    Row(mainAxisAlignment: MainAxisAlignment.start,children: [
                      if(deliveryAddress.houseNumber != null) Text(
                        '${getTranslated('house', context)} - ${deliveryAddress.houseNumber}',
                        maxLines: 1, overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(width: Dimensions.paddingSizeSmall),

                      if(deliveryAddress.floorNumber != null) Text(
                        '${getTranslated('floor', context)} - ${deliveryAddress.floorNumber}',
                        maxLines: 1, overflow: TextOverflow.ellipsis,
                      ),
                    ]),


                    const SizedBox(height: Dimensions.paddingSizeDefault),
                  ]),

                ]),
              );
            }),
      ),
    ) : const SizedBox();
  }
}


class DeliverySectionShimmer extends StatelessWidget {
  const DeliverySectionShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer(child: Column(children: [
      Container(
        margin:  const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall, horizontal: Dimensions.paddingSizeDefault),
        child: Column(children: [
          const SizedBox(height: Dimensions.paddingSizeSmall),

          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Container(height: 14, width: 200, decoration: BoxDecoration(color: Theme.of(context).shadowColor, borderRadius: BorderRadius.circular(2))),
            Container(height: 14, width: 50, decoration: BoxDecoration(color: Theme.of(context).shadowColor, borderRadius: BorderRadius.circular(2))),
          ]),

          const Divider(height: Dimensions.paddingSizeDefault),

          Column(
            children: [
              Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Container(height: Dimensions.paddingSizeLarge, width: Dimensions.paddingSizeLarge, decoration: BoxDecoration(color: Theme.of(context).shadowColor, borderRadius: BorderRadius.circular(2))),
                const SizedBox(width: Dimensions.paddingSizeLarge),

                Container(height: 14, width: 200, decoration: BoxDecoration(
                  color: Theme.of(context).shadowColor, borderRadius: BorderRadius.circular(2),
                )),
              ]),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Container(height: Dimensions.paddingSizeLarge, width: Dimensions.paddingSizeLarge, decoration: BoxDecoration(color: Theme.of(context).shadowColor, borderRadius: BorderRadius.circular(2))),
                const SizedBox(width: Dimensions.paddingSizeLarge),

                Container(height: 14, width: 250, decoration: BoxDecoration(
                  color: Theme.of(context).shadowColor, borderRadius: BorderRadius.circular(2),
                )),
              ]),
            ],
          ),

          const SizedBox(height: Dimensions.paddingSizeDefault),



        ]),
      ),


    ]));
  }
}
