package main

import (
	"fmt"
	"os"
	"text/template"

	env "github.com/caarlos0/env/v6"
	"github.com/hashicorp/go-hclog"
)

type Arbitrator struct {
	Hostname string `env:"TAOS_ARBITRATOR"`
	Port     int    `env:"TAOS_ARBITRATOR_PORT"`
}

type Config struct {
	Pod           string `env:"POD_NAME"`
	FirstEP       string `env:"TAOS_FIRST_EP"`
	FQDN          string `env:"TAOS_FQDN"`
	Port          int    `env:"TAOS_SERVER_PORT"`
	LogDirectory  string `env:"LOG_DIR"`
	DataDirectory string `env:"DATA_DIR"`
	TmpDirectory  string `env:"TMP_DIR"`
	Arbitrator    Arbitrator
	Others        string
}

var config string = `
firstEp                   {{ or .FirstEP "node-0" }}
fqdn                      {{ or .FQDN "node" }}
serverPort                {{ or .Port "6030" }}
logDir                    {{ or .LogDirectory "/var/log/taos" }}
dataDir                   {{ or .DataDirectory "/var/lib/taos" }}
tempDir                   {{ or .TmpDirectory "/tmp/" }}
arbitrator                {{ or .Arbitrator.Hostname "arbitrator" }}:{{ or .Arbitrator.Port "6042" }}
{{ or .Others "" }}
`

func main() {
	var (
		log  hclog.Logger = hclog.Default()
		cfg  Config
		t    *template.Template
		file *os.File
		path string = fmt.Sprintf("/config/%s", "taos.cfg")
		dat         = make([]byte, 0)
		err  error
	)

	if err := env.Parse(&cfg); err != nil {
		fmt.Printf("%+v\n", err)
	}

	if file, err = os.Create("/etc/taos/taos.cfg"); err != nil {
		log.With("error", err).Error("failed to open destination file")
		os.Exit(1)
	}
	defer file.Close()

	if dat, err = os.ReadFile(path); err != nil {
		log.With("error", err).Error("failed to read config file")
		os.Exit(1)
	}

	cfg.Others = string(dat)
	t = template.Must(template.New("config").Parse(config))

	if err = t.Execute(file, cfg); err != nil {
		log.With("error", err).Error("failed to create template")
		os.Exit(1)
	}

	log.Info("Successful init-config")
}
