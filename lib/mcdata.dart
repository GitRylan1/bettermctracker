// To parse this JSON data, do
//
//     final mcdata = mcdataFromJson(jsonString);

import 'dart:convert';

List<Mcdata> mcdataFromJson(String str) => List<Mcdata>.from(json.decode(str).map((x) => Mcdata.fromJson(x)));

String mcdataToJson(List<Mcdata> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Mcdata {
  int id;
  String displayName;
  String name;
  double? hardness;
  int stackSize;
  bool diggable;
  BoundingBox boundingBox;
  List<DropElement> drops;
  bool transparent;
  int emitLight;
  int filterLight;
  // double resistance;
  // Material? material;
  // Map<String, bool>? harvestTools;
  // List<Variation>? variations;

  Mcdata({
    required this.id,
    required this.displayName,
    required this.name,
    required this.hardness,
    required this.stackSize,
    required this.diggable,
    required this.boundingBox,
    required this.drops,
    required this.transparent,
    required this.emitLight,
    required this.filterLight,
    // required this.resistance,
    // this.material,
    // this.harvestTools,
    // this.variations,
  });

  factory Mcdata.fromJson(Map<String, dynamic> json) => Mcdata(
    id: json["id"],
    displayName: json["displayName"],
    name: json["name"],
    hardness: json["hardness"]?.toDouble(),
    stackSize: json["stackSize"],
    diggable: json["diggable"],
    boundingBox: boundingBoxValues.map[json["boundingBox"]]!,
    drops: List<DropElement>.from(json["drops"].map((x) => DropElement.fromJson(x))),
    transparent: json["transparent"],
    emitLight: json["emitLight"],
    filterLight: json["filterLight"],
    // resistance: json["resistance"]?.toDouble(),
    // material: materialValues.map[json["material"]]!,
    // harvestTools: Map.from(json["harvestTools"]!).map((k, v) => MapEntry<String, bool>(k, v)),
    // variations: json["variations"] == null ? [] : List<Variation>.from(json["variations"]!.map((x) => Variation.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "displayName": displayName,
    "name": name,
    "hardness": hardness,
    "stackSize": stackSize,
    "diggable": diggable,
    "boundingBox": boundingBoxValues.reverse[boundingBox],
    "drops": List<dynamic>.from(drops.map((x) => x.toJson())),
    "transparent": transparent,
    "emitLight": emitLight,
    "filterLight": filterLight,
    // "resistance": resistance,
    // "material": materialValues.reverse[material],
    // "harvestTools": Map.from(harvestTools!).map((k, v) => MapEntry<String, dynamic>(k, v)),
    // "variations": variations == null ? [] : List<dynamic>.from(variations!.map((x) => x.toJson())),
  };
}

enum BoundingBox {
  BLOCK,
  EMPTY
}

final boundingBoxValues = EnumValues({
  "block": BoundingBox.BLOCK,
  "empty": BoundingBox.EMPTY
});

class DropElement {
  dynamic drop;
  double? minCount;
  int? maxCount;

  DropElement({
    required this.drop,
    this.minCount,
    this.maxCount,
  });

  factory DropElement.fromJson(Map<String, dynamic> json) => DropElement(
    drop: json["drop"],
    minCount: json["minCount"]?.toDouble(),
    maxCount: json["maxCount"],
  );

  Map<String, dynamic> toJson() => {
    "drop": drop,
    "minCount": minCount,
    "maxCount": maxCount,
  };
}

class DropDropClass {
  int id;
  int metadata;

  DropDropClass({
    required this.id,
    required this.metadata,
  });

  factory DropDropClass.fromJson(Map<String, dynamic> json) => DropDropClass(
    id: json["id"],
    metadata: json["metadata"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "metadata": metadata,
  };
}

enum Material {
  DIRT,
  LEAVES,
  PLANT,
  ROCK,
  WEB,
  WOOD,
  WOOL
}

final materialValues = EnumValues({
  "dirt": Material.DIRT,
  "leaves": Material.LEAVES,
  "plant": Material.PLANT,
  "rock": Material.ROCK,
  "web": Material.WEB,
  "wood": Material.WOOD,
  "wool": Material.WOOL
});

class Variation {
  int metadata;
  String displayName;

  Variation({
    required this.metadata,
    required this.displayName,
  });

  factory Variation.fromJson(Map<String, dynamic> json) => Variation(
    metadata: json["metadata"],
    displayName: json["displayName"],
  );

  Map<String, dynamic> toJson() => {
    "metadata": metadata,
    "displayName": displayName,
  };
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
