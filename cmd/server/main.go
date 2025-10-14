package main

import (
	"log"
	"imp_docker/internal/api"
)

func main() {
	if err := api.RunServer(); err != nil {
		log.Fatal(err)
	}
}
