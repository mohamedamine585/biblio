class Lecteur{
  String nom , prenom , email ;
  String ? addresse ;
  int Cin , nb_prets ,nb_prets_actuels , nb_alertes ; 
  late int fidelite;
  DateTime date_entree ;
  Lecteur(this.nom,this.prenom,this.email,this.Cin,this.addresse,this.date_entree,this.nb_prets,this.nb_prets_actuels,this.nb_alertes,this.fidelite);
}