# Topologie 4 — Réseau de base : 2 VLANs, 1 switch, 1 routeur (Router-on-a-Stick)
 
## Description du projet
 
Ce projet est une topologie **épurée et pédagogique** qui met en pratique les fondamentaux du routage inter-VLAN avec le minimum d'équipements : **un seul switch d'accès** (Cisco 2960-24TT) et **un seul routeur** (Cisco ISR4331). C'est une topologie de référence idéale pour comprendre et valider le fonctionnement du router-on-a-stick avant de l'intégrer dans une infrastructure plus complexe.
 
Deux postes appartenant à deux VLANs différents (RH et Marketing) communiquent entre eux uniquement via les sous-interfaces du routeur — le switch seul ne peut pas router entre VLANs.
 
---
 
## Architecture générale
 
```
PC-Brice (RH)                          
192.168.20.10                          
    │ Fa0 → Fa0/1 (VLAN 20)            
    │                                  
    ├──── [2960-24TT Access-Switch] ──── Gig0/1 ──trunk──  Gig0/0/0 ──── [ISR4331 Router]
    │                                                                      │  .20 → 192.168.20.254
    │ Fa0 → Fa0/10 (VLAN 22)                                              │  .22 → 192.168.22.254
    │                                  
PC-Evan (Marketing)                    
192.168.22.10                          
```
 
---
 
## VLANs configurés
 
| VLAN ID | Nom       | Sous-réseau         | Passerelle (sous-interface routeur) | Poste            |
|---------|-----------|----------------------|--------------------------------------|------------------|
| 20      | RH        | 192.168.20.0/24      | 192.168.20.254                       | PC-Brice (.10)   |
| 22      | MARKETING | 192.168.22.0/24      | 192.168.22.254                       | PC-Evan (.10)    |
 
---
 
## Équipements
 
| Équipement           | Modèle Cisco     | Rôle                                   |
|----------------------|------------------|----------------------------------------|
| Access-Switch        | Catalyst 2960-24TT | Commutation L2, séparation des VLANs  |
| Router               | ISR4331          | Routage inter-VLAN (router-on-a-stick) |
| PC-Brice             | PC               | Poste RH — VLAN 20 — 192.168.20.10    |
| PC-Evan              | PC               | Poste Marketing — VLAN 22 — 192.168.22.10 |
 
---
 
## Fichiers de configuration
 
### Switch (2960-24TT Access-Switch)
 
| Fichier           | Appliqué sur     | Rôle |
|-------------------|------------------|------|
| `vlans.config`    | Switch           | Crée les VLANs 20 (RH) et 22 (MARKETING) |
| `rh.config`       | Switch — Fa0/1   | Port access VLAN 20 → PC-Brice |
| `marketing.config`| Switch — Fa0/10  | Port access VLAN 22 → PC-Evan |
| `trunk.config`    | Switch — Gig0/1  | Port trunk vers le routeur (VLANs 20 et 22) |
 
### Routeur (ISR4331)
 
| Fichier           | Appliqué sur        | Rôle |
|-------------------|---------------------|------|
| `trunk.config`    | Routeur — Gi0/0/0   | Activation de l'interface physique vers le switch |
| `rh.config`       | Routeur — Gi0/0/0.20| Sous-interface RH : dot1Q 20, IP 192.168.20.254 |
| `marketing.config`| Routeur — Gi0/0/0.22| Sous-interface Marketing : dot1Q 22, IP 192.168.22.254 |
 
### Vérification
 
| Fichier                    | Commande               | Vérifie |
|----------------------------|------------------------|---------|
| `verify-vlans.config`      | `show vlan brief`      | VLANs présents sur le switch |
| `verify-interfaces.config` | `show running-config`  | Config des interfaces switch |
| `verify-subinterface.config`| `show running-config` | Sous-interfaces du routeur |
 
---
 
## Détail des configurations clés
 
### Trunk switch → routeur (`trunk.config` — switch)
```
interface GigabitEthernet0/1
    description AS <-> Router
    switchport mode trunk
    switchport trunk allowed vlan 20,22
```
 
### Activation interface routeur (`trunk.config` — routeur)
```
interface GigabitEthernet0/0/0
    description Router <-> AS
    no shutdown
```
 
### Sous-interface RH (`rh.config` — routeur)
```
interface GigabitEthernet0/0/0.20
    description RH SubInterface
    encapsulation dot1Q 20
    ip address 192.168.20.254 255.255.255.0
```
 
### Sous-interface Marketing (`marketing.config` — routeur)
```
interface GigabitEthernet0/0/0.22
    description Marketing SubInterface
    encapsulation dot1Q 22
    ip address 192.168.22.254 255.255.255.0
```
 
---
 
## Ordre d'application des configurations
 
**Sur le switch :**
1. `vlans.config` — créer les VLANs
2. `rh.config` — port access VLAN 20
3. `marketing.config` — port access VLAN 22
4. `trunk.config` — port trunk vers le routeur
**Sur le routeur :**
1. `trunk.config` — activer l'interface physique
2. `rh.config` — créer la sous-interface VLAN 20
3. `marketing.config` — créer la sous-interface VLAN 22
**Vérification :**
- Switch : `verify-vlans.config` → `verify-interfaces.config`
- Routeur : `verify-subinterface.config`
- Test final : `ping 192.168.22.10` depuis PC-Brice (doit traverser le routeur)
---
 
## Technologies & protocoles utilisés
 
- **Cisco IOS** — Configuration switch et routeur
- **IEEE 802.1Q** — Encapsulation trunk (dot1Q)
- **Router-on-a-stick** — Routage inter-VLAN via sous-interfaces
- **Cisco Packet Tracer** — Simulation réseau
---
