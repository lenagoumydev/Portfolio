# Topologie 2 — Réseau multi-VLANs avec VTP, services centralisés et conteneur Docker
 
## Description du projet
 
Ce projet représente une infrastructure réseau d'entreprise plus avancée que Topologie 1. Elle introduit la **propagation automatique des VLANs via VTP** (VLAN Trunking Protocol), une **séparation dédiée des services réseau** (DHCP, DNS, web intranet) dans un VLAN de services isolé, ainsi qu'un **conteneur Docker** permettant de générer et distribuer des configurations Cisco automatiquement.
 
L'architecture simule un environnement multi-département avec 4 VLANs distincts, un switch VTP serveur et plusieurs switches VTP clients qui reçoivent la configuration VLAN automatiquement.
 
---
 
## Architecture générale
 
```
            [Routeur]
                │ trunk (VLANs 10,20,30,40)
            [Switch Core — VTP Server]
           ┌────┼────┬────┐
         Gi1/0/3  Gi1/0/4  Gi1/0/5   (trunks vers switches dept.)
            │        │        │
       [SW Marketing] [SW RH] [SW Direction]
        VLAN 20     VLAN 30   VLAN 10
        
       Gi1/0/1 → Serveur DHCP+DNS  (VLAN 40)
       Gi1/0/2 → Serveur Web Intranet (VLAN 40)
```
 
---
 
## VLANs configurés
 
| VLAN ID | Nom              | Usage                        | Adresse hôte exemple   |
|---------|------------------|------------------------------|------------------------|
| 10      | VLAN_DIRECTION   | Département Direction        | 192.168.10.10/24       |
| 20      | VLAN_MARKETING   | Département Marketing        | 192.168.20.10/24       |
| 30      | VLAN_RH          | Département Ressources Hum.  | 192.168.30.10/24       |
| 40      | VLAN_SERVICES    | Serveurs DHCP, DNS, Intranet | —                      |
 
---
 
## VTP — Propagation automatique des VLANs
 
Le projet utilise **VTP (VLAN Trunking Protocol)** pour synchroniser les VLANs sur tous les switches sans configuration manuelle répétée.
 
| Rôle       | Mode VTP   | Domaine VTP |
|------------|------------|-------------|
| Switch Core | **Server** | `google`    |
| Switch Marketing | **Client** | `google` |
| Switch RH  | **Client** | `google`    |
| Switch Direction | **Client** | `google` |
 
Le switch **Server** crée et propage les VLANs. Les switches **Client** les reçoivent automatiquement via les liens trunk.
 
---
 
## Interfaces du switch Core
 
| Port     | Mode   | VLANs autorisés     | Connecté à              |
|----------|--------|---------------------|-------------------------|
| Gi1/0/1  | Access | VLAN 40             | Serveur DHCP + DNS      |
| Gi1/0/2  | Access | VLAN 40             | Serveur Web (Intranet)  |
| Gi1/0/3  | Trunk  | 10, 20, 30, 40      | Switch Marketing        |
| Gi1/0/4  | Trunk  | 10, 20, 30, 40      | Switch RH               |
| Gi1/0/5  | Trunk  | 10, 20, 30, 40      | Switch Direction        |
| Gi1/0/24 | Trunk  | 10, 20, 30, 40      | Routeur                 |
 
---
 
## Conteneur Docker — `gestionconfigcisco`
 
Le projet inclut un **conteneur Docker** nommé `gestionconfigcisco` destiné à la gestion et la distribution des configurations Cisco.
 
### Fonctionnement
- **Image de base** : `alpine:latest` (image Linux ultra-légère)
- **Outil installé** : `fortune` — génère des messages/citations aléatoires
- **Comportement au démarrage** : affiche automatiquement une citation via `fortune -a`
> 💡 Ce conteneur sert de base légère pour automatiser la génération ou la distribution de configurations réseau Cisco. Il peut être étendu pour scripter des commandes CLI, générer des fichiers `.config`, ou interagir avec des équipements via SSH/Netmiko/Netconf.
 
### Lancer le conteneur
 
```bash
# Build et démarrage via Docker Compose
docker compose up
 
# Mode debug
docker compose -f compose_debug.yaml up
 
# Build manuel
docker build -t gestionconfigcisco .
 
# Exécution manuelle
docker run --rm gestionconfigcisco
```
 
---
 
## Fichiers de configuration
 
| Fichier                | Rôle |
|------------------------|------|
| `vlan.config`          | Création des 4 VLANs sur le switch VTP **Server** |
| `vtp.config` (server)  | Configuration VTP en mode **serveur** (switch core) |
| `vtp.config` (client)  | Configuration VTP en mode **client** (switches dept.) |
| `interfaces.config`    | Configuration des ports trunk et access du switch core |
| `192_168_10.10`        | Adresse IP statique du poste Direction (192.168.10.10/24) |
| `192_168_20.10`        | Adresse IP statique du poste Marketing (192.168.20.10/24) |
| `192_168_30.10`        | Adresse IP statique du poste RH (192.168.30.10/24) |
| `Dockerfile`           | Image Docker pour la gestion des configurations Cisco |
| `compose.yaml`         | Démarrage standard du conteneur |
| `compose_debug.yaml`   | Démarrage en mode debug |
 
---
 
## Technologies & outils utilisés
 
- **Cisco IOS** — Configuration switchs (VTP, VLANs, trunk/access)
- **VTP (VLAN Trunking Protocol)** — Propagation automatique des VLANs
- **IEEE 802.1Q** — Encapsulation trunk entre les équipements
- **Docker / Docker Compose** — Conteneurisation de l'outil de gestion
- **Alpine Linux** — Base légère du conteneur
---
 
## Comment utiliser le projet
 
### Partie réseau (Cisco)
1. Sur le **switch core** : appliquer dans l'ordre `vtp.config` (server) → `vlan.config` → `interfaces.config`
2. Sur chaque **switch département** : appliquer `vtp.config` (client) — les VLANs se propagent automatiquement
3. Configurer les IP statiques sur les postes selon les fichiers `192_168_X.X`
### Partie Docker
```bash
# Prérequis : Docker installé
docker compose up --build
```
 
---
 
## Structure du projet
 
```
topologie-2/
├── Dockerfile               # Image Docker gestionconfigcisco
├── compose.yaml             # Docker Compose standard
├── compose_debug.yaml       # Docker Compose debug
├── vlan.config              # Création des VLANs (switch serveur VTP)
├── vtp.config               # Config VTP (server / client selon switch)
├── interfaces.config        # Config ports trunk et access
├── 192_168_10.10            # IP statique poste Direction
├── 192_168_20.10            # IP statique poste Marketing
├── 192_168_30.10            # IP statique poste RH
└── README.md                # Ce fichier
```
 
---
