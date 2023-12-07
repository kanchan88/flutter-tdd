import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:workoneerweb/configs/app_assets.dart';
import 'package:workoneerweb/feature/client/data/model/bidder_account_model.dart';

class ShowBiddersWidget extends StatefulWidget {

  final BidderAccountModel bidderAccountModel;
  final int sorting;

  const ShowBiddersWidget({required this.bidderAccountModel,required this.sorting, Key? key}) : super(key: key);

  @override
  State<ShowBiddersWidget> createState() => _ShowBiddersWidgetState();
}

class _ShowBiddersWidgetState extends State<ShowBiddersWidget> {

  @override
  Widget build(BuildContext context) {

    return Row(
      children: [

        const Expanded(flex:1, child: Text(''),),

        Expanded(flex:6, child: Card(
          elevation: 0,
          color: const Color(0xFFBFDDEB),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6.0),
              ),
              child: ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.width * 0.1,
                    width: MediaQuery.of(context).size.width * 0.1,
                    child: Image.asset(AppAssets.profileIcn),
                  ),
                ),
                title: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ImageFiltered(
                      imageFilter:
                      ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                      child: Text(widget.bidderAccountModel.fullName,
                          style: Theme.of(context).textTheme.bodyText1),
                    ),
                    Text("#${widget.sorting+1} BIDDER",
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2!
                            .copyWith(letterSpacing: 2.0)),
                  ],
                ),
                trailing: Text(
                  "\$${widget.bidderAccountModel.bidAmount}",
                  style: Theme.of(context)
                      .textTheme
                      .headline6!
                      .copyWith(color: const Color(0xFF25B900)),
                ),
              )),
        )),

        const Expanded(flex:1, child: Text(''),),

      ],
    );
  }
}
