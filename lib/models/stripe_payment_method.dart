class StripePaymentMethod {
  String? id;
  String? object;
  Card? card;
  int? created;
  String? customer;
  bool? livemode;
  String? type;

  StripePaymentMethod(
      {this.id,
      this.object,
      this.card,
      this.created,
      this.customer,
      this.livemode,
      this.type});

  StripePaymentMethod.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    object = json['object'];
    card = json['card'] != null ? Card.fromJson(json['card']) : null;
    created = json['created'];
    customer = json['customer'];
    livemode = json['livemode'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['object'] = object;
    if (card != null) {
      data['card'] = card!.toJson();
    }
    data['created'] = created;
    data['customer'] = customer;
    data['livemode'] = livemode;
    data['type'] = type;
    return data;
  }
}

class Card {
  String? brand;
  Checks? checks;
  String? country;
  String? displayBrand;
  int? expMonth;
  int? expYear;
  String? fingerprint;
  String? funding;
  String? last4;
  Networks? networks;
  ThreeDSecureUsage? threeDSecureUsage;

  Card({
    this.brand,
    this.checks,
    this.country,
    this.displayBrand,
    this.expMonth,
    this.expYear,
    this.fingerprint,
    this.funding,
    this.last4,
    this.networks,
    this.threeDSecureUsage,
  });

  Card.fromJson(Map<String, dynamic> json) {
    brand = json['brand'];
    checks = json['checks'] != null ? Checks.fromJson(json['checks']) : null;
    country = json['country'];
    displayBrand = json['display_brand'];
    expMonth = json['exp_month'];
    expYear = json['exp_year'];
    fingerprint = json['fingerprint'];
    funding = json['funding'];
    last4 = json['last4'];
    networks =
        json['networks'] != null ? Networks.fromJson(json['networks']) : null;
    threeDSecureUsage = json['three_d_secure_usage'] != null
        ? ThreeDSecureUsage.fromJson(json['three_d_secure_usage'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['brand'] = brand;
    if (checks != null) {
      data['checks'] = checks!.toJson();
    }
    data['country'] = country;
    data['display_brand'] = displayBrand;
    data['exp_month'] = expMonth;
    data['exp_year'] = expYear;
    data['fingerprint'] = fingerprint;
    data['funding'] = funding;
    data['last4'] = last4;
    if (networks != null) {
      data['networks'] = networks!.toJson();
    }
    if (threeDSecureUsage != null) {
      data['three_d_secure_usage'] = threeDSecureUsage!.toJson();
    }
    return data;
  }
}

class Checks {
  String? addressLine1Check;
  String? addressPostalCodeCheck;
  String? cvcCheck;

  Checks({this.addressLine1Check, this.addressPostalCodeCheck, this.cvcCheck});

  Checks.fromJson(Map<String, dynamic> json) {
    addressLine1Check = json['address_line1_check'];
    addressPostalCodeCheck = json['address_postal_code_check'];
    cvcCheck = json['cvc_check'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['address_line1_check'] = addressLine1Check;
    data['address_postal_code_check'] = addressPostalCodeCheck;
    data['cvc_check'] = cvcCheck;
    return data;
  }
}

class Networks {
  List<String>? available;
  String? preferred;

  Networks({this.available, this.preferred});

  Networks.fromJson(Map<String, dynamic> json) {
    available = json['available'].cast<String>();
    preferred = json['preferred'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['available'] = available;
    data['preferred'] = preferred;
    return data;
  }
}

class ThreeDSecureUsage {
  bool? supported;

  ThreeDSecureUsage({this.supported});

  ThreeDSecureUsage.fromJson(Map<String, dynamic> json) {
    supported = json['supported'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['supported'] = supported;
    return data;
  }
}
