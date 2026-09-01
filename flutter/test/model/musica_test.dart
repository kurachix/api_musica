import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_musica/model/musica.dart';

void main() {
  group('Testes do Modelo Música', () {
    test('Conversão a partir de JSON (fromJson)', () {
      final mapaJson = {
        'id': 1,
        'titulo': 'Numb',
        'artista': 'Linkin Park',
        'album': 'Meteora',
        'ano': 2003,
      };

      final musica = Musica.fromJson(mapaJson);

      expect(musica.id, 1);
      expect(musica.titulo, 'Numb');
      expect(musica.artista, 'Linkin Park');
      expect(musica.album, 'Meteora');
      expect(musica.ano, 2003);
    });

    test('Conversão para JSON (toJson)', () {
      final musica = Musica(
        id: 1,
        titulo: 'Numb',
        artista: 'Linkin Park',
        album: 'Meteora',
        ano: 2003,
      );

      final mapaJson = musica.toJson();

      expect(mapaJson['id'], 1);
      expect(mapaJson['titulo'], 'Numb');
      expect(mapaJson['artista'], 'Linkin Park');
      expect(mapaJson['album'], 'Meteora');
      expect(mapaJson['ano'], 2003);
    });

    test('Consistência do ciclo JSON -> Música -> JSON', () {
      final mapaOriginal = {
        'id': 2,
        'titulo': 'Evidências',
        'artista': 'Chitãozinho & Xororó',
        'album': 'Cowboy do Asfalto',
        'ano': 1990,
      };

      final musica = Musica.fromJson(mapaOriginal);
      final mapaFinal = musica.toJson();

      expect(mapaFinal, equals(mapaOriginal));
      expect(mapaFinal['id'], mapaOriginal['id']);
      expect(mapaFinal['titulo'], mapaOriginal['titulo']);
      expect(mapaFinal['artista'], mapaOriginal['artista']);
      expect(mapaFinal['album'], mapaOriginal['album']);
      expect(mapaFinal['ano'], mapaOriginal['ano']);
    });
  });
}
