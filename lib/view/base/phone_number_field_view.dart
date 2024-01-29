import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:eproject_watchub/localization/language_constraints.dart';
import 'package:eproject_watchub/view/base/custom_text_field.dart';
import 'package:eproject_watchub/view/screens/auth/widget/country_code_picker_widget.dart';

class PhoneNumberFieldView extends StatelessWidget {
  const PhoneNumberFieldView({
    Key? key,
    required this.onValueChange,
    required this.countryCode,
    required this.phoneNumberTextController,
    required this.phoneFocusNode,
  }) : super(key: key);

  final Function(String value) onValueChange;
  final String? countryCode;
  final TextEditingController phoneNumberTextController;
  final FocusNode phoneFocusNode;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Theme.of(context).primaryColor.withOpacity(0.2))
      ),
      child: Row(children: [
        CountryCodePickerWidget(
          onChanged: (CountryCode value)=> onValueChange(value.code!),
          initialSelection: countryCode,
          favorite: [countryCode ?? ''],
          showDropDownButton: true,
          padding: EdgeInsets.zero,
          showFlagMain: true,
          textStyle: TextStyle(color: Theme.of(context).textTheme.displayLarge!.color),

        ),

        Expanded(child: CustomTextField(
          controller: phoneNumberTextController,
          focusNode: phoneFocusNode,
          inputType: TextInputType.phone,
          hintText: getTranslated('number_hint', context),

        )),
      ]),
    );
  }
}