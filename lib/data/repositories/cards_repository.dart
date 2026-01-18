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

List<CardItem> getCardsByDifficulty(
  List<CardItem> cards,
  Difficulty difficulty,
) {
  if (difficulty == Difficulty.mixed) {
    return cards;
  }
  return cards.where((card) => card.difficulty == difficulty).toList();
}

CardItem getRandomCard(
  List<CardItem> cards, [
  Difficulty? difficulty,
]) {
  final pool =
      difficulty != null ? getCardsByDifficulty(cards, difficulty) : cards;
  if (pool.isEmpty) {
    throw StateError('No cards available for difficulty: $difficulty');
  }
  final random = Random();
  return pool[random.nextInt(pool.length)];
}

CardItem getRandomCardExcluding(
  List<CardItem> cards,
  Set<String> excludedIds, [
  Difficulty? difficulty,
]) {
  final pool =
      difficulty != null ? getCardsByDifficulty(cards, difficulty) : cards;
  final available =
      pool.where((card) => !excludedIds.contains(card.id)).toList();

  if (available.isEmpty) {
    return getRandomCard(cards, difficulty);
  }

  final random = Random();
  return available[random.nextInt(available.length)];
}
