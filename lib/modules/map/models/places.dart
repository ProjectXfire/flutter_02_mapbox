import 'dart:convert';

class PlacesResponse {
  PlacesResponse({
    required this.type,
    required this.query,
    required this.features,
    required this.attribution,
  });

  final String type;
  final List<dynamic> query;
  final List<Feature> features;
  final String attribution;

  factory PlacesResponse.fromJson(String str) =>
      PlacesResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory PlacesResponse.fromMap(Map<String, dynamic> json) => PlacesResponse(
        type: json["type"],
        query: List<dynamic>.from(json["query"].map((x) => x)),
        features:
            List<Feature>.from(json["features"].map((x) => Feature.fromMap(x))),
        attribution: json["attribution"],
      );

  Map<String, dynamic> toMap() => {
        "type": type,
        "query": List<dynamic>.from(query.map((x) => x)),
        "features": List<dynamic>.from(features.map((x) => x.toMap())),
        "attribution": attribution,
      };
}

class Feature {
  Feature({
    required this.id,
    required this.type,
    required this.placeType,
    required this.properties,
    this.textEn,
    //this.languageEn,
    this.placeNameEn,
    required this.text,
    this.language,
    required this.placeName,
    required this.center,
    required this.geometry,
    required this.context,
  });

  final String id;
  final String type;
  final List<String> placeType;
  final Properties properties;
  final String? textEn;
  //final Language? languageEn;
  final String? placeNameEn;
  final String text;
  final String? language;
  final String placeName;
  final List<double> center;
  final Geometry geometry;
  final List<Context> context;

  factory Feature.fromJson(String str) => Feature.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Feature.fromMap(Map<String, dynamic> json) => Feature(
        id: json["id"],
        type: json["type"],
        placeType: List<String>.from(json["place_type"].map((x) => x)),
        properties: Properties.fromMap(json["properties"]),
        textEn: json["text_en"],
        /*languageEn: json["language_en"] == null
            ? null
            : languageValues.map[json["language_en"]],*/
        placeNameEn: json["place_name_en"],
        text: json["text"],
        language: json["language"],
        placeName: json["place_name"],
        center: List<double>.from(json["center"].map((x) => x.toDouble())),
        geometry: Geometry.fromMap(json["geometry"]),
        context:
            List<Context>.from(json["context"].map((x) => Context.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "type": type,
        "place_type": List<dynamic>.from(placeType.map((x) => x)),
        "properties": properties.toMap(),
        "text_en": textEn,
        /*"language_en":
            languageEn == null ? null : languageValues.reverse[languageEn],*/
        "place_name_en": placeNameEn,
        "text": text,
        "language": language == null ? null : languageValues.reverse[language],
        "place_name": placeName,
        "center": List<dynamic>.from(center.map((x) => x)),
        "geometry": geometry.toMap(),
        "context": List<dynamic>.from(context.map((x) => x.toMap())),
      };
}

class Context {
  Context({
    required this.id,
    this.textEn,
    required this.text,
    this.wikidata,
    //this.languageEn,
    this.language,
    this.shortCode,
  });

  final String id;
  final String? textEn;
  final String text;
  final String? wikidata;
  //final Language? languageEn;
  final String? language;
  final ShortCode? shortCode;

  factory Context.fromJson(String str) => Context.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Context.fromMap(Map<String, dynamic> json) => Context(
        id: json["id"],
        textEn: json["text_en"],
        text: json["text"],
        wikidata: json["wikidata"],
        /*languageEn: json["language_en"] == null
            ? null
            : languageValues.map[json["language_en"]],*/
        language: json["language"],
        shortCode: json["short_code"] == null
            ? null
            : shortCodeValues.map[json["short_code"]],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "text_en": textEn,
        "text": text,
        "wikidata": wikidata,
        /*"language_en":
            languageEn == null ? null : languageValues.reverse[languageEn],*/
        "language": language == null ? null : languageValues.reverse[language],
        "short_code":
            shortCode == null ? null : shortCodeValues.reverse[shortCode],
      };
}

enum Language { EN }

final languageValues = EnumValues({"en": Language.EN});

enum ShortCode { PE_CAL, PE, PE_LMA }

final shortCodeValues = EnumValues({
  "pe": ShortCode.PE,
  "PE-CAL": ShortCode.PE_CAL,
  "PE-LMA": ShortCode.PE_LMA
});

class Geometry {
  Geometry({
    required this.coordinates,
    required this.type,
  });

  final List<double> coordinates;
  final String type;

  factory Geometry.fromJson(String str) => Geometry.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Geometry.fromMap(Map<String, dynamic> json) => Geometry(
        coordinates:
            List<double>.from(json["coordinates"].map((x) => x.toDouble())),
        type: json["type"],
      );

  Map<String, dynamic> toMap() => {
        "coordinates": List<dynamic>.from(coordinates.map((x) => x)),
        "type": type,
      };
}

class Properties {
  Properties({
    this.address,
    this.foursquare,
    this.wikidata,
    this.landmark,
    this.category,
    this.maki,
  });

  final String? address;
  final String? foursquare;
  final String? wikidata;
  final bool? landmark;
  final String? category;
  final String? maki;

  factory Properties.fromJson(String str) =>
      Properties.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Properties.fromMap(Map<String, dynamic> json) => Properties(
        address: json["address"],
        foursquare: json["foursquare"],
        wikidata: json["wikidata"],
        landmark: json["landmark"],
        category: json["category"],
        maki: json["maki"],
      );

  Map<String, dynamic> toMap() => {
        "address": address,
        "foursquare": foursquare,
        "wikidata": wikidata,
        "landmark": landmark,
        "category": category,
        "maki": maki,
      };
}

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String>? reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap ??= map.map((k, v) => MapEntry(v, k));
    return reverseMap!;
  }
}
