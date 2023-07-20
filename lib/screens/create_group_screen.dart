
import 'dart:io';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:group_chat/models/user_profile_model.dart';
import 'package:group_chat/repos/profile_repository.dart';
import 'package:group_chat/screens/add_users_to_group_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:provider/provider.dart';

import '../repos/group_repository.dart';
import 'package:flutter_svg/flutter_svg.dart';
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

        return SizedBox(
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

          width: 120,
          height: 120,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  const Color(0xFFfa709a),
                  Theme.of(context).primaryColor
                  // Color(0XFFfee140)

                ],
              ),


              shape: BoxShape.circle

          ),

            child:  SvgPicture.asset('assets/images/group_chat_profile.svg',height: 90,width: 90,color: Colors.white,),),
      );

    } else {


      return InkWell(
        onTap: () {
          _onImageButtonPressed(ImageSource.gallery, context, groupRepo);
        },
        child: Stack(
          alignment: Alignment.bottomRight,

          children: [
            Container(
                alignment: Alignment.center,
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [
                        Color(0xFFfa709a),
                       Theme.of(context).primaryColor
                       // Color(0XFFfee140)

                      ],
                    ),


                  shape: BoxShape.circle

                ),
                padding: const EdgeInsets.all(10.0),
                child:
                    SvgPicture.asset('assets/images/group_chat_profile.svg',height: 90,width: 90,color: Colors.white,),



                ),
            Container(
                margin: const EdgeInsets.only(bottom: 10),
                width: 40,
                height: 40,

                decoration: const BoxDecoration(
                   color: Colors.white,


                    shape: BoxShape.circle

                ),
                child: const Icon(Icons.camera_alt,color: Colors.black,)),
          ],
        ),

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


        body: SingleChildScrollView(
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(

                height: size.height,
                width: size.width,
                child: Image.asset('assets/images/bg.jpeg',fit: BoxFit.cover,),


              ),
             Container(
               height:  size.height,

               width: size.width,
               decoration: BoxDecoration(

                 color: Colors.black.withOpacity(0.1),

               ),
               child: ClipRect(
                 child: BackdropFilter(
                   filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
                   child: Column(
                     mainAxisAlignment: MainAxisAlignment.start,
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       Align(
                         alignment: Alignment.topCenter,
                         child: SafeArea(
                           child: Row(
                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                             children: [
                               Container(
                                 height:50,
                                 width: 50,
                                 margin: const EdgeInsets.only(left: 10,top: 10),
                                 decoration: BoxDecoration(
                                     gradient: LinearGradient(
                                       begin: Alignment.topRight,
                                       end: Alignment.bottomLeft,
                                       colors: [
                                         const Color(0xFFfa709a),
                                         Theme.of(context).primaryColor
                                         // Color(0XFFfee140)

                                       ],
                                     ),


                                     shape: BoxShape.circle

                                 ),
                                 child: IconButton(onPressed: (){
                                   Navigator.of(context).pop();
                                 }, icon: const Icon(Icons.arrow_back)),
                               ),
                               Container(


                                 padding: const EdgeInsets.symmetric(horizontal: 20,vertical:10 ),
                                 decoration: BoxDecoration(
                                     gradient: LinearGradient(
                                       begin: Alignment.topRight,
                                       end: Alignment.bottomLeft,
                                       colors: [
                                         const Color(0xFFfa709a),
                                         Theme.of(context).primaryColor
                                         // Color(0XFFfee140)

                                       ],
                                     ),


                                     shape: BoxShape.rectangle

                                 ),
                                 child:Text("Create Group"),
                               ),


                             ],
                           ),
                         ),
                       ),
                       Container(
                         padding: const EdgeInsets.symmetric(horizontal: 20),
                         child: Column(
                           mainAxisAlignment: MainAxisAlignment.start,
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: <Widget>[
                           Container(
                             padding: EdgeInsets.only(top: 40),
                             child:

                                Container(
                                     padding: EdgeInsets.only(left: 20),
                                     child: Form(
                                       key: formKey,
                                       autovalidateMode: AutovalidateMode.always,
                                       child:Column(
                                         children: [
                                           Row(
                                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                             children: [
                                               groupRepo.loading
                                                   ? Container(
                                                   margin: const EdgeInsets.only(top: 20),
                                                   alignment: Alignment.center,
                                                   child: const CircularProgressIndicator())
                                                   : InkWell(
                                                   onTap: () {
                                                     _onImageButtonPressed(ImageSource.gallery, context, groupRepo);
                                                   },
                                                   child: groupRepo.groupProfilePic.isEmpty
                                                       ?
                                                   _previewImage(groupRepo, context)

                                                       : Padding(
                                                       padding: const EdgeInsets.all(10.0),
                                                       child: Container(
                                                         alignment: Alignment.center,
                                                         child: ClipOval(
                                                             child: ClipRRect(
                                                                 borderRadius:
                                                                 BorderRadius.circular(
                                                                     30),
                                                                 child: CachedNetworkImage(
                                                                     width: 100.0,
                                                                     height: 100.0,
                                                                     fit: BoxFit.cover,
                                                                     imageUrl: groupRepo
                                                                         .groupProfilePic,
                                                                     placeholder: (context,
                                                                         url) =>
                                                                     const CircularProgressIndicator(),
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
                                               Flexible(
                                                 flex: 3,
                                                 child: Container(
                                                   padding: EdgeInsets.only(left: 10),
                                                   child: TextFormField(

                                                     controller: groupRepo.nameController,
                                                     style: const TextStyle(color: Colors.black),

                                                     decoration: InputDecoration(


                                                       border: OutlineInputBorder(

                                                         borderSide: BorderSide(color: Theme.of(context).primaryColor,),
                                                         borderRadius: const BorderRadius.all(
                                                           Radius.circular(10),
                                                         ),
                                                       ),
                                                       enabledBorder: OutlineInputBorder(

                                                         borderSide: BorderSide(color: Theme.of(context).primaryColor, ),
                                                         borderRadius: BorderRadius.all(
                                                           Radius.circular(10),
                                                         ),

                                                       ),
                                                       focusedErrorBorder: OutlineInputBorder(

                                                         borderSide: BorderSide(color: Theme.of(context).primaryColor, ),
                                                         borderRadius: const BorderRadius.all(
                                                           Radius.circular(10),
                                                         ),

                                                       ),
                                                       focusedBorder: OutlineInputBorder(
                                                         borderSide: BorderSide(color: Theme.of(context).primaryColor,),
                                                         borderRadius: const BorderRadius.all(
                                                           Radius.circular(10),
                                                         ),
                                                       ),
                                                       disabledBorder: OutlineInputBorder(
                                                         borderSide: BorderSide(color: Theme.of(context).primaryColor),
                                                         borderRadius: const BorderRadius.all(
                                                           Radius.circular(10),
                                                         ),
                                                       ),
                                                       labelText: 'Group Name',
                                                       errorStyle: TextStyle(color: Theme.of(context).primaryColor),

                                                       labelStyle: TextStyle(color: Colors.black),
                                                       hintText: "Group Name",
                                                       hintStyle: const TextStyle(
                                                         color: Colors.white,


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
                                               ),
                                             ],
                                           ),
                                           Container(
                                             padding: EdgeInsets.only(top: 20),


                                             child: TextFormField(

                                               controller: groupRepo.descriptionController,
                                               style: const TextStyle(color: Colors.black),
                                               maxLines: 5,

                                               decoration: InputDecoration(


                                                 border: OutlineInputBorder(

                                                   borderSide: BorderSide(color: Theme.of(context).primaryColor,),
                                                   borderRadius: const BorderRadius.all(
                                                     Radius.circular(10),
                                                   ),
                                                 ),
                                                 enabledBorder: OutlineInputBorder(

                                                   borderSide: BorderSide(color: Theme.of(context).primaryColor, ),
                                                   borderRadius: const BorderRadius.all(
                                                     Radius.circular(10),
                                                   ),

                                                 ),
                                                 focusedErrorBorder: OutlineInputBorder(

                                                   borderSide: BorderSide(color: Theme.of(context).primaryColor, ),
                                                   borderRadius: BorderRadius.all(
                                                     Radius.circular(10),
                                                   ),

                                                 ),
                                                 focusedBorder: OutlineInputBorder(
                                                   borderSide: BorderSide(color: Theme.of(context).primaryColor,),
                                                   borderRadius: const BorderRadius.all(
                                                     Radius.circular(10),
                                                   ),
                                                 ),
                                                 disabledBorder: OutlineInputBorder(
                                                   borderSide: BorderSide(color: Theme.of(context).primaryColor),
                                                   borderRadius: const BorderRadius.all(
                                                     Radius.circular(10),
                                                   ),
                                                 ),
                                                 labelText: 'Description',
                                                 errorStyle: TextStyle(color: Theme.of(context).primaryColor),

                                                 labelStyle: TextStyle(color: Colors.black),
                                                 hintText: "Description",
                                                 hintStyle: const TextStyle(
                                                   color: Colors.white,


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
                                       )









                                     ),
                                   ),


                           ),


                  groupRepo.groupId == null ? const SizedBox() :
                     InkWell(
                       onTap: () {
                         Navigator.push(context,
                             MaterialPageRoute(builder: (context) => ChangeNotifierProvider(create: (_)=>GroupRepository.instance(),
                             child: AddUsersToGroupScreen(groupRepo.groupId!),)));
                       },
                       child: Container(
                         padding: const EdgeInsets.only(top: 10),
                         child: Row(
                           children: [
                             Stack(
                               alignment: Alignment.center,

                               children: [
                                 Container(
                                   alignment: Alignment.center,
                                   width: 40,
                                   height: 40,
                                   decoration: BoxDecoration(
                                       gradient: LinearGradient(
                                         begin: Alignment.topRight,
                                         end: Alignment.bottomLeft,
                                         colors: [
                                           const Color(0xFFfa709a),
                                           Theme.of(context).primaryColor
                                           // Color(0XFFfee140)

                                         ],
                                       ),


                                       shape: BoxShape.circle

                                   ),

                                   child:const Icon(Icons.account_circle,size: 30,color: Colors.white,),



                                 ),
                                 const Icon(Icons.add_circle_outline_outlined,color: Colors.red,size: 20,),
                               ],
                             ),
                             Container(
                               padding:const EdgeInsets.only(left: 10),

                               child: const Text("Add Group Members",style: TextStyle(fontSize: 15,color: Colors.white),),
                             )
                           ],
                         ),
                       ),

                     ),

                             FutureProvider<UserProfileModel?>.value(value: ProfileRepository.instance().getUserProfiles(),
                               initialData:null,
                             catchError: (context,error){

                               throw error!;
                             },
                             child: Consumer(builder: (BuildContext context, UserProfileModel? value, Widget? child) {
                              return value == null ? const Center(child: CircularProgressIndicator(),) :
                              GridView.builder(
                                 shrinkWrap: true,
                                 gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 5,


                               ), itemBuilder: (BuildContext context,int index){
                                 return Stack(
                                   alignment: Alignment.topRight,
                                   children: [
                                     Container(
                                       padding: const EdgeInsets.all(10.0),
                                       child: ClipOval(
                                           child: ClipRRect(
                                               borderRadius:
                                               BorderRadius.circular(
                                                   100),
                                               child: CachedNetworkImage(
                                                   width: 50.0,
                                                   height: 50.0,
                                                   fit: BoxFit.cover,
                                                   imageUrl: value.getAllUserAccounts!.items![index].profilePicKey!,
                                                   placeholder: (context,
                                                       url) =>
                                                   const CircularProgressIndicator(),
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
                                     ),
                                     Container(
                                       padding:const EdgeInsets.only(right: 10,top: 5),
                                         child: Icon(Icons.cancel_outlined,color:Theme.of(context).primaryColor,size: 20,)),

                                   ],
                                 );

                               },itemCount: value.getAllUserAccounts!.items!.length,);


                             },),),


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



                                               groupRepo.createGroup(widget.username);




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
                   ),
                 ),
               ),
             )
            ],
          ),
        )

    );
  }
}