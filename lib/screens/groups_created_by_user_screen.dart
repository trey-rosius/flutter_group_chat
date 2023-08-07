import 'package:flutter/material.dart';
import '../models/groups_created_by_user_model.dart';
import '../models/get_all_users_per_group_model.dart';
import '../repos/group_repository.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../utils/utils.dart';

class GroupsCreatedByUserScreen extends StatelessWidget {
  const GroupsCreatedByUserScreen(this.username, this.nextToken);
  final String username;
  final String? nextToken;

  @override
  Widget build(BuildContext context) {
    return FutureProvider<GroupCreatedByUserModel?>.value(
        value: GroupRepository.instance().getGroupsCreatedByUser(username),
        initialData: null,
        catchError: (context, error) {
          throw error!;
        },
        child: Consumer(builder: (BuildContext context,
            GroupCreatedByUserModel? value, Widget? child) {
          return value == null
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Container(
                  height: 200,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: value.groupItems!.groupItemList!.length,
                      itemBuilder: (context, index) {
                        return Container(
                          width: 120,
                          height: 180,
                          margin: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topRight,
                                end: Alignment.bottomLeft,
                                colors: [
                                  const Color(0xFFfa709a),
                                  Theme.of(context).primaryColor
                                ],
                              ),
                              borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            children: [
                              FutureProvider<String?>.value(
                                  value: Utils.getDownloadUrl(
                                      key: value
                                          .groupItems!
                                          .groupItemList![index]
                                          .groupProfilePicKey!),
                                  catchError: (context, error) {
                                    throw error!;
                                  },
                                  initialData: null,
                                  child: Consumer(builder:
                                      (_, String? groupProfilePicUrl, child) {
                                    return ClipRRect(
                                      borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          topRight: Radius.circular(10)),
                                      child: CachedNetworkImage(
                                          width: 120,
                                          height: 80,
                                          fit: BoxFit.cover,
                                          imageUrl: groupProfilePicUrl ?? "",
                                          placeholder: (context, url) =>
                                              CircularProgressIndicator(
                                                  valueColor:
                                                      AlwaysStoppedAnimation<
                                                              Color>(
                                                          Theme.of(context)
                                                              .primaryColor)),
                                          errorWidget: (context, url, ex) =>
                                              CircleAvatar(
                                                backgroundColor:
                                                    Theme.of(context)
                                                        .colorScheme
                                                        .secondary,
                                                radius: 40.0,
                                                child: const Icon(
                                                  Icons.account_circle,
                                                  color: Colors.white,
                                                  size: 40.0,
                                                ),
                                              )),
                                    );
                                  })),
                              Container(
                                padding: const EdgeInsets.only(
                                    top: 10, left: 10, right: 10),
                                child: Text(
                                  value.groupItems!.groupItemList![index].name!,
                                 ),

                              ),
                              FutureProvider<GetAllUsersPerGroupModel?>.value(
                                  value: GroupRepository.instance()
                                      .getAllUsersPerGroup(
                                          value.groupItems!
                                              .groupItemList![index].id!,
                                          nextToken,
                                          10),
                                  initialData: null,
                                  catchError: (context, error) {
                                    throw error!;
                                  },
                                  child: Consumer(builder:
                                      (BuildContext context,
                                          GetAllUsersPerGroupModel? value,
                                          Widget? child) {
                                    return value != null
                                        ? Container(
                                            height: 50,
                                            width: 200,
                                            child: Wrap(
                                              spacing: -20,
                                              children: [
                                                for (int i = 0;
                                                    i <
                                                        value
                                                            .getAllUsersPerGroup!
                                                            .items!
                                                            .length;
                                                    i++) ...[
                                                  Container(
                                                    padding: EdgeInsets.only(
                                                        left: 10.0 + i),
                                                    child: ClipOval(
                                                        child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        100),
                                                            child:
                                                                CachedNetworkImage(
                                                                    width: 30.0,
                                                                    height:
                                                                        30.0,
                                                                    fit:
                                                                        BoxFit
                                                                            .cover,
                                                                    imageUrl: value
                                                                        .getAllUsersPerGroup!
                                                                        .items![
                                                                            i]
                                                                        .userItem!
                                                                        .profilePicKey!,
                                                                    placeholder:
                                                                        (context,
                                                                                url) =>
                                                                            const CircularProgressIndicator(),
                                                                    errorWidget: (context,
                                                                            url,
                                                                            ex) =>
                                                                        CircleAvatar(
                                                                          backgroundColor: Theme.of(context)
                                                                              .colorScheme
                                                                              .secondary,
                                                                          radius:
                                                                              30.0,
                                                                          child:
                                                                              const Icon(
                                                                            Icons.account_circle,
                                                                            color:
                                                                                Colors.white,
                                                                            size:
                                                                                30.0,
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
        }));
  }
}
