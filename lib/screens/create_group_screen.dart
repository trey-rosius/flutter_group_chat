
import 'dart:io';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:provider/provider.dart';

import '../repos/group_repository.dart';
import '../utils/shared_preferences.dart';
import 'home_screen.dart';


class CreateGroupScreen extends StatefulWidget {
  CreateGroupScreen({required this.username});
  final String username;



  @override
  _CreateGroupScreenState createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {

  XFile? _imageFile;
  dynamic _pickImageError;

  final ImagePicker _picker = ImagePicker();
  File? file;
  bool denySpaces = true;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey =  GlobalKey<ScaffoldState>();








  String? _retrieveDataError;






  Text? _getRetrieveErrorWidget() {
    if (_retrieveDataError != null) {
      final Text result = Text(_retrieveDataError!);
      _retrieveDataError = null;
      return result;
    }
    return null;
  }

  Widget _previewImage(GroupRepository groupRepo, BuildContext context) {

    final Text? retrieveError = _getRetrieveErrorWidget();
    if (retrieveError != null) {
      return retrieveError;
    }
    if (_imageFile != null) {
      if (kIsWeb) {
        // Why network?
        // See https://pub.dev/packages/image_picker#getting-ready-for-the-web-platform

        return Container(
          height: 60,
          width: 60,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: Image.network(
              _imageFile!.path,
              height: 150,
              width: 150,
            ),
          ),
        );

      } else {

        return Semantics(
            label: 'pick image',
            child: Image.file(
              File(_imageFile!.path),
              width: 150,
            ));

      }
    } else if (_pickImageError != null) {

      if (kDebugMode) {
        print("error occured during image pick");
      }

      return InkWell(
        onTap: () {
          _onImageButtonPressed(ImageSource.gallery, context, groupRepo);
        },
        child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(10.0),
            child: Icon(
              Icons.group,
              size: 100,
              color: Theme.of(context).primaryColor,
            )),
      );

    } else {


      return InkWell(
        onTap: () {
          _onImageButtonPressed(ImageSource.gallery, context, groupRepo);
        },
        child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(10.0),
            child: Icon(
              Icons.group,
              size: 150,
              color: Theme.of(context).primaryColor,
            )),
      );
    }
  }

  Future<void> retrieveLostData() async {
    final response = await _picker.retrieveLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      setState(() {
        _imageFile = response.file;
      });
    } else {
      _retrieveDataError = response.exception!.code;
    }
  }

  void _onImageButtonPressed(ImageSource source, BuildContext context,
      GroupRepository groupRepo) async {
    groupRepo.loading = true;

    try {
      final pickedFile = await _picker.pickImage(
        source: source,
      );

      var dir = await path_provider.getTemporaryDirectory();
      var targetPath = "${dir.absolute.path}/temp.jpg";
      setState(() {
        _imageFile = pickedFile;
      });

      await groupRepo.uploadGroupProfilePic(
          _imageFile!.path, targetPath);

    } catch (e) {
      // groupRepo.loading = false;

      setState(() {
        _pickImageError = e;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();



  }



  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();


  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var groupRepo = context.watch<GroupRepository>();


    return Scaffold(
        key: _scaffoldKey,


        body: Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(

              height: size.height,
              width: size.width,
              child: Image.asset('assets/images/bg.jpeg',fit: BoxFit.cover,),


            ),
            Align(
              alignment: Alignment.topCenter,
              child: SafeArea(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(onPressed: (){
                      Navigator.of(context).pop();
                    }, icon: Icon(Icons.arrow_back)),

                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  groupRepo.loading
                      ? Container(
                      margin: const EdgeInsets.only(top: 20),
                      alignment: Alignment.center,
                      child: CircularProgressIndicator())
                      : InkWell(
                      onTap: () {
                        _onImageButtonPressed(ImageSource.gallery, context, groupRepo);
                      },
                      child: groupRepo.groupProfilePic.isEmpty
                          ?
                      _previewImage(groupRepo, context)

                          : Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Container(
                            alignment: Alignment.center,
                            child: ClipOval(
                                child: ClipRRect(
                                    borderRadius:
                                    new BorderRadius.circular(
                                        30),
                                    child: CachedNetworkImage(
                                        width: 100.0,
                                        height: 100.0,
                                        fit: BoxFit.cover,
                                        imageUrl: groupRepo
                                            .groupProfilePic,
                                        placeholder: (context,
                                            url) =>
                                            CircularProgressIndicator(),
                                        errorWidget: (context,
                                            url, ex) =>
                                            CircleAvatar(
                                              backgroundColor:
                                              Theme.of(
                                                  context)
                                                  .colorScheme.secondary,
                                              radius: 40.0,
                                              child: const Icon(
                                                Icons
                                                    .account_circle,
                                                color:
                                                Colors.white,
                                                size: 40.0,
                                              ),
                                            )))),
                          ))

                    // child: _prev,

                  ),
                  Form(
                    key: formKey,
                    autovalidateMode: AutovalidateMode.always,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [



                        Container(

                          margin: const EdgeInsets.only(top: 20),
                          child: TextFormField(

                            controller: groupRepo.nameController,
                            style: const TextStyle(color: Colors.black),

                            decoration: InputDecoration(
                              fillColor: Colors.white,
                              filled: true,

                              border: OutlineInputBorder(

                                borderSide: BorderSide(color: (Colors.grey[700])!, width: 2),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(

                                borderSide: BorderSide(color: (Colors.grey[700])!, width: 2),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: (Colors.grey[700])!, width: 2),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                              labelText: 'Group Name',

                              labelStyle: TextStyle(color: Colors.black),
                              hintText: "Group Name",
                              hintStyle: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Group Name';
                              }
                              return null;
                            },
                          ),

                        ),





                      ],
                    ),
                  ),




                  Container(
                    margin:const EdgeInsets.only(bottom: 20),
                    child: Column(
                      children: <Widget>[
                        groupRepo.loading? Container(
                          padding: const EdgeInsets.only(top: 30.0),

                          child: const CircularProgressIndicator(),
                        ) :
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: SizedBox(
                            width: size.width/1.1,
                            height:50,

                            child: ElevatedButton(

                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(Theme.of(context).primaryColor),
                                    shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)))

                                ),
                                onPressed: (){


                                  final FormState form = formKey.currentState!;
                                  if (!form.validate()) {

                                  } else {
                                    form.save();




                                    if (kDebugMode) {
                                      print(groupRepo.groupProfilePic);

                                    }



                                    groupRepo.createGroup(widget.username).then((bool value){

                                      if(value){

                                        Navigator.push(context, MaterialPageRoute(builder: (context){
                                          return MultiProvider(
                                            providers: [
                                              ChangeNotifierProvider(create: (_) => GroupRepository.instance(),),
                                              //   ChangeNotifierProvider(create: (_) => PostRepository.instance(),),
                                              //   ChangeNotifierProvider(create: (_) => SharedPrefsUtils.instance(),),

                                            ],
                                            child: HomeScreen(),

                                          );


                                        }));


                                      }else{
                                        print('an error occured');
                                      }



                                    });




                                  }

                                }, child: const Text('Continue',style: TextStyle(fontWeight:FontWeight.bold, color: Colors.black),)),
                          ),
                        )

                      ],
                    ),
                  )

                ],
              ),
            ),
          ],
        )

    );
  }
}