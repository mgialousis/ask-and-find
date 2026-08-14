import 'package:flutter_test/flutter_test.dart';
import 'package:pes_vres/data/repositories/cards_repository.dart';
import 'package:pes_vres/domain/entities/difficulty.dart';
import 'package:flutter/widgets.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('every card in assets/cards.json loads and is playable', () async {
    final cards = await loadCardsFromAssets();
    expect(cards.length, greaterThanOrEqualTo(225));

    for (final card in cards) {
      expect(card.isValid, isTrue, reason: 'card ${card.id} has ${card.answersEn.length} answers');
      for (final locale in const [Locale('en'), Locale('es')]) {
        final answers = card.getAnswers(locale);
        expect(answers.length, greaterThanOrEqualTo(10), reason: 'card ${card.id} ${locale.languageCode}');
        expect(card.getPrompt(locale).isNotEmpty, isTrue);
        // points must come from the card, never the difficulty fallback
        for (final a in answers) {
          expect(card.answerPoints!.containsKey(a), isTrue,
              reason: 'card ${card.id}: no explicit points for "$a" (${locale.languageCode})');
        }
      }
      // scoring must be identical in both languages
      final en = card.pointsForAnswers(card.getAnswers(const Locale('en')));
      final es = card.pointsForAnswers(card.getAnswers(const Locale('es')));
      expect(en, es, reason: 'card ${card.id} scores differently per language');
    }
  });

  test('difficulty filtering yields a usable pool for every setting', () async {
    final cards = await loadCardsFromAssets();
    for (final d in Difficulty.values) {
      for (final lang in ['en', 'es']) {
        final pool = getCardsByDifficulties(cards, {d}, lang);
        expect(pool.length, greaterThanOrEqualTo(10),
            reason: '${d.name}/$lang pool is only ${pool.length} cards');
      }
    }
  });
}
