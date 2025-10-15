#Base: Uma imagem com o Go instalado para compilar
FROM golang:1.25.3

#Define o diretório de trabalho dentro do contêiner
WORKDIR /app

#Copia os arquivos de gerenciamento de dependências
COPY go.mod ./
#COPY go.sum ./

#Baixa as dependências
RUN go mod download

#Copia todo o resto do código-fonte
COPY . .

#Compila a aplicação
RUN go build -o /server ./cmd/server

#Expõe a porta que a aplicação usa
EXPOSE 8080

#Comando para executar a aplicação quando o contêiner iniciar
CMD ["/server"]