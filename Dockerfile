# ---- Estágio de Build ----
FROM golang:1.25.3-alpine AS builder

# Define o diretório de trabalho dentro do container
WORKDIR /app

# Copia e baixa as dependências primeiro
COPY go.mod ./
RUN go mod download

# Copia o restante do código-fonte
COPY . .

# Compila a aplicação em modo estático (sem dependências de libc)
# - CGO desabilitado => binário 100% estático
# - GOOS=linux => compatível com a imagem final
# - -ldflags="-w -s" => remove debug symbols (menor tamanho)
RUN CGO_ENABLED=0 GOOS=linux go build -ldflags="-w -s" -o /server ./cmd/server

# ---- Estágio Final (imagem mínima para produção) ----
FROM alpine:3.20

# Cria um usuário e grupo não-root para segurança
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

# Define o diretório de trabalho
WORKDIR /app

# Copia apenas o binário compilado do estágio de build
COPY --from=builder /server /app/server

# Expõe a porta usada pela aplicação
EXPOSE 8080

# Troca para o usuário não-root
USER appuser

# Define o comando de inicialização
CMD ["./server"]
