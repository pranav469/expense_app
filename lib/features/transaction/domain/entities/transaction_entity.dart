import 'package:equatable/equatable.dart';

class TransactionEntity extends Equatable {
  final String id;
  final double amount;
  final String note;
  final String type; // 'credit' | 'debit'
  final String categoryId;
  final String categoryName; // populated via SQL JOIN
  final DateTime timestamp;
  final bool isSynced;
  final bool isDeleted;

  const TransactionEntity({
    required this.id,
    required this.amount,
    required this.note,
    required this.type,
    required this.categoryId,
    required this.categoryName,
    required this.timestamp,
    this.isSynced = false,
    this.isDeleted = false,
  });

  TransactionEntity copyWith({
    String? id,
    double? amount,
    String? note,
    String? type,
    String? categoryId,
    String? categoryName,
    DateTime? timestamp,
    bool? isSynced,
    bool? isDeleted,
  }) {
    return TransactionEntity(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      note: note ?? this.note,
      type: type ?? this.type,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      timestamp: timestamp ?? this.timestamp,
      isSynced: isSynced ?? this.isSynced,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }

  bool get isCredit => type == 'credit';
  bool get isDebit => type == 'debit';

  @override
  List<Object?> get props =>
      [id, amount, note, type, categoryId, timestamp, isSynced, isDeleted];
}


// // features/transactions/domain/entities/transaction_entity.dart
// import 'package:equatable/equatable.dart';
//
// class TransactionEntity extends Equatable {
//   final String id;
//   final double amount;
//   final String note;
//   final String type;        // 'credit' | 'debit'
//   final String categoryId;
//   final String categoryName; // populated via SQL JOIN
//   final DateTime timestamp;
//   final bool isSynced;
//   final bool isDeleted;
//
//   const TransactionEntity({
//     required this.id,
//     required this.amount,
//     required this.note,
//     required this.type,
//     required this.categoryId,
//     required this.categoryName,
//     required this.timestamp,
//     this.isSynced = false,
//     this.isDeleted = false,
//   });
//
//   @override
//   List<Object?> get props => [id, amount, note, type, categoryId, isSynced, isDeleted];
// }