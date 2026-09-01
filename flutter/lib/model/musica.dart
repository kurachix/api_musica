class Musica {
  final int? id;
  final String titulo;
  final String artista;
  final String album;
  final int ano;

  Musica({
    this.id,
    required this.titulo,
    required this.artista,
    required this.album,
    required this.ano,
  });

  factory Musica.fromJson(Map<String, dynamic> json) {
    return Musica(
      id: json['id'] as int?,
      titulo: json['titulo'] as String,
      artista: json['artista'] as String,
      album: json['album'] as String,
      ano: json['ano'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'titulo': titulo,
      'artista': artista,
      'album': album,
      'ano': ano,
    };
  }

  Musica copyWith({
    int? id,
    String? titulo,
    String? artista,
    String? album,
    int? ano,
  }) {
    return Musica(
      id: id ?? this.id,
      titulo: titulo ?? this.titulo,
      artista: artista ?? this.artista,
      album: album ?? this.album,
      ano: ano ?? this.ano,
    );
  }

  @override
  String toString() {
    return 'Musica(id: $id, titulo: $titulo, artista: $artista, album: $album, ano: $ano)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Musica &&
        other.id == id &&
        other.titulo == titulo &&
        other.artista == artista &&
        other.album == album &&
        other.ano == ano;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        titulo.hashCode ^
        artista.hashCode ^
        album.hashCode ^
        ano.hashCode;
  }
}
