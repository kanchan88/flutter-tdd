import 'dart:typed_data';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:provider/provider.dart';
import 'package:steps_indicator/steps_indicator.dart';
import 'package:video_player/video_player.dart';
import 'package:workoneerweb/core/provider/login_state_provider.dart';
import 'package:workoneerweb/core/responsive/responsive_ui.dart';
import 'package:workoneerweb/core/responsive/use_mobile_app_dialog.dart';
import 'package:workoneerweb/core/widgets/loading_data.dart';
import 'package:workoneerweb/feature/auth/presentation/providers/authentication_provider.dart';
import 'package:workoneerweb/feature/client/data/model/job_category_model.dart';
import 'package:workoneerweb/feature/client/data/model/job_sub_category_model.dart';
import 'package:workoneerweb/feature/client/presentation/bloc/add_auction_bloc.dart';
import 'package:workoneerweb/feature/client/presentation/bloc/job_category_bloc.dart';
import 'package:workoneerweb/feature/client/presentation/bloc/job_sub_category_bloc.dart';
import 'package:workoneerweb/feature/client/presentation/widgets/local_video_player.dart';
import '../../../auth/domain/entities/user.dart';
import '../../../trader/presentation/common/un_autenticated_view.dart';
import '/configs/app_assets.dart';
import '/configs/app_colors.dart';

class AddJobCarouselContainer extends StatefulWidget {
  const AddJobCarouselContainer({Key? key}) : super(key: key);

  @override
  State<AddJobCarouselContainer> createState() =>
      _AddJobCarouselContainerState();
}

class _AddJobCarouselContainerState extends State<AddJobCarouselContainer> {
  CarouselController stepsController = CarouselController();
  int selectedStep = 0;
  int? service;
  int nbSteps = 6;
  final searchTFC = TextEditingController();
  var categoryList = <SearchResultWidget>[];
  var subCategoryList = <SearchResultWidget>[];
  List<Uint8List>? images = [];
  VideoPlayerController? videoPlayerController;
  Uint8List? selfieVideoFile, videoFile;
  final postCodeTFC = TextEditingController(), kmsTFC = TextEditingController();
  final postCodeFN = FocusNode(), kmsFN = FocusNode();

  String? serviceType;
  String? serviceDescription;

  bool getSubCatOnce = true;
  JobCategoryModel? chosenJobCategory = JobCategoryModel(id: '1', name: 'ERR');
  JobSubCategoryModel? chosenJobSubCategory;

  @override
  void initState() {
    BlocProvider.of<JobCategoryBloc>(context).add(FetchJobCategoryEvents());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveUI.isMobile(context)? const UseAppDialog() : Container(
      child: Expanded(
        flex: 4,
        child: Provider.of<LoginStateProvider>(context, listen:false).getUserType!=UserType.client ? const UnAuthenticatedView(user: 'client'):
        Stack(
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
                viewportFraction: 1,
              ),
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
    );
  }

  List<Widget> _steps() {

    return [
      // search service
      Card(
        elevation: 4.0,
        child: Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.1,
                right: 20,
                left: 20),
            color: Colors.white,
            child: Column(children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "WHAT NEED TO BE DONE",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 28,
                      color: Colors.black,
                      fontFamily: "Marcellus"),
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
                  onSubmitted: (keyword) {},
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    fillColor: Colors.white,
                    filled: true,
                    hintText: "Search Keyword",
                    hintStyle: const TextStyle(color: Colors.grey),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 10.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(color: Colors.grey.shade200),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              BlocConsumer<JobCategoryBloc, JobCategoryState>(
                listener: (context, state) {
                  if (state is LoadedJobCategoryState) {
                    setState(() {
                      for (int i = 0; i < state.allJobs.length; i++) {
                        categoryList.add(
                          SearchResultWidget(
                              name: state.allJobs[i].name,
                              id: state.allJobs[i].id,
                              isChosen: false),
                        );
                      }
                    });
                  }
                },
                builder: (context, state) {
                  if (state is StartJobCategoryState) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: ElevatedButton(
                            onPressed: () {
                              BlocProvider.of<JobCategoryBloc>(context)
                                  .add(FetchJobCategoryEvents());
                            },
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    AppColors.primaryColor),
                                shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30))),
                                padding: MaterialStateProperty.all(
                                    EdgeInsets.symmetric(
                                        vertical: 15,
                                        horizontal:
                                            MediaQuery.of(context).size.width /
                                                3))),
                            child: const Text(
                              "Search",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            )),
                      ),
                    );
                  } else if (state is LoadingJobCategoryState) {
                    return const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: LoadingData(),
                    );
                  } else if (state is LoadedJobCategoryState) {
                    return Column(children: [
                      categoryList.isEmpty
                          ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: ElevatedButton(
                                    onPressed: () {
                                      BlocProvider.of<JobCategoryBloc>(context)
                                          .add(FetchJobCategoryEvents());
                                    },
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                AppColors.primaryColor),
                                        shape: MaterialStateProperty.all(
                                            RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(30))),
                                        padding: MaterialStateProperty.all(
                                            const EdgeInsets.symmetric(
                                                vertical: 15, horizontal: 10))),
                                    child: const Text(
                                      "Search",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                    )),
                              ),
                            )
                          : SizedBox(
                              height: MediaQuery.of(context).size.height * 0.3,
                              child: ListView(
                                children: [
                                  for (var result in categoryList)
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: TextButton(
                                        onPressed: () {
                                          setState(() {
                                            setState(() {
                                              chosenJobCategory =
                                                  JobCategoryModel(
                                                      id: result.id,
                                                      name: result.name);
                                            });
                                            result.isChosen = true;
                                          });
                                        },
                                        style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    Colors.transparent)),
                                        child: Container(
                                          padding: const EdgeInsets.all(15),
                                          decoration: BoxDecoration(
                                              border: result.isChosen
                                                  ? Border.all(
                                                      color: AppColors
                                                          .primaryColor)
                                                  : Border.all(
                                                      color: Colors.black26),
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                              color: result.isChosen
                                                  ? AppColors.primaryColor
                                                  : Colors.white),
                                          child: Row(children: [
                                            Expanded(
                                                child: Text(
                                              result.name,
                                              style: TextStyle(
                                                  color: result.isChosen
                                                      ? Colors.white
                                                      : Colors.black,
                                                  fontSize: 16),
                                            ))
                                          ]),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),

                      const SizedBox(height: 20),

                      categoryList.isNotEmpty

                          ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: ElevatedButton(
                                    onPressed: () {
                                      if (chosenJobCategory == null) {
                                        Fluttertoast.showToast(
                                            msg: 'Category is required');
                                      } else {
                                        stepsController.animateToPage(1,
                                            duration: const Duration(
                                                milliseconds: 800));
                                      }
                                    },
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                AppColors.primaryColor),
                                        shape: MaterialStateProperty.all(
                                            RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(30))),
                                        padding: MaterialStateProperty.all(
                                            const EdgeInsets.symmetric(
                                                vertical: 15, horizontal: 10))),
                                    child: const Text(
                                      "Continue",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                    )),
                              ),
                            )
                          : Container(
                              height: 0,
                            )
                    ]);
                  } else {
                    return const Text("WENT WRONG. CLOSE THE APP & TRY AGAIN");
                  }
                },
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.1,
                    child: Container(
                      color: AppColors.bgGreyColor,
                      height: 2,
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.05,
                    child: const Center(child: Text("or")),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.1,
                    child: Container(
                      color: AppColors.bgGreyColor,
                      height: 2,
                    ),
                  ),
                ],
              ),

              SizedBox(
                height: MediaQuery.of(context).size.height * 0.03,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Go to app to for best experience",
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2!
                        .copyWith(color: AppColors.primaryColor),
                  ),
                ],
              ),

            ]
            ),
        ),
      ),

      // service inside - like repair/new
      Card(
        elevation: 4.0,
        child: Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.1,
                right: 20,
                left: 20),
            color: Colors.white,
            child: Column(children: [

              SizedBox(height: MediaQuery.of(context).size.height * 0.05),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "WHAT WORK ARE YOU LOOKING TO UNDERTAKE?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 28,
                      color: Colors.black,
                      fontFamily: "Marcellus"),
                ),
              ),
              const SizedBox(height: 20),
              Column(children: [
                BlocConsumer<JobSubCategoryBloc, JobSubCategoryState>(
                  listener: (context, state) {
                    if (state is LoadedJobSubCategoryState) {
                      if (getSubCatOnce == true) {
                        for (int i = 0; i < state.allSubJobs.length; i++) {
                          subCategoryList.add(SearchResultWidget(
                              name: state.allSubJobs[i].name,
                              id: state.allSubJobs[i].id,
                              isChosen: false));
                        }
                        getSubCatOnce = false;
                      }
                    }
                  },
                  builder: (context, state) {
                    final jobSubCategoryBloc =
                        BlocProvider.of<JobSubCategoryBloc>(context);

                    jobSubCategoryBloc.add(FetchJobSubCategoryEvents(
                        id: chosenJobCategory!.id.toString()));

                    if (state is LoadingJobSubCategoryState) {
                      return const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: LoadingData(),
                      );
                    } else if (state is LoadedJobSubCategoryState) {
                      return Column(children: [
                        subCategoryList.isNotEmpty
                            ? SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.3,
                                child: ListView(
                                  children: [
                                    for (var result in subCategoryList)
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: TextButton(
                                          onPressed: () {
                                            setState(() {
                                              for (var element
                                                  in subCategoryList) {
                                                element.isChosen = false;
                                                chosenJobSubCategory =
                                                    JobSubCategoryModel(
                                                        id: element.id,
                                                        name: element.name);
                                              }
                                              result.isChosen = true;
                                            });
                                          },
                                          style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      Colors.transparent)),
                                          child: Container(
                                            padding: const EdgeInsets.all(15),
                                            decoration: BoxDecoration(
                                                border: result.isChosen
                                                    ? Border.all(
                                                        color: AppColors
                                                            .primaryColor)
                                                    : Border.all(
                                                        color: Colors.black26),
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                                color: result.isChosen
                                                    ? AppColors.primaryColor
                                                    : Colors.white),
                                            child: Row(children: [
                                              Expanded(
                                                child: Text(
                                                  result.name,
                                                  style: TextStyle(
                                                      color: result.isChosen
                                                          ? Colors.white
                                                          : Colors.black,
                                                      fontSize: 16),
                                                ),
                                              ),
                                            ]),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              )
                            : const LoadingData(),
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: ElevatedButton(
                                onPressed: () {
                                  stepsController.animateToPage(2,
                                      duration:
                                          const Duration(milliseconds: 800));
                                },
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        AppColors.primaryColor),
                                    shape: MaterialStateProperty.all(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30))),
                                    padding: MaterialStateProperty.all(
                                        const EdgeInsets.symmetric(
                                            vertical: 15, horizontal: 10))),
                                child: const Text(
                                  "Continue",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                )),
                          ),
                        )
                      ]);
                    } else {
                      return const Text(
                          "WENT WRONG. CLOSE THE APP & TRY AGAIN");
                    }
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.1,
                      child: Container(
                        color: AppColors.bgGreyColor,
                        height: 2,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.05,
                      child: const Center(child: Text("or")),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.1,
                      child: Container(
                        color: AppColors.bgGreyColor,
                        height: 2,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.03,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Go to app to for best experience",
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2!
                          .copyWith(color: AppColors.primaryColor),
                    ),
                  ],
                ),
              ]),
            ])),
      ),

      // video of service need
      Card(
        elevation: 4.0,
        child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.1,
                right: 20,
                left: 20),
            decoration: const BoxDecoration(color: Colors.white),
            child: Column(children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              const Text(
                "UPLOAD VIDEO",
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
                        child: videoFile != null
                            ? Container(
                          color: Colors.black,
                          height:
                          MediaQuery.of(context).size.height * 0.4,
                          width:
                          MediaQuery.of(context).size.width * 0.48,
                        )
                            : Container(
                                color: AppColors.primaryColorOff,
                                height:
                                    MediaQuery.of(context).size.height * 0.4,
                                width: MediaQuery.of(context).size.width * 0.48,
                                child: const Text(""),
                              ),
                      ),
                    ),

                    IconButton(
                      onPressed: () async {
                        if (videoFile != null) {
                          await showDialog(
                            context: context,
                            useSafeArea: true,
                            builder: (_) => LocalVideoPlayer(videoFile!),
                          );
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
                          onPressed: () async {},
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

                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.02,
                    ),

                    Expanded(
                      child: videoFile == null
                          ? ElevatedButton(
                              onPressed: () async {

                                Uint8List? video =
                                    await ImagePickerWeb.getVideoAsBytes();

                                setState(() {
                                  videoFile = video;
                                });
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
                              ),
                            ),
                    ),

                  ],
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.1,
                    child: Container(
                      color: AppColors.bgGreyColor,
                      height: 2,
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.05,
                    child: const Center(child: Text("or")),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.1,
                    child: Container(
                      color: AppColors.bgGreyColor,
                      height: 2,
                    ),
                  ),
                ],
              ),

              SizedBox(
                height: MediaQuery.of(context).size.height * 0.03,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Go to app to for best experience",
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2!
                        .copyWith(color: AppColors.primaryColor),
                  ),
                ],
              ),
            ])),
      ),

      // upload video self
      Card(
        elevation: 4.0,
        child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.1,
                right: 20,
                left: 20),
            decoration: const BoxDecoration(color: Colors.white),
            child: Column(children: [

              SizedBox(height: MediaQuery.of(context).size.height * 0.05),

              const Text(
                "UPLOAD VIDEO SELFIE",
                style: TextStyle(
                    fontSize: 32, color: Colors.black, fontFamily: "Marcellus"),
              ),

              const SizedBox(height: 20),

              Container(
                margin: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(30),
                ),
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
                          child: selfieVideoFile != null
                              ? Container(
                                  color: Colors.black,
                                  height: MediaQuery.of(context).size.height * 0.4,
                                  width: MediaQuery.of(context).size.width * 0.48,
                                )
                              : Container(
                                  color: AppColors.primaryColorOff,
                                  height: MediaQuery.of(context).size.height * 0.4,
                                  width: MediaQuery.of(context).size.width * 0.48,
                                  child: const Text(" "),
                                ),
                      ),
                    ),

                    IconButton(
                      onPressed: () async {
                        if (selfieVideoFile != null) {
                          await showDialog(
                            context: context,
                            useSafeArea: true,
                            builder: (_) => LocalVideoPlayer(selfieVideoFile!),
                          );
                        }
                      },
                      icon: const Icon(
                        Icons.play_circle,
                        color: Colors.white,
                        size: 48,
                      ),
                    ),

                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                          onPressed: () async {},
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
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.02,
                    ),
                    Expanded(
                      child: selfieVideoFile == null
                          ? ElevatedButton(
                              onPressed: () async {

                                Uint8List? video =
                                await ImagePickerWeb.getVideoAsBytes();

                                setState(() {
                                  selfieVideoFile = video;
                                });

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
                                stepsController.animateToPage(4,
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
                              ),
                      ),
                    )
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.1,
                    child: Container(
                      color: AppColors.bgGreyColor,
                      height: 2,
                    ),
                  ),

                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.05,
                    child: const Center(child: Text("or")),
                  ),

                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.1,
                    child: Container(
                      color: AppColors.bgGreyColor,
                      height: 2,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.03,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Go to app to for best experience",
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2!
                        .copyWith(color: AppColors.primaryColor),
                  ),
                ],
              ),
            ])),
      ),

      // upload photos
      Card(
        elevation: 4.0,
        child: Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.1,
                right: 20,
                left: 20),
            decoration: const BoxDecoration(color: Colors.white),
            child: Column(children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              const Text(
                "UPLOAD PHOTOS",
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
                  constraints: const BoxConstraints(minHeight: 200),
                  decoration: BoxDecoration(
                      color: AppColors.primaryColorOff,
                      borderRadius: BorderRadius.circular(20)),
                  child: images!.isEmpty
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () async {
                                List<Uint8List>? pickedImages =
                                    await ImagePickerWeb
                                        .getMultiImagesAsBytes();

                                setState(() {
                                  images = pickedImages;
                                });
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
                          height: 200,
                          child: GridView.count(
                              crossAxisCount: 4,
                              mainAxisSpacing: 8,
                              crossAxisSpacing: 8,
                              children: images!
                                  .map((image) => ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.memory(image,
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
                          onPressed: () async {},
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
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.02,
                    ),
                    Expanded(
                      child: images!.isEmpty
                          ? ElevatedButton(
                              onPressed: () async {
                                List<Uint8List>? pickedImages =
                                    await ImagePickerWeb
                                        .getMultiImagesAsBytes();
                                setState(() {
                                  images = pickedImages;
                                });
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
                              ))
                          : ElevatedButton(
                              onPressed: () async {
                                stepsController.animateToPage(5,
                                    curve: Curves.ease,
                                    duration:
                                        const Duration(milliseconds: 800));
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
                    width: MediaQuery.of(context).size.width * 0.1,
                    child: Container(
                      color: AppColors.bgGreyColor,
                      height: 2,
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.05,
                    child: const Center(child: Text("or")),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.1,
                    child: Container(
                      color: AppColors.bgGreyColor,
                      height: 2,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.03,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Go to app to for best experience",
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2!
                        .copyWith(color: AppColors.primaryColor),
                  ),
                ],
              ),
            ])),
      ),
      // overall review
      Card(
        elevation: 4.0,
        child: Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.1,
                right: 20,
                left: 20),
            decoration: const BoxDecoration(color: Colors.white),
            child: Column(children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
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
                    if (videoFile != null)
                      const Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Icon(Icons.check,
                            size: 48, color: Colors.green),
                      ),
                    if (videoFile == null)
                      const Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Icon(Icons.not_interested,
                            size: 48, color: Colors.red),
                      ),
                    Expanded(
                      child: Text(
                        videoFile != null
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
                    if (selfieVideoFile != null)
                      const Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Icon(Icons.check,
                            size: 48, color: Colors.green),
                      ),
                    if (selfieVideoFile == null)
                      const Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Icon(Icons.not_interested,
                            size: 48, color: Colors.red),
                      ),
                    Expanded(
                      child: Text(
                        selfieVideoFile != null
                            ? "SELFIE VIDEO UPLOADED"
                            : "SELFIE VIDEO NOT UPLOADED",
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
                child: Row(
                  children: [
                    if (images!.isNotEmpty)
                      const Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Icon(Icons.check,
                            size: 48, color: Colors.green),
                      ),
                    if (images!.isEmpty)
                      const Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Icon(Icons.not_interested,
                            size: 48, color: Colors.red),
                      ),
                    Expanded(
                        child: Text(
                      images!.isNotEmpty
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
                  children: [
                    if (chosenJobCategory != null && chosenJobSubCategory !=null)
                      const Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Icon(Icons.done, size: 48, color: Colors.green),
                      ),
                    if (chosenJobCategory == null || chosenJobSubCategory == null)
                      const Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Icon(Icons.not_interested,
                            size: 48, color: Colors.red),
                      ),
                    Expanded(
                        child: Text(
                          chosenJobCategory != null && chosenJobSubCategory !=null ? "SERVICE INFO" : "NO SERVICE INFO",
                      style: const TextStyle(fontSize: 16),
                    ))
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          if (images!.isEmpty ||
                              selfieVideoFile == null ||
                              videoFile == null ||
                              chosenJobSubCategory == null
                          ) {
                            Fluttertoast.showToast(
                                msg: "Add Missing Data to Continue");
                          } else {
                            stepsController.animateToPage(9,
                                duration: const Duration(milliseconds: 800));
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
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ])),
      ),

      // done
      Card(
        elevation: 4.0,
        child: BlocBuilder<AddAuctionBloc, AddAuctionsState>(
            builder: (context, state) {
              if(state is AddAuctionInitialState){
                return GestureDetector(
                    onTap: () async {
                      if (images!.isEmpty) {
                        Fluttertoast.showToast(
                            msg: "Some files are missing! Add them to continue");
                      } else if (selfieVideoFile == null) {
                        Fluttertoast.showToast(msg: "Selfie Video is missing");
                      } else if (videoFile == null) {
                        Fluttertoast.showToast(msg: "Service Video is missing");
                      } else {

                        // TODO: change userId, address

                        Map auctionData = {
                            'jobImages':images,
                            'video':videoFile,
                            "selfieVideo": selfieVideoFile,
                            "address": 'Maitidevi',
                            "winnerId": "",
                            "catId": chosenJobCategory!.id,
                            "subCatId": chosenJobSubCategory!.id,
                            "userId": Provider.of<LoginStateProvider>(context,listen: false).getUserId!,
                        };

                        BlocProvider.of<AddAuctionBloc>(context).add(PostAddAuctionEvent(auctionData: auctionData));


                      }
                    },

                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.1,
                          right: 20,
                          left: 20),
                      decoration: const BoxDecoration(color: Colors.white),
                      child: Column(children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.1,
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
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 10),
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
                  );
              }
              else if( state is AddAuctionLoadingState){
                return SizedBox(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        Padding(
                          padding: EdgeInsets.all(MediaQuery.of(context).size.width*0.03),
                          child: const SizedBox(
                            height: 60,
                            width: 60,
                            child: CircularProgressIndicator(
                              color: AppColors.primaryColor,
                            ),
                          ),
                        ),

                        Padding(
                          padding: EdgeInsets.all(MediaQuery.of(context).size.width*0.01),
                          child: Text("Adding Auction Data!", style: Theme.of(context).textTheme.bodyText1!.copyWith(fontWeight: FontWeight.w800, fontSize: 18.0),),
                        ),

                        Padding(
                          padding: EdgeInsets.symmetric(horizontal:MediaQuery.of(context).size.width*0.01),
                          child: const Text("Please donot close browser", style: TextStyle(color:Color(0xFFDADADA), fontSize: 16.0),),
                        ),

                      ],
                    ),
                  ),
                );
              }
              else if( state is AddAuctionLoadedState){
                return SizedBox(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        Padding(
                          padding: EdgeInsets.all(MediaQuery.of(context).size.width*0.03),
                          child: SizedBox(
                            child: Icon(Icons.done_outline, color: AppColors.primaryColor, size: MediaQuery.of(context).size.height*0.1,)
                          ),
                        ),

                        Padding(
                          padding: EdgeInsets.all(MediaQuery.of(context).size.width*0.01),
                          child: Text("Auction Created Successfully!", style: Theme.of(context).textTheme.bodyText1!.copyWith(fontWeight: FontWeight.w800, fontSize: 18.0),),
                        ),

                        Padding(
                          padding: EdgeInsets.symmetric(horizontal:MediaQuery.of(context).size.width*0.01),
                          child: const Text("Yahoo. Your auction is created & is under review!", style: TextStyle(color:Color(0xFFDADADA), fontSize: 16.0),),
                        ),

                        SizedBox(height: MediaQuery.of(context).size.width*0.03,),

                        TextButton(onPressed: (){
                          GoRouter.of(context).go("/client");
                        }, child: const Text('SEE AUCTION', style: TextStyle(color: Colors.white),)),

                      ],
                    ),
                  ),
                );
              }
              else{
                return SizedBox(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        Padding(
                          padding: EdgeInsets.all(MediaQuery.of(context).size.width*0.03),
                          child: const Icon(
                            Icons.not_interested,
                            color: Colors.red,
                            size: 60.0,
                          ),
                        ),

                        Padding(
                          padding: EdgeInsets.all(MediaQuery.of(context).size.width*0.01),
                          child: Text("SOMETHING WENT WRONG", style: Theme.of(context).textTheme.bodyText1!.copyWith(fontWeight: FontWeight.w800, fontSize: 18.0),),
                        ),

                        TextButton(
                            onPressed: (){
                              Map auctionData = {
                                'jobImages':images,
                                'video':videoFile,
                                "selfieVideo": selfieVideoFile,
                                "address": 'Maitidevi',
                                "winnerId": "",
                                "catId": chosenJobCategory!.id,
                                "subCatId": chosenJobSubCategory!.id,
                                "userId": Provider.of<LoginStateProvider>(context,listen: false).getUserId!,
                              };

                              BlocProvider.of<AddAuctionBloc>(context).add(PostAddAuctionEvent(auctionData: auctionData));

                              },
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('RE-TRY WITH SAME DATA', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),),
                          ),
                        )

                      ],
                    ),
                  ),
                );
              }
            },
        ),
      ),

    ];
  }
}

class SearchResultWidget {
  String name;
  String id;
  bool isChosen;

  SearchResultWidget(
      {required this.name, required this.id, required this.isChosen});
}

class ServiceWidget {
  String name;
  String id;
  int isChosen;

  ServiceWidget({required this.name, required this.id, required this.isChosen});
}
