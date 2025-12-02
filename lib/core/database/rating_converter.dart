import 'package:fake_store_api_app/core/models/rating.dart';
import 'package:floor/floor.dart';

class RatingConverter extends TypeConverter<RatingModel, String> {
  @override
  RatingModel decode(String databaseValue) {
    return RatingModel.fromRawJson(databaseValue);
  }

  @override
  String encode(RatingModel value) {
    return value.toRawJson();
  }
}
