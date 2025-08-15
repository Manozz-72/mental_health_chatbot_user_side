import 'dart:developer';
import 'package:googleapis_auth/auth_io.dart';

class FirebaseAccessToken {
  static String firebaseMessagingApi =
      "https://www.googleapis.com/auth/firebase.messaging";

  Future<String> generateFirebaseAccessToken() async {
    final credentialsJson = {
      "type": "service_account",
      "project_id": "mental-health-30ee1",
      "private_key_id": "3329994d536459607ff9ad6d7b5ec629d7e308fd",
      "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCxpXR5djWOnIh5\ns43pB4Q3Fh27yGyl/ve/SQGwMIwyt2H5ODwWd47HIsj2GUS/oWUcTfYdVriTzGsw\nBGXYjMQpz5KwtDG/MUc3FEYcGpNvTbyeHYOwwHjkAakUfAf/t650FQUpkQ5olpna\nr+LHirzD5LgRvC9ix5P2xsj5Ju1NHccfUq9sVdxco2aJ7wLXueryW0CsMLZH3doY\nS/5T8ZDG+oiQRMzsbnvro/3kTTYtxRxjOE5R6OOjRZmqoRzgaxFubK/I3FqTcBq5\nCEskPnlR9oZx/P22bWxGCxiRJc8qMnJ3fKyJjxj7O8nWC7831tg+ZSsTs1k7TwDm\n+d9Gi6BzAgMBAAECggEAEFhW5S4ZM2v3qqr4ra5BXggs6DBCvus8xF7lRt7Qp4H0\nA8hGzxJlErGCqBIfHzqsYPRTZtOp2/99BUgCTvB0xBwTNSr/QMY59TlqUf+n/R+7\n8RhqG4M6HFCCzB21ZrPx20Br3y03lCv3MAXq6c08HRIYVZlpCr+uP5B+wV3xi5zA\njDF7O8UB1JNDbVBrJWP5Zk3df85saLe7tFndOJ9gRsIzDHjPhL8R8qKJV6JYpMaC\nHIt1jlkEyvE/Gn3IBnq+q0xWlp2z4c8xF3SfX+v3v00l6nfzfg5YkouVSeERrmAk\nUWhJ5csUsohxTUEJ8Oy9yBEPbkBjaO0v1jMs9imFEQKBgQDYVuFOcq63BYU4GZjn\nQSEiU3o0bfhQTYafGHlKd2lmovPAPhKe7MRFuzYUW2luCI8dhGtngVgPwHZNvfVm\nkw7u4CrOB9AGc80+vvLwC9eNI38Op8FNDAk6gupHQKReyLWbl9dPTiTCjrtOnmar\nMCtTo7Vtc/tRjlo7LnKUnhpGNQKBgQDSNqc8PdMPiVZkE59dUNbRhjOsI+bgc+yR\nLZtx85oKzb0svVtcYLDOGoCX2GCrvPqbUACFmjMf90VnGz+EMebTwi3DZrFewgVm\nb4Y/0QWL10/vBKfzUZVqMFB1YY6eVw0npBlhDKyLrZQaLfNl9+7SF3d3sDLoSded\nwTsp/weBBwKBgQC/xRPnpEU3u88Bkb82j0c91F2piCnrlS1Wbi1mUz+9WYlUyjFb\na2n4niEsHnPws+mZMr66e6+CFwtHkrGsAYPlQBTxmX9PmOtBSaa0HusuE18XsKDr\nGVY85bui+aw60RQbHpgflpeDV162LDe6W/KsK5wxr/QBsXxOpbewAg4sWQKBgGQn\nFdZlvkEQtdBIaQ0UjsSUo9nH4R/fGz6v8/d+kE3FZ/QA455HkvUfO1UdCjHIf72v\niBAfP2xjavWMzd41yDvrr9IBA1CaL+h2Cggtle7iTnsaRMpwfDdzfWHvcPuPjfzs\n+gp691o1APLYIbbbQTVnaMvlbtutEsVeYsnHb9PRAoGAG2295N67wps5QkMQIcMM\nhSLw2t9iDlSXE+qzsD4/k/AKbEBpzUZtcNPhTjJSzWvWmJsZBGous8hZju3ew+Vr\nKfk6huFgcW5So8d1mu8yz2W1bYuNgzmo00FP/XZmLvxiWct0Wb04KvplNioLzELQ\nrC2N3lAE7PZfNK//T1ieX5E=\n-----END PRIVATE KEY-----\n",
      "client_email": "firebase-adminsdk-fbsvc@mental-health-30ee1.iam.gserviceaccount.com",
      "client_id": "115651112335294894723",
      "auth_uri": "https://accounts.google.com/o/oauth2/auth",
      "token_uri": "https://oauth2.googleapis.com/token",
      "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
      "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-fbsvc%40mental-health-30ee1.iam.gserviceaccount.com",
      "universe_domain": "googleapis.com"
    };

    try {
      final client = await clientViaServiceAccount(
          ServiceAccountCredentials.fromJson(credentialsJson),
          [firebaseMessagingApi]);
      final accessToken = client.credentials.accessToken.data;
      // log('OAuth 2.0 access token generated: $accessToken');
      return accessToken;
    } catch (e) {
      log('Error generating access token: $e');
      return '';
    }
  }
}
