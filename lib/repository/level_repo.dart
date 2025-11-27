import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hop/globals/api_endpoints.dart';
import 'package:hop/globals/constants.dart';
import 'package:hop/managers/api_manager.dart';
import 'package:hop/models/calculated_level_data.dart';
import 'package:hop/models/level_questions.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../managers/user_manager.dart';

part 'level_repo.g.dart';

class LevelRepo {
  Future<List<LevelQuestion>> getQuestions(Ref ref, String? sport) async {
    try {
      Map<String, dynamic> queryParams = {};
      if (sport != null) {
        queryParams = {"sport": sport.toLowerCase()};
      }

      final response = await ref
          .read(apiManagerProvider)
          .get(ref, ApiEndPoint.getQuestions, queryParams: queryParams);
      final List<LevelQuestion> questions = [];
      for (final item in response['data']["questions"]) {
        questions.add(LevelQuestion.fromJson(item));
      }
      return questions;
    } catch (e, st) {
      myPrint('st = $st');
      myPrint('e = $e');
      if (e is Map<String, dynamic>) {
        throw e['message'];
      }
      rethrow;
    }
  }

  Future<CalculatedLevelData> calculateLevel(
      Ref ref, List<double?> answers, bool allowClub, String sportsName) async {
    try {
      final token = ref.read(userManagerProvider).user?.accessToken;
      final response = await ref.read(apiManagerProvider).post(
          ref,
          allowClub
              ? ApiEndPoint.calculateWithClubIdLevel
              : ApiEndPoint.calculateLevel,
          {
            "answers": answers,
            "scale": 7,
            "sport_name": sportsName.toLowerCase(),
          },
          token: token);

      return CalculatedLevelData.fromJson(response['data']);
    } catch (e) {
      if (e is Map<String, dynamic>) {
        throw e['message'];
      }
      rethrow;
    }
  }
}

@riverpod
LevelRepo levelRepo(Ref ref) => LevelRepo();

@riverpod
Future<List<LevelQuestion>> levelQuestions(LevelQuestionsRef ref,
    {String? sport}) async {
  return await ref.read(levelRepoProvider).getQuestions(ref, sport);
}

@riverpod
Future<CalculatedLevelData> calculateLevel(CalculateLevelRef ref,
    {required List<double?> answers,
    required bool allowClub,
    required String sportsName}) async {
  return await ref
      .read(levelRepoProvider)
      .calculateLevel(ref, answers, allowClub, sportsName);
}
