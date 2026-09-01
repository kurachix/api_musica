from fastapi import FastAPI, HTTPException, status
from pydantic import BaseModel
from typing import List, Optional

app = FastAPI(title="API de Músicas")

class MusicaBase(BaseModel):
    titulo: str
    artista: str
    album: str
    ano: int

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
    {"id": 1, "titulo": "Numb", "artista": "Linkin Park", "album": "Meteora", "ano": 2003},
    {"id": 2, "titulo": "Evidências", "artista": "Chitãozinho & Xororó", "album": "Cowboy do Asfalto", "ano": 1990},
    {"id": 3, "titulo": "Tempo Perdido", "artista": "Legião Urbana", "album": "Dois", "ano": 1986},
    {"id": 4, "titulo": "Bohemian Rhapsody", "artista": "Queen", "album": "A Night at the Opera", "ano": 1975},
    {"id": 5, "titulo": "Águas de Março", "artista": "Elis Regina e Tom Jobim", "album": "Elis & Tom", "ano": 1974},
]
proximo_id = 6


@app.get("/musicas", response_model=List[Musica])
def listar_musicas():
    return banco_musicas


@app.get("/musicas/{musica_id}", response_model=Musica)
def buscar_musica(musica_id: int):
    for musica in banco_musicas:
        if musica["id"] == musica_id:
            return musica
    raise HTTPException(
        status_code=status.HTTP_404_NOT_FOUND,
        detail=f"Música com ID {musica_id} não encontrada."
    )


@app.post("/musicas", response_model=Musica, status_code=status.HTTP_201_CREATED)
def cadastrar_musica(dados: MusicaCriar):
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


@app.put("/musicas/{musica_id}", response_model=Musica)
def atualizar_musica(musica_id: int, dados: MusicaAtualizar):
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


@app.delete("/musicas/{musica_id}", status_code=status.HTTP_204_NO_CONTENT)
def excluir_musica(musica_id: int):
    for index, musica in enumerate(banco_musicas):
        if musica["id"] == musica_id:
            banco_musicas.pop(index)
            return None
            
    raise HTTPException(
        status_code=status.HTTP_404_NOT_FOUND,
        detail=f"Música com ID {musica_id} não encontrada."
    )
