from fastapi import FastAPI, HTTPException, status
from pydantic import BaseModel
from typing import List, Optional

app = FastAPI(
    title="API de Músicas",
    description="API REST simples para gerenciamento de músicas.",
    version="1.0.0"
)

# Modelo Pydantic para os dados da Música
class MusicaBase(BaseModel):
    titulo: str
    artista: str
    album: Optional[str] = None
    ano: Optional[int] = None

class MusicaCriar(MusicaBase):
    pass

class MusicaAtualizar(BaseModel):
    titulo: Optional[str] = None
    artista: Optional[str] = None
    album: Optional[str] = None
    ano: Optional[int] = None

class Musica(MusicaBase):
    id: int


banco_musicas: List[dict] = [
    {"id": 1, "titulo": "Evidências", "artista": "Chitãozinho & Xororó", "album": "Cowboy do Asfalto", "ano": 1990},
    {"id": 2, "titulo": "Tempo Perdido", "artista": "Legião Urbana", "album": "Dois", "ano": 1986},
    {"id": 3, "titulo": "Águas de Março", "artista": "Elis Regina e Tom Jobim", "album": "Elis & Tom", "ano": 1974},
]
proximo_id = 4


@app.get("/musicas", response_model=List[Musica], summary="Listar todas as músicas")
def listar_musicas():
    """Retorna a lista completa de músicas cadastradas."""
    return banco_musicas


@app.get("/musicas/{musica_id}", response_model=Musica, summary="Buscar música por ID")
def buscar_musica(musica_id: int):
    """Busca uma música específica pelo seu identificador (ID)."""
    for musica in banco_musicas:
        if musica["id"] == musica_id:
            return musica
    raise HTTPException(
        status_code=status.HTTP_404_NOT_FOUND,
        detail=f"Música com ID {musica_id} não encontrada."
    )


@app.post("/musicas", response_model=Musica, status_code=status.HTTP_201_CREATED, summary="Cadastrar nova música")
def cadastrar_musica(dados: MusicaCriar):
    """Cadastra uma nova música na base de dados."""
    global proximo_id
    nova_musica = {
        "id": proximo_id,
        "titulo": dados.titulo,
        "artista": dados.artista,
        "album": dados.album,
        "ano": dados.ano
    }
    banco_musicas.append(nova_musica)
    proximo_id += 1
    return nova_musica


@app.put("/musicas/{musica_id}", response_model=Musica, summary="Atualizar música existente")
def atualizar_musica(musica_id: int, dados: MusicaAtualizar):
    """Atualiza as informações de uma música cadastrada."""
    for musica in banco_musicas:
        if musica["id"] == musica_id:
            if dados.titulo is not None:
                musica["titulo"] = dados.titulo
            if dados.artista is not None:
                musica["artista"] = dados.artista
            if dados.album is not None:
                musica["album"] = dados.album
            if dados.ano is not None:
                musica["ano"] = dados.ano
            return musica
            
    raise HTTPException(
        status_code=status.HTTP_404_NOT_FOUND,
        detail=f"Música com ID {musica_id} não encontrada."
    )


@app.delete("/musicas/{musica_id}", status_code=status.HTTP_204_NO_CONTENT, summary="Excluir música")
def excluir_musica(musica_id: int):
    """Remove uma música da base de dados pelo seu ID."""
    for index, musica in enumerate(banco_musicas):
        if musica["id"] == musica_id:
            banco_musicas.pop(index)
            return None
            
    raise HTTPException(
        status_code=status.HTTP_404_NOT_FOUND,
        detail=f"Música com ID {musica_id} não encontrada."
    )
