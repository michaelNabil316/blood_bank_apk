//translation
final governments = [
  'Alexandera',
  'Cairo',
  'Beheira',
  'Beni Suief',
  'Dakahlia',
  'Damietta',
  'Faiyuim',
  'Al-minya',
  'Aswan',
];
final alex = ['sidi beshr', 'mamora', 'el nozha'];
final cair = ['nasr city', '6th octobr', 'al obour'];
final alminya = ['maghagha', 'samalout', 'der mawas'];
final aswan = ['aswan', 'adfo', 'kom ambo'];
final beheira = ['Badr', 'Edku', 'rosetta'];
final beniSuief = ['El Fashin', 'El Wasta', 'Biba'];
final dakahlia = ['El Gamaliya', 'El kurdi', 'Delqas'];
final damietta = ['El Zarqa', 'Faraskur', 'Kafr Saad'];
final faiyuim = ['Ibsgeway', 'Tamiya', 'Itsa'];
cityList(String value) {
  if (value == 'Alexandera') return alex;
  if (value == 'Cairo') return cair;
  if (value == 'Al-minya') return alminya;
  if (value == 'Aswan') return aswan;
  //-------
  if (value == 'Beheira') return beheira;
  if (value == 'Beni Suief') return beniSuief;
  if (value == 'Dakahlia') return dakahlia;
  if (value == 'Damietta') return damietta;
  if (value == 'Faiyuim') return faiyuim;
}
