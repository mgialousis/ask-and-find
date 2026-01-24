import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

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

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
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
    Locale('en'),
    Locale('es'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Say & Find'**
  String get appTitle;

  /// No description provided for @appTagline.
  ///
  /// In en, this message translates to:
  /// **'The Ultimate Party Trivia Game'**
  String get appTagline;

  /// No description provided for @newGame.
  ///
  /// In en, this message translates to:
  /// **'New Game'**
  String get newGame;

  /// No description provided for @howToPlay.
  ///
  /// In en, this message translates to:
  /// **'How to Play'**
  String get howToPlay;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @startGame.
  ///
  /// In en, this message translates to:
  /// **'Start Game'**
  String get startGame;

  /// No description provided for @continueButton.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueButton;

  /// No description provided for @playAgain.
  ///
  /// In en, this message translates to:
  /// **'Play Again'**
  String get playAgain;

  /// No description provided for @newSetup.
  ///
  /// In en, this message translates to:
  /// **'New Setup'**
  String get newSetup;

  /// No description provided for @shareResults.
  ///
  /// In en, this message translates to:
  /// **'Share Results'**
  String get shareResults;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @endGame.
  ///
  /// In en, this message translates to:
  /// **'End Game'**
  String get endGame;

  /// No description provided for @endTurn.
  ///
  /// In en, this message translates to:
  /// **'End Turn'**
  String get endTurn;

  /// No description provided for @showQuestion.
  ///
  /// In en, this message translates to:
  /// **'Show Question'**
  String get showQuestion;

  /// No description provided for @refreshQuestion.
  ///
  /// In en, this message translates to:
  /// **'New Question'**
  String get refreshQuestion;

  /// No description provided for @showAnswers.
  ///
  /// In en, this message translates to:
  /// **'Show Answers'**
  String get showAnswers;

  /// No description provided for @hideAnswers.
  ///
  /// In en, this message translates to:
  /// **'Hide Answers'**
  String get hideAnswers;

  /// No description provided for @restoreDefaults.
  ///
  /// In en, this message translates to:
  /// **'Restore Defaults'**
  String get restoreDefaults;

  /// No description provided for @gameSetup.
  ///
  /// In en, this message translates to:
  /// **'Game Setup'**
  String get gameSetup;

  /// No description provided for @numberOfTeams.
  ///
  /// In en, this message translates to:
  /// **'Number of Teams'**
  String get numberOfTeams;

  /// No description provided for @teamSetup.
  ///
  /// In en, this message translates to:
  /// **'Team Setup'**
  String get teamSetup;

  /// No description provided for @gameSettings.
  ///
  /// In en, this message translates to:
  /// **'Game Settings'**
  String get gameSettings;

  /// No description provided for @numberOfRounds.
  ///
  /// In en, this message translates to:
  /// **'Number of Rounds'**
  String get numberOfRounds;

  /// No description provided for @roundDuration.
  ///
  /// In en, this message translates to:
  /// **'Round Duration'**
  String get roundDuration;

  /// No description provided for @difficulty.
  ///
  /// In en, this message translates to:
  /// **'Difficulty'**
  String get difficulty;

  /// No description provided for @teamName.
  ///
  /// In en, this message translates to:
  /// **'Team Name'**
  String get teamName;

  /// No description provided for @teamColor.
  ///
  /// In en, this message translates to:
  /// **'Team Color'**
  String get teamColor;

  /// No description provided for @enterTeamName.
  ///
  /// In en, this message translates to:
  /// **'Enter team name'**
  String get enterTeamName;

  /// No description provided for @team.
  ///
  /// In en, this message translates to:
  /// **'Team'**
  String get team;

  /// No description provided for @teams.
  ///
  /// In en, this message translates to:
  /// **'Teams'**
  String get teams;

  /// No description provided for @teamWithNumber.
  ///
  /// In en, this message translates to:
  /// **'Team {number}'**
  String teamWithNumber(int number);

  /// No description provided for @easy.
  ///
  /// In en, this message translates to:
  /// **'Easy'**
  String get easy;

  /// No description provided for @medium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get medium;

  /// No description provided for @hard.
  ///
  /// In en, this message translates to:
  /// **'Hard'**
  String get hard;

  /// No description provided for @seconds30.
  ///
  /// In en, this message translates to:
  /// **'30s'**
  String get seconds30;

  /// No description provided for @seconds45.
  ///
  /// In en, this message translates to:
  /// **'45s'**
  String get seconds45;

  /// No description provided for @seconds60.
  ///
  /// In en, this message translates to:
  /// **'60s'**
  String get seconds60;

  /// No description provided for @seconds90.
  ///
  /// In en, this message translates to:
  /// **'90s'**
  String get seconds90;

  /// No description provided for @roundOf.
  ///
  /// In en, this message translates to:
  /// **'Round {current} of {total}'**
  String roundOf(int current, int total);

  /// No description provided for @findAnswersInTime.
  ///
  /// In en, this message translates to:
  /// **'Find 10 answers in {seconds} seconds'**
  String findAnswersInTime(int seconds);

  /// No description provided for @passDeviceMessage.
  ///
  /// In en, this message translates to:
  /// **'It\'s {currentTeam}\'s turn, pass device to {nextTeam}'**
  String passDeviceMessage(String currentTeam, String nextTeam);

  /// No description provided for @readyStartTurn.
  ///
  /// In en, this message translates to:
  /// **'Ready? Start Turn'**
  String get readyStartTurn;

  /// No description provided for @tapToStartTimer.
  ///
  /// In en, this message translates to:
  /// **'Tap the card to start the timer'**
  String get tapToStartTimer;

  /// No description provided for @gameOver.
  ///
  /// In en, this message translates to:
  /// **'Game Over!'**
  String get gameOver;

  /// No description provided for @teamWins.
  ///
  /// In en, this message translates to:
  /// **'{teamName} Wins!'**
  String teamWins(String teamName);

  /// No description provided for @itsATie.
  ///
  /// In en, this message translates to:
  /// **'It\'s a Tie!'**
  String get itsATie;

  /// No description provided for @noWinner.
  ///
  /// In en, this message translates to:
  /// **'No winner'**
  String get noWinner;

  /// No description provided for @noScoresRecorded.
  ///
  /// In en, this message translates to:
  /// **'No scores recorded'**
  String get noScoresRecorded;

  /// No description provided for @nPoints.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 point} other{{count} points}}'**
  String nPoints(int count);

  /// No description provided for @nPts.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 pt} other{{count} pts}}'**
  String nPts(int count);

  /// No description provided for @roundComplete.
  ///
  /// In en, this message translates to:
  /// **'Round Complete!'**
  String get roundComplete;

  /// No description provided for @foundOf.
  ///
  /// In en, this message translates to:
  /// **'Found {found} of {total}'**
  String foundOf(int found, int total);

  /// No description provided for @scoresSoFar.
  ///
  /// In en, this message translates to:
  /// **'Scores So Far'**
  String get scoresSoFar;

  /// No description provided for @finalScores.
  ///
  /// In en, this message translates to:
  /// **'Final Scores'**
  String get finalScores;

  /// No description provided for @foundWithCount.
  ///
  /// In en, this message translates to:
  /// **'Found ({count}) ({points} pts)'**
  String foundWithCount(int count, int points);

  /// No description provided for @missedWithCount.
  ///
  /// In en, this message translates to:
  /// **'Missed ({count})'**
  String missedWithCount(int count);

  /// No description provided for @rank1st.
  ///
  /// In en, this message translates to:
  /// **'1st'**
  String get rank1st;

  /// No description provided for @rank2nd.
  ///
  /// In en, this message translates to:
  /// **'2nd'**
  String get rank2nd;

  /// No description provided for @rank3rd.
  ///
  /// In en, this message translates to:
  /// **'3rd'**
  String get rank3rd;

  /// No description provided for @rankNth.
  ///
  /// In en, this message translates to:
  /// **'{rank}th'**
  String rankNth(int rank);

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @audio.
  ///
  /// In en, this message translates to:
  /// **'Audio'**
  String get audio;

  /// No description provided for @haptics.
  ///
  /// In en, this message translates to:
  /// **'Haptics'**
  String get haptics;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @privacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get privacy;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @soundEffects.
  ///
  /// In en, this message translates to:
  /// **'Sound Effects'**
  String get soundEffects;

  /// No description provided for @soundEffectsDesc.
  ///
  /// In en, this message translates to:
  /// **'Play sounds during gameplay'**
  String get soundEffectsDesc;

  /// No description provided for @hapticFeedback.
  ///
  /// In en, this message translates to:
  /// **'Haptic Feedback'**
  String get hapticFeedback;

  /// No description provided for @hapticFeedbackDesc.
  ///
  /// In en, this message translates to:
  /// **'Vibrate on interactions'**
  String get hapticFeedbackDesc;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @darkModeDesc.
  ///
  /// In en, this message translates to:
  /// **'Coming soon in a future update'**
  String get darkModeDesc;

  /// No description provided for @analytics.
  ///
  /// In en, this message translates to:
  /// **'Analytics'**
  String get analytics;

  /// No description provided for @analyticsDesc.
  ///
  /// In en, this message translates to:
  /// **'Help improve the game by sending anonymous usage data'**
  String get analyticsDesc;

  /// No description provided for @settingsRestored.
  ///
  /// In en, this message translates to:
  /// **'Settings restored to defaults'**
  String get settingsRestored;

  /// No description provided for @versionNumber.
  ///
  /// In en, this message translates to:
  /// **'Version {number}'**
  String versionNumber(String number);

  /// No description provided for @validationNameEmpty.
  ///
  /// In en, this message translates to:
  /// **'Team name cannot be empty'**
  String get validationNameEmpty;

  /// No description provided for @validationNameDuplicate.
  ///
  /// In en, this message translates to:
  /// **'Team name must be unique'**
  String get validationNameDuplicate;

  /// No description provided for @validationFixErrors.
  ///
  /// In en, this message translates to:
  /// **'Please fix validation errors before starting'**
  String get validationFixErrors;

  /// No description provided for @howToPlayTitle.
  ///
  /// In en, this message translates to:
  /// **'How to Play'**
  String get howToPlayTitle;

  /// No description provided for @step1Title.
  ///
  /// In en, this message translates to:
  /// **'Set Up Teams'**
  String get step1Title;

  /// No description provided for @step1Desc.
  ///
  /// In en, this message translates to:
  /// **'Create 2-4 teams and choose unique names and colors for each team. Each team will take turns guessing answers.'**
  String get step1Desc;

  /// No description provided for @step2Title.
  ///
  /// In en, this message translates to:
  /// **'Read the Prompt'**
  String get step2Title;

  /// No description provided for @step2Desc.
  ///
  /// In en, this message translates to:
  /// **'Each round, the active team sees a prompt (like \"Name European capital cities\"). Their goal is to guess 10 correct answers from a hidden list.'**
  String get step2Desc;

  /// No description provided for @step3Title.
  ///
  /// In en, this message translates to:
  /// **'Beat the Clock'**
  String get step3Title;

  /// No description provided for @step3Desc.
  ///
  /// In en, this message translates to:
  /// **'Teams have a time limit (30-90 seconds) to find as many answers as possible. Tap the hidden chips to reveal answers when you guess correctly.'**
  String get step3Desc;

  /// No description provided for @step4Title.
  ///
  /// In en, this message translates to:
  /// **'Score Points'**
  String get step4Title;

  /// No description provided for @step4Desc.
  ///
  /// In en, this message translates to:
  /// **'Each correct answer found earns 1 point. There are no penalties for wrong guesses, so keep trying! Only the 10 selected answers for that round count.'**
  String get step4Desc;

  /// No description provided for @step5Title.
  ///
  /// In en, this message translates to:
  /// **'Take Turns'**
  String get step5Title;

  /// No description provided for @step5Desc.
  ///
  /// In en, this message translates to:
  /// **'Teams take turns playing rounds until all configured rounds are complete. The game alternates between teams in order.'**
  String get step5Desc;

  /// No description provided for @step6Title.
  ///
  /// In en, this message translates to:
  /// **'Win the Game'**
  String get step6Title;

  /// No description provided for @step6Desc.
  ///
  /// In en, this message translates to:
  /// **'After all rounds, the team with the most points wins! If there\'s a tie for first place, overtime rounds determine the winner.'**
  String get step6Desc;

  /// No description provided for @proTips.
  ///
  /// In en, this message translates to:
  /// **'Pro Tips'**
  String get proTips;

  /// No description provided for @tip1.
  ///
  /// In en, this message translates to:
  /// **'Communication is key! Discuss answers with your team.'**
  String get tip1;

  /// No description provided for @tip2.
  ///
  /// In en, this message translates to:
  /// **'Think of multiple variations of an answer (e.g., \"USA\" vs \"United States\").'**
  String get tip2;

  /// No description provided for @tip3.
  ///
  /// In en, this message translates to:
  /// **'Watch the timer! The last 10 seconds are critical.'**
  String get tip3;

  /// No description provided for @tip4.
  ///
  /// In en, this message translates to:
  /// **'Learn from revealed answers at the end of each round.'**
  String get tip4;

  /// No description provided for @shareTitle.
  ///
  /// In en, this message translates to:
  /// **'Say & Find - Game Results'**
  String get shareTitle;

  /// No description provided for @shareWinner.
  ///
  /// In en, this message translates to:
  /// **'Winner:'**
  String get shareWinner;

  /// No description provided for @shareTie.
  ///
  /// In en, this message translates to:
  /// **'Tie between:'**
  String get shareTie;

  /// No description provided for @shareScore.
  ///
  /// In en, this message translates to:
  /// **'Score:'**
  String get shareScore;

  /// No description provided for @shareFinalStandings.
  ///
  /// In en, this message translates to:
  /// **'Final Standings:'**
  String get shareFinalStandings;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @spanish.
  ///
  /// In en, this message translates to:
  /// **'Spanish'**
  String get spanish;

  /// No description provided for @community.
  ///
  /// In en, this message translates to:
  /// **'Community'**
  String get community;

  /// No description provided for @submitNewCard.
  ///
  /// In en, this message translates to:
  /// **'Submit New Card'**
  String get submitNewCard;

  /// No description provided for @submitNewCardDesc.
  ///
  /// In en, this message translates to:
  /// **'Propose a new trivia card for review.'**
  String get submitNewCardDesc;

  /// No description provided for @reportIssue.
  ///
  /// In en, this message translates to:
  /// **'Report Issue'**
  String get reportIssue;

  /// No description provided for @reportIssueDesc.
  ///
  /// In en, this message translates to:
  /// **'Flag a problem with an existing card.'**
  String get reportIssueDesc;

  /// No description provided for @pendingSubmissions.
  ///
  /// In en, this message translates to:
  /// **'Pending Submissions'**
  String get pendingSubmissions;

  /// No description provided for @pendingSubmissionsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 pending submission} other{{count} pending submissions}}'**
  String pendingSubmissionsCount(int count);

  /// No description provided for @retrySubmissions.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retrySubmissions;

  /// No description provided for @submitCardTitle.
  ///
  /// In en, this message translates to:
  /// **'Submit a New Card'**
  String get submitCardTitle;

  /// No description provided for @reportIssueTitle.
  ///
  /// In en, this message translates to:
  /// **'Report an Issue'**
  String get reportIssueTitle;

  /// No description provided for @questionLabel.
  ///
  /// In en, this message translates to:
  /// **'Question'**
  String get questionLabel;

  /// No description provided for @questionHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., Name 10 European capital cities'**
  String get questionHint;

  /// No description provided for @answersLabel.
  ///
  /// In en, this message translates to:
  /// **'Answers'**
  String get answersLabel;

  /// No description provided for @answersHint.
  ///
  /// In en, this message translates to:
  /// **'Provide 10 correct answers.'**
  String get answersHint;

  /// No description provided for @answersCount.
  ///
  /// In en, this message translates to:
  /// **'{count} of {min} answers filled'**
  String answersCount(int count, int min);

  /// No description provided for @addAnswer.
  ///
  /// In en, this message translates to:
  /// **'Add Answer'**
  String get addAnswer;

  /// No description provided for @sourceLabel.
  ///
  /// In en, this message translates to:
  /// **'Source'**
  String get sourceLabel;

  /// No description provided for @sourceHint.
  ///
  /// In en, this message translates to:
  /// **'Optional source or reference'**
  String get sourceHint;

  /// No description provided for @yourNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Your Name'**
  String get yourNameLabel;

  /// No description provided for @yourNameHint.
  ///
  /// In en, this message translates to:
  /// **'Optional'**
  String get yourNameHint;

  /// No description provided for @yourEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Your Email'**
  String get yourEmailLabel;

  /// No description provided for @yourEmailHint.
  ///
  /// In en, this message translates to:
  /// **'Optional, for follow-up'**
  String get yourEmailHint;

  /// No description provided for @optional.
  ///
  /// In en, this message translates to:
  /// **'optional'**
  String get optional;

  /// No description provided for @previewCard.
  ///
  /// In en, this message translates to:
  /// **'Preview'**
  String get previewCard;

  /// No description provided for @submitCard.
  ///
  /// In en, this message translates to:
  /// **'Submit Card'**
  String get submitCard;

  /// No description provided for @submitReport.
  ///
  /// In en, this message translates to:
  /// **'Submit Report'**
  String get submitReport;

  /// No description provided for @offlineSubmissionSaved.
  ///
  /// In en, this message translates to:
  /// **'You\'re offline. We\'ll send this when you\'re back online.'**
  String get offlineSubmissionSaved;

  /// No description provided for @submissionError.
  ///
  /// In en, this message translates to:
  /// **'Submission failed. Please try again.'**
  String get submissionError;

  /// No description provided for @submissionSuccess.
  ///
  /// In en, this message translates to:
  /// **'Submission received'**
  String get submissionSuccess;

  /// No description provided for @submissionSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'Thanks for helping improve the game.'**
  String get submissionSuccessMessage;

  /// No description provided for @submitAnother.
  ///
  /// In en, this message translates to:
  /// **'Submit Another'**
  String get submitAnother;

  /// No description provided for @backToSettings.
  ///
  /// In en, this message translates to:
  /// **'Back to Settings'**
  String get backToSettings;

  /// No description provided for @cardBeingCorrected.
  ///
  /// In en, this message translates to:
  /// **'Card Being Corrected'**
  String get cardBeingCorrected;

  /// No description provided for @selectCard.
  ///
  /// In en, this message translates to:
  /// **'Select a Card'**
  String get selectCard;

  /// No description provided for @changeCard.
  ///
  /// In en, this message translates to:
  /// **'Change Card'**
  String get changeCard;

  /// No description provided for @searchCards.
  ///
  /// In en, this message translates to:
  /// **'Search cards'**
  String get searchCards;

  /// No description provided for @filterByDifficulty.
  ///
  /// In en, this message translates to:
  /// **'Filter by difficulty'**
  String get filterByDifficulty;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @errorLoadingCards.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load cards.'**
  String get errorLoadingCards;

  /// No description provided for @noCardsFound.
  ///
  /// In en, this message translates to:
  /// **'No cards found.'**
  String get noCardsFound;

  /// No description provided for @issueTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Issue Type'**
  String get issueTypeLabel;

  /// No description provided for @issueTypeWrongAnswer.
  ///
  /// In en, this message translates to:
  /// **'Wrong answer'**
  String get issueTypeWrongAnswer;

  /// No description provided for @issueTypeWrongAnswerDesc.
  ///
  /// In en, this message translates to:
  /// **'An answer is incorrect or missing.'**
  String get issueTypeWrongAnswerDesc;

  /// No description provided for @issueTypeOutdated.
  ///
  /// In en, this message translates to:
  /// **'Outdated info'**
  String get issueTypeOutdated;

  /// No description provided for @issueTypeOutdatedDesc.
  ///
  /// In en, this message translates to:
  /// **'The card uses outdated facts.'**
  String get issueTypeOutdatedDesc;

  /// No description provided for @issueTypeSpelling.
  ///
  /// In en, this message translates to:
  /// **'Spelling/grammar'**
  String get issueTypeSpelling;

  /// No description provided for @issueTypeSpellingDesc.
  ///
  /// In en, this message translates to:
  /// **'Spelling or grammar needs correction.'**
  String get issueTypeSpellingDesc;

  /// No description provided for @issueTypeUnclear.
  ///
  /// In en, this message translates to:
  /// **'Unclear question'**
  String get issueTypeUnclear;

  /// No description provided for @issueTypeUnclearDesc.
  ///
  /// In en, this message translates to:
  /// **'The prompt is confusing or ambiguous.'**
  String get issueTypeUnclearDesc;

  /// No description provided for @issueTypeOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get issueTypeOther;

  /// No description provided for @issueTypeOtherDesc.
  ///
  /// In en, this message translates to:
  /// **'Something else needs attention.'**
  String get issueTypeOtherDesc;

  /// No description provided for @describeIssue.
  ///
  /// In en, this message translates to:
  /// **'Describe the issue'**
  String get describeIssue;

  /// No description provided for @describeIssueHint.
  ///
  /// In en, this message translates to:
  /// **'Tell us what\'s wrong and how to fix it.'**
  String get describeIssueHint;

  /// No description provided for @validationQuestionRequired.
  ///
  /// In en, this message translates to:
  /// **'Question is required'**
  String get validationQuestionRequired;

  /// No description provided for @validationQuestionTooShort.
  ///
  /// In en, this message translates to:
  /// **'Question must be at least 10 characters'**
  String get validationQuestionTooShort;

  /// No description provided for @validationDescriptionRequired.
  ///
  /// In en, this message translates to:
  /// **'Description is required'**
  String get validationDescriptionRequired;

  /// No description provided for @validationDescriptionTooShort.
  ///
  /// In en, this message translates to:
  /// **'Description must be at least 20 characters'**
  String get validationDescriptionTooShort;

  /// No description provided for @validationInvalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Invalid email format'**
  String get validationInvalidEmail;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
