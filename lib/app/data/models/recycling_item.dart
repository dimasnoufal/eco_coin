import 'dart:typed_data';

class RecyclingItem {
  final int? id;
  final String categoryName;
  final String confidence;
  final Uint8List image;
  final String date;
  final int ecoPoints;

  RecyclingItem({
    this.id,
    required this.categoryName,
    required this.confidence,
    required this.image,
    required this.date,
    required this.ecoPoints,
  });

  Map<String, dynamic> toJson() {
    return {
      'categoryName': categoryName,
      'confidence': confidence,
      'image': image,
      'date': date,
      'ecoPoints': ecoPoints,
    };
  }

  factory RecyclingItem.fromJson(Map<String, dynamic> json) {
    return RecyclingItem(
      id: json['id'],
      categoryName: json['categoryName'],
      confidence: json['confidence'],
      image: json['image'],
      date: json['date'],
      ecoPoints: json['ecoPoints'],
    );
  }
}
