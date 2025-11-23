import 'dart:convert';

class InfoBuku {
  final String title;
  final String author;
  final String genre;
  final String synopsis;
  final String imagePath;
  final int biaya;
  bool tersedia;

  InfoBuku({
    required this.title,
    required this.author,
    required this.genre,
    required this.synopsis,
    required this.imagePath,
    required this.biaya,
    this.tersedia = true,
  });

  InfoBuku copyWith({
    String? title,
    String? author,
    String? genre,
    String? synopsis,
    String? imagePath,
    int? biaya,
    bool? tersedia,
  }) {
    return InfoBuku(
      title: title ?? this.title,
      author: author ?? this.author,
      genre: genre ?? this.genre,
      synopsis: synopsis ?? this.synopsis,
      imagePath: imagePath ?? this.imagePath,
      biaya: biaya ?? this.biaya,
      tersedia: tersedia ?? this.tersedia,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'author': author,
      'genre': genre,
      'synopsis': synopsis,
      'imagePath': imagePath,
      'biaya': biaya,
      'tersedia': tersedia,
    };
  }

  factory InfoBuku.fromMap(Map<String, dynamic> map) {
    return InfoBuku(
      title: map['title'] as String,
      author: map['author'] as String,
      genre: map['genre'] as String,
      synopsis: map['synopsis'] as String,
      imagePath: map['imagePath'] as String,
      biaya: map['biaya'] as int,
      tersedia: map['tersedia'] is bool ? map['tersedia'] : true,
    );
  }

  String toJson() => json.encode(toMap());

  factory InfoBuku.fromJson(String source) =>
      InfoBuku.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'InfoBuku(title: $title, author: $author, genre: $genre, synopsis: $synopsis, imagePath: $imagePath, biaya: $biaya, tersedia: $tersedia)';
  }

  @override
  bool operator ==(covariant InfoBuku other) {
    return other.title == title &&
        other.author == author &&
        other.genre == genre &&
        other.synopsis == synopsis &&
        other.imagePath == imagePath &&
        other.biaya == biaya &&
        other.tersedia == tersedia;
  }

  @override
  int get hashCode {
    return title.hashCode ^
        author.hashCode ^
        genre.hashCode ^
        synopsis.hashCode ^
        imagePath.hashCode ^
        biaya.hashCode ^
        tersedia.hashCode;
  }
}

// Dummy data for testing and development
List<InfoBuku> daftarBookmark = [];
List<InfoBuku> daftarPeminjaman = [];
List<Map<String, dynamic>> riwayatPeminjaman = [];

// Sample book data
final List<InfoBuku> daftarBuku = [
  InfoBuku(
    title: 'Bintang',
    author: 'Tere Liye',
    genre: 'Adventure, Romance, Fantasy, Action, Drama, Tragedy',
    synopsis:
        'Petualangan Raib, Seli, dan Ali di dunia paralel Klan Bintang...',
    imagePath: 'assets/Bintang.jpg',
    biaya: 4000,
  ),
  InfoBuku(
    title: 'Bulan',
    author: 'Tere Liye',
    genre: 'Adventure, Romance, Fantasy, Action, Drama, Tragedy',
    synopsis: 'Kelanjutan petualangan Raib, Seli, dan Ali di klan Matahari...',
    imagePath: 'assets/Bulan.jpg',
    biaya: 3000,
  ),
  InfoBuku(
    title: 'Bumi',
    author: 'Tere Liye',
    genre: 'Adventure, Romance, Fantasy, Action, Drama, Tragedy',
    synopsis:
        'Raib, Seli, dan Ali menjelajahi dunia paralel dan menghadapi Tamus...',
    imagePath: 'assets/Bumi.jpg',
    biaya: 2000,
  ),
  InfoBuku(
    title: 'Matahari',
    author: 'Tere Liye',
    genre: 'Adventure, Romance, Fantasy, Action, Drama, Tragedy',
    synopsis: 'Petualangan menuju Klan Bintang setelah kematian Ily...',
    imagePath: 'assets/Matahari.jpg',
    biaya: 4000,
  ),
  InfoBuku(
    title: 'Nebula',
    author: 'Tere Liye',
    genre: 'Adventure, Romance, Fantasy, Action, Drama, Tragedy',
    synopsis: 'Selena, Mata, dan Tazk di Akademi Bayangan Tingkat Tinggi...',
    imagePath: 'assets/Nebula.jpg',
    biaya: 4000,
  ),
  InfoBuku(
    title: 'Si Putih',
    author: 'Tere Liye',
    genre: 'Adventure, Romance, Fantasy, Action, Drama, Tragedy',
    synopsis: 'Petualangan tiga sahabat menuju Klan Nebula...',
    imagePath: 'assets/Si putih.jpg',
    biaya: 3000,
  ),
  InfoBuku(
    title: 'IPA',
    author: 'Tim Edukasi',
    genre: 'Pendidikan',
    synopsis: 'Buku pelajaran IPA lengkap dengan ilustrasi dan latihan soal.',
    imagePath: 'assets/ipa.jpg',
    biaya: 3000,
  ),
  InfoBuku(
    title: 'Matematika',
    author: 'Matematika Nasional',
    genre: 'Pendidikan',
    synopsis: 'Panduan belajar matematika dengan pendekatan visual.',
    imagePath: 'assets/matematika.jpg',
    biaya: 6000,
  ),
  InfoBuku(
    title: 'Seni Budaya',
    author: 'Tim Kreatif Nasional',
    genre: 'Pendidikan',
    synopsis:
        'Memahami seni rupa, musik, tari, dan teater dalam budaya Indonesia.',
    imagePath: 'assets/seni budaya.jpg',
    biaya: 7000,
  ),
  InfoBuku(
    title: 'Bahasa Indonesia',
    author: 'Pusat Bahasa',
    genre: 'Pendidikan',
    synopsis: 'Materi bahasa Indonesia untuk meningkatkan kemampuan berbahasa.',
    imagePath: 'assets/bahasa indo.jpg',
    biaya: 4000,
  ),
];
