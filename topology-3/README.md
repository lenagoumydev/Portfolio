# Topologie 3 — Réseau haute disponibilité avec HSRP (failover routeur)
 
## Description du projet
 
Ce projet représente l'évolution la plus avancée de la série. Il introduit la **haute disponibilité au niveau du routage** grâce au protocole **HSRP (Hot Standby Router Protocol)**, qui permet à deux routeurs de fonctionner en **actif/passif** : si le routeur principal tombe, le second prend automatiquement le relais sans interruption pour les utilisateurs.
 
Le réseau appartient au domaine VTP `ARTSHOP` et segmente l'entreprise en 4 VLANs avec routage inter-VLAN en router-on-a-stick, DHCP relay centralisé, et une redondance complète de la passerelle par défaut.
 
---
 
## Architecture générale
 
```
                    [Routeur Principal]   [Routeur Secondaire]
                     IP réelle .254        IP réelle .254
                     Priorité HSRP: 110    Priorité HSRP: 100
                              └──────────┬──────────┘
                                  IP Virtuelle HSRP
                                   192.168.20.253
                                         │
                              [Switch Core — VTP Server]
                           ┌──────────┼──────────┐
                         Gi1/0/20  Gi1/0/21  Gi1/0/22     Gi1/0/3
                            │         │          │            │
                       [SW Marketing] [SW RH] [SW Direction] [Serveurs]
                        VLAN 20     VLAN 21    VLAN 22      VLAN 30
                         Fa0/1-2     Fa0/1      Fa0/1
```
 
---
 
## HSRP — Haute disponibilité des routeurs
 
HSRP permet à **deux routeurs de partager une IP virtuelle** utilisée comme passerelle par les postes clients. En cas de panne du routeur actif, le routeur standby prend le relais automatiquement.
 
| Paramètre            | Routeur Principal       | Routeur Secondaire      |
|----------------------|-------------------------|-------------------------|
| IP virtuelle (HSRP)  | 192.168.20.253          | 192.168.20.253          |
| Priorité HSRP        | **110** (actif)         | **100** (standby)       |
| Preempt              | ✅ (reprend si rétabli) | ✅                       |
| Délai preempt        | 10 secondes             | 10 secondes             |
| Interface concernée  | `0/0/1.20`              | `0/0/1.20`              |
 
> 💡 Le routeur avec la **priorité la plus haute (110)** est élu **actif**. Si ce routeur tombe, le secondaire (priorité 100) prend automatiquement la main. Quand le principal revient, il **reprend son rôle actif** grâce au `preempt`.
 
---
 
## VLANs configurés
 
| VLAN ID | Nom              | Sous-réseau          | Passerelle réelle | IP virtuelle HSRP | DHCP relay        |
|---------|------------------|----------------------|-------------------|-------------------|-------------------|
| 20      | MARKETING        | 192.168.20.0/24      | 192.168.20.254    | 192.168.20.253    | ✅ 192.168.30.3  |
| 21      | HUMAN_RESOURCES  | 192.168.21.0/24      | 192.168.21.254    | —                 | ✅ 192.168.30.3  |
| 22      | DIRECTION        | 192.168.22.0/24      | 192.168.22.254    | —                 | ✅ 192.168.30.3  |
| 30      | SERVICES         | 192.168.30.0/24      | 192.168.30.254    | —                 | ❌ (serveur ici) |
 
---
 
## VTP — Domaine ARTSHOP
 
| Équipement       | Mode VTP   | Domaine  |
|------------------|------------|----------|
| Switch Core      | **Server** | ARTSHOP  |
| Switch Marketing | **Client** | ARTSHOP  |
| Switch RH        | **Client** | ARTSHOP  |
| Switch Direction | **Client** | ARTSHOP  |
 
Les VLANs sont créés une seule fois sur le switch **Server** et propagés automatiquement vers tous les **Clients** via les liens trunk.
 
---
 
## Configuration des interfaces
 
### Switch Core (trunk vers les switches départements)
 
| Port      | Mode  | VLANs autorisés | Connecté à        |
|-----------|-------|-----------------|-------------------|
| Gi1/0/1   | Trunk | 20, 21, 22      | Routeur Principal |
| Gi1/0/2   | Trunk | 20, 21, 22      | Routeur Secondaire|
| Gi1/0/3   | Access| VLAN 30         | Serveurs (DHCP…)  |
| Gi1/0/20  | Trunk | 20, 21, 22      | Switch Marketing  |
| Gi1/0/21  | Trunk | 20, 21, 22      | Switch RH         |
| Gi1/0/22  | Trunk | 20, 21, 22      | Switch Direction  |
 
### Switches départements (ports access)
 
| Switch           | Port    | Mode   | VLAN |
|------------------|---------|--------|------|
| Switch Marketing | Fa0/1-2 | Access | 20   |
| Switch RH        | Fa0/1   | Access | 21   |
| Switch Direction | Fa0/1   | Access | 22   |
 
---
 
## Fichiers de configuration
 
| Fichier                     | Rôle |
|-----------------------------|------|
| `vlan.config`               | Création des VLANs 20, 21, 22, 30 (switch VTP server) |
| `vtp.config` (server)       | Mode VTP **server** — switch core (domaine ARTSHOP) |
| `vtp.config` (client)       | Mode VTP **client** — switches départements |
| `routers.config`            | Ports trunk du switch core vers les **deux routeurs** |
| `switches.config`           | Ports trunk du switch core vers les **switches départements** |
| `servers.config`            | Port access VLAN 30 vers les serveurs |
| `inter-vlans-routing.config`| Sous-interfaces du routeur (router-on-a-stick, DHCP relay) |
| `failover-hsrp.config`      | Config HSRP sur chaque routeur (actif priorité 110 / standby 100) |
| `marketing.config`          | Ports access VLAN 20 sur le switch Marketing |
| `human_resources.config`    | Port access VLAN 21 sur le switch RH |
| `direction.config`          | Port access VLAN 22 sur le switch Direction |
| `cisco_pt.pkt`              | Fichier de simulation Cisco Packet Tracer |
 
---
 
## Ordre d'application des configurations
 
Pour reproduire le réseau depuis zéro dans Cisco Packet Tracer :
 
1. **Switch Core** → `vtp.config` (server) → `vlan.config` → `routers.config` → `switches.config` → `servers.config`
2. **Switches départements** → `vtp.config` (client) → config spécifique (`marketing.config`, `human_resources.config`, `direction.config`)
3. **Routeur Principal** → `inter-vlans-routing.config` → `failover-hsrp.config` (priorité 110)
4. **Routeur Secondaire** → `inter-vlans-routing.config` → `failover-hsrp.config` (priorité 100)
---
 
## Technologies & protocoles utilisés
 
- **Cisco IOS** — Configuration routeurs et switchs
- **HSRP** — Hot Standby Router Protocol (haute disponibilité passerelle)
- **VTP** — VLAN Trunking Protocol (propagation automatique des VLANs)
- **IEEE 802.1Q** — Encapsulation trunk (dot1Q)
- **Router-on-a-stick** — Routage inter-VLAN via sous-interfaces
- **DHCP Relay** (`ip helper-address`) — Redirection DHCP vers serveur centralisé
- **Cisco Packet Tracer** — Simulation réseau
---
 
## Structure du projet
 
```
topologie-3/
├── cisco_pt.pkt                  # Simulation Packet Tracer
├── vlan.config                   # Création des VLANs
├── vtp.config                    # Config VTP (server + client)
├── routers.config                # Trunk switch core → routeurs
├── switches.config               # Trunk switch core → switches dept.
├── servers.config                # Access port vers serveurs (VLAN 30)
├── inter-vlans-routing.config    # Sous-interfaces routeur + DHCP relay
├── failover-hsrp.config          # HSRP actif (110) et standby (100)
├── marketing.config              # Access VLAN 20
├── human_resources.config        # Access VLAN 21
├── direction.config              # Access VLAN 22
└── README.md                     # Ce fichier
```
 
---
