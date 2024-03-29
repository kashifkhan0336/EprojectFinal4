import 'package:flutter/material.dart';
import 'package:eproject_watchub/data/model/response/product_model.dart';
import 'package:eproject_watchub/helper/responsive_helper.dart';
import 'package:eproject_watchub/localization/language_constraints.dart';
import 'package:eproject_watchub/provider/splash_provider.dart';
import 'package:eproject_watchub/utill/color_resources.dart';
import 'package:eproject_watchub/utill/dimensions.dart';
import 'package:eproject_watchub/utill/styles.dart';
import 'package:eproject_watchub/view/base/custom_image.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class ReviewWidget extends StatelessWidget {
  final ActiveReview reviewModel;
  const ReviewWidget({Key? key, required this.reviewModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String? customerName = getTranslated('user_not_available', context);

    if(reviewModel.customer != null) {
      customerName = '${reviewModel.customer!.fName ?? ''} ${reviewModel.customer!.lName ?? ''}';
    }




    return Container(
      margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Theme.of(context).cardColor,
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [

          ClipOval(
            child: CustomImage(
              image: '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.customerImageUrl}/${
                  reviewModel.customer != null ? reviewModel.customer!.image ?? '' : ''}',
              height: 50, width: 50, fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 5),

          Expanded(
            child: Column(crossAxisAlignment:CrossAxisAlignment.start, children: [

              Text(
                customerName,
                style: poppinsMedium.copyWith(fontSize: Dimensions.fontSizeLarge),
                maxLines: 1, overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              Row(children: [

                const Icon(Icons.star_rounded, color: ColorResources.ratingColor, size: 20),
                const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                Text('${reviewModel.rating}', style: poppinsRegular.copyWith(color: ColorResources.ratingColor)),

              ]),
              SizedBox(height: ResponsiveHelper.isDesktop(context) ? Dimensions.paddingSizeLarge : Dimensions.paddingSizeSmall),

              Text(reviewModel.comment!, style: poppinsRegular),

            ]),
          ),

        ]),
      ]),
    );
  }
}

class ReviewShimmer extends StatelessWidget {
  const ReviewShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Theme.of(context).cardColor,
      ),
      child: Shimmer(
        duration: const Duration(seconds: 2),
        enabled: true,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Container(height: 30, width: 30, decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle)),
            const SizedBox(width: 5),
            Container(height: 15, width: 100, color: Colors.white),
            const Expanded(child: SizedBox()),
            Icon(Icons.star, color: Theme.of(context).primaryColor, size: 18),
            const SizedBox(width: 5),
            Container(height: 15, width: 20, color: Colors.white),
          ]),
          const SizedBox(height: 5),
          Container(height: 15, width: MediaQuery.of(context).size.width, color: Colors.white),
          const SizedBox(height: 3),
          Container(height: 15, width: MediaQuery.of(context).size.width, color: Colors.white),
        ]),
      ),
    );
  }
}

