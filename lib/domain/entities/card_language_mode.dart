/// Controls which language is used for card questions and answers.
enum CardLanguageMode {
  english,
  spanish,
  bilingual;

  Set<String> get requiredLanguageCodes => switch (this) {
    CardLanguageMode.english => const {'en'},
    CardLanguageMode.spanish => const {'es'},
    CardLanguageMode.bilingual => const {'en', 'es'},
  };
}
