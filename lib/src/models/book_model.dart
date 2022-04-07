class BookModel {
  String? id;
  String? imgUrl;
  String? name;
  String? author;
  String? ownerId;
  String? retailType;
  String? price;
  String? review;
  String? view;
  String? ownerName;
  List? tags;
  String? description;

  BookModel({
    this.id,
    this.name,
    this.author,
    this.imgUrl,
    this.price,
    this.description,
    this.ownerId,
    this.retailType,
    this.ownerName,
    this.review,
    this.tags,
    this.view,
  });

  Map<String, dynamic> toJson() => {
        'imgUrl': imgUrl,
        'name': name,
        'author': author,
        'price': price,
        'ownerName': ownerName,
        'ownerId': ownerId,
        'description': description,
        'review': review,
        'retailType': retailType,
        'tags': tags,
        'view': view,
      };

  factory BookModel.fromJson(dynamic json) => BookModel(
        id: json.id,
        author: json['author'],
        description: json['description'],
        price: json['price'],
        review: json['review'],
        ownerId: json['ownerId'],
        ownerName: json['ownerName'],
        tags: json['tags'],
        view: json['view'],
        retailType: json['retailType'],
        imgUrl: json['imgUrl'],
        name: json['name'],
      );

  factory BookModel.fromMap(dynamic json) => BookModel(
        author: json['author'],
        description: json['description'],
        price: json['price'],
        review: json['review'],
        ownerId: json['ownerId'],
        ownerName: json['ownerName'],
        tags: json['tags'],
        view: json['view'],
        retailType: json['retailType'],
        imgUrl: json['imgUrl'],
        name: json['name'],
      );

  static List<BookModel> generateHeaderList() {
    return [
      BookModel(
        id: '1',
        name: "Do not be a jackals",
        author: "Shahab Shaker",
        description: "Let's not be jackals",
        review: "126",
        price: "4.7",
        view: "124470",
        tags: [
          "Academic",
          "To know",
          "Animals",
        ],
        imgUrl: "shoqal.png",
      ),
      BookModel(
        id: '1',
        name: "Succese",
        author: "Shahab Shaker",
        description:
            "Let's not be jackalsLet's not be jackalsLet's not be jLet's not be jackalsLet's not be jackalsLet's not be jackalsLet's not be jackalsLet's not be jaLet's not be jackalsLet's not be jackalsLet's not be jackalsLet's not be jackalsLet's not be jaLet's not be jackalsLet's not be jackalsLet's not be jackalsLet's not be jackalsLet's not be jaLet's not be jackalsLet's not be jackalsLet's not be jackalsLet's not be jackalsLet's not be jaLet's not be jackalsLet's not be jackalsLet's not be jackalsLet's not be jackalsLet's not be jaLet's not be jackalsLet's not be jackalsLet's not be jackalsLet's not be jackalsLet's not be jaLet's not be jackalsLet's not be jackalsLet's not be jackalsLet's not be jackalsLet's not be jaLet's not be jackalsLet's not be jackalsLet's not be jackalsLet's not be jackalsLet's not be jaackalsLet's not be jackalsLet's not be jackalsLet's not be jackalsLet's not be jackalsLet's not be jackalsLet's not be jackalsLet's not be jackalsLet's not be jackalsLet's not be jackalsLet's not be jackalsLet's not be jackalsLet's not be jackalsLet's not be jackalsLet's not be jackalsLet's not be jackalsLet's not be jackalsLet's not be jackalsLet's not be jackalsLet's not be jackalsLet's not be jackalsLet's not be jackalsLet's not be jackalsLet's not be jackalsLet's not be jackalsLet's not be jackalsLet's not be jackals",
        review: "126",
        price: "4.7",
        view: "124470",
        tags: [
          "Academic",
          "To know",
          "Animals",
        ],
        imgUrl: "download.png",
      ),
      BookModel(
        id: '1',
        name: "Be Happy",
        author: "Shahab Shaker",
        description: "Let's not be jackals",
        review: "126",
        price: "4.7",
        view: "124470",
        tags: [
          "Academic",
          "To know",
          "Animals",
        ],
        imgUrl: "download.jpg",
      ),
      BookModel(
        id: '1',
        name: "How can we not be jackals?",
        author: "Shahab Shaker",
        description: "Let's not be jackals",
        review: "126",
        price: "4.7",
        view: "124470",
        tags: [
          "Academic",
          "To know",
          "Animals",
        ],
        imgUrl: "shoqal.png",
      ),
    ];
  }

  static List<BookModel> generateCategoryList() {
    return [
      BookModel(
        id: '1',
        name: "Asar Morakab",
        author: "Daren Hardi",
        description: "Be Happy",
        review: "126",
        price: "4.7",
        view: "124470",
        tags: [
          "Academic",
          "To know",
          "Animals",
        ],
        imgUrl: "102878.jpg",
      ),
      BookModel(
        id: '1',
        name: "Nagofteha",
        author: "Sadra kafiri",
        description: "Be Happy",
        review: "126",
        price: "4.7",
        view: "124470",
        tags: [
          "Academic",
          "To know",
          "Animals",
        ],
        imgUrl: "115265.jpg",
      ),
      BookModel(
        id: '1',
        name: "Jahad",
        author: "Emam Ali",
        description: "Be Happy",
        review: "126",
        price: "4.7",
        view: "124470",
        tags: [
          "Academic",
          "To know",
          "Animals",
        ],
        imgUrl: "117659.jpg",
      ),
      BookModel(
        id: '1',
        name: "Ghorbagheh",
        author: "Daren Hardi",
        description: "Be Happy",
        review: "126",
        price: "4.7",
        view: "124470",
        tags: [
          "Academic",
          "To know",
          "Animals",
        ],
        imgUrl: "61038.jpg",
      ),
      BookModel(
        id: '1',
        name: "Asar Morakab",
        author: "Daren Hardi",
        description: "Be Happy",
        review: "126",
        price: "4.7",
        view: "124470",
        tags: [
          "Academic",
          "To know",
          "Animals",
        ],
        imgUrl: "81647.jpg",
      ),
    ];
  }

  static List<BookModel> generateItemsList() {
    return [
      BookModel(
        id: '1',
        name: "Asar Morakab",
        author: "Daren Hardi",
        description: "Be Happy",
        review: "126",
        price: "4.7",
        view: "124470",
        tags: [
          "Academic",
          "To know",
          "Animals",
        ],
        imgUrl: "117659.jpg",
      ),
      BookModel(
        id: '1',
        name: "Asar Morakab",
        author: "Daren Hardi",
        description: "Be Happy",
        review: "126",
        price: "4.7",
        view: "124470",
        tags: [
          "Academic",
          "To know",
          "Animals",
        ],
        imgUrl: "115265.jpg",
      ),
      BookModel(
        id: '1',
        name: "Asar Morakab",
        author: "Daren Hardi",
        description: "Be Happy",
        review: "126",
        price: "4.7",
        view: "124470",
        tags: [
          "Academic",
          "To know",
          "Animals",
        ],
        imgUrl: "102878.jpg",
      ),
      BookModel(
        id: '1',
        name: "Asar Morakab",
        author: "Daren Hardi",
        description: "Be Happy",
        review: "126",
        price: "4.7",
        view: "124470",
        tags: [
          "Academic",
          "To know",
          "Animals",
        ],
        imgUrl: "61038.jpg",
      ),
      BookModel(
        id: '1',
        name: "Asar Morakab",
        author: "Daren Hardi",
        description: "Be Happy",
        review: "126",
        price: "4.7",
        view: "124470",
        tags: [
          "Academic",
          "To know",
          "Animals",
        ],
        imgUrl: "81647.jpg",
      ),
    ];
  }
}
