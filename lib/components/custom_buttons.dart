import 'package:flutter/material.dart';

import '../constants.dart';


class DefaultButton extends StatelessWidget {
  final VoidCallback onPress;
  final String titleB;


  const DefaultButton({super.key, required this.onPress, required this.titleB});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPress,
      child: Container(
        margin: const EdgeInsets.only(
          left: kDefaultPadding,
          right: kDefaultPadding,
        ),
        width: double.infinity,
        height: 60,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(
              Radius.circular(kDefaultPadding)),
          color: kPrimaryColor,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children:  [
            Text(titleB,
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w300,
                  color: kTextWhiteColor,
                  letterSpacing: 1.2),
            ),
          ],
        ),
      ),
    );
  }
}