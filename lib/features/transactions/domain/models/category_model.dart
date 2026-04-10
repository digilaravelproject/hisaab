class CategoryModel {
  final int id;
  final String name;
  final String type;
  final String icon;
  final bool isCustom;

  CategoryModel({
    required this.id,
    required this.name,
    required this.type,
    required this.icon,
    required this.isCustom,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      type: json['type'] ?? 'expense',
      icon: json['icon'] ?? '',
      isCustom: json['is_custom'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'icon': icon,
      'is_custom': isCustom,
    };
  }
}
