import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:flutter_musica/model/musica.dart';
import 'package:flutter_musica/api/musica_api.dart';

class MusicaApiMock extends MusicaApi {
  List<Map<String, dynamic>> banco = [
    {
      'id': 1,
      'titulo': 'Numb',
      'artista': 'Linkin Park',
      'album': 'Meteora',
      'ano': 2003,
    },
    {
      'id': 2,
      'titulo': 'Evidências',
      'artista': 'Chitãozinho & Xororó',
      'album': 'Cowboy do Asfalto',
      'ano': 1990,
    },
    {
      'id': 3,
      'titulo': 'Tempo Perdido',
      'artista': 'Legião Urbana',
      'album': 'Dois',
      'ano': 1986,
    },
    {
      'id': 4,
      'titulo': 'Bohemian Rhapsody',
      'artista': 'Queen',
      'album': 'A Night at the Opera',
      'ano': 1975,
    },
    {
      'id': 5,
      'titulo': 'Águas de Março',
      'artista': 'Elis Regina e Tom Jobim',
      'album': 'Elis & Tom',
      'ano': 1974,
    },
  ];
  int proximoId = 6;

  @override
  Future<Response<List<Musica>>> listar() async {
    final decoder = (dados) {
      if (dados is List) {
        return dados
            .map((item) => Musica.fromJson(item as Map<String, dynamic>))
            .toList();
      }
      return <Musica>[];
    };
    final listaDecodificada = decoder(banco);
    return Response<List<Musica>>(
      statusCode: 200,
      body: listaDecodificada,
    );
  }

  @override
  Future<Response<Musica>> buscarPorId(int id) async {
    final item = banco.firstWhereOrNull((m) => m['id'] == id);
    if (item == null) {
      return const Response<Musica>(
        statusCode: 404,
        statusText: 'Not Found',
      );
    }
    return Response<Musica>(
      statusCode: 200,
      body: Musica.fromJson(item),
    );
  }

  @override
  Future<Response<Musica>> cadastrar(Musica musica) async {
    if (musica.titulo.isEmpty || musica.artista.isEmpty || musica.album.isEmpty || musica.ano <= 0) {
      return const Response<Musica>(
        statusCode: 422,
        statusText: 'Unprocessable Entity',
      );
    }
    final novoMap = {
      'id': proximoId++,
      'titulo': musica.titulo,
      'artista': musica.artista,
      'album': musica.album,
      'ano': musica.ano,
    };
    banco.add(novoMap);
    return Response<Musica>(
      statusCode: 201,
      body: Musica.fromJson(novoMap),
    );
  }

  @override
  Future<Response<Musica>> atualizar(int id, Musica musica) async {
    final index = banco.indexWhere((m) => m['id'] == id);
    if (index == -1) {
      return const Response<Musica>(
        statusCode: 404,
        statusText: 'Not Found',
      );
    }
    final atualizado = {
      'id': id,
      'titulo': musica.titulo,
      'artista': musica.artista,
      'album': musica.album,
      'ano': musica.ano,
    };
    banco[index] = atualizado;
    return Response<Musica>(
      statusCode: 200,
      body: Musica.fromJson(atualizado),
    );
  }

  @override
  Future<Response> excluir(int id) async {
    final index = banco.indexWhere((m) => m['id'] == id);
    if (index == -1) {
      return const Response(
        statusCode: 404,
        statusText: 'Not Found',
      );
    }
    banco.removeAt(index);
    return const Response(
      statusCode: 204,
    );
  }
}

void main() {
  group('Testes da Camada MusicaApi (GetConnect)', () {
    late MusicaApiMock api;

    setUp(() {
      api = MusicaApiMock();
    });

    test('Listar músicas - GET /musicas', () async {
      final response = await api.listar();

      expect(response.statusCode, 200);
      expect(response.body, isA<List<Musica>>());
      expect(response.body!.length, 5);
      expect(response.body!.first, isA<Musica>());
      expect(response.body!.first.titulo, 'Numb');
    });

    test('Buscar música por ID com sucesso - GET /musicas/{id}', () async {
      final response = await api.buscarPorId(1);

      expect(response.statusCode, 200);
      expect(response.body, isA<Musica>());
      expect(response.body!.id, 1);
      expect(response.body!.titulo, 'Numb');
    });

    test('Buscar música por ID inexistente - GET /musicas/999', () async {
      final response = await api.buscarPorId(999);

      expect(response.statusCode, 404);
      expect(response.body, isNull);
    });

    test('Cadastrar nova música - POST /musicas', () async {
      final novaMusica = Musica(
        titulo: 'In the End',
        artista: 'Linkin Park',
        album: 'Hybrid Theory',
        ano: 2000,
      );

      final response = await api.cadastrar(novaMusica);

      expect(response.statusCode, 201);
      expect(response.body, isA<Musica>());
      expect(response.body!.id, isNotNull);
      expect(response.body!.titulo, 'In the End');
      expect(response.body!.artista, 'Linkin Park');
      expect(response.body!.album, 'Hybrid Theory');
      expect(response.body!.ano, 2000);
    });

    test('Atualizar música existente - PUT /musicas/{id}', () async {
      final musicaExistente = Musica(
        titulo: 'Tempo Perdido (Remaster)',
        artista: 'Legião Urbana',
        album: 'Dois',
        ano: 1986,
      );

      final response = await api.atualizar(3, musicaExistente);

      expect(response.statusCode, 200);
      expect(response.body, isA<Musica>());
      expect(response.body!.id, 3);
      expect(response.body!.titulo, 'Tempo Perdido (Remaster)');
    });

    test('Excluir música existente - DELETE /musicas/{id}', () async {
      final responseExcluir = await api.excluir(1);

      expect(responseExcluir.statusCode == 200 || responseExcluir.statusCode == 204, isTrue);

      final responseConsulta = await api.buscarPorId(1);
      expect(responseConsulta.statusCode, 404);
    });

    test('Erro ao excluir música inexistente', () async {
      final response = await api.excluir(999);

      expect(response.statusCode, 404);
    });

    test('Erro ao cadastrar com dados inválidos', () async {
      final musicaInvalida = Musica(
        titulo: '',
        artista: '',
        album: '',
        ano: 0,
      );

      final response = await api.cadastrar(musicaInvalida);

      expect(response.statusCode, 422);
    });
  });
}
