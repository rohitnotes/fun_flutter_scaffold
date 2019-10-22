import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:fun_flutter_scaffold/viewstate/view_state_exception.dart';

import 'api.dart';

final Http http = Http();

class Http extends BaseHttp {
  @override
  void init() {
    options.baseUrl = 'https://www.pgyer.com/apiv2/';
    interceptors.add(PgyerApiInterceptor());
  }
}

/// App相关 API
class PgyerApiInterceptor extends InterceptorsWrapper {
  @override
  onRequest(RequestOptions options) async {
    /// TODO 处理key的问题
    options.queryParameters['_api_key'] = '';
    options.queryParameters['appKey'] = '';
    debugPrint('---api-request--->url--> ${options.baseUrl}${options.path}' +
        ' queryParameters: ${options.queryParameters}');
    return options;
  }

  @override
  onResponse(Response response) {
    ResponseData respData = ResponseData.fromJson(response.data);
    if (respData.success) {
      response.data = respData.data;
      return http.resolve(response);
    } else {
      throw NotSuccessException(respData.message);
    }
  }
}

class ResponseData extends BaseResponseData {
  bool get success => code == 0;

  ResponseData.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    data = json['data'];
  }
}

/// CheckApp更新接口
class AppUpdateInfo {
  String buildBuildVersion;
  String forceUpdateVersion;
  String forceUpdateVersionNo;
  bool needForceUpdate;
  String downloadURL;
  bool buildHaveNewVersion;
  String buildVersionNo;
  String buildVersion;
  String buildShortcutUrl;
  String buildUpdateDescription;

  static AppUpdateInfo fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    AppUpdateInfo pgyerApiBean = AppUpdateInfo();
    pgyerApiBean.buildBuildVersion = map['buildBuildVersion'];
    pgyerApiBean.forceUpdateVersion = map['forceUpdateVersion'];
    pgyerApiBean.forceUpdateVersionNo = map['forceUpdateVersionNo'];
    pgyerApiBean.needForceUpdate = map['needForceUpdate'];
    pgyerApiBean.downloadURL = map['downloadURL'];
    pgyerApiBean.buildHaveNewVersion = map['buildHaveNewVersion'];
    pgyerApiBean.buildVersionNo = map['buildVersionNo'];
    pgyerApiBean.buildVersion = map['buildVersion'];
    pgyerApiBean.buildShortcutUrl = map['buildShortcutUrl'];
    pgyerApiBean.buildUpdateDescription = map['buildUpdateDescription'];
    return pgyerApiBean;
  }

  Map toJson() => {
        "buildBuildVersion": buildBuildVersion,
        "forceUpdateVersion": forceUpdateVersion,
        "forceUpdateVersionNo": forceUpdateVersionNo,
        "needForceUpdate": needForceUpdate,
        "downloadURL": downloadURL,
        "buildHaveNewVersion": buildHaveNewVersion,
        "buildVersionNo": buildVersionNo,
        "buildVersion": buildVersion,
        "buildShortcutUrl": buildShortcutUrl,
        "buildUpdateDescription": buildUpdateDescription,
      };
}
