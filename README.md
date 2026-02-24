# Quelpoke 🐾

Application web Go qui associe un nom d'utilisateur à un Pokémon de la première génération en utilisant un hash déterministe.

## Fonctionnalités

- Génération d'un Pokémon unique basé sur un nom (hash SHA-1)
- Interface web simple et intuitive
- API PokeAPI pour récupérer les informations des Pokémon
- Serveur HTTP léger et performant
- Configuration via variables d'environnement

## Démarrage rapide

### Prérequis

- Go 1.22.4 ou supérieur

### Installation

```bash
# Cloner le projet
git clone <url-du-repo>
cd quelpoke

# Lancer l'application
go run main.go
```

L'application sera accessible sur `http://localhost:8080`

## Utilisation

### Interface web

Accédez à l'application via votre navigateur :

```
http://localhost:8080/?name=VotreNom
```

Le paramètre `name` permet de générer un Pokémon unique associé à ce nom.

**Exemple :**
- `http://localhost:8080/?name=thomas` → Génère toujours le même Pokémon pour "thomas"
- `http://localhost:8080/?name=pikachu` → Génère un autre Pokémon pour "pikachu"

### Variables d'environnement

| Variable | Valeur par défaut | Description |
|----------|-------------------|-------------|
| `ADDR` | `0.0.0.0` | Adresse d'écoute du serveur |
| `PORT` | `8080` | Port d'écoute du serveur |
| `VERSION` | `dev` | Version de l'application |

**Exemple :**

```bash
ADDR=127.0.0.1 PORT=3000 VERSION=1.0.0 go run main.go
```

## Architecture

### Structure du projet

```
quelpoke/
├── main.go           # Code principal de l'application
├── index.tmpl.html   # Template HTML embarqué
├── go.mod            # Dépendances Go
└── README.md         # Documentation
```

### Fonctionnement

1. **Calcul du Pokémon** : L'application calcule un hash SHA-1 du nom fourni
2. **Mapping vers un ID** : Le hash est converti en un ID entre 1 et 151 (première génération)
3. **Récupération des données** : Appel à l'API PokeAPI pour obtenir le nom du Pokémon
4. **Affichage** : Rendu du template HTML avec les informations du Pokémon

### Fonctions principales

- `main()` : Point d'entrée, configuration du serveur HTTP
- `index()` : Handler principal, gestion de la requête et rendu du template
- `pokemonID()` : Calcul déterministe de l'ID Pokémon basé sur le hash SHA-1
- `pokemonName()` : Récupération du nom du Pokémon via PokeAPI
- `env()` : Utilitaire pour lire les variables d'environnement avec valeur par défaut

## Développement

### Build

```bash
go build -o quelpoke main.go
```

### Exécution

```bash
./quelpoke
```

### Container Docker (optionnel)

```dockerfile
FROM golang:1.22.4-alpine AS builder
WORKDIR /app
COPY . .
RUN go build -o quelpoke main.go

FROM alpine:latest
WORKDIR /app
COPY --from=builder /app/quelpoke .
COPY index.tmpl.html .
EXPOSE 8080
CMD ["./quelpoke"]
```

## Personnalisation

Le template HTML (`index.tmpl.html`) peut être modifié pour personnaliser l'apparence de l'application. Les variables disponibles dans le template :

- `{{.PokemonID}}` : ID numérique du Pokémon (1-151)
- `{{.PokemonName}}` : Nom du Pokémon (récupéré via API)
- `{{.Name}}` : Nom de l'utilisateur fourni en paramètre
- `{{.Version}}` : Version de l'application

## API Externe

Ce projet utilise [PokeAPI](https://pokeapi.co/) pour récupérer les informations des Pokémon.

**Endpoint utilisé :**
```
GET https://pokeapi.co/api/v2/pokemon/{id}
```

## Logs

L'application génère des logs pour chaque requête :

```
2026/02/23 11:47:00 starting quelpoke app on http://0.0.0.0:8080
2026/02/23 11:47:05 generated page in 234.5ms with pokemon id: 42 for name: thomas
```

## Gestion des erreurs

L'application gère les erreurs suivantes :

- Échec du parsing du template → HTTP 500
- Échec de l'appel à PokeAPI → HTTP 500
- Échec du rendu du template → HTTP 500

Les erreurs sont loggées avec le préfixe `[ERR]`.

## Licence

Projet personnel - Utilisation libre