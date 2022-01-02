import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';

class CountryCode extends StatelessWidget {
  final Function(String code) countryCode;
  const CountryCode({required this.countryCode, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      
      width: 120,
      child: CountryCodePicker(
        padding: const EdgeInsets.all(0.0),
        onChanged: (code) {
          countryCode(code.dialCode!);
        },
        
        initialSelection: 'ET',
        favorite: const ['+1', 'US'],
        showCountryOnly: false,
        showFlag: true,
        showOnlyCountryWhenClosed: false,
        alignLeft: false,
      ),
    );
  }
}