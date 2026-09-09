<div align="center">
<img src="https://capsule-render.vercel.app/api?type=waving&color=0:1e3a5f,100:2c5f8a&height=140&section=header&text=Topology%20X&fontSize=36&fontColor=ffffff&animation=fadeIn&fontAlignY=42&desc=Lab%20réseau%20%7C%20Cisco%20Packet%20Tracer&descAlignY=62&descSize=15" width="100%"/>
[![Typing SVG](https://readme-typing-svg.demolab.com?font=Fira+Code&weight=500&size=18&pause=1000&color=2C5F8A&center=true&vCenter=true&width=550&lines=Conception+d'une+topologie+réseau;VLAN+%7C+Routage+%7C+Sécurité)](https://git.io/typing-svg)
 
![Cisco](https://img.shields.io/badge/Cisco-1BA0D7?style=flat-square&logo=cisco&logoColor=white)
![Packet Tracer](https://img.shields.io/badge/Packet%20Tracer-0071C5?style=flat-square&logo=cisco&logoColor=white)
![Status](https://img.shields.io/badge/Statut-Terminé-2C5F8A?style=flat-square)
 
</div>
---
 
## 🎯 Objectif du TP
 
> *Décris en 2-3 phrases ce que ce lab démontre : ex. "Mise en place d'un réseau local segmenté par VLAN avec routage inter-VLAN et configuration de la sécurité des ports."*
 
---
 
## 🗺️ Schéma de la topologie
 
<div align="center">
<img src="./screenshots/topologie.png" alt="Schéma de la topologie" width="80%"/>
</div>
> *Ajoute une capture d'écran de ton schéma Packet Tracer dans un dossier `screenshots/` et mets à jour le chemin ci-dessus.*
 
---
 
## 🖥️ Équipements utilisés
 
| Équipement | Modèle | Rôle |
|---|---|---|
| Routeur | Cisco 2911 | Routage inter-VLAN |
| Switch | Cisco 2960 | Commutation / VLANs |
| PC | Générique | Postes clients |
 
> *Adapte ce tableau à ton matériel réel (nombre de routeurs, switches, PC, serveurs...).*
 
---
 
## 🌐 Plan d'adressage IP
 
| VLAN | Nom | Réseau | Passerelle |
|---|---|---|---|
| 10 | Administration | 192.168.10.0/24 | 192.168.10.1 |
| 20 | Utilisateurs | 192.168.20.0/24 | 192.168.20.1 |
| 99 | Management | 192.168.99.0/24 | 192.168.99.1 |
 
> *Remplace par ton propre plan d'adressage.*
 
---
 
## ⚙️ Configuration réalisée
 
- [ ] Création et attribution des VLANs
- [ ] Configuration du routage inter-VLAN (Router-on-a-stick / SVI)
- [ ] Sécurisation des ports (port security)
- [ ] Configuration du protocole de gestion (SSH, mots de passe)
- [ ] Tests de connectivité (ping, traceroute)
> *Coche les points réellement traités, ajoute ou retire des lignes selon le TP.*
 
---
 
## ✅ Résultats / Tests de connectivité
 
> *Décris les tests effectués et leurs résultats : ex. "Ping réussi entre VLAN 10 et VLAN 20 après configuration du routage inter-VLAN. Accès refusé pour les hôtes hors du VLAN autorisé, conformément à la politique de sécurité."*
 
---
 
## 🧠 Compétences mises en œuvre
 
`VLAN` `Routage inter-VLAN` `Port Security` `Adressage IP` `Cisco IOS` `Dépannage réseau`
 
---
 
<div align="center">
⬅️ [Retour au portfolio](https://github.com/lenagoumydev/Portfolio)
 
</div>
