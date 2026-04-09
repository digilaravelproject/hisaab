class StaticPageModel {
  final int id;
  final String slug;
  final String title;
  final String content;
  final bool isActive;
  final int sortOrder;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  StaticPageModel({
    required this.id,
    required this.slug,
    required this.title,
    required this.content,
    this.isActive = true,
    this.sortOrder = 1,
    this.createdAt,
    this.updatedAt,
  });

  factory StaticPageModel.fromJson(Map<String, dynamic> json) {
    return StaticPageModel(
      id: json['id'] != null ? int.parse(json['id'].toString()) : 0,
      slug: json['slug'] ?? '',
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      isActive: json['is_active'] == true || json['is_active'] == 1,
      sortOrder: json['sort_order'] != null ? int.parse(json['sort_order'].toString()) : 1,
      createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.tryParse(json['updated_at']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'slug': slug,
        'title': title,
        'content': content,
        'is_active': isActive,
        'sort_order': sortOrder,
        'created_at': createdAt?.toIso8601String(),
        'updated_at': updatedAt?.toIso8601String(),
      };
}
