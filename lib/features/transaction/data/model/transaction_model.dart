import '../../domain/entities/transaction_entity.dart';

class TransactionModel extends TransactionEntity {
  const TransactionModel({
    required super.id,
    required super.amount,
    required super.note,
    required super.type,
    required super.categoryId,
    required super.categoryName,
    required super.timestamp,
    super.isSynced,
    super.isDeleted,
  });

  /// From SQL JOIN result (includes category_name alias)
  factory TransactionModel.fromJoinMap(Map<String, dynamic> map) =>
      TransactionModel(
        id: map['id'] as String,
        amount: (map['amount'] as num).toDouble(),
        note: map['note'] as String? ?? '',
        type: map['type'] as String,
        categoryId: map['category_id'] as String,
        categoryName: map['category_name'] as String? ?? '',
        timestamp: DateTime.parse(map['timestamp'] as String),
        isSynced: (map['is_synced'] as int) == 1,
        isDeleted: (map['is_deleted'] as int) == 1,
      );

  factory TransactionModel.fromEntity(TransactionEntity e) => TransactionModel(
    id: e.id,
    amount: e.amount,
    note: e.note,
    type: e.type,
    categoryId: e.categoryId,
    categoryName: e.categoryName,
    timestamp: e.timestamp,
    isSynced: e.isSynced,
    isDeleted: e.isDeleted,
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'amount': amount,
    'note': note,
    'type': type,
    'category_id': categoryId,
    'timestamp': timestamp.toIso8601String(),
    'is_synced': isSynced ? 1 : 0,
    'is_deleted': isDeleted ? 1 : 0,
  };

  Map<String, dynamic> toSyncJson() => {
    'id': id,
    'amount': amount,
    'note': note,
    'type': type,
    'category_id': categoryId,
    'timestamp':
    '${timestamp.year}-${_pad(timestamp.month)}-${_pad(timestamp.day)} '
        '${_pad(timestamp.hour)}:${_pad(timestamp.minute)}:${_pad(timestamp.second)}',
  };

  String _pad(int v) => v.toString().padLeft(2, '0');
}