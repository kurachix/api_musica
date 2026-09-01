import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_musica/model/musica.dart';

void main() {
  group('Testes do Model Musica', () {
    test('Teste fromJson', () {
      final json = {
        'id': 1,
        'titulo': 'Numb',
        'artista': 'Linkin Park',
        'album': 'Meteora',
        'ano': 2003,
      };

      final musica = Musica.fromJson(json);

      expect(musica.id, 1);
      expect(musica.titulo, 'Numb');
      expect(musica.artista, 'Linkin Park');
      expect(musica.album, 'Meteora');
      expect(musica.ano, 2003);
    });

    test('Teste toJson', () {
      final musica = Musica(
        id: 1,
        titulo: 'Numb',
        artista: 'Linkin Park',
        album: 'Meteora',
        ano: 2003,
      );

      final json = musica.toJson();

      expect(json['id'], 1);
      expect(json['titulo'], 'Numb');
      expect(json['artista'], 'Linkin Park');
      expect(json['album'], 'Meteora');
      expect(json['ano'], 2003);
    });

    test('Teste de conversão JSON -> Musica -> JSON', () {
      final jsonOriginal = {
        'id': 2,
        'titulo': 'Evidências',
        'artista': 'Chitãozinho & Xororó',
        'album': 'Cowboy do Asfalto',
        'ano': 1990,
      };

      final musica = Musica.fromJson(jsonOriginal);
      final jsonFinal = musica.toJson();

      expect(jsonFinal, equals(jsonOriginal));
      expect(jsonFinal['id'], jsonOriginal['id']);
      expect(jsonFinal['titulo'], jsonOriginal['titulo']);
      expect(jsonFinal['artista'], jsonOriginal['artista']);
      expect(jsonFinal['album'], jsonOriginal['album']);
      expect(jsonFinal['ano'], jsonOriginal['ano']);
    });
  });
}
