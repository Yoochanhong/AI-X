class Price {
  Crushed? crushed;
  Crushed? damaged;
  Crushed? scratched;
  Crushed? seperationed;
  String? totalPrice;

  Price(
      {this.crushed,
        this.damaged,
        this.scratched,
        this.seperationed,
        this.totalPrice});

  Price.fromJson(Map<String, dynamic> json) {
    crushed =
    json['crushed'] != null ? new Crushed.fromJson(json['crushed']) : null;
    damaged =
    json['damaged'] != null ? new Crushed.fromJson(json['damaged']) : null;
    scratched = json['scratched'] != null
        ? new Crushed.fromJson(json['scratched'])
        : null;
    seperationed = json['seperationed'] != null
        ? new Crushed.fromJson(json['seperationed'])
        : null;
    totalPrice = json['total_price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.crushed != null) {
      data['crushed'] = this.crushed!.toJson();
    }
    if (this.damaged != null) {
      data['damaged'] = this.damaged!.toJson();
    }
    if (this.scratched != null) {
      data['scratched'] = this.scratched!.toJson();
    }
    if (this.seperationed != null) {
      data['seperationed'] = this.seperationed!.toJson();
    }
    data['total_price'] = this.totalPrice;
    return data;
  }
}

class Crushed {
  String? area;
  String? price;

  Crushed({this.area, this.price});

  Crushed.fromJson(Map<String, dynamic> json) {
    area = json['area'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['area'] = this.area;
    data['price'] = this.price;
    return data;
  }
}