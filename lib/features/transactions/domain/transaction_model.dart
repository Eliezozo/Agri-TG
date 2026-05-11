import 'package:freezed_annotation/freezed_annotation.dart';

part 'transaction_model.freezed.dart';
part 'transaction_model.g.dart';

@freezed
class Transaction with _$Transaction {
  const factory Transaction({
    required String id,
    required String type,          // 'cotisation' | 'achat' | 'prime' | 'autre'
    required double amount,        // positif = entrée, négatif = sortie
    required String blockchainHash,
    required DateTime date,
    required String description,
    String? memberName,
    String? category,
  }) = _Transaction;

  factory Transaction.fromJson(Map<String, dynamic> json) =>
      _$TransactionFromJson(json);
}
