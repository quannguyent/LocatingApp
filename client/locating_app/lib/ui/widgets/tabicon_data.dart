import 'package:flutter/material.dart';
import '../../res/resources.dart';

class TabIconData {
  TabIconData({
    this.imagePath, // = '',
    this.index = 0,
    this.selectedImagePath, // = '',
    this.isSelected = false,
    this.animationController,
    this.isNotification,
  }
      );

  Widget imagePath;
  Widget selectedImagePath;
  bool isSelected;
  int index;
  bool isNotification;

  AnimationController animationController;

  static List<TabIconData> tabIconsList = <TabIconData>[
    TabIconData(
      imagePath: Icon(
        Icons.public,
        color: AppTheme.grey.withOpacity(0.6),
        size: 35,
      ),
      selectedImagePath: Icon(
        Icons.public,
        color: AppTheme.nearlyDarkBlue.withOpacity(0.6),
        size: 35,
      ),
      index: 0,
      isSelected: true,
    ),
    TabIconData(
      imagePath: Icon(
        Icons.ac_unit,
        color: AppTheme.grey.withOpacity(0.6),
        size: 35,
      ),
      selectedImagePath: Icon(
        Icons.ac_unit,
        color: AppTheme.nearlyDarkBlue.withOpacity(0.6),
        size: 35,
      ),
      index: 1,
      isSelected: true,
    ),
    TabIconData(
      imagePath: Icon(
        Icons.settings,
        color: AppTheme.grey.withOpacity(0.6),
        size: 36,
      ), //'assets/images/ic-back.png',
      selectedImagePath: Icon(
        Icons.settings,
        color: AppTheme.nearlyDarkBlue.withOpacity(0.6),
        size: 36,
      ), //'assets/images/ic-back.png',
      index: 2,
      isSelected: false,
      //animationController: null,
    ),
    TabIconData(
      imagePath: Icon(
        Icons.account_circle_outlined,
        color: AppTheme.grey.withOpacity(0.6),
        size: 36,
      ),
      selectedImagePath: Icon(
        Icons.account_circle_outlined,
        color: AppTheme.nearlyDarkBlue.withOpacity(0.6),
        size: 36,
      ),
      index: 3,
      isSelected: false,
    ),
  ];
}
