# EMC_EMISSION_MODELING
Code MATLAB pour la modélisation de l'émission en rayonné à partir des données de mesure en conduit et du signal émis et des conditions de l'environnement de propagation du signal.
Le présent code MATLAB a été réalisé dans le cadre de la thèse PhD concernant "la susceptibilité électromagnétique des Drones" du doctorant Imrane BENNAGEH inscrit dans le cycle doctoral de l'École Mohammadia des Ingénieurs (EMI), Université Mohammed V (UM5), Rabat.
Dans le dossier Repository Github, on retrouve les fichiers ci-après:
- (03) Fichiers Excel (AWGN_X.xlsx): Ces fichiers représentent les données de mesure du niveau de bruit dans 3 environnement : awgn_1 (Basement), awgn_2 (Open Area) and awgn_3 (forest Area). Ces mesures ont été effectuées par analyseur de spectre "Anritsu MS2711E" et antenne log-périodique LP-02 NARDA.
- (03) fichiers datas (datas_X.xlsx): Ces fichiers Excel donnent les mesures des émissions du transmetteur "FUTABA T14SG" en conduit et en rayonné. Ces données représentent les Input au code MATLAB de modélisation. Nous disposons de trois tableaux relatifs aux trois environnements : datas_1 (Sous-Sol), datas_2 (Espace Ouvert) et datas_3 (Forêt).
- (03) scripts MATLAB: Les trois codes concernent la modélisation de 3 environnements : Basement, Open Area and Forest.

Description sommaire du code MATLAB:
Le code Matlab consiste à utiliser les mesures des émissions en conduit d'un Emetteur de type "FUTABA T14SG" en combinaison avec les données statistiques de l'environnement considéré pour déduire la forme du signal en rayonné transmis au récepteur du drone placé à une certaine distance. La modélisation du signal repose sur des données deterministes et stochastiques pour prédir la forme du signal à l'antenne de réception du drone.


