import 'package:flutter/material.dart';

import '../extras/constants.dart';


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

class CustomElevatedButton extends StatelessWidget {
  final String titleB;
  final bool isLoading;
  final VoidCallback onPressed;

  CustomElevatedButton({
    required this.titleB,
    required this.isLoading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        left: kDefaultPadding,
        right: kDefaultPadding,
      ),
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(kDefaultPadding),
        ),
        color: kPrimaryColor,
      ),
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          primary: Colors.transparent,
          elevation: 0, // Remove elevation
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(kDefaultPadding),
          ),
        ),
        child: isLoading
            ? SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            color: kTextWhiteColor, // Use the appropriate color
            strokeWidth: 2,
          ),
        )
            : Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              titleB,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w300,
                color: kTextWhiteColor,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
