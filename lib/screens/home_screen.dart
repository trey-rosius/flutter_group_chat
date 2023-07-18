
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../models/group_model.dart';
import '../repos/group_repository.dart';
import '../utils/shared_preferences.dart';
import 'create_group_screen.dart';
import 'login_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});






  @override
  State createState() =>
      HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {





  @override
  void initState() {
    super.initState();





  }

  @override
  void dispose(){

    super.dispose();


  }












  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;



    return FutureProvider<String?>(
        create: (BuildContext context) {
          return SharedPrefsUtils.instance().getUserName();
        },
        initialData: null,
        child: Consumer<String?>(builder: (_, String? username, child) {
           return username == null ? LoginScreen() : Scaffold(




             body:  Stack(
               children: [
                 SizedBox(

                     height: size.height,
                     width: size.width,
                     child: Image.asset('assets/images/bg.jpeg',fit: BoxFit.cover,)),

                 SingleChildScrollView(
                   child: Container(


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
                                     mainAxisAlignment: MainAxisAlignment.end,
                                     children: [

                                       Container(

                                         margin: EdgeInsets.only(top: 20),
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
                                         child:const Text("Group Home"),
                                       ),


                                     ],
                                   ),
                                 ),
                               ),

        FutureProvider<GroupModel?>.value(value: GroupRepository.instance().getUserGroups(username),
    initialData:null,
    catchError: (context,error){

    throw error!;
    },
    child: Consumer(builder: (BuildContext context, GroupModel? value, Widget? child) {
       return value == null ? const Center(child: CircularProgressIndicator(),) : Container(
         child:Expanded(
           child: GridView.builder(
             shrinkWrap: true,

             gridDelegate: SliverWovenGridDelegate.count(
               crossAxisCount: 2,
               mainAxisSpacing: 8,
               crossAxisSpacing: 8,
               pattern: [
                 const WovenGridTile(1),
                 const WovenGridTile(
                   5 / 7,
                   crossAxisRatio: 0.9,
                   alignment: AlignmentDirectional.centerEnd,
                 ),
               ],
             ),
             itemCount: value.getAllGroupsCreatedByUser!.items!.length,
/*
             childrenDelegate: SliverChildBuilderDelegate(

                   (context, index) => Text(value.getAllGroupsCreatedByUser!.items![index].name!),
             ),
             */

             itemBuilder: (BuildContext context, int index) {
               return Container(
                 padding: const EdgeInsets.all(10),
                 color: Colors.white,
                 child: Column(
                   children: [
                     CachedNetworkImage(
                         width: 50.0,
                         height: 50.0,
                         fit: BoxFit.cover,
                         imageUrl: value.getAllGroupsCreatedByUser!.items![index].groupProfilePicKey!,
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
                             )),
                     Text(value.getAllGroupsCreatedByUser!.items![index].name!),
                     Text(value.getAllGroupsCreatedByUser!.items![index].description!)
                   ],
                 ),
               );
           },
           )
           /*
           GridView.builder(
             shrinkWrap: true,
             itemCount: value.getAllGroupsCreatedByUser!.items!.length,
               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                     crossAxisCount: 2,),
               itemBuilder: (BuildContext context, int index ){
               return Text(value.getAllGroupsCreatedByUser!.items![index].name!);
               }),
           */
         )
       );
    }))


    ],
                           ),




                         )),
                   ),
                 ),

               ],
             ),

             floatingActionButton: FloatingActionButton(

               onPressed: () {
                 Navigator.push(context, MaterialPageRoute(builder: (context){
                   return MultiProvider(providers: [
                     ChangeNotifierProvider(create: (_) => GroupRepository.instance()),

                   ], child:CreateGroupScreen( username: username,));

                 }));

               },
               child: const Icon(Icons.group_add),

             ),
           );

        }));





  }

}
