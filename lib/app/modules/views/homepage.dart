import 'package:clock_app/app/data/data.dart';
import 'package:clock_app/app/data/enums.dart';
import 'package:clock_app/app/data/models/menu_info.dart';
import 'package:clock_app/app/data/theme_data.dart';
import 'package:clock_app/app/modules/views/alarm_page.dart';
import 'package:clock_app/app/modules/views/clock_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.pageBackgroundColor,
      body: Row(
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: menuItems
                .map((currentMenuInfo) => buildMenuButton(currentMenuInfo))
                .toList(),
          ),
          VerticalDivider(
            color: CustomColors.dividerColor,
            width: 1,
          ),
          Expanded(
            child: Consumer<MenuInfo>(
              builder: (BuildContext context, MenuInfo value, Widget? child) {
                if (value.menuType == MenuType.clock) {
                  return ClockPage();
                } else if (value.menuType == MenuType.alarm) {
                  return AlarmPage();
                } else {
                  return RichText(
                    text: TextSpan(
                      style: TextStyle(fontSize: 20),
                      children: <TextSpan>[
                        TextSpan(text: 'Upcoming Tutorial\n'),
                        TextSpan(
                          text: value.title,
                          style: TextStyle(fontSize: 48),
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildMenuButton(MenuInfo currentMenuInfo) {
    return Consumer<MenuInfo>(
      builder: (BuildContext context, MenuInfo value, Widget? child) {
        return MaterialButton(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(topRight: Radius.circular(32))),
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 0),
          color: currentMenuInfo.menuType == value.menuType
              ? CustomColors.menuBackgroundColor
              : CustomColors.pageBackgroundColor,
          onPressed: () {
            var menuInfo = Provider.of<MenuInfo>(context, listen: false);
            menuInfo.updateMenu(currentMenuInfo);
          },
          child: Column(
            children: <Widget>[
              Image.asset(
                currentMenuInfo.imageSource!,
                scale: 1.5,
              ),
              SizedBox(height: 16),
              Text(
                currentMenuInfo.title ?? '',
                style: TextStyle(
                    fontFamily: 'avenir',
                    color: CustomColors.primaryTextColor,
                    fontSize: 14),
              ),
            ],
          ),
        );
      },
    );
  }
}
