enum ApiEndPoint {
  login("users/login", isAuthRequired: false),
  register("users/register", isAuthRequired: false, successCode: 201),
  locations("locations", isAuthRequired: false),
  courtBooking("court-bookings", isAuthRequired: false),
  courtBookingPost("court-bookings", isAuthRequired: true, successCode: 200),
  userProfileUpdate("users/profiles/upload", isAuthRequired: true),
  userBookings("users/bookings", isAuthRequired: true),
  usersActiveMembership("users/active-membership", isAuthRequired: true),
  playersRanking("users/get-allusers", isAuthRequired: true),
  getAllMembership("memberships", isAuthRequired: true),
  coachList("court-bookings/club-coaches", isAuthRequired: true),
  coachesOff("court-bookings/coaches-off", isAuthRequired: true),
  userBookingsWaitingList(
    // TO FETCH CURRENT USER's Waiting list bookings for past and upcoming bookings
    "users/bookings/waiting-list",
    isAuthRequired: true,
  ),
  getAllMembershipCategory("memberships/membership-category",
      isAuthRequired: true),

  membershipPurchase("memberships/location/purchase", isAuthRequired: true),

  usersMe("users/me", isAuthRequired: true),
  usersPost("users", isAuthRequired: true),
  cancellationPolicy("services/cancellation-policy", isAuthRequired: true),

  customFields("users/custom-fields", isAuthRequired: true),
  paymentDetails("payments/details", isAuthRequired: true),
  paymentsProcess("payments/process", isAuthRequired: true),
  openMatches("services/open-matches", isAuthRequired: true),
  events("services/events", isAuthRequired: true),
  lessons("services/lessons", isAuthRequired: true),
  // services
  services("services", isAuthRequired: true),
  joinService("services/join", isAuthRequired: true),
  //service/cancel
  serviceCancel("services/cancel", isAuthRequired: true),
  serviceWaitingList("services/waiting-list"),
  serviceApprovePlayer("services/request"),
  openMatchCalculatePriceApi("services/open-match-calculate-price",
      isAuthRequired: true),
  serviceDeleteReservedPlayer(""),
  getQuestions("get-questions", isAuthRequired: false, isWithoutClub: true),
  calculateLevel("calculate-level", isAuthRequired: false, isWithoutClub: true),
  calculateWithClubIdLevel("calculate-level", isAuthRequired: true),
  updatePassword("users/update-password", isAuthRequired: true),
  deleteAccount("users/delete-account", isAuthRequired: true),
  couponsVerify("payments/coupons/verify", isAuthRequired: true),
  transaction("transaction", isAuthRequired: true, isWithoutClub: true),
  appUpdates("app-updates", isAuthRequired: false),
  fcmToken("users/user-fcmtoken", successCode: 201),
  bookingLessons("court-bookings/lessons", isAuthRequired: true),
  joinEventWaitingList("services/events/waiting-list", isAuthRequired: true,successCode: 201),

  setUserPassword("users/update-account", isAuthRequired: false),
  checkEmail("users/check-email", isAuthRequired: false),
  userRecoverPassword("users/recover-password", isAuthRequired: false),
  userUpdateRecoverPassword("users/update-recover-password",
      isAuthRequired: false),
  courtPricePost("court-bookings/discount-price",
      isAuthRequired: true, successCode: 201),
  usersAssessments("users/assessments_data", isAuthRequired: true),
  serviceSubmitAssessment("services/submit-assessment"),
  serviceAssessment("services/assessment"),
  usersWallets("users/wallets", isAuthRequired: true),
  userBookingCartList("court-bookings/cart-details", isAuthRequired: true),
  deleteCartBooking("court-bookings/cart", isAuthRequired: true),
  multiBookingPaymentsProcess("payments/process/cart", isAuthRequired: true),
  upgradeBookingToOpen("services/upgrade-to-open-match",
      isAuthRequired: true, successCode: 200),
  fetchChatCount("chat-contacts", isAuthRequired: true, isWebSocketUrl: true),
  transactions("users/transactions", isAuthRequired: true),
  getUserMatchLevels("users/get-user-matchlevels", isAuthRequired: true),
  followFriend("follow-friend/follow", isAuthRequired: true),
  unfollowFriend("follow-friend/unfollow", isAuthRequired: true),
  checkFollowStatus("follow-friend/check", isAuthRequired: true),
  getFollowingList("follow-friend/following", isAuthRequired: true),
  getFollowerList("follow-friend/follower", isAuthRequired: true),
  addPlayersToWaitingList("court-bookings/waiting-list/players", isAuthRequired: true),
  waitingListAction("court-bookings/waiting-list", isAuthRequired: true),
  getUsersList("users/list", isAuthRequired: true),
  ;

  final String _path;
  final int successCode;
  final bool isAuthRequired;
  final bool isWithoutClub;
  final bool isWebSocketUrl;

  const ApiEndPoint(
    String path, {
    this.successCode = 200,
    this.isAuthRequired = true,
    this.isWithoutClub = false,
    this.isWebSocketUrl = false,
  }) : _path = path;

  String path({List<String> id = const [""]}) {
    if (this == ApiEndPoint.paymentDetails) {
      return "payments/${id.first}/details";
    }
    if (this == ApiEndPoint.joinEventWaitingList) {
      return "services/${id.first}/events/waiting-list";
    }
    if (this == ApiEndPoint.cancellationPolicy) {
      return "services/${id.first}/cancellation-policy";
    }
    if (this == ApiEndPoint.services) {
      return "services/${id.first}";
    }
    if (this == ApiEndPoint.upgradeBookingToOpen) {
      return "services/${id.first}/upgrade-to-open-match";
    }
    if (this == ApiEndPoint.paymentsProcess) {
      return "payments/process${(bool.tryParse(id.first) ?? false) ? "/regular-to-openmatch" : ""}";
    }
    if (this == ApiEndPoint.joinService) {
      return "services/join/${id.first}";
    }
    if (this == ApiEndPoint.serviceCancel) {
      return "services/cancel/${id.first}";
    }
    if (this == ApiEndPoint.membershipPurchase) {
      return "memberships/${id.first}/location/${id.last}/purchase";
    }
    if (this == ApiEndPoint.serviceWaitingList) {
      return "services/waiting-list/${id.first}";
    }
    if (this == ApiEndPoint.fetchChatCount) {
      return "chat-contacts/${id.first}";
    }
    if (this == ApiEndPoint.serviceApprovePlayer) {
      return "services/request/${id.first}/${id[1]}/${id.last}";
    }
    if (this == ApiEndPoint.openMatchCalculatePriceApi) {
      return "services/${id.first}/open-match-calculate-price";
    }
    if (this == ApiEndPoint.deleteCartBooking) {
      return "court-bookings/cart/${id.first}";
    }
    if (this == ApiEndPoint.serviceDeleteReservedPlayer) {
      // "services/{serviceID}/reserved/{reservedID}/delete"
      return "services/${id.first}/reserved/${id[1]}/delete";
    }
    if (this == ApiEndPoint.serviceSubmitAssessment) {
      return "services/submit-assessment/${id.first}";
    }
    if (this == ApiEndPoint.usersAssessments) {
      return "users/${id.first}/assessments_data";
    }
    if (this == ApiEndPoint.serviceAssessment) {
      return "services/assessment/${id.first}";
    }
    if (this == ApiEndPoint.getUserMatchLevels) {
      return "users/get-user-matchlevels/${id.first}";
    }
    if (this == ApiEndPoint.followFriend) {
      return "follow-friend/follow/${id.first}";
    }
    if (this == ApiEndPoint.unfollowFriend) {
      return "follow-friend/unfollow/${id.first}";
    }
    if (this == ApiEndPoint.checkFollowStatus) {
      return "follow-friend/check/${id.first}";
    }
    if (this == ApiEndPoint.addPlayersToWaitingList) {
      return "court-bookings/waiting-list/players/${id.first}";
    }
    if (this == ApiEndPoint.waitingListAction) {
      return "court-bookings/waiting-list/${id.first}/${id.last}";
    }

    return _path;
  }
}
