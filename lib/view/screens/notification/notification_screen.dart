import 'package:flutter/material.dart';
import 'package:eproject_watchub/helper/date_converter.dart';
import 'package:eproject_watchub/helper/responsive_helper.dart';
import 'package:eproject_watchub/localization/language_constraints.dart';
import 'package:eproject_watchub/provider/notification_provider.dart';
import 'package:eproject_watchub/utill/color_resources.dart';
import 'package:eproject_watchub/utill/dimensions.dart';
import 'package:eproject_watchub/utill/styles.dart';
import 'package:eproject_watchub/view/base/custom_app_bar.dart';
import 'package:eproject_watchub/view/base/custom_loader.dart';
import 'package:eproject_watchub/view/base/footer_view.dart';
import 'package:eproject_watchub/view/base/no_data_screen.dart';
import 'package:eproject_watchub/view/base/web_app_bar/web_app_bar.dart';
import 'package:eproject_watchub/view/screens/notification/widget/notification_dialog.dart';
import 'package:provider/provider.dart';

import '../../../provider/splash_provider.dart';
import '../../../utill/images.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    Provider.of<NotificationProvider>(context, listen: false).initNotificationList(context);

    return Scaffold(
      appBar: (ResponsiveHelper.isDesktop(context)? const PreferredSize(preferredSize: Size.fromHeight(120), child: WebAppBar()): CustomAppBar(title: getTranslated('notification', context))) as PreferredSizeWidget?,
      body: RefreshIndicator(
        onRefresh: () async {
          await Provider.of<NotificationProvider>(context, listen: false).initNotificationList(context);
        },
        backgroundColor: Theme.of(context).primaryColor,
        child: ListView(
          children: [
            // ResponsiveHelper.isDesktop(context) ? notificationProvider.notificationList.length<=4 ? SizedBox(height: 150) : SizedBox(): SizedBox(),
            ConstrainedBox(
              constraints: BoxConstraints(minHeight: ResponsiveHelper.isDesktop(context) ? MediaQuery.of(context).size.height - 400 : MediaQuery.of(context).size.height),
              child: Consumer<NotificationProvider>(
                  builder: (context, notificationProvider, child) {
                    List<DateTime> dateTimeList = [];
                    return notificationProvider.notificationList != null ? notificationProvider.notificationList!.isNotEmpty
                        ? Scrollbar(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height*0.6),
                        child: ListView.builder(
                            itemCount: notificationProvider.notificationList!.length,
                            padding: ResponsiveHelper.isDesktop(context) ? const EdgeInsets.symmetric(horizontal: 350, vertical: 20) :  EdgeInsets.zero,
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              DateTime originalDateTime = DateConverter.isoStringToLocalDate(notificationProvider.notificationList![index].createdAt!);
                              DateTime convertedDate = DateTime(originalDateTime.year, originalDateTime.month, originalDateTime.day);
                              bool addTitle = false;
                              if(!dateTimeList.contains(convertedDate)) {
                                addTitle = true;
                                dateTimeList.add(convertedDate);
                              }
                              return InkWell(
                                onTap: () {
                                  showDialog(context: context, builder: (BuildContext context) {
                                    return NotificationDialog(notificationModel: notificationProvider.notificationList![index]);
                                  });
                                },
                                hoverColor: Colors.transparent,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    addTitle ? Padding(
                                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 2),
                                      child: Text(DateConverter.isoStringToLocalDateOnly(notificationProvider.notificationList![index].createdAt!)),
                                    ) : const SizedBox(),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).cardColor,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Column(
                                        children: [
                                          const SizedBox(height: Dimensions.paddingSizeDefault),
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            // mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.symmetric(vertical: 5),
                                                child: Container(
                                                  height: 50, width: 50,
                                                  margin: EdgeInsets.symmetric(horizontal: ResponsiveHelper.isDesktop(context) ? Dimensions.paddingSizeLarge : 0),
                                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Theme.of(context).primaryColor.withOpacity(0.20)),
                                                  child: ClipRRect(
                                                    borderRadius: BorderRadius.circular(10),
                                                    child: FadeInImage.assetNetwork(
                                                      placeholder: Images.getPlaceHolderImage(context),
                                                      image: '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.notificationImageUrl}/${notificationProvider.notificationList![index].image}',
                                                      height: 150, width: MediaQuery.of(context).size.width, fit: BoxFit.cover,
                                                      imageErrorBuilder: (c, o, s) => Image.asset(Images.getPlaceHolderImage(context), height: 150, width: MediaQuery.of(context).size.width, fit: BoxFit.cover),
                                                    ),
                                                  ),
                                                ),
                                              ) ,
                                              const SizedBox(width: Dimensions.paddingSizeDefault),

                                              Expanded(
                                                child: ListTile(
                                                 contentPadding: EdgeInsets.zero,
                                                  title: Text(
                                                    notificationProvider.notificationList![index].title!,
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: poppinsBold.copyWith(
                                                      fontSize: Dimensions.fontSizeLarge,
                                                    ),
                                                  ),
                                                  subtitle: Text(notificationProvider.notificationList![index].description!,
                                                    style: poppinsLight.copyWith(
                                                      color: Theme.of(context).hintColor,
                                                    ),
                                                  ),
                                                ),
                                              ),

                                              const SizedBox(width: 10),
                                            ],
                                          ),
                                          const SizedBox(height: 20),
                                          Container(height: 1, color: ColorResources.getGreyColor(context).withOpacity(.2))
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                      ),
                    )
                        : NoDataScreen(title: getTranslated('no_notification_found', context),)
                        : SizedBox(height: MediaQuery.of(context).size.height *0.6,child: Center(child: CustomLoader(color: Theme.of(context).primaryColor)));
                  }
              ),
            ),
            ResponsiveHelper.isDesktop(context) ? const FooterView() : const SizedBox(),
          ],

        ),
      ),
    );
  }
}

