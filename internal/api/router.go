package api

import (
	"encoding/json"
	"net/http"
	"os"
	"time"
)

// ServiceInfo representa as informações expostas em /info.
type ServiceInfo struct {
	Name      string `json:"name"`
	Version   string `json:"version"`
	Timestamp string `json:"timestamp"`
	Hostname  string `json:"hostname"`
}

// RunServer inicia o servidor HTTP.
func RunServer() error {
	mux := http.NewServeMux()

	mux.HandleFunc("/healthz", func(w http.ResponseWriter, _ *http.Request) {
		w.WriteHeader(http.StatusOK)
		_, _ = w.Write([]byte("ok"))
	})

	mux.HandleFunc("/info", func(w http.ResponseWriter, _ *http.Request) {
		hostname, _ := os.Hostname()
		info := ServiceInfo{
			Name:      getEnv("APP_NAME", "imp_docker"),
			Version:   getEnv("APP_VERSION", "0.1.0"),
			Timestamp: time.Now().Format(time.RFC3339),
			Hostname:  hostname,
		}
		w.Header().Set("Content-Type", "application/json")
		_ = json.NewEncoder(w).Encode(info)
	})

	serverAddr := getEnv("SERVER_PORT", ":8080")
	return http.ListenAndServe(serverAddr, mux)
}

func getEnv(key, defaultValue string) string {
	if value := os.Getenv(key); value != "" {
		return value
	}
	return defaultValue
}
