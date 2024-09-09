import 'dart:convert';
import 'package:http/http.dart' as http;

abstract class PredictRemoteDatasource{
  Future<Map<String, dynamic>> predictResult(
  {
    required double mode,
    required double homeCode,
    double? homePoss,
    double? homeShoots,
    double? homeShootsOn,
    double? homeCorners,
    double? homeChances,
    required awayCode,
    double? awayPoss,
    double? awayShoots,
    double? awayShootsOn,
    double? awayCorners,
    double? awayChances,
}
      );
}
 class PredictRemoteDatasourceImp extends PredictRemoteDatasource{
  Future<Map<String, dynamic>> predictResult({
    required double mode,
    required double homeCode,
    double? homePoss,
    double? homeShoots,
    double? homeShootsOn,
    double? homeCorners,
    double? homeChances,
    required awayCode,
    double? awayPoss,
    double? awayShoots,
    double? awayShootsOn,
    double? awayCorners,
    double? awayChances,}) async{
    Map<String, dynamic> data = {
      "mode": mode,
      "home_team": homeCode,
      "home_pos": homePoss,
      "home_sh": homeShoots,
      "home_cor": homeCorners,
      "home_sh_on": homeShootsOn,
      "home_ch": homeChances,
      "away_team": awayCode,
      "away_pos": awayPoss,
      "away_sh": awayShoots,
      "away_cor": awayCorners,
      "away_sh_on": awayShootsOn,
      "away_ch": awayChances,
    };
    String url = 'http://192.168.204.117:5000';
    final response = await http.post(Uri.parse(url),
        headers: {"Content-Type": "application/json"}, body: jsonEncode(data));
    if (response.statusCode == 200) {
      Map<String, dynamic> responseData = jsonDecode(response.body);

      // Extract prediction data
      List<dynamic> predictionData = responseData['prediction'];
      List<List<double>> prediction = predictionData
          .map<List<double>>((e) => (e as List<dynamic>).map<double>((e) => e.toDouble()).toList())
          .toList();

      // Extract pr data
      String prJson = responseData['pr'];
      Map<String, dynamic> prData = jsonDecode(prJson);
      List<List<dynamic>> pr = List<List<dynamic>>.from(prData['data']);
      List<List<double>> prList = pr
          .map<List<double>>((e) => e.map<double>((e) => e.toDouble()).toList())
          .toList();

      // Store the results in a map
      Map<String, dynamic> results = {
        'prediction': prediction,
        'pr': prList
      };

      print(results);
      return results;
    } else {
      print("Error: ${response.statusCode}");
    }
    return {};
 }
}