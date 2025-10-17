# Projeto API em Go

API de exemplo para demonstrar a containerização com Docker.

## Descrição

Esta é uma simples API em Golang que expõe o endpoint `/healthz` e `/info` e retorna um JSON. O objetivo principal deste projeto é servir como um laboratório para as melhores práticas de Docker.

## Pré-requisitos

* Docker Desktop instalado - Windows
* Docker instalado - Linux

## Como Construir a Imagem Docker

Para construir a imagem otimizada e segura, utilize o comando exemplo abaixo na raiz do projeto:

```bash
docker build -t minha-api:latest .
```

## Como Executar o Contêiner

Para iniciar um contêiner a partir da imagem construída localmente:

```bash
docker run -d -p 8080:8080 --name minha-api-app minha-api:latest
```

A API estará disponível em `http://localhost:8080/info`.

## Como Usar a Imagem do Registry

Esta imagem é pública e pode ser baixada por qualquer pessoa que tenha o Docker instalado.

## Estrutura do Dockerfile

O `Dockerfile` utiliza uma abordagem **multi-stage build** para garantir uma imagem final mínima e segura.

* **Estágio `builder`**: Usa a imagem `golang:1.25.3-alpine` para compilar a aplicação, resultando em um binário estático.
* **Estágio Final**: Usa a imagem `alpine:3.20`, que é extremamente leve. Apenas o binário compilado é copiado para a imagem final.
* **Segurança**: A aplicação é executada por um usuário não-root (`appuser`) para mitigar riscos de segurança.

## Boas Práticas Implementadas

* **Imagens Mínimas:** Uso de `alpine` como base final (~20MB de imagem).
* **Multi-Stage Builds:** Separação do ambiente de build do ambiente de execução.
* **Usuário Não-Root:** Adoção do princípio de menor privilégio.
* **Cache de Layers:** A ordem dos comandos `COPY` e `RUN` no Dockerfile foi pensada para otimizar o cache de build.