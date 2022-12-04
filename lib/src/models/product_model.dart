class Product {
  int id;
  String name;
  String date;

  Product(
    this.id,
    this.name,
    this.date,
  );

  Product.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        date = json['date'];

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'name': name,
        'date': date,
      };
}
