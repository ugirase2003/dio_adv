class Emp {
  int id;
  String name;
  String department;
  String img;

  Emp(this.id, this.name, this.department, this.img);
  factory Emp.fromJson(Map<String, dynamic> json) {
    return Emp(
        int.parse(json["id"]), json["name"], json["department"], json["img"]);
  }

  // static Map<String, dynamic> toJson(Emp emp) {
  //   return {
  //     "name": emp.name,
  //     "deparment": emp.department,
  //     "id": emp.id,
  //   };
  // }
}
