
import 'package:mysql1/mysql1.dart';

class Ouvrage {
 late String nomOuvrage , nomAuteur ; 
  late  String ?categorie ;
 late int? idouvrage;
 late int nb , nb_dispo , nb_perdu ,prets_tot;
  late double prix  ;
  late DateTime date_entree ;
  
  Ouvrage.define( this.idouvrage, this.nomOuvrage,this.nomAuteur,this.categorie,this.nb,this.nb_dispo,this.nb_perdu,this.prix,this.date_entree);
  Ouvrage.forstats(this.nomOuvrage,this.nomAuteur,this.prets_tot);
  

  Future<void> Modifier_ouvrage({required MySqlConnection mySqlConnection , required Ouvrage ouvrage})async{
    try {
      mySqlConnection.query("call update_ouvrage(?,?,?,?,?,?);",[ouvrage.idouvrage,ouvrage.nomOuvrage,ouvrage.nomAuteur,ouvrage.prix,ouvrage.nb,ouvrage.categorie]);
    } catch (e) {
      print(e);
    }
  }
}