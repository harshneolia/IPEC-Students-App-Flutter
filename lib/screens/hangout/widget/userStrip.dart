import 'package:flutter/material.dart';

import '../../../data/const.dart';
import '../../../theme/style.dart';
import '../../../util/SizeConfig.dart';

class UserStripWidget extends StatelessWidget {
  const UserStripWidget({
    Key? key,
    required this.name,
    required this.section,
    required this.yr,
    required this.id,
    this.isCompact = false,
  }) : super(key: key);
  final bool isCompact;
  final String? id;
  final String? name;
  final String? section;
  final String? yr;

  @override
  Widget build(BuildContext context) {
    var subTitle = isCompact
        ? [
            Row(
              children: [
                Expanded(
                  child: Text(
                    name!,
                    style: TextStyle(
                      fontSize: 12,
                    ),
                    overflow: TextOverflow.clip,
                  ),
                ),
                kLowWidthPadding,
                Text(
                  yr! + " year, ",
                  style: TextStyle(fontSize: 12),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  section!,
                  style: TextStyle(fontSize: 12),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ]
        : [
            Row(
              children: [
                Flexible(
                  child: Text(
                    name!,
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Visibility(
                    visible: kAdmins.contains(id), child: kLowWidthPadding),
                Visibility(
                  visible: kAdmins.contains(id),
                  child: Image.asset(
                    'assets/icons/verified.png',
                    width: 15,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  yr! + " year, ",
                  style: TextStyle(fontSize: 12),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  section!,
                  style: TextStyle(fontSize: 12),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ];

    return InkWell(
      onTap: () {
        //Open Profile
      },
      child: Row(
        children: [
          CircleAvatar(
            radius: isCompact
                ? SizeConfig.widthMultiplier * 4
                : SizeConfig.widthMultiplier * 5,
            backgroundImage: NetworkImage("https://robohash.org/$name"),
          ),
          kMedWidthPadding,
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: subTitle,
            ),
          ),
        ],
      ),
    );
  }
}
