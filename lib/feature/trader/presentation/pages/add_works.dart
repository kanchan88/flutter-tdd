import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:steps_indicator/steps_indicator.dart';
import 'package:video_player/video_player.dart';
import '../../../../core/responsive/responsive_ui.dart';
import '../../../../core/responsive/use_mobile_app_dialog.dart';
import '/core/utils/validators.dart';
import '/feature/client/presentation/common/header_view.dart';
import '/feature/client/presentation/widgets/sidebar_dashboard.dart';
import '/configs/app_assets.dart';
import '/configs/app_colors.dart';


class TraderOnboarding extends StatefulWidget {

  const TraderOnboarding({Key? key}) : super(key: key);

  @override
  State<TraderOnboarding> createState() => _TraderOnboardingState();
}

class _TraderOnboardingState extends State<TraderOnboarding> {
  CarouselController stepsController = CarouselController();
  int selectedStep = 0;
  int? service;
  int nbSteps = 6;
  final searchTFC = TextEditingController();
  var categoryList = <SearchResultWidget>[];
  var subCategoryList = <SearchResultWidget>[];
  var images = <File>[];
  VideoPlayerController? videoPlayerController;
  String? selfieVideoThumbPath, selfieVideoPath, videoThumbPath, profileVideoPath;
  final postCodeTFC = TextEditingController(), kmsTFC = TextEditingController();
  final postCodeFN = FocusNode(), kmsFN = FocusNode();

  String? serviceType;
  String? serviceDescription;


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: ResponsiveUI.isMobile(context)? const UseAppDialog() :ListView(
        children: [

          const Header(),

          Padding(
            padding: EdgeInsets.symmetric(horizontal:MediaQuery.of(context).size.width*0.07, vertical: MediaQuery.of(context).size.height*0.05 ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                const Expanded(
                  flex: 2,
                  child: Sidebar(),
                ),
                const SizedBox(
                  width: 20.0,
                ),
                Expanded(
                  flex: 4,
                  child:Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      CarouselSlider(
                        carouselController: stepsController,
                        options: CarouselOptions(
                            onPageChanged: (val, res) {
                              setState(() {
                                selectedStep = val;
                              });
                            },
                            height: MediaQuery.of(context).size.height,
                            enableInfiniteScroll: false,
                            padEnds: false,
                            viewportFraction: 1),
                        items: _steps(),
                      ),

                      SizedBox(
                        height: 100,
                        child: StepsIndicator(
                          selectedStep: selectedStep,
                          nbSteps: nbSteps,
                          doneLineColor: AppColors.primaryColor,
                          doneStepColor: AppColors.primaryColor,
                          undoneLineColor: Colors.grey[400]!,
                          lineLength: 20,
                          doneLineThickness: 2,
                          doneStepSize: 16,
                          selectedStepColorIn: AppColors.primaryColor,
                          selectedStepColorOut: AppColors.primaryColor,
                          selectedStepSize: 24,
                          unselectedStepColorIn: Colors.grey[400]!,
                          unselectedStepColorOut: Colors.grey[400]!,
                          enableLineAnimation: true,
                          enableStepAnimation: true,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

        ],
      ),
    );
  }

  List<Widget> _steps() {

//    final jobCategoryBloc = BlocProvider.of<JobCategoryBloc>(context);

    return [
      // your type
      Card(
        elevation: 4.0,
        child: Container(
            width: MediaQuery.of(context).size.width,

            padding:  EdgeInsets.only(top: MediaQuery.of(context).size.height*0.1, right: 20, left: 20),
            color: Colors.white,
            child: Column(
                children: [

                  SizedBox(height: MediaQuery.of(context).size.height*0.05),

                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      "WHAT ARE YOU?",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 28, color: Colors.black, fontFamily: "Marcellus"),
                    ),
                  ),

                  const SizedBox(height: 20),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: searchTFC,
                      textInputAction: TextInputAction.search,
                      cursorColor: AppColors.primaryColor,
                      keyboardType: TextInputType.text,
                      textAlignVertical: TextAlignVertical.top,
                      style: const TextStyle(fontSize: 16.0),
                      onSubmitted: (keyword) {

                      },
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.search),
                        fillColor: Colors.white,
                        filled: true,
                        hintText: "Search Keyword",
                        hintStyle: const TextStyle(color: Colors.grey),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(color: Colors.grey.shade200),
                        ),

                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
//            BlocConsumer<JobCategoryBloc, JobCategoryState>(
//
//              listener: (context, state){
//
//                if(state is SuccessLoadedJobCategories){
//
//                  setState(() {
//                    for (int i = 0; i < state.jobCategories.length; i++) {
//                      categoryList.add(
//                        SearchResultWidget(name: state.jobCategories[i].name, id: state.jobCategories[i].id, isChosen: false),
//                      );
//                    }
//                  });
//
//                }
//              },
//
//              builder: (context, state) {
//
//                if(state is RequestToLoadJobCategories){
//                  return Padding(
//                    padding: const EdgeInsets.all(8.0),
//                    child: SizedBox(
//                      width: MediaQuery.of(context).size.width,
//                      child: ElevatedButton(
//                          onPressed: () {
//                            jobCategoryBloc.add( const FetchAllJobCategories(query: ''));
//                          },
//                          style: ButtonStyle(
//                              backgroundColor: MaterialStateProperty.all(
//                                  AppColors.primaryColor),
//                              shape: MaterialStateProperty.all(
//                                  RoundedRectangleBorder(
//                                      borderRadius: BorderRadius.circular(30))),
//                              padding: MaterialStateProperty.all(
//                                  EdgeInsets.symmetric(
//                                      vertical: 15,
//                                      horizontal:
//                                      MediaQuery.of(context).size.width /
//                                          3))),
//                          child: const Text(
//                            "Search",
//                            style: TextStyle(
//                                fontWeight: FontWeight.bold, fontSize: 18),
//                          )),
//                    ),
//                  );
//                }
//
//                else if (state is LoadingJobCategories) {
//                  return const Padding(
//                    padding: EdgeInsets.all(8.0),
//                    child: LoadingData(),
//                  );
//                } else if (state is SuccessLoadedJobCategories) {
//                  return Column(children: [
//                    categoryList.isEmpty?Padding(
//                      padding: const EdgeInsets.all(8.0),
//                      child: SizedBox(
//                        width: MediaQuery.of(context).size.width,
//                        child: ElevatedButton(
//                            onPressed: () {
//                              jobCategoryBloc.add( const FetchAllJobCategories(query: ''));
//                            },
//                            style: ButtonStyle(
//                                backgroundColor: MaterialStateProperty.all(
//                                    AppColors.primaryColor),
//                                shape: MaterialStateProperty.all(
//                                    RoundedRectangleBorder(
//                                        borderRadius: BorderRadius.circular(30))),
//                                padding: MaterialStateProperty.all(
//                                    EdgeInsets.symmetric(
//                                        vertical: 15,
//                                        horizontal:
//                                        MediaQuery.of(context).size.width /
//                                            3))),
//                            child: const Text(
//                              "Search",
//                              style: TextStyle(
//                                  fontWeight: FontWeight.bold, fontSize: 18),
//                            )),
//                      ),
//                    ):SizedBox(
//                      height: MediaQuery.of(context).size.height * 0.3,
//                      child: ListView(
//                        children: [
//                          for (var result in categoryList)
//                            TextButton(
//                              onPressed: () {
//                                setState(() {
//                                  for (var element in categoryList) {
//                                    element.isChosen = false;
//                                    setState(() {
//                                      chosenJobCategory = JobCategoryModel(id: element.id, name: element.name);
//                                    });
//                                  }
//                                  result.isChosen = true;
//                                });
//                              },
//                              child: Container(
//                                padding: const EdgeInsets.all(20),
//                                decoration: BoxDecoration(
//                                    border: result.isChosen
//                                        ? Border.all(
//                                        color: AppColors.primaryColor)
//                                        : Border.all(color: Colors.black26),
//                                    borderRadius: BorderRadius.circular(30),
//                                    color: result.isChosen
//                                        ? AppColors.primaryColor
//                                        : Colors.white),
//                                child: Row(children: [
//                                  Expanded(
//                                      child: Text(
//                                        result.name,
//                                        style: TextStyle(
//                                            color: result.isChosen
//                                                ? Colors.white
//                                                : Colors.black,
//                                            fontSize: 16),
//                                      ))
//                                ]),
//                              ),
//                            ),
//                        ],
//                      ),
//                    ),
//                    const SizedBox(height: 20),
//                    categoryList.isNotEmpty?Padding(
//                      padding: const EdgeInsets.all(8.0),
//                      child: SizedBox(
//                        width: MediaQuery.of(context).size.width,
//                        child: ElevatedButton(
//                            onPressed: () {
//                              if(chosenJobCategory==null){
//                                Fluttertoast.showToast(msg: 'Category is required');
//                              }
//                              else{
//                                stepsController.animateToPage(1,
//                                    duration: const Duration(milliseconds: 800));
//                              }
//                            },
//                            style: ButtonStyle(
//                                backgroundColor: MaterialStateProperty.all(
//                                    AppColors.primaryColor),
//                                shape: MaterialStateProperty.all(
//                                    RoundedRectangleBorder(
//                                        borderRadius:
//                                        BorderRadius.circular(30))),
//                                padding: MaterialStateProperty.all(
//                                    EdgeInsets.symmetric(
//                                        vertical: 15,
//                                        horizontal:
//                                        MediaQuery.of(context).size.width /
//                                            3))),
//                            child: const Text(
//                              "Continue",
//                              style: TextStyle(
//                                  fontWeight: FontWeight.bold, fontSize: 18),
//                            )),
//                      ),
//                    ):Container(height: 0,)
//                  ]);
//                } else {
//                  return const Text("WENT WRONG. CLOSE THE APP & TRY AGAIN");
//                }
//              },
//            ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      SizedBox(
                        width: MediaQuery.of(context).size.width*0.1,
                        child: Container(
                          color:  AppColors.bgGreyColor,
                          height: 2,
                        ),
                      ),

                      SizedBox(
                        width: MediaQuery.of(context).size.width*0.05,
                        child: const Center(child: Text("or")),
                      ),

                      SizedBox(
                        width: MediaQuery.of(context).size.width*0.1,
                        child: Container(
                          color:  AppColors.bgGreyColor,
                          height: 2,
                        ),
                      ),

                    ],
                  ),

                  SizedBox(
                    height: MediaQuery.of(context).size.height*0.03,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Go to app to for best experience", style: Theme.of(context).textTheme.bodyText2!.copyWith(color: AppColors.primaryColor),),
                    ],
                  ),

                ])),
      ),
      // profile video
      Card(
        elevation: 4.0,
        child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            padding:  EdgeInsets.only(top: MediaQuery.of(context).size.height*0.1, right: 20, left: 20),
            decoration: const BoxDecoration(color: Colors.white),
            child: Column(
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height*0.05),
                  const Text(
                    "PROFILE VIDEO",
                    style: TextStyle(
                        fontSize: 32, color: Colors.black, fontFamily: "Marcellus"),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    margin: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                        color: Colors.grey[400],
                        borderRadius: BorderRadius.circular(30)),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [

                        DottedBorder(
                          borderType: BorderType.RRect,
                          radius: const Radius.circular(20),
                          color: Colors.grey.shade400,
                          dashPattern: const [20, 20],
                          strokeWidth: 3.0,
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: profileVideoPath != null
                                  ? Image.network(
                                profileVideoPath!,
                                color: AppColors.primaryColorOff,
                                height: MediaQuery.of(context).size.height*0.4,
                                width: MediaQuery.of(context).size.width*0.48,
                                fit: BoxFit.cover,
                              )
                                  :  Container(
                                  color: AppColors.primaryColorOff,
                                  height: MediaQuery.of(context).size.height*0.4,
                                  width: MediaQuery.of(context).size.width*0.48,
                                  child: const Text(" "))),
                        ),

                        IconButton(

                          onPressed: () async {
                            if (profileVideoPath != null) {

                            }
                          },

                          icon: const Icon(
                            Icons.play_circle,
                            color: Colors.white,
                            size: 48,
                          ),

                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                              onPressed: () async {

                              },
                              style: ButtonStyle(
                                  shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(30))),
                                  backgroundColor:
                                  MaterialStateProperty.all(AppColors.green),
                                  padding: MaterialStateProperty.all(
                                      const EdgeInsets.all(15))),
                              child: const Text(
                                "Send to phone",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 18),
                              )),
                        ),

                        SizedBox(width: MediaQuery.of(context).size.width*0.02,),

                        Expanded(
                          child: profileVideoPath == null
                              ? ElevatedButton(
                              onPressed: () async {

                              },
                              style: ButtonStyle(
                                  shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(30))),
                                  padding: MaterialStateProperty.all(
                                      const EdgeInsets.all(15))),
                              child: const Text(
                                "Upload",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 18),
                              ),
                          )
                              : ElevatedButton(
                              onPressed: () async {
                                stepsController.animateToPage(3,
                                    duration: const Duration(milliseconds: 800),
                                    curve: Curves.ease);
                              },
                              style: ButtonStyle(
                                  shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(30))),
                                  padding: MaterialStateProperty.all(
                                      const EdgeInsets.all(15))),
                              child: const Text(
                                "Continue",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 18),
                              )),
                        )
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width*0.1,
                        child: Container(
                          color:  AppColors.bgGreyColor,
                          height: 2,
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width*0.05,
                        child: const  Center(child: Text("or")),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width*0.1,
                        child: Container(
                          color:  AppColors.bgGreyColor,
                          height: 2,
                        ),
                      ),

                    ],
                  ),

                  SizedBox(
                    height: MediaQuery.of(context).size.height*0.03,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Go to app to for best experience", style: Theme.of(context).textTheme.bodyText2!.copyWith(color: AppColors.primaryColor),),
                    ],
                  ),
                ])),
      ),
      // upload photos
      Card(
        elevation: 4.0,
        child: Container(
            width: MediaQuery.of(context).size.width,
            padding:  EdgeInsets.only(top: MediaQuery.of(context).size.height*0.1, right: 20, left: 20),
            decoration: const BoxDecoration(color: Colors.white),
            child: Column(children: [
              SizedBox(height: MediaQuery.of(context).size.height*0.05),
              const Text(
                "MY WORKS",
                style: TextStyle(
                    fontSize: 32, color: Colors.black, fontFamily: "Marcellus"),
              ),
              const SizedBox(height: 20),
              DottedBorder(
                borderType: BorderType.RRect,
                radius: const Radius.circular(20),
                color: Colors.grey.shade400,
                dashPattern: const [20, 20],
                strokeWidth: 3.0,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  height: MediaQuery.of(context).size.height*0.4,
                  width: MediaQuery.of(context).size.width*0.48,
                  decoration: BoxDecoration(
                      color: AppColors.primaryColorOff,
                      borderRadius: BorderRadius.circular(20)),
                  child: images.isEmpty
                      ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                       InkWell(
                        onTap: () async {

                        },
                        child: const Icon(
                          Icons.drive_folder_upload_rounded,
                          color: Colors.white,
                          size: 48,
                        ),
                      ),
                    ],
                  )
                      : SizedBox(
                    height: MediaQuery.of(context).size.height*0.4,
                    width: MediaQuery.of(context).size.width*0.48,
                    child: GridView.count(
                        crossAxisCount: 4,
                        mainAxisSpacing: 8,
                        crossAxisSpacing: 8,
                        children: images
                            .map((image) => ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                                image.path,
                                height: 80,
                                width: 80,
                                fit: BoxFit.cover)))
                            .toList()),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [

                    Expanded(
                      child: ElevatedButton(
                          onPressed: () async {

                          },
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30))),
                              backgroundColor: MaterialStateProperty.all(AppColors.green),
                              padding: MaterialStateProperty.all(
                                  const EdgeInsets.all(15))),
                          child: const Text(
                            "Send to phone",
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 18),
                          )),
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width*0.02,),
                    Expanded(
                      child: images.isEmpty
                          ? ElevatedButton(
                          onPressed: () async {


                          },
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(30))),
                              padding: MaterialStateProperty.all(
                                  const EdgeInsets.all(15))),
                          child: const Text(
                            "Upload",
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 18),
                          ),
                      )
                          : ElevatedButton(
                          onPressed: () async {
                            stepsController.animateToPage(5,
                                curve: Curves.ease,
                                duration: const Duration(milliseconds: 800));
                          },
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(30))),
                              padding: MaterialStateProperty.all(
                                  const EdgeInsets.all(15))),
                          child: const Text(
                            "Continue",
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 18),
                          )),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width*0.1,
                    child: Container(
                      color:  AppColors.bgGreyColor,
                      height: 2,
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width*0.05,
                    child: const Center(child: Text("or")),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width*0.1,
                    child: Container(
                      color:  AppColors.bgGreyColor,
                      height: 2,
                    ),
                  ),

                ],
              ),

              SizedBox(
                height: MediaQuery.of(context).size.height*0.03,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Go to app to for best experience", style: Theme.of(context).textTheme.bodyText2!.copyWith(color: AppColors.primaryColor),),
                ],
              ),
            ])),
      ),
      // postal area
      Card(
        elevation: 4.0,
        child: Container(
            width:  MediaQuery.of(context).size.width,
            padding:  EdgeInsets.only(top: MediaQuery.of(context).size.height*0.1, right: 20, left: 20),
            decoration: const BoxDecoration(color: Colors.white),
            child: Column(children: [
              SizedBox(height: MediaQuery.of(context).size.height*0.05),
              const Text(
                "SET YOUR WORKING\nAREA POST CODE",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 32, color: Colors.black, fontFamily: "Marcellus"),
              ),
              const SizedBox(height: 40),
              Image.asset(
                AppAssets.mapIcn,
                height: 120,
              ),
              const SizedBox(height: 40),
              const Text("Where do you offer your services? "),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child:
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Container(
                    constraints: const BoxConstraints(maxWidth: 180),
                    child: TextField(
                      controller: postCodeTFC,
                      onEditingComplete: () =>
                          FocusScope.of(context).requestFocus(kmsFN),
                      textInputAction: TextInputAction.done,
                      cursorColor: AppColors.primaryColor,
                      keyboardType: TextInputType.text,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16.0),
                      decoration: InputDecoration(
                          fillColor: Colors.grey[50],
                          filled: true,
                          hintText: "Post Code",
                          hintStyle: const TextStyle(color: Colors.grey),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: const BorderSide(
                                color: AppColors.primaryColor, width: 1.5),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: const BorderSide(color: Colors.grey),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: const BorderSide(color: Colors.grey),
                          ),
                          contentPadding:
                          const EdgeInsets.symmetric(horizontal: 20)),
                    ),
                  ),

                  const SizedBox(width: 20),

                  Container(
                    constraints: const BoxConstraints(maxWidth: 180),
                    child: TextField(
                      controller: kmsTFC,
                      textAlign: TextAlign.center,
                      textInputAction: TextInputAction.done,
                      cursorColor: AppColors.primaryColor,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(fontSize: 16.0),
                      decoration: InputDecoration(
                          fillColor: Colors.grey[50],
                          filled: true,
                          hintText: "km",
                          hintStyle: const TextStyle(color: Colors.grey),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: const BorderSide(
                                color: AppColors.primaryColor, width: 1.5),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: const BorderSide(color: Colors.grey),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: const BorderSide(color: Colors.grey),
                          ),
                          contentPadding:
                          const EdgeInsets.symmetric(horizontal: 20)),
                    ),
                  ),
                ]),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          if(await validatePostCode(postCodeTFC.text, '+611245')==false){
                            Fluttertoast.showToast(msg: "Invalid Postal Address");
                          } else {
                            stepsController.animateToPage(4,
                                duration: const Duration(milliseconds: 800));
                          }

                        },
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(AppColors.primaryColor),
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30))),
                            padding: MaterialStateProperty.all(
                                const EdgeInsets.all(15))),
                        child: const Text(
                          "Continue",
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 18),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ])),
      ),
      // overall review
      Card(
        elevation: 4.0,
        child: Container(
            width: MediaQuery.of(context).size.width,
            padding:  EdgeInsets.only(top: MediaQuery.of(context).size.height*0.1, right: 20, left: 20),
            decoration: const BoxDecoration(color: Colors.white),
            child: Column(children: [
              SizedBox(
                height: MediaQuery.of(context).size.height*0.05,
              ),
              const Text(
                "FILES UPLOADED",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 32, color: Colors.black, fontFamily: "Marcellus"),
              ),
              const SizedBox(height: 40),
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
                child: Row(
                  children: [
                    if (profileVideoPath != null)
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(File(videoThumbPath!),
                                height: 80, width: 80, fit: BoxFit.cover)),
                      ),
                    if (profileVideoPath == null)
                      const Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Icon(Icons.not_interested,
                            size: 48, color: Colors.red),
                      ),
                    Expanded(
                      child: Text(
                        profileVideoPath != null
                            ? "VIDEO UPLOADED"
                            : "VIDEO NOT UPLOADED",
                        style: const TextStyle(fontSize: 16),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
                child: Row(
                  children: [
                    if (selfieVideoPath != null)
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(File(selfieVideoPath!),
                                height: 80, width: 80, fit: BoxFit.cover)),
                      ),
                    if (selfieVideoPath == null)
                      const Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Icon(Icons.not_interested,
                            size: 48, color: Colors.red),
                      ),
                    Expanded(
                        child: Text(
                          selfieVideoPath != null
                              ? "SELFIE VIDEO UPLOADED"
                              : "SELFIE VIDEO NOT UPLOADED",
                          style: const TextStyle(fontSize: 16),
                        ))
                  ],
                ),
              ),
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
                child: Row(
                  children: [
                    if (images.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(File(images.first.path),
                                height: 80, width: 80, fit: BoxFit.cover)),
                      ),
                    if (images.isEmpty)
                      const Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Icon(Icons.not_interested,
                            size: 48, color: Colors.red),
                      ),
                    Expanded(
                        child: Text(
                          images.isNotEmpty
                              ? "PHOTOS UPLOADED"
                              : "PHOTOS NOT UPLOADED",
                          style: const TextStyle(fontSize: 16),
                        ))
                  ],
                ),
              ),
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
                child: Row(
                  children: const [
                    if ("s"!="s")
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Icon(Icons.done, size: 48, color: Colors.green),
                      ),
                    if ("s"=="s")
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Icon(Icons.not_interested,
                            size: 48, color: Colors.red),
                      ),
                    Expanded(
                        child: Text(
                          "s"=="s" ? "SERVICE INFO" : "NO SERVICE INFO",
                          style: TextStyle(fontSize: 16),
                        ))
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                          onPressed: () async {
                            if (images.isEmpty || selfieVideoPath == null || profileVideoPath == null) {
                              Fluttertoast.showToast(msg: "Add Missing to Continue");
                            } else {
                              stepsController.animateToPage(9, duration: const Duration(milliseconds: 800));
                            }
                          },
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30))),
                              padding: MaterialStateProperty.all(
                                  const EdgeInsets.all(15))),
                          child: const Text(
                            "Done",
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 18),
                          )),
                    ),
                  ],
                ),
              ),
            ])),
      ),
      // done
      Card(
        elevation: 4.0,
        child: GestureDetector(
          onTap: () async {
            if (images.isEmpty) {
              Fluttertoast.showToast(
                  msg: "Some files are missing! Add them to continue");
            }

            else if(selfieVideoPath == null){
              Fluttertoast.showToast(
                  msg: "Selfie Video is missing");
            }

            else if( profileVideoPath == null ){
              Fluttertoast.showToast(
                  msg: "Service Video is missing");
            }

            else {

            }
          },
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding:  EdgeInsets.only(top: MediaQuery.of(context).size.height*0.1, right: 20, left: 20),
            decoration: const BoxDecoration(color: Colors.white),
            child: Column(children: [
              SizedBox(
                height: MediaQuery.of(context).size.height*0.1,
              ),
              TweenAnimationBuilder(
                duration: const Duration(milliseconds: 600),
                tween: Tween<double>(begin: 0, end: 4),
                builder: (BuildContext ctx, double val, Widget? child) {
                  return SizedBox(height: 40 * val, child: child);
                },
                child: Image.asset(AppAssets.doneIcn, height: 120),
              ),
              const SizedBox(height: 20),
              const Text(
                "NICELY DONE",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 32, color: Colors.black, fontFamily: "Marcellus"),
              ),
              const Padding(
                padding: EdgeInsets.all(10.0),
                child: Text("tap to continue"),
              ),
              Expanded(
                child: Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: const [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: Text(
                          "YOUR JOB WILL NOW GO FOR QUALITY ASSURANCE.",
                          style: TextStyle(fontSize: 16, color: Colors.black54),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ]),
          ),
        ),
      ),
    ];
  }
}

class SearchResultWidget {
  String name;
  String id;
  bool isChosen;

  SearchResultWidget({required this.name, required this.id, required this.isChosen});
}

class ServiceWidget {
  String name;
  String id;
  int isChosen;

  ServiceWidget({required this.name, required this.id, required this.isChosen});
}
