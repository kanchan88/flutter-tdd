import 'package:flutter/material.dart';
import 'package:workoneerweb/configs/app_assets.dart';
import 'package:workoneerweb/configs/app_colors.dart';

class Sidebar extends StatefulWidget {

  const Sidebar({Key? key}) : super(key: key);

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: const BoxDecoration(color: Colors.white),
      child: Column(
        children: [
          const SizedBox(
            height: 20.0,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            color: AppColors.primaryColor,
            padding:
            const EdgeInsets.symmetric(horizontal: 10.0),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 10.0, vertical: 15.0),
              child: Text(
                'My Auctions',
                style: Theme.of(context)
                    .textTheme
                    .bodyText2!
                    .copyWith(
                    fontWeight: FontWeight.w800,
                    color: Colors.white),
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            padding:
            const EdgeInsets.symmetric(horizontal: 10.0),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 10.0, vertical: 15.0),
              child: Text(
                'Live Auctions',
                style: Theme.of(context)
                    .textTheme
                    .bodyText2!
                    .copyWith(fontWeight: FontWeight.w800),
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            padding:
            const EdgeInsets.symmetric(horizontal: 10.0),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 10.0, vertical: 15.0),
              child: Text(
                'Won Auctions',
                style: Theme.of(context)
                    .textTheme
                    .bodyText2!
                    .copyWith(fontWeight: FontWeight.w800),
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            padding:
            const EdgeInsets.symmetric(horizontal: 10.0),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 10.0, vertical: 15.0),
              child: Text(
                'Download App',
                style: Theme.of(context)
                    .textTheme
                    .bodyText2!
                    .copyWith(fontWeight: FontWeight.w800),
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            padding:
            const EdgeInsets.symmetric(horizontal: 10.0),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 10.0, vertical: 15.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Image.asset(
                            AppAssets.androidAppIcon,
                            height: 50.0,
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          Text(
                            'Android',
                            style: Theme.of(context)
                                .textTheme
                                .bodyText2!
                                .copyWith(
                                fontWeight:
                                FontWeight.w800),
                          ),
                        ],
                      ),
                      const Text("OR"),
                      Column(
                        children: [
                          Image.asset(
                            AppAssets.iosAppIcon,
                            height: 50.0,
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          Text(
                            'Apple',
                            style: Theme.of(context)
                                .textTheme
                                .bodyText2!
                                .copyWith(
                                fontWeight:
                                FontWeight.w800),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 14.0),
                    child: Text(
                      "It’s a lot easier. Download now!",
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2,
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
