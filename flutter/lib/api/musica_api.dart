import 'package:get/get.dart';
import '../model/musica.dart';

class MusicaApi extends GetConnect {
  final String urlBase;

  MusicaApi({this.urlBase = 'http://127.0.0.1:8000'}) {
    httpClient.baseUrl = urlBase;
    httpClient.timeout = const Duration(seconds: 10);
  }

  Future<Response<List<Musica>>> listar() {
    return get<List<Musica>>(
      '/musicas',
      decoder: (dados) {
        if (dados is List) {
          return dados
              .map((item) => Musica.fromJson(item as Map<String, dynamic>))
              .toList();
        }
        return <Musica>[];
      },
    );
  }

  Future<Response<Musica>> buscarPorId(int id) {
    return get<Musica>(
      '/musicas/$id',
      decoder: (dados) {
        if (dados is Map<String, dynamic>) {
          return Musica.fromJson(dados);
        }
        return null;
      },
    );
  }

  Future<Response<Musica>> cadastrar(Musica musica) {
    return post<Musica>(
      '/musicas',
      musica.toJson(),
      decoder: (dados) {
        if (dados is Map<String, dynamic>) {
          return Musica.fromJson(dados);
        }
        return null;
      },
    );
  }

  Future<Response<Musica>> atualizar(int id, Musica musica) {
    return put<Musica>(
      '/musicas/$id',
      musica.toJson(),
      decoder: (dados) {
        if (dados is Map<String, dynamic>) {
          return Musica.fromJson(dados);
        }
        return null;
      },
    );
  }

  Future<Response> excluir(int id) {
    return delete('/musicas/$id');
  }
}
