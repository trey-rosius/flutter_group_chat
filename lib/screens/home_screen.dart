import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:group_chat/repos/chat_repository.dart';
import 'package:group_chat/screens/chat_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../models/groups_created_by_user_model.dart';
import '../models/user_item.dart';
import '../models/get_all_users_per_group_model.dart';
import '../repos/group_repository.dart';
import '../repos/profile_repository.dart';
import '../utils/shared_preferences.dart';
import '../utils/utils.dart';
import 'create_group_screen.dart';
import 'login_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  String? nextToken;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
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
          return username == null
              ? LoginScreen()
              : Scaffold(
                  body: Stack(
                    children: [
                      SizedBox(
                          height: size.height,
                          width: size.width,
                          child: Image.asset(
                            'assets/images/bg.jpeg',
                            fit: BoxFit.cover,
                          )),
                      SingleChildScrollView(
                        child: Container(
                          height: size.height,
                          width: size.width,
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.1),
                          ),
                          child: ClipRect(
                              child: BackdropFilter(
                            filter:
                                ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
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
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 10),
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
                                              shape: BoxShape.rectangle),
                                          child: const Text("Groups"),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                FutureProvider<GroupCreatedByUserModel?>.value(
                                    value: GroupRepository.instance()
                                        .getUserGroups(username),
                                    initialData: null,
                                    catchError: (context, error) {
                                      throw error!;
                                    },
                                    child: Consumer(builder:
                                        (BuildContext context,
                                            GroupCreatedByUserModel? value,
                                            Widget? child) {
                                      return value == null
                                          ? const Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            )
                                          : Container(
                                              height: 320,
                                              child: ListView.builder(
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  shrinkWrap: true,
                                                  itemCount: value.groupItems!
                                                      .groupItemList!.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return Container(
                                                      width: 200,
                                                      margin:
                                                      EdgeInsets.all(10),
                                                      decoration: BoxDecoration(
                                                          gradient:
                                                              LinearGradient(
                                                            begin: Alignment
                                                                .topRight,
                                                            end: Alignment
                                                                .bottomLeft,
                                                            colors: [
                                                              const Color(
                                                                  0xFFfa709a),
                                                              Theme.of(context)
                                                                  .primaryColor
                                                            ],
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10)),

                                                      child: Column(
                                                        children: [
                                                          FutureProvider<
                                                                  String?>.value(
                                                              value: Utils.getDownloadUrl(
                                                                  key: value
                                                                      .groupItems!
                                                                      .groupItemList![
                                                                          index]
                                                                      .groupProfilePicKey!),
                                                              catchError:
                                                                  (context,
                                                                      error) {
                                                                throw error!;
                                                              },
                                                              initialData: null,
                                                              child: Consumer(
                                                                  builder: (_,
                                                                      String?
                                                                          groupProfilePicUrl,
                                                                      child) {
                                                                return ClipRRect(
                                                                  borderRadius: const BorderRadius
                                                                          .only(
                                                                      topLeft: Radius
                                                                          .circular(
                                                                              10),
                                                                      topRight:
                                                                          Radius.circular(
                                                                              10)),
                                                                  child: CachedNetworkImage(
                                                                      width: 200,
                                                                      height: 180,

                                                                      fit: BoxFit.cover,
                                                                      imageUrl: groupProfilePicUrl ?? "",
                                                                      placeholder: (context, url) => CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)),
                                                                      errorWidget: (context, url, ex) => CircleAvatar(
                                                                            backgroundColor:
                                                                                Theme.of(context).colorScheme.secondary,
                                                                            radius:
                                                                                40.0,
                                                                            child:
                                                                                const Icon(
                                                                              Icons.account_circle,
                                                                              color: Colors.white,
                                                                              size: 40.0,
                                                                            ),
                                                                          )),
                                                                );
                                                              })),


                                                          Container(

padding:EdgeInsets.only(top: 10,left: 10,right: 10),
                                                            child: Text(
                                                              value
                                                                  .groupItems!
                                                                  .groupItemList![
                                                                      index]
                                                                  .name!,
                                                              style: const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 20),
                                                            ),
                                                          ),
                                                          FutureProvider<
                                                                  GetAllUsersPerGroupModel?>.value(
                                                              value: GroupRepository
                                                                      .instance()
                                                                  .getAllUsersPerGroup(
                                                                      value
                                                                          .groupItems!
                                                                          .groupItemList![
                                                                              index]
                                                                          .id!,
                                                                      nextToken,
                                                                      10),
                                                              initialData: null,
                                                              catchError:
                                                                  (context,
                                                                      error) {
                                                                throw error!;
                                                              },
                                                              child: Consumer(builder:
                                                                  (BuildContext
                                                                          context,
                                                                      GetAllUsersPerGroupModel?
                                                                          value,
                                                                      Widget?
                                                                          child) {
                                                                return value !=
                                                                        null
                                                                    ? Container(
                                                                        height:
                                                                            50,
                                                                        width:
                                                                            200,
                                                                        child:
                                                                            Wrap(
                                                                          spacing:
                                                                              -20,
                                                                          children: [
                                                                            for (int i = 0;
                                                                                i < value.getAllUsersPerGroup!.items!.length;
                                                                                i++) ...[
                                                                              Container(
                                                                                padding: EdgeInsets.only(left: 10.0 + i),
                                                                                child: ClipOval(
                                                                                    child: ClipRRect(
                                                                                        borderRadius: BorderRadius.circular(100),
                                                                                        child: CachedNetworkImage(
                                                                                            width: 30.0,
                                                                                            height: 30.0,
                                                                                            fit: BoxFit.cover,
                                                                                            imageUrl: value.getAllUsersPerGroup!.items![i].userItem!.profilePicKey!,
                                                                                            placeholder: (context, url) => const CircularProgressIndicator(),
                                                                                            errorWidget: (context, url, ex) => CircleAvatar(
                                                                                                  backgroundColor: Theme.of(context).colorScheme.secondary,
                                                                                                  radius: 30.0,
                                                                                                  child: const Icon(
                                                                                                    Icons.account_circle,
                                                                                                    color: Colors.white,
                                                                                                    size: 30.0,
                                                                                                  ),
                                                                                                )))),
                                                                              )
                                                                            ]
                                                                          ],
                                                                        ),
                                                                      )
                                                                    : Container();
                                                              }))
                                                        ],
                                                      ),
                                                    );
                                                  }),
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
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return MultiProvider(
                            providers: [
                              ChangeNotifierProvider(
                                  create: (_) => GroupRepository.instance()),
                            ],
                            child: CreateGroupScreen(
                              username: username,
                            ));
                      }));

/*
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return MultiProvider(
                            providers: [
                              ChangeNotifierProvider(create: (_) => ChatRepository.instance()),
                              FutureProvider<UserItem?>.value(
                                  value: ProfileRepository.instance().getAUserProfile(
                            username), initialData: null,
                              catchError: (context,error) => throw error!,),

                            ],

                            child: GroupChatScreen(username));


                      }));
*/
                    },
                    child: const Icon(Icons.group_add),
                  ),
                );
        }));
  }
}
