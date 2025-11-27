class CourtPriceModel {
  double? price;
  double? discountedPrice;
  double? openMatchPrice;
  double? reservePrice;
  double? openMatchDiscountedPrice;
  CancellationPolicyCourtPrice? cancellationPolicy;

  CourtPriceModel(
      {this.price,
      this.discountedPrice,
      this.reservePrice,
      this.openMatchPrice,
      this.openMatchDiscountedPrice,
      this.cancellationPolicy});

  CourtPriceModel.fromJson(Map<String, dynamic> json) {
    price = (json['calculatedPrice']['price'] ?? 0).toDouble();
    discountedPrice =
        (json['calculatedPrice']['discountedPrice'] ?? 0).toDouble();
    reservePrice =
        (json['calculatedPrice']['reservePrice'] ?? 0).toDouble();
    openMatchPrice =
        (json['calculatedPrice']['openMatchPrice'] ?? 0).toDouble();
    openMatchDiscountedPrice = (json['calculatedPrice']
                ['openMatchDiscountedPrice'] ??
            json['calculatedPrice']['openMatchdiscountedPrice'] ??
            0)
        .toDouble();
    cancellationPolicy = json['cancellationPolicy'] != null
        ? new CancellationPolicyCourtPrice.fromJson(json['cancellationPolicy'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['price'] = price;
    data['discountedPrice'] = discountedPrice;
    data['openMatchDiscountedPrice'] = openMatchDiscountedPrice;
    data['reservePrice'] = reservePrice;
    data['openMatchPrice'] = openMatchPrice;
    if (this.cancellationPolicy != null) {
      data['cancellationPolicy'] = this.cancellationPolicy!.toJson();
    }
    return data;
  }
}

class CancellationPolicyCourtPrice {
  int? cancellationTime;
  int? openMatchCancellationTime;

  CancellationPolicyCourtPrice({this.cancellationTime, this.openMatchCancellationTime});

  int? get cancellationTimeInHours {
    if (cancellationTime == null) {
      return null;
    }
    return (cancellationTime ?? 0) ~/ 3600;
  }

  int? get openMatchCancellationTimeInHours {
    if (openMatchCancellationTime == null) {
      return null;
    }
    return (openMatchCancellationTime ?? 0) ~/ 3600;
  }

  CancellationPolicyCourtPrice.fromJson(Map<String, dynamic> json) {
    cancellationTime = json['cancellationTime'];
    openMatchCancellationTime = json['openMatchCancellationTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cancellationTime'] = this.cancellationTime;
    data['openMatchCancellationTime'] = this.openMatchCancellationTime;
    return data;
  }
}
