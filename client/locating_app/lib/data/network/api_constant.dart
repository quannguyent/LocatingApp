class ApiConstant {
  //define all api constant like: host, path, ...
  static final apiHost = "http://128.199.150.84:8080/api/";
  static String LIST_NEWS(int page) {
    String url =
        "http://128.199.150.84:2368/ghost/api/v3/content/posts/?key=b502d872e24eb084781cc76f20&page=$page&include=authors";
    return url;
  }

  static final APIHOST = "http://112.213.88.49:8088/rpc/locating-app/";
  // static final APIHOST = "http://192.168.1.140:8000/api/v1/";
  static final apiHostLogin = "auth/login/";
  static final FACEBOOK = "facebook";
  static final GOOGLE = "google";

  // Profile
  static String REGISTER = "account/signup";
  static String AUTHENTICATION = "account/login";
  static String PROFILE_USER = "profile/get";
  static String VERIFY_CODE = "user/verification";
  static String FORGOT_PASSWORD = "profile/forgot-password";
  static String VERIFY_OTP_CODE = "profile/verify-otp-code";
  static String RESET_PASSWORD = "profile/recovery-password";
  static String UPDATE_PROFILE = "profile/update";
  static String SAVE_IMAGE = "profile/save-image";
  static String CHANGE_PASSWORD = "profile/change-password";

  static final String SETTING = "user/setting";
  static String UPDATE_LOCATION = "user/update_location";
  static String SHARE_LOCATION = "locating/user/share/";
  static final String GET_PHONE = "user/";
  static String LOG_LOCATION = "locating/location-log";
  static String LAST_LOG = "locating/user/last-log/";
  static final String ADD_FRIEND = "friend/send-friend-request";
  static final String GET_LIST_FRIEND = "friend/list-friends";
  static final String SET_CLOSE_FRIEND = "locating/user-relationship/close";
  static final DELETE_FRIEND = "locating/user-relationship";
  static final String SEND_CHAT = "locating/conversation/send-message";
  static final String PLACE = "locating/place";
  static final String GET_PROFILE_UUID = "user/filter-by-user-id/";
  static final String CALL_FOR_HELP = "locating/call-for-help";

  static final String HUB = "http://citechi.ddns.net:44323/";
  static final String LOCATION = "location-hub";
  static final String chat = "conversation-hub";

  static final String HOST_PHONE = '112.213.88.49';
  static final String SCHEME = 'http';
  static final String URL_PHONE = '/rpc/locating-app/friend/get-friend-from-contact';

  static final String GET_USER_BY_PHONE = 'friend/get-friend-from-contact';
}
