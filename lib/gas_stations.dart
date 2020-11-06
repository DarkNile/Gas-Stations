class GasStation{
  final String name;
  final String location;
  final String address;
  final String gov;
  final String rating;
  final String lat;
  final String long;

  GasStation({this.name,
    this.location,
    this.address,
    this.gov,
    this.rating,
    this.lat,
    this.long});

  factory GasStation.fromjson(Map<String,dynamic> json){
    return new GasStation(
      name: json['name'] as String,
      location: json['location'] as String,
      address: json['address'] as String,
      gov: json['gov'] as String,
      rating: json['rating'] as String,
      lat: json['lat'] as String,
      long: json['long'] as String,
    );
  }
}