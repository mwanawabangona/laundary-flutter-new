import 'package:laundry_customer/models/carde_save_model/carde_save_model.dart';
import 'package:laundry_customer/models/saved_cards_model/saved_cards_model.dart';
import 'package:laundry_customer/notfiers/cards_notifier.dart';
import 'package:laundry_customer/repos/cards_repo.dart';
import 'package:laundry_customer/services/api_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final cardsRepoProvider = Provider<ICardsRepo>((ref) {
  return CardsRepo();
});
//
//
//
final allCardsProvider =
    StateNotifierProvider<AllCardsNotfier, ApiState<SavedCardsModel>>((ref) {
  return AllCardsNotfier(ref.watch(cardsRepoProvider));
});
//
//
//
final cardSaveProvider =
    StateNotifierProvider<SaveCardNotfier, ApiState<CardeSaveModel>>((ref) {
  return SaveCardNotfier(ref.watch(cardsRepoProvider));
});
