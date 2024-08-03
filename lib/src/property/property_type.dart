class Property {
  final String id;
  final String imageUrl;
  final String title;
  final String description;
  final int price;
  final int shares;
  final int investorsCount;
  final int sharesLeft;

  Property({
    required this.id,
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.price,
    required this.shares,
    required this.investorsCount,
    required this.sharesLeft,
  });

  factory Property.fromJson(Map<String, dynamic> json) {
    return Property(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      imageUrl: json['imageUrl'],
      price: json['price'],
      shares: json['shares'],
      investorsCount: json['investorsCount'],
      sharesLeft: json['sharesLeft']
    );
  }
}
