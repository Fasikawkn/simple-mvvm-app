import 'dart:convert';

// List<Medicine> medicineFromJson(String str) => List<Medicine>.from(json.decode(str).map((x) => Medicine.fromJson(x)));

// String medicineToJson(List<Medicine> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Medicine {
    Medicine({
      required this.name,
      required this.dose,
      required this.strength,
    });

    String name;
    String dose;
    String strength;

    factory Medicine.fromJson(Map<String, dynamic> json) => Medicine(
        name: json["name"],
        dose: json["dose"],
        strength: json["strength"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "dose": dose,
        "strength": strength,
    };
}
