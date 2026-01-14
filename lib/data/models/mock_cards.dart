import 'package:pes_vres/domain/entities/card_item.dart';
import 'package:pes_vres/domain/entities/difficulty.dart';

/// Mock card data for development and testing
/// In production, this will be replaced with JSON assets or database
final List<CardItem> mockCards = [
  // Easy difficulty cards
  const CardItem(
    id: '1',
    promptEn: 'Name countries in Europe',
    answersEn: [
      'France',
      'Germany',
      'Italy',
      'Spain',
      'Poland',
      'Netherlands',
      'Belgium',
      'Greece',
      'Portugal',
      'Sweden',
      'Norway',
      'Denmark',
      'Finland',
    ],
    difficulty: Difficulty.easy,
    source: 'Source: General geographic knowledge',
  ),
  const CardItem(
    id: '2',
    promptEn: 'Name popular fruit varieties',
    answersEn: [
      'Apple',
      'Banana',
      'Orange',
      'Grape',
      'Strawberry',
      'Pineapple',
      'Watermelon',
      'Mango',
      'Peach',
      'Pear',
      'Cherry',
      'Blueberry',
    ],
    difficulty: Difficulty.easy,
    source: 'Source: Common fruits',
  ),
  const CardItem(
    id: '3',
    promptEn: 'Name colors of the rainbow',
    answersEn: [
      'Red',
      'Orange',
      'Yellow',
      'Green',
      'Blue',
      'Indigo',
      'Violet',
      'Purple',
      'Pink',
      'Cyan',
    ],
    difficulty: Difficulty.easy,
    source: 'Source: Light spectrum',
  ),

  // Medium difficulty cards
  const CardItem(
    id: '4',
    promptEn: 'Name planets in the solar system',
    answersEn: [
      'Mercury',
      'Venus',
      'Earth',
      'Mars',
      'Jupiter',
      'Saturn',
      'Uranus',
      'Neptune',
      'Pluto',
      'Ceres',
    ],
    difficulty: Difficulty.medium,
    source: 'Source: NASA Solar System',
  ),
  const CardItem(
    id: '5',
    promptEn: 'Name capital cities in Asia',
    answersEn: [
      'Tokyo',
      'Beijing',
      'Seoul',
      'Bangkok',
      'Singapore',
      'New Delhi',
      'Manila',
      'Jakarta',
      'Kuala Lumpur',
      'Hanoi',
      'Taipei',
      'Dhaka',
    ],
    difficulty: Difficulty.medium,
    source: 'Source: World capitals',
  ),
  const CardItem(
    id: '6',
    promptEn: 'Name popular programming languages',
    answersEn: [
      'Python',
      'JavaScript',
      'Java',
      'C++',
      'TypeScript',
      'Go',
      'Rust',
      'Swift',
      'Kotlin',
      'Ruby',
      'PHP',
      'C#',
    ],
    difficulty: Difficulty.medium,
    source: 'Source: TIOBE Index',
  ),

  // Hard difficulty cards
  const CardItem(
    id: '7',
    promptEn: 'Name Shakespeare plays',
    answersEn: [
      'Hamlet',
      'Macbeth',
      'Romeo and Juliet',
      'Othello',
      'King Lear',
      'The Tempest',
      'A Midsummer Night\'s Dream',
      'Julius Caesar',
      'Twelfth Night',
      'Much Ado About Nothing',
      'As You Like It',
      'The Merchant of Venice',
    ],
    difficulty: Difficulty.hard,
    source: 'Source: Complete Works of William Shakespeare',
  ),
  const CardItem(
    id: '8',
    promptEn: 'Name chemical elements with atomic numbers 1-15',
    answersEn: [
      'Hydrogen',
      'Helium',
      'Lithium',
      'Beryllium',
      'Boron',
      'Carbon',
      'Nitrogen',
      'Oxygen',
      'Fluorine',
      'Neon',
      'Sodium',
      'Magnesium',
      'Aluminum',
      'Silicon',
      'Phosphorus',
    ],
    difficulty: Difficulty.hard,
    source: 'Source: Periodic Table',
  ),
  const CardItem(
    id: '9',
    promptEn: 'Name US state capitals',
    answersEn: [
      'Montgomery',
      'Juneau',
      'Phoenix',
      'Little Rock',
      'Sacramento',
      'Denver',
      'Hartford',
      'Dover',
      'Tallahassee',
      'Atlanta',
      'Honolulu',
      'Boise',
    ],
    difficulty: Difficulty.hard,
    source: 'Source: US Geography',
  ),
  const CardItem(
    id: '10',
    promptEn: 'Name Olympic sports',
    answersEn: [
      'Athletics',
      'Swimming',
      'Gymnastics',
      'Basketball',
      'Football',
      'Tennis',
      'Boxing',
      'Cycling',
      'Volleyball',
      'Wrestling',
      'Judo',
      'Archery',
      'Fencing',
    ],
    difficulty: Difficulty.medium,
    source: 'Source: International Olympic Committee',
  ),
];

/// Get cards by difficulty level
List<CardItem> getCardsByDifficulty(Difficulty difficulty) {
  if (difficulty == Difficulty.mixed) {
    return mockCards;
  }
  return mockCards.where((card) => card.difficulty == difficulty).toList();
}

/// Get a random card from the list
CardItem getRandomCard([Difficulty? difficulty]) {
  final cards = difficulty != null ? getCardsByDifficulty(difficulty) : mockCards;
  if (cards.isEmpty) {
    throw StateError('No cards available for difficulty: $difficulty');
  }
  cards.shuffle();
  return cards.first;
}

/// Get a random card avoiding specific IDs
CardItem getRandomCardExcluding(Set<String> excludedIds, [Difficulty? difficulty]) {
  final cards = difficulty != null ? getCardsByDifficulty(difficulty) : mockCards;
  final availableCards = cards.where((card) => !excludedIds.contains(card.id)).toList();

  if (availableCards.isEmpty) {
    // If all cards have been used, reset and allow repeats
    return getRandomCard(difficulty);
  }

  availableCards.shuffle();
  return availableCards.first;
}
