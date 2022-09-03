import 'package:flutter_test/flutter_test.dart';
import 'package:radioactivity/api/client.dart';

void main() {
  test('Test API', () async {
    var client = ApiClient();
    var response = await client.doRequest(type: DataLayer.onehlatest);
    expect(response.numberReturned, response.features.length);
  });
}
