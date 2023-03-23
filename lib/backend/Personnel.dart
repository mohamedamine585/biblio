class Personnel {
 final String nom , prenom , email,grade,mot_de_passe,adresse;
   final int cin ;
 final int ? age , minutes_en_service , prets_effectues;
  final DateTime date_entree ;
  DateTime ?derniere_activite ;
  

  Personnel( this.nom, this.prenom, this.email, this.grade, this.age, this.date_entree, this.prets_effectues, this.mot_de_passe, this.adresse,this.cin, this.minutes_en_service);
 
}