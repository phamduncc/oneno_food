import 'package:flutter/material.dart';

abstract class AppLocalizations {
  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  // App Title
  String get appTitle;
  String get appSubtitle;

  // Navigation
  String get home;
  String get favorites;
  String get about;
  String get settings;

  // Home Screen
  String get selectProvince;
  String get selectProvinceHint;
  String get welcomeTitle;
  String get welcomeSubtitle;
  String get specialtiesOf;

  // Food Categories
  String get mainDishes;
  String get snacks;
  String get drinks;
  String get souvenirs;

  // Food Detail
  String get description;
  String get famousLocation;
  String get addToFavorites;
  String get removeFromFavorites;
  String get share;

  // Favorites Screen
  String get favoriteFoods;
  String get noFavorites;
  String get noFavoritesSubtitle;
  String get exploreNow;
  String get youHaveFavorites;
  String get clearAll;
  String get confirmClearAll;
  String get confirmClearAllMessage;
  String get cancel;
  String get deleteAll;

  // About Screen
  String get aboutApp;
  String get appDescription;
  String get features;
  String get featuresContent;
  String get version;
  String get versionContent;
  String get shareApp;
  String get rateApp;
  String get supportContact;
  String get email;
  String get hotline;
  String get website;

  // Messages
  String get addedToFavorites;
  String get removedFromFavorites;
  String get error;
  String get loading;
  String get copied;
  String get shareFeatureComingSoon;
  String get rateFeatureComingSoon;

  // QR Scanner
  String get scanQR;
  String get scanQRDescription;
  String get cameraPermission;
  String get cameraPermissionMessage;
  String get openSettings;

  // Language
  String get language;
  String get vietnamese;
  String get english;
  String get changeLanguage;
}
