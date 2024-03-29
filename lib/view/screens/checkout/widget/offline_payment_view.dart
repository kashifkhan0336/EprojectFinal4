import 'package:flutter/material.dart';
import 'package:eproject_watchub/data/model/response/offline_payment_model.dart';
import 'package:eproject_watchub/helper/order_helper.dart';
import 'package:eproject_watchub/helper/price_converter.dart';
import 'package:eproject_watchub/helper/responsive_helper.dart';
import 'package:eproject_watchub/localization/app_localization.dart';
import 'package:eproject_watchub/localization/language_constraints.dart';
import 'package:eproject_watchub/provider/order_provider.dart';
import 'package:eproject_watchub/provider/splash_provider.dart';
import 'package:eproject_watchub/utill/dimensions.dart';
import 'package:eproject_watchub/utill/images.dart';
import 'package:eproject_watchub/utill/styles.dart';
import 'package:eproject_watchub/view/base/custom_button.dart';
import 'package:eproject_watchub/view/base/custom_text_field.dart';
import 'package:eproject_watchub/view/screens/checkout/widget/place_order_button_view.dart';
import 'package:provider/provider.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class OfflinePaymentView extends StatefulWidget {
  const OfflinePaymentView({Key? key}) : super(key: key);

  @override
  State<OfflinePaymentView> createState() => _OfflinePaymentViewState();
}

class _OfflinePaymentViewState extends State<OfflinePaymentView> {
  AutoScrollController? scrollController;
  Map<String, String>? selectedValue;


  @override
  void initState() {
    scrollController = AutoScrollController(
      viewportBoundaryGetter: () => Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom),
      axis: Axis.horizontal,
    );

    int? index = Provider.of<SplashProvider>(context, listen: false).offlinePaymentModelList?.indexOf(
      Provider.of<OrderProvider>(context, listen: false).selectedOfflineMethod,
    );
    if(index != null){
      scrollController?.scrollToIndex(index, preferPosition: AutoScrollPosition.middle);
      scrollController?.highlight(index);
    }



    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final SplashProvider splashProvider = Provider.of<SplashProvider>(context, listen: false);

    return Center(child: SizedBox(width: 600, child: Container(
      constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * 0.9),
      margin: const EdgeInsets.all(Dimensions.paddingSizeLarge),
      padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(Dimensions.radiusSizeSmall),
      ),
      child: Consumer<OrderProvider>(builder: (context, orderProvider, _) {

        // return Text('data');
        return Column(mainAxisSize: MainAxisSize.min, children: [
          Expanded(child: SingleChildScrollView(
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Text(getTranslated('offline_payment', context), style: poppinsMedium.copyWith(fontSize: Dimensions.fontSizeDefault)),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              Image.asset(Images.offlinePayment, height: 100),
              const SizedBox(height: Dimensions.paddingSizeDefault),

              Text(getTranslated('pay_your_bill_using_the_info', context), textAlign: TextAlign.center, style: poppinsRegular.copyWith(
                fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).textTheme.bodySmall?.color,
              )),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              SingleChildScrollView(
                controller: scrollController, scrollDirection: Axis.horizontal,
                child: IntrinsicHeight(
                  child: Row(children: splashProvider.offlinePaymentModelList!.map((offline) => AutoScrollTag(
                    controller: scrollController!,
                    key: ValueKey(splashProvider.offlinePaymentModelList!.indexOf(offline)),
                    index: splashProvider.offlinePaymentModelList!.indexOf(offline),
                    child: InkWell(
                      onTap: () async {
                        orderProvider.formKey.currentState?.reset();
                        orderProvider.changePaymentMethod(offlinePaymentModel: offline);

                        await scrollController!.scrollToIndex(splashProvider.offlinePaymentModelList!.indexOf(offline), preferPosition: AutoScrollPosition.middle);
                        await scrollController!.highlight(splashProvider.offlinePaymentModelList!.indexOf(offline));
                      },
                      child: Container(
                        width: ResponsiveHelper.isMobile() ? MediaQuery.sizeOf(context).width * 0.7 : 300,
                        constraints: const BoxConstraints(minHeight: 160),
                        padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                        margin: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          border: Border.all(color: Theme.of(context).primaryColor.withOpacity(0.1), width: 1),
                          borderRadius: BorderRadius.circular(Dimensions.radiusSizeLarge),
                          boxShadow: [BoxShadow(
                            color: Theme.of(context).primaryColor.withOpacity(0.05),
                            offset: const Offset(0, 4), blurRadius: 8,
                          )],
                        ),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          FittedBox(
                            alignment: Alignment.centerLeft,
                            child: Row(children: [
                              Text(offline?.methodName ?? '', style: poppinsRegular.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).primaryColor)),
                              const SizedBox(width: Dimensions.paddingSizeDefault),

                              if(offline?.id == orderProvider.selectedOfflineMethod?.id)
                                Row(mainAxisAlignment: MainAxisAlignment.end,  children: [
                                  Text(getTranslated('pay_on_this_account', context),  maxLines: 1, style: poppinsRegular.copyWith(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: Dimensions.fontSizeSmall, overflow: TextOverflow.ellipsis,
                                  )),
                                  const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                                  Icon(Icons.check_circle_rounded, color: Theme.of(context).primaryColor)
                                ]),

                            ]),
                          ),
                          const SizedBox(height: Dimensions.paddingSizeDefault),

                          if(offline?.methodFields != null) BillInfoWidget(methodList: offline!.methodFields!),

                        ]),
                      ),
                    ),
                  )).toList()),
                ),
              ),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              Text(
                '${getTranslated('amount', context)} : ${PriceConverter.convertPrice(
                  context, orderProvider.partialAmount ?? OrderHelper.getTotalAmount(
                  subTotal: orderProvider.getCheckOutData?.amount,
                  deliveryCharge: orderProvider.getCheckOutData?.deliveryCharge,
                ))}',
                style: poppinsBold.copyWith(fontSize: Dimensions.fontSizeLarge),
              ),
              const SizedBox(height: Dimensions.paddingSizeExtraLarge),


              if(orderProvider.selectedOfflineMethod?.methodFields != null) PaymentInfoWidget(
                methodInfo: orderProvider.selectedOfflineMethod!.methodInformations!,
                key: ObjectKey(orderProvider.selectedOfflineMethod!.methodInformations!),
              ),








            ]),
          )),

          Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            SizedBox(width: 100, child: CustomButton(
              borderRadius: Dimensions.radiusSizeLarge,
              buttonText: getTranslated('close', context), width: 100,
              backgroundColor: Theme.of(context).disabledColor,
              onPressed: ()=> Navigator.pop(context),
            )),
            const SizedBox(width: Dimensions.paddingSizeDefault),

            const SizedBox(width: 130, child: PlaceOrderButtonView(
              fromOfflinePayment: true,
            )),

          ]),

          SizedBox(height: MediaQuery.of(context).viewInsets.bottom * 0.9),
        ]);
      }),
    )));
  }
}


class BillInfoWidget extends StatelessWidget {
  final List<MethodField> methodList;
  const BillInfoWidget({Key? key, required this.methodList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: methodList.map((method) => Padding(
      padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeExtraSmall),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(method.fieldName ?? '', style: poppinsRegular),
        const SizedBox(width: Dimensions.paddingSizeSmall),

        Flexible(child: Text(' :  ${method.fieldData}',
          style: poppinsRegular, maxLines: 1,
          overflow: TextOverflow.ellipsis,
        )),
      ]),
    )).toList());
  }
}

class PaymentInfoWidget extends StatefulWidget {
  final List<MethodInformation> methodInfo;

  const PaymentInfoWidget({Key? key, required this.methodInfo}) : super(key: key);

  @override
  State<PaymentInfoWidget> createState() => _PaymentInfoWidgetState();
}

class _PaymentInfoWidgetState extends State<PaymentInfoWidget> {

  final TextEditingController noteTextController = TextEditingController();

  @override
  void initState() {
    final OrderProvider orderProvider = Provider.of<OrderProvider>(context, listen: false);
    orderProvider.field = {};
    for(int i = 0; i < widget.methodInfo.length; i++){
      orderProvider.field.addAll({'${widget.methodInfo[i].informationName}' : TextEditingController()});
    }
    super.initState();
  }

  @override
  void dispose() {
    noteTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(getTranslated('payment_info', context), style: poppinsMedium,),
      const SizedBox(height: Dimensions.paddingSizeSmall),

      Consumer<OrderProvider>(
        builder: (context, orderProvider, _) {
          return Column(children: [
            Form(
                key: orderProvider.formKey,
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: orderProvider.field.length,
                  padding: const EdgeInsets.symmetric(
                    vertical: Dimensions.paddingSizeExtraSmall, horizontal: 10,
                  ),

                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall),
                    child: CustomTextField(
                      onValidate: widget.methodInfo[index].informationRequired! ? (String? value){
                       return value != null && value.isEmpty ? '${widget.methodInfo[index].informationName?.replaceAll("_", " ").toCapitalized()
                       } ${getTranslated('is_required', context)}' : null;
                      }: null,
                      isShowBorder: true,
                      controller: orderProvider.field['${widget.methodInfo[index].informationName}'],
                      hintText:  widget.methodInfo[index].informationPlaceholder,
                      fillColor: Theme.of(context).cardColor,
                    ),
                  ),
                ),
              ),
            const SizedBox(height: Dimensions.paddingSizeDefault),


            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
              child: CustomTextField(
                fillColor: Theme.of(context).cardColor,
                isShowBorder: true,
                controller: noteTextController,
                hintText: getTranslated('enter_your_payment_note', context),
                maxLines: 5,
                inputType: TextInputType.multiline,
                inputAction: TextInputAction.newline,
                capitalization: TextCapitalization.sentences,
                onChanged: (value) {
                  orderProvider.selectedOfflineMethod?.copyWith(note: noteTextController.text);
                },
              ),
            ),



          ]);
        }
      )




    ]);
  }
}
