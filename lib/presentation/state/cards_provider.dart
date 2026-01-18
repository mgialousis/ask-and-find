import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pes_vres/data/repositories/cards_repository.dart';
import 'package:pes_vres/domain/entities/card_item.dart';

final cardsProvider = FutureProvider<List<CardItem>>((ref) async {
  return loadCardsFromAssets();
});
