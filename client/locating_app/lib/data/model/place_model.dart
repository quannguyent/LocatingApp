import 'package:json_annotation/json_annotation.dart';
part 'place_model.g.dart';

@JsonSerializable(explicitToJson: true)
class PlaceModel {
  @JsonKey(name: "id", defaultValue: "")
  String id;

  @JsonKey(name: "name", defaultValue: "")
  String name;

  @JsonKey(name: "address", defaultValue: "")
  String address;

  @JsonKey(name: "rad", defaultValue: null)
  double rad;

  @JsonKey(name: "lat", defaultValue: null)
  double lat;

  @JsonKey(name: "lng", defaultValue: null)
  double lng;

  @JsonKey(name: "created_at", defaultValue: null)
  double createdAt;

  PlaceModel({
    this.id,
    this.name,
    this.address,
    this.rad,
    this.lat,
    this.lng,
    this.createdAt,
  });

  static PlaceModel fromJson(Map<String, dynamic> json) => _$PlaceModelFromJson(json);

  Map<String, dynamic> toJson() => _$PlaceModelToJson(this);
}
