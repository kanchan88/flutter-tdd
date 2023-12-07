import 'package:flutter/material.dart';
import '/core/responsive/responsive_ui.dart';
import '/configs/app_colors.dart';

class ProgressDialog extends StatelessWidget {

  final String message;

  const ProgressDialog({Key? key,  required this.message }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        margin: const EdgeInsets.all(8.0),
        width: ResponsiveUI.isMobile(context)?double.infinity:MediaQuery.of(context).size.width*0.4,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 10.0,),
              const CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryColor),),
              const SizedBox(width: 6.0,),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  message,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
