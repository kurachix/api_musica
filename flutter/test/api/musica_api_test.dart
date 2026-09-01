import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:flutter_musica/model/musica.dart';
import 'package:flutter_musica/api/musica_api.dart';

class MusicaApiSimulada extends MusicaApi {
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
    final decodificador = (dados) {
      if (dados is List) {
        return dados
            .map((item) => Musica.fromJson(item as Map<String, dynamic>))
            .toList();
      }
      return <Musica>[];
    };
    final listaDecodificada = decodificador(banco);
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
        statusText: 'Não Encontrado',
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
        statusText: 'Dados Inválidos',
      );
    }
    final novoRegistro = {
      'id': proximoId++,
      'titulo': musica.titulo,
      'artista': musica.artista,
      'album': musica.album,
      'ano': musica.ano,
    };
    banco.add(novoRegistro);
    return Response<Musica>(
      statusCode: 201,
      body: Musica.fromJson(novoRegistro),
    );
  }

  @override
  Future<Response<Musica>> atualizar(int id, Musica musica) async {
    final indice = banco.indexWhere((m) => m['id'] == id);
    if (indice == -1) {
      return const Response<Musica>(
        statusCode: 404,
        statusText: 'Não Encontrado',
      );
    }
    final registroAtualizado = {
      'id': id,
      'titulo': musica.titulo,
      'artista': musica.artista,
      'album': musica.album,
      'ano': musica.ano,
    };
    banco[indice] = registroAtualizado;
    return Response<Musica>(
      statusCode: 200,
      body: Musica.fromJson(registroAtualizado),
    );
  }

  @override
  Future<Response> excluir(int id) async {
    final indice = banco.indexWhere((m) => m['id'] == id);
    if (indice == -1) {
      return const Response(
        statusCode: 404,
        statusText: 'Não Encontrado',
      );
    }
    banco.removeAt(indice);
    return const Response(
      statusCode: 204,
    );
  }
}

void main() {
  group('Testes da Camada de API (MusicaApi com GetConnect)', () {
    late MusicaApiSimulada api;

    setUp(() {
      api = MusicaApiSimulada();
    });

    test('Listar todas as músicas (GET /musicas)', () async {
      final resposta = await api.listar();

      expect(resposta.statusCode, 200);
      expect(resposta.body, isA<List<Musica>>());
      expect(resposta.body!.length, 5);
      expect(resposta.body!.first, isA<Musica>());
      expect(resposta.body!.first.titulo, 'Numb');
    });

    test('Buscar música por ID com sucesso (GET /musicas/{id})', () async {
      final resposta = await api.buscarPorId(1);

      expect(resposta.statusCode, 200);
      expect(resposta.body, isA<Musica>());
      expect(resposta.body!.id, 1);
      expect(resposta.body!.titulo, 'Numb');
    });

    test('Buscar música por ID inexistente (GET /musicas/999)', () async {
      final resposta = await api.buscarPorId(999);

      expect(resposta.statusCode, 404);
      expect(resposta.body, isNull);
    });

    test('Cadastrar nova música com sucesso (POST /musicas)', () async {
      final novaMusica = Musica(
        titulo: 'Cheia de Manias',
        artista: 'Raça Negra',
        album: 'Raça Negra',
        ano: 1992,
      );

      final resposta = await api.cadastrar(novaMusica);

      expect(resposta.statusCode, 201);
      expect(resposta.body, isA<Musica>());
      expect(resposta.body!.id, isNotNull);
      expect(resposta.body!.titulo, 'Cheia de Manias');
      expect(resposta.body!.artista, 'Raça Negra');
      expect(resposta.body!.album, 'Raça Negra');
      expect(resposta.body!.ano, 1992);
    });

    test('Atualizar música existente (PUT /musicas/{id})', () async {
      final musicaAtualizada = Musica(
        titulo: 'Tempo Perdido (Ao Vivo)',
        artista: 'Legião Urbana',
        album: 'Dois',
        ano: 1986,
      );

      final resposta = await api.atualizar(3, musicaAtualizada);

      expect(resposta.statusCode, 200);
      expect(resposta.body, isA<Musica>());
      expect(resposta.body!.id, 3);
      expect(resposta.body!.titulo, 'Tempo Perdido (Ao Vivo)');
    });

    test('Excluir música existente (DELETE /musicas/{id})', () async {
      final respostaExclusao = await api.excluir(1);

      expect(respostaExclusao.statusCode == 200 || respostaExclusao.statusCode == 204, isTrue);

      final respostaConsulta = await api.buscarPorId(1);
      expect(respostaConsulta.statusCode, 404);
    });

    test('Erro ao excluir música inexistente', () async {
      final resposta = await api.excluir(999);

      expect(resposta.statusCode, 404);
    });

    test('Erro ao cadastrar música com dados inválidos', () async {
      final musicaInvalida = Musica(
        titulo: '',
        artista: '',
        album: '',
        ano: 0,
      );

      final resposta = await api.cadastrar(musicaInvalida);

      expect(resposta.statusCode, 422);
    });
  });
}
