import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workoneerweb/core/widgets/loading_data.dart';
import 'package:workoneerweb/core/widgets/no_data_found.dart';
import 'package:workoneerweb/feature/client/domain/entities/auction_entity.dart';
import 'package:workoneerweb/feature/trader/presentation/bloc/client_details_bloc.dart';
import '/configs/app_colors.dart';


class ShowClientDetails extends StatefulWidget {

  final AuctionEntity auction;

  const ShowClientDetails({Key? key, required this.auction}) : super(key: key);

  @override
  State<ShowClientDetails> createState() => _ShowClientDetailsState();
}

class _ShowClientDetailsState extends State<ShowClientDetails> {

  @override
  void initState() {
    BlocProvider.of<ClientDetailBloc>(context).add(FetchClientDetailsEvent(clientId: widget.auction.client.toString()));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.6,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.white,
          border: Border.all(color: Colors.black54)),
      child: Column(

        children: [

          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "\$450",
                    style: Theme.of(context)
                        .textTheme
                        .headline4!
                        .copyWith(color: AppColors.primaryColor, fontSize: 36.0),
                  ),
                ),

                BlocBuilder<ClientDetailBloc, ClientDetailsState>(
                  builder: (context, state) {
                    if(state is LoadingClientDetailsState){
                      return const LoadingData();
                    }
                    else if ( state is LoadedClientDetailsState){
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          // name
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                    width: MediaQuery.of(context).size.width * 0.35,
                                    child: const Text(
                                      "Name:",
                                      style: TextStyle(
                                          fontSize: 18.0, fontWeight: FontWeight.w600),
                                    )),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width * 0.4,
                                  child: Text(
                                    state.user.fullName.toString(),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 18.0,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          // email
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                    width: MediaQuery.of(context).size.width * 0.35,
                                    child: const Text(
                                      "Email:",
                                      style: TextStyle(
                                          fontSize: 18.0, fontWeight: FontWeight.w600),
                                    )),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width * 0.4,
                                  child:Text(
                                    state.user.email.toString(),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 18.0,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          // phone
                          Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width * 0.35,
                                      child: const Text("Phone:",
                                          style: TextStyle(
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.w600))),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width * 0.4,
                                    child: Text(
                                      state.user.phone.toString(),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w800,
                                        fontSize: 18.0,
                                      ),
                                    ),
                                  )
                                ],
                              )
                          ),
                          // location
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                    width: MediaQuery.of(context).size.width * 0.35,
                                    child: const Text("Location:",
                                        style: TextStyle(
                                            fontSize: 18.0, fontWeight: FontWeight.w600))),

                                SizedBox(
                                  width: MediaQuery.of(context).size.width * 0.4,
                                  child: Text(
                                    "${state.user.postCode}, ${state.user.country}",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 18.0,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      );
                    } else {
                      return const NoDataFound(msg:"CLIENT DETAIL");
                    }
                  },
                ),
              ],
            ),
          ),

          SizedBox(
            height: MediaQuery.of(context).size.height * 0.02,
          ),

        ],
      ),
    );
  }
}
