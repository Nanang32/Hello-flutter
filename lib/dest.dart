class Dest {
  final int? id;
  final String title;
  final String desc;
  final String locate;
  final String photo;

  Dest({
    this.id,
    required this.title,
    required this.desc,
    required this.locate,
    required this.photo,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'desc': desc,
      'locate': locate,
      'photo': photo,
    };
  }

  factory Dest.fromMap(Map<String, dynamic> map) {
    return Dest(
      id: map['id'],
      title: map['title'],
      desc: map['desc'],
      locate: map['locate'],
      photo: map['photo'],
    );
  }
}
