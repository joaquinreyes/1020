import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hop/globals/api_endpoints.dart';
import 'package:hop/globals/utils.dart';
import 'package:hop/managers/api_manager.dart';
import 'package:hop/managers/user_manager.dart';
import 'package:hop/models/app_user.dart';
import 'package:hop/models/custom_fields.dart';
import 'package:hop/models/register_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:http/http.dart' as http;

import '../globals/constants.dart';
import '../managers/pagination_params.dart';
import '../models/players_ranking.dart';
import '../models/transaction_model.dart';
import '../models/user_assessment.dart';
import '../models/wallet_info.dart';
import '../models/user_match_levels.dart';
import '../models/follow_list.dart';
import '../models/user_search_response.dart';
import '../screens/app_provider.dart';
import '../utils/pagination_state.dart';

part 'user_repo.g.dart';

class AuthRepo {
  Future<AppUser> signIn(String email, String password, Ref ref) async {
    try {
      final apiManager = ref.read(apiManagerProvider);
      final response = await apiManager.post(ref, ApiEndPoint.login, {
        'email': email,
        'password': password,
      });
      if (response is Map<String, dynamic>) {
        final AppUser user = AppUser.fromJson(response);
        await ref.read(userManagerProvider).authenticate(ref, user);
        return user;
      }
      throw "Some error occured";
    } catch (e) {
      if (e is Map<String, dynamic>) {
        if (e['message'].toString().toLowerCase() ==
            'Password field is missing'.toLowerCase()) {
          final done = await setPassword(ref, email, password);
          if (done) {
            return ref.watch(authRepoProvider).signIn(email, password, ref);
          }
        } else {
          throw e['message'];
        }
      }
      rethrow;
    }
  }

  Future<bool> setPassword(Ref ref, String email, String password) async {
    try {
      final apiManager = ref.read(apiManagerProvider);
      await apiManager.post(ref, ApiEndPoint.setUserPassword, {
        'email': email,
        'password': password,
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<AppUser> signup(RegisterModel? model, Ref ref) async {
    try {
      final apiManager = ref.read(apiManagerProvider);
      final sports = ref.read(settingSportsValueProvider);
      final response =
          await apiManager.post(ref, ApiEndPoint.register, model!.toJson(sports));
      if (response is Map<String, dynamic>) {
        final AppUser user = AppUser.fromJson(response);
        await ref.read(userManagerProvider).authenticate(ref, user);
        return user;
      }
      throw "Some error occured";
    } catch (e) {
      if (e is Map<String, dynamic>) {
        throw e['message'];
      }
      rethrow;
    }
  }

  Future signout(Ref ref) async {
    try {
      final userManager = ref.read(userManagerProvider);
      await userManager.signOut(ref);
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> updateProfile(Ref ref, File? originalFile) async {
    try {
      if (originalFile == null) {
        return false;
      }
      final userManager = ref.read(userManagerProvider);
      final apiManager = ref.read(apiManagerProvider);
      final file = await Utils.bakeImageOrientation(originalFile);
      if (file == null) {
        throw "Some error occured while baking image";
      }
      final token = userManager.user?.accessToken;
      String fileName = file.path.split('/').last;
      String extension = fileName.split('.').last;
      http.MultipartFile multipartFile = await http.MultipartFile.fromPath(
          "image", file.path,
          filename: fileName, contentType: DioMediaType('image', extension));
      final response = await apiManager.patchMultipart(
        ref,
        ApiEndPoint.userProfileUpdate,
        multipartData: {
          'image': multipartFile,
        },
        token: token,
      );
      if (response is Map<String, dynamic>) {
        final AppUser appUser = ref.read(userManagerProvider).user!;
        appUser.user!.profileUrl = response["data"]["profile_url"];
        userManager.authenticate(ref, appUser);
      }
      return true;
    } catch (e) {
      if (e is Map<String, dynamic>) {
        throw e['message'];
      }
      rethrow;
    }
  }

  Future<bool> fetchUser(Ref ref) async {
    try {
      final apiManager = ref.read(apiManagerProvider);
      final token = ref.read(userManagerProvider).user?.accessToken;
      final response =
          await apiManager.get(ref, ApiEndPoint.usersMe, token: token);
      final User user;

      if (response is Map<String, dynamic>) {
        user = User.fromJson(response["user"]);
        final AppUser appUser = ref.read(userManagerProvider).user!;
        if (appUser.user != null) {
          appUser.user?.copy(user);
        } else {
          appUser.user = user;
        }
        ref.read(userManagerProvider).authenticate(ref, appUser);
        return appUser.user?.isBlocked ?? false;
      }

      throw "Some error occured";
    } catch (e) {
      if (e is Map<String, dynamic>) {
        throw e['message'];
      }
      rethrow;
    }
  }

  Future<bool> updatUser(Ref ref, User user) async {
    try {
      final apiManager = ref.read(apiManagerProvider);
      final token = ref.read(userManagerProvider).user?.accessToken;
      final response = await apiManager.patch(
        ref,
        ApiEndPoint.usersPost,
        user.toJson(),
        token: token,
      );
      if (response is Map<String, dynamic>) {
        user = User.fromJson(response["data"]["user"]);
        final AppUser appUser = ref.read(userManagerProvider).user!;
        if (appUser.user != null) {
          appUser.user?.copy(user);
        } else {
          appUser.user = user;
        }
        ref.read(userManagerProvider).authenticate(ref, appUser);
        return true;
      }
      throw "Some error occured";
    } catch (e) {
      if (e is Map<String, dynamic>) {
        throw e['message'];
      }
      rethrow;
    }
  }

  Future<List<CustomFields>> fetchAllCustomFields(Ref ref) async {
    try {
      final apiManager = ref.read(apiManagerProvider);
      final token = ref.read(userManagerProvider).user?.accessToken;
      final response = (await apiManager.get(ref, ApiEndPoint.customFields,
          token: token))["data"];
      if (response is List) {
        List<CustomFields> customFields = [];
        for (var element in response) {
          customFields.add(CustomFields.fromJson(element));
        }
        customFields.removeWhere((element) => !element.isVisible);
        return customFields;
      }
      throw "Some error occured";
    } catch (e) {
      if (e is Map<String, dynamic>) {
        throw e['message'];
      }
      rethrow;
    }
  }

  Future<bool> updatePassword(Ref ref,
      {required String oldPassword, required String newPassword}) async {
    try {
      final apiManager = ref.read(apiManagerProvider);
      final token = ref.read(userManagerProvider).user?.accessToken;
      await apiManager.patch(
        ref,
        ApiEndPoint.updatePassword,
        {
          "current_password": oldPassword,
          "new_password": newPassword,
        },
        token: token,
      );
      return true;
    } catch (e) {
      if (e is Map<String, dynamic>) {
        throw e['message'];
      }
      rethrow;
    }
  }

  Future<bool> deleteAccount(Ref ref, {required String password}) async {
    try {
      final apiManager = ref.read(apiManagerProvider);
      final token = ref.read(userManagerProvider).user?.accessToken;
      await apiManager.patch(
        ref,
        ApiEndPoint.deleteAccount,
        token: token,
        {
          "password": password,
        },
      );
      return true;
    } catch (e) {
      if (e is Map<String, dynamic>) {
        throw e['message'];
      }
      rethrow;
    }
  }

  Future<void> saveFCMToken(Ref ref, String fcmToken) async {
    try {
      final apiManager = ref.read(apiManagerProvider);
      final token = ref.read(userManagerProvider).user?.accessToken;
      final res = await apiManager.post(
        ref,
        ApiEndPoint.fcmToken,
        token: token,
        {
          "token": fcmToken,
        },
      );
      return res;
    } catch (e) {
      if (e is Map<String, dynamic>) {
        throw e['message'];
      }
      rethrow;
    }
  }

  Future<bool?> resetPassword(Ref ref, String email) async {
    try {
      final apiManager = ref.read(apiManagerProvider);

      await apiManager.post(ref, ApiEndPoint.userRecoverPassword, {
        'email': email,
      });

      return true;
    } catch (e) {
      if (e is Map<String, dynamic>) {
        throw e['message'];
      }
      rethrow;
    }
  }

  Future<bool?> updateRecoveryPassword(
      Ref ref, String email, String password, String token) async {
    try {
      final apiManager = ref.read(apiManagerProvider);
      await apiManager.post(ref, ApiEndPoint.userUpdateRecoverPassword,
          {'email': email, "recovery_token": token, "new_password": password});

      return true;
    } catch (e) {
      if (e is Map<String, dynamic>) {
        throw e['message'];
      }
      rethrow;
    }
  }

  Future<UserAssessment> fetchUserAssessment(Ref ref, int id) async {
    try {
      final apiManager = ref.read(apiManagerProvider);
      final token = ref.read(userManagerProvider).user?.accessToken;
      final response = await apiManager.get(ref, ApiEndPoint.usersAssessments,
          token: token, pathParams: [id.toString()]);
      return UserAssessment.fromJson(response["data"]);
    } catch (e) {
      if (e is Map<String, dynamic>) {
        throw e['message'];
      }
      rethrow;
    }
  }

  Future<List<TransactionModel>> transactions(Ref ref) async {
    try {
      final apiManager = ref.read(apiManagerProvider);
      final token = ref.read(userManagerProvider).user?.accessToken;
      final response = (await apiManager.get(ref, ApiEndPoint.transactions,
          token: token))["data"]["transactions"];
      if (response is List) {
        List<TransactionModel> wallets = [];
        for (var element in response) {
          wallets.add(TransactionModel.fromJson(element));
        }
        return wallets;
      }
      throw "Some error occurred";
    } catch (e) {
      if (e is Map<String, dynamic>) {
        throw e['message'];
      }
      rethrow;
    }
  }

  Future<PlayersRanking> fetchPlayersRanking(Ref ref,
      {required int page,
      required int limit,
      required String sportName}) async {
    try {
      final token = ref.read(userManagerProvider).user?.accessToken ?? "";
      final Map<String, dynamic> queryParams = {
        "limit": limit,
        "page": page,
        "sport_name": "padel",
      };
      final response = await ref.read(apiManagerProvider).get(
            ref,
            ApiEndPoint.playersRanking,
            queryParams: queryParams,
            token: token,
          );
      return PlayersRanking.fromJson(response["data"]);
    } catch (e) {
      if (e is Map<String, dynamic>) {
        throw e['message'];
      }
      rethrow;
    }
  }

  Future<List<WalletInfo>> walletInfo(Ref ref) async {
    try {
      final apiManager = ref.read(apiManagerProvider);
      final token = ref.read(userManagerProvider).user?.accessToken ?? "";

      if(token.trim().isEmpty){
        return [];
      }

      final response = (await apiManager.get(ref, ApiEndPoint.usersWallets,
          token: token))["data"];
      if (response is List) {
        List<WalletInfo> wallets = [];
        for (var element in response) {
          wallets.add(WalletInfo.fromJson(element));
        }
        return wallets;
      }
      throw "Some error occurred";
    } catch (e) {
      if (e is Map<String, dynamic>) {
        throw e['message'];
      }
      rethrow;
    }
  }

  Future<List<MatchLevel>> getUserMatchLevels(Ref ref,
      {required int userId, required int matchNumber, required String sportName}) async {
    try {
      final apiManager = ref.read(apiManagerProvider);
      final token = ref.read(userManagerProvider).user?.accessToken;
      final Map<String, dynamic> queryParams = {
        "match_number": matchNumber,
        "sport_name": sportName,
      };
      final response = await apiManager.get(
        ref,
        ApiEndPoint.getUserMatchLevels,
        pathParams: [userId.toString()],
        queryParams: queryParams,
        token: token,
      );

      if (response is Map<String, dynamic>) {
        final userMatchLevels = UserMatchLevelsResponse.fromJson(response);
        return (userMatchLevels.data ?? []).reversed.toList();
      }
      throw "Some error occurred";
    } catch (e) {
      if (e is Map<String, dynamic>) {
        throw e['message'];
      }
      rethrow;
    }
  }

  Future<bool> followFriend(Ref ref, {required int userId}) async {
    try {
      final apiManager = ref.read(apiManagerProvider);
      final token = ref.read(userManagerProvider).user?.accessToken;
      await apiManager.post(
        ref,
        ApiEndPoint.followFriend,
        {},
        token: token,
        pathParams: [userId.toString()],
      );
      return true;
    } catch (e) {
      if (e is Map<String, dynamic>) {
        throw e['message'];
      }
      rethrow;
    }
  }

  Future<bool> unfollowFriend(Ref ref, {required int userId}) async {
    try {
      final apiManager = ref.read(apiManagerProvider);
      final token = ref.read(userManagerProvider).user?.accessToken;
      await apiManager.delete(
        ref,
        ApiEndPoint.unfollowFriend,
        token: token,
        pathParams: [userId.toString()],
      );
      return true;
    } catch (e) {
      if (e is Map<String, dynamic>) {
        throw e['message'];
      }
      rethrow;
    }
  }

  Future<bool> checkFollowStatus(Ref ref, {required int userId}) async {
    try {
      final apiManager = ref.read(apiManagerProvider);
      final token = ref.read(userManagerProvider).user?.accessToken;
      final response = await apiManager.get(
        ref,
        ApiEndPoint.checkFollowStatus,
        token: token,
        pathParams: [userId.toString()],
      );
      if (response is Map<String, dynamic>) {
        return response['data']['following']['following']['id'] == userId;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<FollowList> getFollowingList(Ref ref) async {
    try {
      final apiManager = ref.read(apiManagerProvider);
      final token = ref.read(userManagerProvider).user?.accessToken;
      final response = await apiManager.get(
        ref,
        ApiEndPoint.getFollowingList,
        token: token,
      );
      if (response is Map<String, dynamic>) {
        return FollowList.fromJson(response["data"]);
      }
      throw "Some error occurred";
    } catch (e) {
      if (e is Map<String, dynamic>) {
        throw e['message'];
      }
      rethrow;
    }
  }

  Future<FollowList> getFollowerList(Ref ref) async {
    try {
      final apiManager = ref.read(apiManagerProvider);
      final token = ref.read(userManagerProvider).user?.accessToken;
      final response = await apiManager.get(
        ref,
        ApiEndPoint.getFollowerList,
        token: token,
      );
      if (response is Map<String, dynamic>) {
        return FollowList.fromJson(response);
      }
      throw "Some error occurred";
    } catch (e) {
      if (e is Map<String, dynamic>) {
        throw e['message'];
      }
      rethrow;
    }
  }

  Future<UserSearchResponse> searchUsers(
    Ref ref, {
    required int page,
    required int pageSize,
    required String search,
  }) async {
    try {
      final apiManager = ref.read(apiManagerProvider);
      final token = ref.read(userManagerProvider).user?.accessToken;
      final Map<String, dynamic> queryParams = {
        "page": page,
        "pageSize": pageSize,
        "search": search,
      };
      final response = await apiManager.get(
        ref,
        ApiEndPoint.getUsersList,
        token: token,
        queryParams: queryParams,
      );
      if (response is Map<String, dynamic>) {
        return UserSearchResponse.fromJson(response);
      }
      throw "Some error occurred";
    } catch (e) {
      if (e is Map<String, dynamic>) {
        throw e['message'];
      }
      rethrow;
    }
  }
}

@Riverpod(keepAlive: true)
AuthRepo authRepo(Ref ref) {
  return AuthRepo();
}

@riverpod
Future<AppUser?> loginUser(
    LoginUserRef ref, String email, String password) async {
  return ref.watch(authRepoProvider).signIn(email, password, ref);
}

@riverpod
Future<AppUser?> registerUser(RegisterUserRef ref, RegisterModel model) async {
  return ref.watch(authRepoProvider).signup(model, ref);
}

@Riverpod(keepAlive: true)
Future<bool> fetchUser(FetchUserRef ref) async {
  return ref.watch(authRepoProvider).fetchUser(ref);
}

@riverpod
Future<bool> updateUser(Ref ref, User user) async {
  return ref.watch(authRepoProvider).updatUser(ref, user);
}

@riverpod
Future<bool> updateProfile(Ref ref, File? file) async {
  return ref.watch(authRepoProvider).updateProfile(ref, file);
}

@Riverpod(keepAlive: true)
Future<List<CustomFields>> fetchAllCustomFields(
    FetchAllCustomFieldsRef ref) async {
  return ref.watch(authRepoProvider).fetchAllCustomFields(ref);
}

@riverpod
Future<(bool?, bool?)> updatePictureAndUser(
    UpdatePictureAndUserRef ref, File? file, User user) async {
  final results = await Future.wait([
    ref.watch(updateProfileProvider(file).future),
    ref.watch(updateUserProvider(user).future),
  ]);

  return (results[0] as bool?, results[1] as bool?);
}

@riverpod
Future<bool> updatePassword(Ref ref,
    {required String oldPassword, required String newPassword}) async {
  return ref
      .watch(authRepoProvider)
      .updatePassword(ref, oldPassword: oldPassword, newPassword: newPassword);
}

@riverpod
Future<bool> deleteAccount(Ref ref, {required String password}) async {
  return ref.watch(authRepoProvider).deleteAccount(ref, password: password);
}

@riverpod
Future<void> saveFCMToken(SaveFCMTokenRef ref, String token) async {
  return ref.watch(authRepoProvider).saveFCMToken(ref, token);
}

@riverpod
Future<bool?> recoverPassword(RecoverPasswordRef ref, String email) async {
  return ref.watch(authRepoProvider).resetPassword(ref, email);
}

@riverpod
Future<bool?> updateRecoveryPassword(UpdateRecoveryPasswordRef ref,
    {required String email, required String password, required String token}) {
  return ref
      .watch(authRepoProvider)
      .updateRecoveryPassword(ref, email, password, token);
}

@riverpod
Future<UserAssessment> fetchUserAssessment(Ref ref, {required int id}) async {
  return ref.watch(authRepoProvider).fetchUserAssessment(ref, id);
}

@riverpod
Future<List<WalletInfo>> walletInfo(WalletInfoRef ref) async {
  return ref.watch(authRepoProvider).walletInfo(ref);
}

@riverpod
Future<List<TransactionModel>> transactions(TransactionsRef ref) async {
  return ref.watch(authRepoProvider).transactions(ref);
}

@riverpod
Future<PlayersRanking> fetchPlayersRanking(
  FetchPlayersRankingRef ref, {
  required int page,
  required int limit,
  required String sportName,
}) async {
  return ref.read(authRepoProvider).fetchPlayersRanking(
        ref,
        page: page,
        limit: limit,
        sportName: sportName,
      );
}

@riverpod
Future<List<MatchLevel>> getUserMatchLevels(GetUserMatchLevelsRef ref,
    {required int userId, required int matchNumber, required String sportName}) async {
  return ref.watch(authRepoProvider).getUserMatchLevels(
    ref,
    userId: userId,
    matchNumber: matchNumber,
    sportName: sportName,
  );
}

@riverpod
Future<bool> followFriend(FollowFriendRef ref, {required int userId}) async {
  return ref.watch(authRepoProvider).followFriend(ref, userId: userId);
}

@riverpod
Future<bool> unfollowFriend(UnfollowFriendRef ref, {required int userId}) async {
  return ref.watch(authRepoProvider).unfollowFriend(ref, userId: userId);
}

@riverpod
Future<bool> checkFollowStatus(CheckFollowStatusRef ref, {required int userId}) async {
  return ref.watch(authRepoProvider).checkFollowStatus(ref, userId: userId);
}

@riverpod
Future<FollowList> getFollowingList(GetFollowingListRef ref) async {
  return ref.watch(authRepoProvider).getFollowingList(ref);
}

@riverpod
Future<FollowList> getFollowerList(GetFollowerListRef ref) async {
  return ref.watch(authRepoProvider).getFollowerList(ref);
}

@riverpod
Future<UserSearchResponse> searchUsers(
  SearchUsersRef ref, {
  required int page,
  required int pageSize,
  required String search,
}) async {
  return ref.watch(authRepoProvider).searchUsers(
    ref,
    page: page,
    pageSize: pageSize,
    search: search,
  );
}

class PaginationNotifierPlayersRanking
    extends StateNotifier<AsyncValue<PaginationState<Levels>>> {
  final Ref ref;
  final PlayerRankingParams params;

  PaginationNotifierPlayersRanking(this.ref, this.params)
      : super(AsyncValue.data(PaginationState.initial())) {
    // Optionally, load initial data here.
  }

  Future<void> loadMore() => _fetchPage(isRefresh: false);

  Future<void> refresh() => _fetchPage(isRefresh: true);

  Future<void> _fetchPage({required bool isRefresh}) async {
    final currentState = state;
    if (currentState is! AsyncData) return;
    final data = currentState.value;

    if (data == null) {
      return;
    }

    if (!isRefresh && (data.isLoading || !data.hasMore)) return;
    final nextPage = isRefresh ? 1 : data.page + 1;

    // Set loading state.
    state = AsyncValue.data(data.copyWith(
        isLoading: true,
        mainLoading: isRefresh,
        error: null,
        items: isRefresh ? [] : data.items));

    try {
      final playersRanking = await ref.read(
        fetchPlayersRankingProvider(
          page: nextPage,
          limit: params.currentPage == 0
              ? 10
              : params.currentPage == 1
                  ? 50
                  : params.limit,
          sportName: params.sportName,
        ).future,
      );

      final newItems = playersRanking.levels ?? [];
      final hasMore = nextPage < (playersRanking.totalPages ?? 0);

      final updatedState = data.copyWith(
          items: isRefresh ? [...newItems] : [...data.items, ...newItems],
          page: nextPage,
          isLoading: false,
          mainLoading: false,
          hasMore: hasMore && params.currentPage == 2,
          extraData: playersRanking.result);

      state = AsyncValue.data(updatedState);

      if (updatedState.items.length < kMinimumLimit && updatedState.hasMore) {
        loadMore();
        return;
      }
    } catch (e, stackTrace) {
      myPrint(
          "------------ Error Players Ranking Pagination ---------- ${e.toString()} ");
      state = AsyncValue.error(e, stackTrace);
    }
  }
}

final playersRankingPaginationProvider = StateNotifierProvider.family<
    PaginationNotifierPlayersRanking,
    AsyncValue<PaginationState<Levels>>,
    PlayerRankingParams>(
  (ref, params) => PaginationNotifierPlayersRanking(ref, params),
);
