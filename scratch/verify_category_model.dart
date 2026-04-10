import 'dart:convert';
import '../lib/features/transactions/domain/models/category_model.dart';

void main() {
  final jsonString = '''{
    "status": true,
    "message": "Categories fetched.",
    "data": [
        {
            "id": 2,
            "name": "Business",
            "type": "income",
            "icon": "business-icon.png",
            "is_custom": false
        },
        {
            "id": 3,
            "name": "Food",
            "type": "expense",
            "icon": "food-icon.png",
            "is_custom": false
        }
    ]
  }''';

  final jsonMap = json.decode(jsonString);
  final List<dynamic> data = jsonMap['data'];
  
  final categories = data.map((item) => CategoryModel.fromJson(item)).toList();
  
  print('Total categories parsed: ${categories.length}');
  for (var cat in categories) {
    print('Category: ${cat.name}, Type: ${cat.type}, Icon: ${cat.icon}');
  }
}
