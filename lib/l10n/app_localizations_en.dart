// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Say & Find';

  @override
  String get appTagline => 'The Ultimate Party Trivia Game';

  @override
  String get newGame => 'New Game';

  @override
  String get howToPlay => 'How to Play';

  @override
  String get settings => 'Settings';

  @override
  String get startGame => 'Start Game';

  @override
  String get continueButton => 'Continue';

  @override
  String get playAgain => 'Play Again';

  @override
  String get newSetup => 'New Setup';

  @override
  String get shareResults => 'Share Results';

  @override
  String get home => 'Home';

  @override
  String get close => 'Close';

  @override
  String get endGame => 'End Game';

  @override
  String get endTurn => 'End Turn';

  @override
  String get showQuestion => 'Show Question';

  @override
  String get refreshQuestion => 'New Question';

  @override
  String get showAnswers => 'Show Answers';

  @override
  String get hideAnswers => 'Hide Answers';

  @override
  String get restoreDefaults => 'Restore Defaults';

  @override
  String get gameSetup => 'Game Setup';

  @override
  String get numberOfTeams => 'Number of Teams';

  @override
  String get teamSetup => 'Team Setup';

  @override
  String get gameSettings => 'Game Settings';

  @override
  String get numberOfRounds => 'Number of Rounds';

  @override
  String get roundDuration => 'Round Duration';

  @override
  String get difficulty => 'Difficulty';

  @override
  String get teamName => 'Team Name';

  @override
  String get teamColor => 'Team Color';

  @override
  String get enterTeamName => 'Enter team name';

  @override
  String get team => 'Team';

  @override
  String get teams => 'Teams';

  @override
  String teamWithNumber(int number) {
    return 'Team $number';
  }

  @override
  String get easy => 'Easy';

  @override
  String get medium => 'Medium';

  @override
  String get hard => 'Hard';

  @override
  String get seconds30 => '30s';

  @override
  String get seconds45 => '45s';

  @override
  String get seconds60 => '60s';

  @override
  String get seconds90 => '90s';

  @override
  String roundOf(int current, int total) {
    return 'Round $current of $total';
  }

  @override
  String findAnswersInTime(int seconds) {
    return 'Find 10 answers in $seconds seconds';
  }

  @override
  String passDeviceMessage(String currentTeam, String nextTeam) {
    return 'It\'s $currentTeam\'s turn, pass device to $nextTeam';
  }

  @override
  String get readyStartTurn => 'Ready? Start Turn';

  @override
  String get tapToStartTimer => 'Tap the card to start the timer';

  @override
  String get gameOver => 'Game Over!';

  @override
  String teamWins(String teamName) {
    return '$teamName Wins!';
  }

  @override
  String get itsATie => 'It\'s a Tie!';

  @override
  String get noWinner => 'No winner';

  @override
  String get noScoresRecorded => 'No scores recorded';

  @override
  String nPoints(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count points',
      one: '1 point',
    );
    return '$_temp0';
  }

  @override
  String nPts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pts',
      one: '1 pt',
    );
    return '$_temp0';
  }

  @override
  String get roundComplete => 'Round Complete!';

  @override
  String foundOf(int found, int total) {
    return 'Found $found of $total';
  }

  @override
  String get scoresSoFar => 'Scores So Far';

  @override
  String get finalScores => 'Final Scores';

  @override
  String foundWithCount(int count, int points) {
    return 'Found ($count) ($points pts)';
  }

  @override
  String missedWithCount(int count) {
    return 'Missed ($count)';
  }

  @override
  String get rank1st => '1st';

  @override
  String get rank2nd => '2nd';

  @override
  String get rank3rd => '3rd';

  @override
  String rankNth(int rank) {
    return '${rank}th';
  }

  @override
  String get settingsTitle => 'Settings';

  @override
  String get audio => 'Audio';

  @override
  String get haptics => 'Haptics';

  @override
  String get appearance => 'Appearance';

  @override
  String get privacy => 'Privacy';

  @override
  String get language => 'Language';

  @override
  String get soundEffects => 'Sound Effects';

  @override
  String get soundEffectsDesc => 'Play sounds during gameplay';

  @override
  String get hapticFeedback => 'Haptic Feedback';

  @override
  String get hapticFeedbackDesc => 'Vibrate on interactions';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get darkModeDesc => 'Coming soon in a future update';

  @override
  String get analytics => 'Analytics';

  @override
  String get analyticsDesc =>
      'Help improve the game by sending anonymous usage data';

  @override
  String get settingsRestored => 'Settings restored to defaults';

  @override
  String versionNumber(String number) {
    return 'Version $number';
  }

  @override
  String get validationNameEmpty => 'Team name cannot be empty';

  @override
  String get validationNameDuplicate => 'Team name must be unique';

  @override
  String get validationFixErrors =>
      'Please fix validation errors before starting';

  @override
  String get howToPlayTitle => 'How to Play';

  @override
  String get step1Title => 'Set Up Teams';

  @override
  String get step1Desc =>
      'Create 2-4 teams and choose unique names and colors for each team. Each team will take turns guessing answers.';

  @override
  String get step2Title => 'Read the Prompt';

  @override
  String get step2Desc =>
      'Each round, the active team sees a prompt (like \"Name European capital cities\"). Their goal is to guess 10 correct answers from a hidden list.';

  @override
  String get step3Title => 'Beat the Clock';

  @override
  String get step3Desc =>
      'Teams have a time limit (30-90 seconds) to find as many answers as possible. Tap the hidden chips to reveal answers when you guess correctly.';

  @override
  String get step4Title => 'Score Points';

  @override
  String get step4Desc =>
      'Each correct answer found earns 1 point. There are no penalties for wrong guesses, so keep trying! Only the 10 selected answers for that round count.';

  @override
  String get step5Title => 'Take Turns';

  @override
  String get step5Desc =>
      'Teams take turns playing rounds until all configured rounds are complete. The game alternates between teams in order.';

  @override
  String get step6Title => 'Win the Game';

  @override
  String get step6Desc =>
      'After all rounds, the team with the most points wins! If there\'s a tie for first place, overtime rounds determine the winner.';

  @override
  String get proTips => 'Pro Tips';

  @override
  String get tip1 => 'Communication is key! Discuss answers with your team.';

  @override
  String get tip2 =>
      'Think of multiple variations of an answer (e.g., \"USA\" vs \"United States\").';

  @override
  String get tip3 => 'Watch the timer! The last 10 seconds are critical.';

  @override
  String get tip4 => 'Learn from revealed answers at the end of each round.';

  @override
  String get shareTitle => 'Say & Find - Game Results';

  @override
  String get shareWinner => 'Winner:';

  @override
  String get shareTie => 'Tie between:';

  @override
  String get shareScore => 'Score:';

  @override
  String get shareFinalStandings => 'Final Standings:';

  @override
  String get english => 'English';

  @override
  String get spanish => 'Spanish';

  @override
  String get community => 'Community';

  @override
  String get submitNewCard => 'Submit New Card';

  @override
  String get submitNewCardDesc => 'Propose a new trivia card for review.';

  @override
  String get reportIssue => 'Report Issue';

  @override
  String get reportIssueDesc => 'Flag a problem with an existing card.';

  @override
  String get pendingSubmissions => 'Pending Submissions';

  @override
  String pendingSubmissionsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pending submissions',
      one: '1 pending submission',
    );
    return '$_temp0';
  }

  @override
  String get retrySubmissions => 'Retry';

  @override
  String get submitCardTitle => 'Submit a New Card';

  @override
  String get reportIssueTitle => 'Report an Issue';

  @override
  String get questionLabel => 'Question';

  @override
  String get questionHint => 'e.g., Name 10 European capital cities';

  @override
  String get answersLabel => 'Answers';

  @override
  String get answersHint => 'Provide 10 correct answers.';

  @override
  String answersCount(int count, int min) {
    return '$count of $min answers filled';
  }

  @override
  String get addAnswer => 'Add Answer';

  @override
  String get sourceLabel => 'Source';

  @override
  String get sourceHint => 'Optional source or reference';

  @override
  String get yourNameLabel => 'Your Name';

  @override
  String get yourNameHint => 'Optional';

  @override
  String get yourEmailLabel => 'Your Email';

  @override
  String get yourEmailHint => 'Optional, for follow-up';

  @override
  String get optional => 'optional';

  @override
  String get previewCard => 'Preview';

  @override
  String get submitCard => 'Submit Card';

  @override
  String get submitReport => 'Submit Report';

  @override
  String get offlineSubmissionSaved =>
      'You\'re offline. We\'ll send this when you\'re back online.';

  @override
  String get submissionError => 'Submission failed. Please try again.';

  @override
  String get submissionSuccess => 'Submission received';

  @override
  String get submissionSuccessMessage => 'Thanks for helping improve the game.';

  @override
  String get submitAnother => 'Submit Another';

  @override
  String get backToSettings => 'Back to Settings';

  @override
  String get cardBeingCorrected => 'Card Being Corrected';

  @override
  String get selectCard => 'Select a Card';

  @override
  String get changeCard => 'Change Card';

  @override
  String get searchCards => 'Search cards';

  @override
  String get filterByDifficulty => 'Filter by difficulty';

  @override
  String get all => 'All';

  @override
  String get errorLoadingCards => 'Couldn\'t load cards.';

  @override
  String get noCardsFound => 'No cards found.';

  @override
  String get issueTypeLabel => 'Issue Type';

  @override
  String get issueTypeWrongAnswer => 'Wrong answer';

  @override
  String get issueTypeWrongAnswerDesc => 'An answer is incorrect or missing.';

  @override
  String get issueTypeOutdated => 'Outdated info';

  @override
  String get issueTypeOutdatedDesc => 'The card uses outdated facts.';

  @override
  String get issueTypeSpelling => 'Spelling/grammar';

  @override
  String get issueTypeSpellingDesc => 'Spelling or grammar needs correction.';

  @override
  String get issueTypeUnclear => 'Unclear question';

  @override
  String get issueTypeUnclearDesc => 'The prompt is confusing or ambiguous.';

  @override
  String get issueTypeOther => 'Other';

  @override
  String get issueTypeOtherDesc => 'Something else needs attention.';

  @override
  String get describeIssue => 'Describe the issue';

  @override
  String get describeIssueHint => 'Tell us what\'s wrong and how to fix it.';

  @override
  String get validationQuestionRequired => 'Question is required';

  @override
  String get validationQuestionTooShort =>
      'Question must be at least 10 characters';

  @override
  String get validationDescriptionRequired => 'Description is required';

  @override
  String get validationDescriptionTooShort =>
      'Description must be at least 20 characters';

  @override
  String get validationInvalidEmail => 'Invalid email format';
}
