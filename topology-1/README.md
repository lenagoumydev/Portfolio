# Topologie 1 — Réseau segmenté par VLANs avec routage inter-VLAN
 
## Description du projet
 
Ce projet représente une infrastructure réseau locale (LAN) segmentée en **plusieurs VLANs** avec routage inter-VLAN, conçue et simulée sous **Cisco Packet Tracer** (`.pkt`). L'objectif est de mettre en place une architecture réseau d'entreprise typique où différents départements sont isolés logiquement tout en pouvant communiquer via un routeur central.
 
---
 
## Architecture générale
 
```
[Internet / WAN]
      │
  [Routeur principal] ──── [Routeur secondaire]
      │
  [Switch Layer 3]
      │
  [Switch Layer 2 / Patch Panel]
   ┌──┼──┬──┬──┐
  IT  MKT MKT DIR  ...
```
 
Le réseau est structuré en **3 couches** :
 
1. **Couche routage** — Deux routeurs interconnectés, dont un gère le routage inter-VLAN via des sous-interfaces (router-on-a-stick)
2. **Couche distribution** — Un switch Layer 3 qui relie les routeurs aux équipements d'accès
3. **Couche accès** — Un switch Layer 2 (Patch Panel) auquel sont connectés les postes clients
---
 
## VLANs configurés
 
| VLAN ID | Nom        | Sous-réseau         | Passerelle          | DHCP relay |
|---------|------------|----------------------|----------------------|------------|
| 20      | IT         | 192.168.20.0/24      | 192.168.20.254       | ✅ 192.168.31.3 |
| 21      | MARKETING  | 192.168.21.0/24      | 192.168.21.254       | ✅ 192.168.31.3 |
| 22      | DIRECTION  | 192.168.22.0/24      | 192.168.22.254       | ✅ 192.168.31.3 |
| 30      | (Serveurs) | 192.168.30.0/24      | 192.168.30.254       | ❌ |
| 31      | (Serveurs) | 192.168.31.0/24      | 192.168.31.254       | ❌ |
| 99      | (Mgmt/Autre)| 192.168.99.0/24     | 192.168.99.254       | ✅ 192.168.31.3 |
 
---
 
## 🖥️ Postes clients visibles dans le diagramme
 
| Hôte            | VLAN        | Adresse IP       |
|-----------------|-------------|------------------|
| PC-1            | IT (20)     | 192.168.20.10/24 |
| PC-2            | MARKETING (21) | 192.168.21.10/24 |
| PC-3            | MARKETING (21) | 192.168.21.11/24 |
| PC-4            | DIRECTION (22) | 192.168.22.10/24 |
 
---
 
## ⚙️ Fichiers de configuration
 
| Fichier                | Rôle |
|------------------------|------|
| `vlans.config`         | Création des VLANs 20, 21, 22 sur le switch Layer 2 |
| `access.config`        | Attribution des ports du switch en mode **access** par VLAN |
| `trunk.config`         | Configuration du port **trunk** vers le routeur (VLANs 20–31) |
| `subinterfaces.config` | Création des **sous-interfaces** du routeur (router-on-a-stick) |
| `global.config`        | Configuration globale (à compléter) |
| `topo-1.pkt`           | Fichier de simulation Cisco Packet Tracer |
| `topo.drawio`          | Diagramme de la topologie (Draw.io) |
| `diagrame.png/.svg`    | Export visuel du diagramme |
 
---
 
## Détail des configurations
 
### VLANs (`vlans.config`)
Création des VLANs nommés sur le switch d'accès :
- VLAN 20 → `IT`
- VLAN 21 → `MARKETING`
- VLAN 22 → `DIRECTION`
### Ports Access (`access.config`)
Assignation des ports physiques du switch Layer 2 :
- `Gi1/0/1` → VLAN 20 (IT)
- `Gi1/0/2` → VLAN 21 (MARKETING)
- `Gi1/0/3` → VLAN 21 (MARKETING)
- `Gi1/0/4` → VLAN 22 (DIRECTION)
### Port Trunk (`trunk.config`)
Le port `Gi1/0/24` est configuré en **trunk** pour transporter les VLANs 20, 21, 22, 30, 31 vers le routeur.
 
### Sous-interfaces routeur (`subinterfaces.config`)
Technique **router-on-a-stick** sur l'interface `GigabitEthernet 0/0/1` :
- Chaque VLAN a sa propre sous-interface (`.20`, `.21`, `.22`, `.30`, `.31`, `.99`)
- Encapsulation **802.1Q** (dot1Q)
- Un `ip helper-address` pointe vers `192.168.31.3` pour relayer le DHCP vers les VLANs clients
