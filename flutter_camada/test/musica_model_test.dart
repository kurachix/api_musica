import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_camada/models/musica_model.dart';

void main() {
  group('Testes do Modelo Musica', () {
    test('Deve criar uma instância de Musica corretamente', () {
      final musica = Musica(
        id: 1,
        titulo: 'Evidências',
        artista: 'Chitãozinho & Xororó',
        album: 'Cowboy do Asfalto',
        ano: 1990,
      );

      expect(musica.id, 1);
      expect(musica.titulo, 'Evidências');
      expect(musica.artista, 'Chitãozinho & Xororó');
      expect(musica.album, 'Cowboy do Asfalto');
      expect(musica.ano, 1990);
    });

    test('Deve converter de Map/JSON (fromJson) para objeto Musica', () {
      final json = {
        'id': 2,
        'titulo': 'Tempo Perdido',
        'artista': 'Legião Urbana',
        'album': 'Dois',
        'ano': 1986,
      };

      final musica = Musica.fromJson(json);

      expect(musica.id, 2);
      expect(musica.titulo, 'Tempo Perdido');
      expect(musica.artista, 'Legião Urbana');
      expect(musica.album, 'Dois');
      expect(musica.ano, 1986);
    });

    test('Deve converter objeto Musica para Map/JSON (toJson)', () {
      final musica = Musica(
        id: 3,
        titulo: 'Águas de Março',
        artista: 'Elis Regina e Tom Jobim',
        album: 'Elis & Tom',
        ano: 1974,
      );

      final json = musica.toJson();

      expect(json['id'], 3);
      expect(json['titulo'], 'Águas de Março');
      expect(json['artista'], 'Elis Regina e Tom Jobim');
      expect(json['album'], 'Elis & Tom');
      expect(json['ano'], 1974);
    });

    test('Deve suportar campos opcionais nulos no fromJson e toJson', () {
      final jsonSemOpcionais = {
        'titulo': 'Música Simples',
        'artista': 'Artista Desconhecido',
      };

      final musica = Musica.fromJson(jsonSemOpcionais);

      expect(musica.id, isNull);
      expect(musica.titulo, 'Música Simples');
      expect(musica.artista, 'Artista Desconhecido');
      expect(musica.album, isNull);
      expect(musica.ano, isNull);

      final jsonGerado = musica.toJson();
      expect(jsonGerado.containsKey('id'), isFalse);
      expect(jsonGerado.containsKey('album'), isFalse);
      expect(jsonGerado.containsKey('ano'), isFalse);
    });

    test('Deve clonar objeto corretamente usando copyWith', () {
      final original = Musica(
        id: 1,
        titulo: 'Título Original',
        artista: 'Artista Original',
      );

      final modificado = original.copyWith(titulo: 'Novo Título');

      expect(modificado.id, 1);
      expect(modificado.titulo, 'Novo Título');
      expect(modificado.artista, 'Artista Original');
    });
  });
}
