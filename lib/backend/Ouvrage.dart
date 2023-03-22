import 'dart:ffi';

class Ouvrage {
  String nomOuvrage , nomAuteur ; 
  String ?categorie ;
  int nb , nb_dispo , nb_perdu,nb_pretes ;
  double prix  ;
  DateTime date_entree ;
  Ouvrage(this.nomOuvrage,this.nomAuteur,this.categorie,this.nb,this.nb_dispo,this.nb_perdu,this.nb_pretes,this.prix,this.date_entree);
  

}