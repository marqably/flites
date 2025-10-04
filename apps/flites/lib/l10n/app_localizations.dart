import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_it.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('it'),
    Locale('ja'),
    Locale('ko'),
    Locale('pt'),
    Locale('zh'),
  ];

  /// The application title
  ///
  /// In en, this message translates to:
  /// **'Flites'**
  String get title;

  /// Button text for adding a new image
  ///
  /// In en, this message translates to:
  /// **'Add Image'**
  String get addImage;

  /// Tools section header
  ///
  /// In en, this message translates to:
  /// **'Tools'**
  String get tools;

  /// Frames section header
  ///
  /// In en, this message translates to:
  /// **'Frames'**
  String get frames;

  /// Tooltip for canvas mode button
  ///
  /// In en, this message translates to:
  /// **'Canvas Mode'**
  String get canvasMode;

  /// Tooltip for move tool button
  ///
  /// In en, this message translates to:
  /// **'Move Tool'**
  String get moveTool;

  /// Tooltip for rotate tool button
  ///
  /// In en, this message translates to:
  /// **'Rotate Tool'**
  String get rotateTool;

  /// Tooltip for rotate Hitbox tool button
  ///
  /// In en, this message translates to:
  /// **'Hitbox Tool'**
  String get hitboxTool;

  /// Tooltip for visibility toggle button
  ///
  /// In en, this message translates to:
  /// **'Toggle visibility'**
  String get toggleVisibility;

  /// Title for canvas and image controls overlay
  ///
  /// In en, this message translates to:
  /// **'Canvas and Image Controls'**
  String get canvasAndImageControls;

  /// Section header for canvas controls
  ///
  /// In en, this message translates to:
  /// **'Canvas Controls'**
  String get canvasControls;

  /// Section header for image controls
  ///
  /// In en, this message translates to:
  /// **'Image Controls'**
  String get imageControls;

  /// Checkbox label for using previous frame as reference
  ///
  /// In en, this message translates to:
  /// **'Use Previous Frame as Reference'**
  String get usePreviousFrameAsReference;

  /// Checkbox label for showing bounding border
  ///
  /// In en, this message translates to:
  /// **'Show bounding border'**
  String get showBoundingBorder;

  /// Button text for sorting images by name
  ///
  /// In en, this message translates to:
  /// **'Sort by name'**
  String get sortByName;

  /// Button text for renaming files according to order
  ///
  /// In en, this message translates to:
  /// **'Rename Files according to order'**
  String get renameFilesAccordingToOrder;

  /// Button text for resetting file names
  ///
  /// In en, this message translates to:
  /// **'Reset Names'**
  String get resetNames;

  /// Delete button tooltip
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// Tooltip for play/pause button
  ///
  /// In en, this message translates to:
  /// **'Play/Pause'**
  String get playPause;

  /// Button text for exporting sprite
  ///
  /// In en, this message translates to:
  /// **'Export Sprite'**
  String get exportSprite;

  /// Label for file name input
  ///
  /// In en, this message translates to:
  /// **'File name'**
  String get fileName;

  /// Label for location selection
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// Export button text
  ///
  /// In en, this message translates to:
  /// **'Export'**
  String get export;

  /// Hint text for TextField for sprite name
  ///
  /// In en, this message translates to:
  /// **'Enter sprite name'**
  String get enterSpriteName;

  /// Tooltip for location picker button
  ///
  /// In en, this message translates to:
  /// **'Select download location'**
  String get selectLocation;

  /// Tooltip for zoom in button
  ///
  /// In en, this message translates to:
  /// **'Zoom In'**
  String get zoomIn;

  /// Tooltip for zoom out button
  ///
  /// In en, this message translates to:
  /// **'Zoom Out'**
  String get zoomOut;

  /// Message shown while image is being processed
  ///
  /// In en, this message translates to:
  /// **'Please wait while we process your image'**
  String get processingImage;

  /// Message shown during processing on web platform
  ///
  /// In en, this message translates to:
  /// **'This might take a moment...'**
  String get processingMightTakeAMoment;

  /// File menu label
  ///
  /// In en, this message translates to:
  /// **'File'**
  String get menuFile;

  /// Preferences menu label
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get menuPreferences;

  /// Theme menu label
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get menuTheme;

  /// Light theme menu option
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get menuThemeLight;

  /// Dark theme menu option
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get menuThemeDark;

  /// System theme menu option
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get menuThemeSystem;

  /// Language menu label
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get menuLanguage;

  /// About Flites menu label
  ///
  /// In en, this message translates to:
  /// **'About Flites'**
  String get menuAboutFlites;

  /// General term for padding
  ///
  /// In en, this message translates to:
  /// **'Padding'**
  String get padding;

  /// Label for width input
  ///
  /// In en, this message translates to:
  /// **'Width'**
  String get width;

  /// Label for height input
  ///
  /// In en, this message translates to:
  /// **'Height'**
  String get height;

  /// Error message shown when no dimensions are provided for export
  ///
  /// In en, this message translates to:
  /// **'Please provide at least one dimension (width or height).'**
  String get provideDimensionError;

  /// Message indicating where files will be saved on web platform
  ///
  /// In en, this message translates to:
  /// **'File will be saved to your downloads folder.'**
  String get webDownloadLocation;

  /// Tooltip shown when trying to play with only one image
  ///
  /// In en, this message translates to:
  /// **'Add more than one image to play'**
  String get addMoreImagesToPlay;

  /// Title for theme mode section in settings
  ///
  /// In en, this message translates to:
  /// **'Theme Mode'**
  String get themeMode;

  /// Title for language section in settings
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageSection;

  /// Label for size in pixels
  ///
  /// In en, this message translates to:
  /// **'SIZE (px)'**
  String get sizePx;

  /// Label for width input
  ///
  /// In en, this message translates to:
  /// **'W'**
  String get widthLabel;

  /// Label for height input
  ///
  /// In en, this message translates to:
  /// **'H'**
  String get heightLabel;

  /// Title shown in update dialog when new version is available
  ///
  /// In en, this message translates to:
  /// **'Update Available'**
  String get updateAvailable;

  /// Message shown in update dialog when new version is available
  ///
  /// In en, this message translates to:
  /// **'A new version of Flites is available.'**
  String get newVersionAvailable;

  /// Button text for updating the app
  ///
  /// In en, this message translates to:
  /// **'Update Now'**
  String get updateNow;

  /// Button text to postpone the update
  ///
  /// In en, this message translates to:
  /// **'Later'**
  String get later;

  /// Error message shown when update URL could not be opened
  ///
  /// In en, this message translates to:
  /// **'Failed to open update URL.'**
  String get failedToOpenUpdateUrl;

  /// Confirmation message shown when an image has been saved
  ///
  /// In en, this message translates to:
  /// **'Image saved!'**
  String get imageSaved;

  /// Button text to open the folder containing a saved file
  ///
  /// In en, this message translates to:
  /// **'Show Containing Folder'**
  String get showContainingFolder;

  /// Button text for saving the current project/file
  ///
  /// In en, this message translates to:
  /// **'Save Project'**
  String get saveProject;

  /// Button text for opening a project/file
  ///
  /// In en, this message translates to:
  /// **'Open Project'**
  String get openProject;

  /// Button text for exporting a spritemap
  ///
  /// In en, this message translates to:
  /// **'Export Spritemap'**
  String get exportSpritemap;

  /// Title for the select options dialog
  ///
  /// In en, this message translates to:
  /// **'Select Options'**
  String get selectOptionsTitle;

  /// Cancel button text
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// OK button text
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// Placeholder text when no options are selected
  ///
  /// In en, this message translates to:
  /// **'Select options'**
  String get selectOptionsPlaceholder;

  /// Section header for export format settings
  ///
  /// In en, this message translates to:
  /// **'Format Settings'**
  String get formatSettings;

  /// Label for sprite sheet name input
  ///
  /// In en, this message translates to:
  /// **'Sprite Sheet Name'**
  String get spriteSheetName;

  /// Label for file format selection
  ///
  /// In en, this message translates to:
  /// **'File Format'**
  String get fileFormat;

  /// Option for PNG image format
  ///
  /// In en, this message translates to:
  /// **'PNG Image'**
  String get pngImage;

  /// Option for SVG vector format
  ///
  /// In en, this message translates to:
  /// **'SVG Vector'**
  String get svgVector;

  /// Error message when SVG export is not available
  ///
  /// In en, this message translates to:
  /// **'SVG export is not available in Flites yet.'**
  String get svgExportNotAvailable;

  /// Section header for image settings
  ///
  /// In en, this message translates to:
  /// **'Image Settings'**
  String get imageSettings;

  /// Label for tile size input
  ///
  /// In en, this message translates to:
  /// **'Tile Size'**
  String get tileSize;

  /// Section header for code generation settings
  ///
  /// In en, this message translates to:
  /// **'Code Generation'**
  String get codeGeneration;

  /// Label for target framework selection
  ///
  /// In en, this message translates to:
  /// **'Target Framework'**
  String get targetFramework;

  /// Message shown while generating a sprite sheet
  ///
  /// In en, this message translates to:
  /// **'Generating sprite sheet...'**
  String get generatingSpriteSheet;

  /// Checkbox label for generating hitbox code
  ///
  /// In en, this message translates to:
  /// **'Generate hitbox code'**
  String get generateHitboxCode;

  /// Button text for closing panels or dialogs
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'de',
    'en',
    'es',
    'fr',
    'it',
    'ja',
    'ko',
    'pt',
    'zh',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'it':
      return AppLocalizationsIt();
    case 'ja':
      return AppLocalizationsJa();
    case 'ko':
      return AppLocalizationsKo();
    case 'pt':
      return AppLocalizationsPt();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
