import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:workoneerweb/configs/app_assets.dart';
import 'package:workoneerweb/configs/app_colors.dart';
import 'package:workoneerweb/feature/client/domain/entities/auction_entity.dart';

class SingleAuctionCardTrader extends StatelessWidget {

  final AuctionEntity auctionModel;

  const SingleAuctionCardTrader({Key? key, required this.auctionModel,}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Card(
        elevation: 6.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6.0),
        ),
        color: AppColors.bgGreyColor,
        child: Row(

          children: [

            SizedBox(
              width: MediaQuery.of(context).size.width*0.11,
              height: MediaQuery.of(context).size.width*0.105,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Stack(
                  children: [

                    Container(
                      width: MediaQuery.of(context).size.width*0.07,
                      height: MediaQuery.of(context).size.width*0.07,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: AppColors.bgGreyColor,
                          border: Border.all(color: Colors.grey)
                      ),
                      child: auctionModel.images!.isNotEmpty?Image.network(
                        auctionModel.images![0].toString(),
                        fit: BoxFit.cover,
                      ):Image.asset(
                        AppAssets.appLogo,
                        fit: BoxFit.cover,
                      ),
                    ),

                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Image.asset(
                        AppAssets.tickIcon,
                        width: MediaQuery.of(context).size.width*0.02, height: MediaQuery.of(context).size.width*0.02,),
                    )

                  ],
                ),
              ),
            ),

            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Text("Auction ${auctionModel.lotNumber}", style: Theme.of(context).textTheme.headline6,),
                  ),

                  const Padding(
                    padding: EdgeInsets.all(3.0),
                    child: Text("10 bidders"),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Text(auctionModel.status.toString(), style: const TextStyle(color: AppColors.green, fontWeight: FontWeight.w600, fontSize: 14.0),),
                  ),

                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(10.0),
              child: IconButton(
                onPressed: (){
                  if(auctionModel.status.toString().startsWith("ENDED")){
                    GoRouter.of(context).goNamed(
                      'won-auction',
                      params: {'id':auctionModel.lotNumber.toString()},
                    );
                  } else {
                    GoRouter.of(context).goNamed(
                      'trader-live-auction',
                      params: {'id':auctionModel.lotNumber.toString()},
                    );
                  }
                },
                icon:Icon(Icons.arrow_forward_ios, size: MediaQuery.of(context).size.width*0.02,),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
