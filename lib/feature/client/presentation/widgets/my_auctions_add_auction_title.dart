import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';


class MyAuctionsAddAuctionsTitle extends StatefulWidget {

  const MyAuctionsAddAuctionsTitle({Key? key}) : super(key: key);

  @override
  State<MyAuctionsAddAuctionsTitle> createState() => _MyAuctionsAddAuctionsTitleState();
}

class _MyAuctionsAddAuctionsTitleState extends State<MyAuctionsAddAuctionsTitle> {


  @override
  Widget build(BuildContext context) {
    return Column(

      children: [

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "MY AUCTIONS",
                style: Theme.of(context).textTheme.headline3,
              ),
            ),

            InkWell(
              borderRadius: BorderRadius.circular(40.0),
              onTap: () {

                GoRouter.of(context).go("/client/add-auction");
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 8.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black87, width: 1.0),
                  borderRadius: BorderRadius.circular(40.0),
                ),
                child: Text(
                  "Add Auction",
                  style: Theme.of(context).textTheme.bodyText2,
                ),
              ),
            ),

          ],
        ),
      ],
    );
  }
}
