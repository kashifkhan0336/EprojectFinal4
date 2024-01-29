import 'package:flutter/material.dart';
import 'package:eproject_watchub/provider/wallet_provider.dart';
import 'package:eproject_watchub/utill/dimensions.dart';
import 'package:eproject_watchub/utill/styles.dart';
import 'package:eproject_watchub/view/screens/wallet/wallet_screen.dart';
import 'package:provider/provider.dart';

class TabButtonView extends StatelessWidget {
  final TabButtonModel? tabButtonModel;
  const TabButtonView({
    Key? key, this.tabButtonModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<WalletProvider>(
        builder: (context, walletProvider, _) {
          return GestureDetector(
            onTap: ()=> walletProvider.setCurrentTabButton(tabButtonList.indexOf(tabButtonModel)),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall, vertical: Dimensions.paddingSizeDefault),
              decoration: BoxDecoration(
                  color: walletProvider.selectedTabButtonIndex == tabButtonList.indexOf(tabButtonModel) ? Theme.of(context).cardColor : Theme.of(context).primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: walletProvider.selectedTabButtonIndex == tabButtonList.indexOf(tabButtonModel) ? [BoxShadow(
                    color: Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(0.1),
                    blurRadius: 15, offset: const Offset(0, 4),
                  )] : null,
              ),
              padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall, horizontal: Dimensions.paddingSizeSmall),
              child: Row(children: [
                Image.asset(
                  tabButtonModel!.buttonIcon, height: 20, width: 20,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(width: Dimensions.paddingSizeSmall,),

                Text(tabButtonModel!.buttonText!,
                  style: poppinsBold.copyWith(
                    fontSize: Dimensions.fontSizeSmall,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ]),
            ),
          );
        }
    );
  }
}