import 'package:flutter/material.dart';
import 'package:workoneerweb/configs/app_colors.dart';

class SingleBillingList extends StatelessWidget {

  final int index;

  const SingleBillingList({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
      const EdgeInsets.symmetric(horizontal: 10.0),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 2.0),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
                bottom: BorderSide(color: Colors.grey.shade300, width: 1.0)
            )
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width*0.25,
                child: Row(
                  children: [
                    Checkbox(
                      onChanged: (b){},
                      value: false,
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.primaryColorOff,
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(Icons.insert_drive_file, color: AppColors.primaryColor, size: 20.0,),
                        ),
                      ),
                    ),

                    SizedBox(
                      width:MediaQuery.of(context).size.width*0.12,
                      child: Text("#007$index",
                        textAlign: TextAlign.start, style: Theme.of(context).textTheme.bodyText2!.copyWith(fontWeight: FontWeight.w600, fontSize: 14.0),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(
                width: MediaQuery.of(context).size.width*0.15,
                child: Text("Dec 1, 2022",
                  textAlign: TextAlign.start, style: Theme.of(context).textTheme.bodyText2!.copyWith(fontWeight: FontWeight.w600, fontSize: 14.0),),
              ),

              SizedBox(
                width: MediaQuery.of(context).size.width*0.1,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: TextButton(
                    onPressed: () {},
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(AppColors.primaryColor),
                        shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30))),
                        padding: MaterialStateProperty.all(
                            const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 2.0
                            ))),
                    child: const Text(
                        "Paid",
                        style:TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white)),

                  ),
                ),
              ),

              SizedBox(
                width: MediaQuery.of(context).size.width*0.1,
                child: Text("\$10.00",
                  textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyText2!.copyWith(fontWeight: FontWeight.w600, fontSize: 14.0),
                ),
              ),


              Expanded(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width*0.2,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      Text(
                        "Basic Plan",
                        style: Theme.of(context).textTheme.bodyText2!.copyWith(fontWeight: FontWeight.w600, fontSize: 14.0),
                      ),

                      Text(
                        "Download",
                        style: Theme.of(context).textTheme.bodyText2!.copyWith(fontWeight: FontWeight.w600, color: AppColors.primaryColor, fontSize: 14.0),
                      ),

                    ],
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
