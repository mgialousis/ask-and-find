import 'dart:convert';
import 'dart:math';

import 'package:flutter/services.dart';
import 'package:pes_vres/domain/entities/card_item.dart';
import 'package:pes_vres/domain/entities/difficulty.dart';

const String _cardsAssetPath = 'assets/cards.json';

Future<List<CardItem>> loadCardsFromAssets() async {
  final jsonString = await rootBundle.loadString(_cardsAssetPath);
  final data = jsonDecode(jsonString) as List<dynamic>;
  return data
      .map((entry) => CardItem.fromJson(entry as Map<String, dynamic>))
      .toList();
}

List<CardItem> getCardsByDifficulties(
  List<CardItem> cards,
  Set<Difficulty> difficulties, [
  String? languageCode,
]) {
  final filtered =
      cards.where((card) => difficulties.contains(card.difficulty)).toList();
  if (languageCode == null) {
    return filtered;
  }
  return filtered
      .where((card) => card.languageScope.contains(languageCode))
      .toList();
}

CardItem getRandomCard(
  List<CardItem> cards, [
  Set<Difficulty>? difficulties,
  String? languageCode,
]) {
  final pool = difficulties != null
      ? getCardsByDifficulties(cards, difficulties, languageCode)
      : cards
          .where(
            (card) =>
                languageCode == null ||
                card.languageScope.contains(languageCode),
          )
          .toList();
  if (pool.isEmpty) {
    throw StateError(
      'No cards available for difficulties: $difficulties, locale: $languageCode',
    );
  }
  final random = Random();
  return pool[random.nextInt(pool.length)];
}

CardItem getRandomCardExcluding(
  List<CardItem> cards,
  Set<String> excludedIds, [
  Set<Difficulty>? difficulties,
  String? languageCode,
]) {
  final pool = difficulties != null
      ? getCardsByDifficulties(cards, difficulties, languageCode)
      : cards
          .where(
            (card) =>
                languageCode == null ||
                card.languageScope.contains(languageCode),
          )
          .toList();
  final available =
      pool.where((card) => !excludedIds.contains(card.id)).toList();

  if (available.isEmpty) {
    return getRandomCard(cards, difficulties, languageCode);
  }

  final random = Random();
  return available[random.nextInt(available.length)];
}
