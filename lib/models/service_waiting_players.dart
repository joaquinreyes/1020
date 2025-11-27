import 'package:hop/models/base_classes/booking_player_base.dart';

class ServiceWaitingPlayers extends BookingPlayerBase {
  ServiceWaitingPlayers({
    super.reservedPlayersCount,
    super.isWaiting,
    super.customer,
    super.otherPlayer,
    super.id,
    super.position
  });

  ServiceWaitingPlayers.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    status = json['status'];
    customer = json['customer'] != null
        ? BookingCustomerBase.fromJson(json['customer'])
        : null;
  }
}
