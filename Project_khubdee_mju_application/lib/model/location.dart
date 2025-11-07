class Location {
  String? location_id;
  String? location_name;

  Location({this.location_id, this.location_name});

  Map<String, dynamic> fromLocationToJson() {
    return <String, dynamic>{
      'location_id': location_id,
      'location_name': location_name,
    };
  }

  factory Location.fromJsonToLocation(Map<String, dynamic> json) => 
    Location(
      location_id: json['location_id'], 
      location_name: json['location_name']);
}
