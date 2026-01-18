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
  Set<Difficulty> difficulties,
) {
  return cards.where((card) => difficulties.contains(card.difficulty)).toList();
}

CardItem getRandomCard(
  List<CardItem> cards, [
  Set<Difficulty>? difficulties,
]) {
  final pool =
      difficulties != null ? getCardsByDifficulties(cards, difficulties) : cards;
  if (pool.isEmpty) {
    throw StateError('No cards available for difficulties: $difficulties');
  }
  final random = Random();
  return pool[random.nextInt(pool.length)];
}

CardItem getRandomCardExcluding(
  List<CardItem> cards,
  Set<String> excludedIds, [
  Set<Difficulty>? difficulties,
]) {
  final pool =
      difficulties != null ? getCardsByDifficulties(cards, difficulties) : cards;
  final available =
      pool.where((card) => !excludedIds.contains(card.id)).toList();

  if (available.isEmpty) {
    return getRandomCard(cards, difficulties);
  }

  final random = Random();
  return available[random.nextInt(available.length)];
}
