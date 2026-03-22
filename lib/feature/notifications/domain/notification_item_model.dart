class NotificationItemModel {
  const NotificationItemModel({
    required this.id,
    required this.title,
    required this.message,
    required this.priority,
    required this.type,
    required this.createdAt,
  });

  final String id;
  final String title;
  final String message;
  final String priority;
  final String type;
  final DateTime createdAt;
}
