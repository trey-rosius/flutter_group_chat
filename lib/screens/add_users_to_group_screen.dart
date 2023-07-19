import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:group_chat/repos/group_repository.dart';
import 'package:provider/provider.dart';
import '../models/user_profile_model.dart';
import '../repos/profile_repository.dart';
import '../utils/custom_checkbox.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
class AddUsersToGroupScreen extends StatefulWidget {
  const AddUsersToGroupScreen(this.groupId, {super.key});
  final String groupId;


  @override
  State<AddUsersToGroupScreen> createState() => _AddUsersToGroupScreenState();
}

class _AddUsersToGroupScreenState extends State<AddUsersToGroupScreen> {

  late final Stream<GraphQLResponse<String>> operation;
  late final Stream<GraphQLResponse<String>> sendMessageStream;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var groupRepository = context.watch<GroupRepository>();


    return Scaffold(
      body: Stack(
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

                              margin: const EdgeInsets.only(top: 5),
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
                              child:const Text("Add users to group"),
                            ),


                          ],
                        ),
                      ),
                    ),

                 groupRepository.userProfile.isEmpty ? const SizedBox():
                 SizedBox(
                      height: 80,
                      child:  ListView.builder(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context,int index){
                          return Container(

                                    padding: const EdgeInsets.all(10.0),
                                    child:  CircleAvatar(
                                      radius: 30,
                                      child: ClipRRect(
                                                  borderRadius: BorderRadius.circular(100),

                                                  child: CachedNetworkImage(
                                                      height: 60,
                                                      width: 60,

                                                      fit: BoxFit.cover,
                                                      imageUrl: groupRepository.userProfile[index].profilePicKey!,
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
                                                ),
                                    ));









                        },
                        itemCount: groupRepository.userProfile.length,
                       ),
                    ),
                    FutureProvider<UserProfileModel?>.value(value: ProfileRepository.instance().getUserProfiles(),
                      initialData:null,
                      catchError: (context,error){

                        throw error!;
                      },
                      child: Consumer(builder: (BuildContext context, UserProfileModel? value, Widget? child) {
                        return value == null ? const Center(child: CircularProgressIndicator(),) :
                        Expanded(
                          child: ListView.separated(
                            shrinkWrap: true,

                             itemBuilder: (BuildContext context,int index){
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                               Row(

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
                                   Text(value.getAllUserAccounts!.items![index].username!,
                                   style: const TextStyle(fontSize: 20,color: Colors.black),),
                                 ],
                               ),
                                Container(
                                  padding:EdgeInsets.only(right: 10),
                                  child: CustomCheckbox(
                                       groupId: widget.groupId,
                                       userItem: value.getAllUserAccounts!.items![index],
                                       groupRepository: groupRepository,

                                      iconSize: 20,
                                     size: 40, selectedColor: Theme.of(context).primaryColor,
                                    selectedIconColor: Colors.white,
                                    borderColor: Theme.of(context).primaryColor),
                                )





                              ],
                            );

                          },
                            itemCount: value.getAllUserAccounts!.items!.length,
                            separatorBuilder: (BuildContext context, int index) {
                               return const Divider();
                            },),
                        );


                      },),),


                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
