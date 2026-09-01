import pytest
from fastapi.testclient import TestClient
from app import app, banco_musicas

cliente = TestClient(app)

@pytest.fixture(autouse=True)
def restaurar_banco():
    banco_musicas.clear()
    banco_musicas.extend([
        {"id": 1, "titulo": "Numb", "artista": "Linkin Park", "album": "Meteora", "ano": 2003},
        {"id": 2, "titulo": "Evidências", "artista": "Chitãozinho & Xororó", "album": "Cowboy do Asfalto", "ano": 1990},
        {"id": 3, "titulo": "Tempo Perdido", "artista": "Legião Urbana", "album": "Dois", "ano": 1986},
        {"id": 4, "titulo": "Bohemian Rhapsody", "artista": "Queen", "album": "A Night at the Opera", "ano": 1975},
        {"id": 5, "titulo": "Águas de Março", "artista": "Elis Regina e Tom Jobim", "album": "Elis & Tom", "ano": 1974},
    ])


def test_listar_todas_as_musicas():
    resposta = cliente.get("/musicas")
    assert resposta.status_code == 200
    dados = resposta.json()
    assert len(dados) == 5
    assert dados[0]["titulo"] == "Numb"


def test_buscar_musica_por_id_sucesso():
    resposta = cliente.get("/musicas/1")
    assert resposta.status_code == 200
    dados = resposta.json()
    assert dados["id"] == 1
    assert dados["titulo"] == "Numb"


def test_buscar_musica_por_id_inexistente():
    resposta = cliente.get("/musicas/999")
    assert resposta.status_code == 404
    assert resposta.json()["detail"] == "Música com ID 999 não encontrada."


def test_cadastrar_nova_musica_sucesso():
    nova_musica = {
        "titulo": "Cheia de Manias",
        "artista": "Raça Negra",
        "album": "Raça Negra",
        "ano": 1992
    }
    resposta = cliente.post("/musicas", json=nova_musica)
    assert resposta.status_code == 201
    dados = resposta.json()
    assert dados["id"] is not None
    assert dados["titulo"] == "Cheia de Manias"
    assert dados["artista"] == "Raça Negra"
    assert dados["album"] == "Raça Negra"
    assert dados["ano"] == 1992


def test_cadastrar_musica_dados_invalidos():
    dados_invalidos = {
        "titulo": "Música Incompleta"
    }
    resposta = cliente.post("/musicas", json=dados_invalidos)
    assert resposta.status_code == 422


def test_atualizar_musica_existente():
    dados_atualizados = {
        "titulo": "Tempo Perdido (Ao Vivo)",
        "ano": 1998
    }
    resposta = cliente.put("/musicas/3", json=dados_atualizados)
    assert resposta.status_code == 200
    dados = resposta.json()
    assert dados["id"] == 3
    assert dados["titulo"] == "Tempo Perdido (Ao Vivo)"
    assert dados["artista"] == "Legião Urbana"
    assert dados["ano"] == 1998


def test_atualizar_musica_inexistente():
    resposta = cliente.put("/musicas/999", json={"titulo": "Inexistente"})
    assert resposta.status_code == 404


def test_excluir_musica_sucesso():
    resposta = cliente.delete("/musicas/1")
    assert resposta.status_code == 204
    
    resposta_busca = cliente.get("/musicas/1")
    assert resposta_busca.status_code == 404


def test_excluir_musica_inexistente():
    resposta = cliente.delete("/musicas/999")
    assert resposta.status_code == 404
