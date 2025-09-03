import '../../../../../resources/app_constants.dart';
import '../dto/api_error_response.dart';

class ApiError {
  final String description;

  ApiError._({required this.description});

  factory ApiError.fromErrorResponse({
    required ApiErrorResponse errorResponse,
  }) {
    return ApiError._(description: errorResponse.userMessage);
  }

  factory ApiError.fromErrorType({required ApiErrorType errorType}) {
    return ApiError._(description: errorType.description);
  }
}

enum ApiErrorType {
  unknown(responseCode: -1, description: AppConstants.apiUnknownError),
  connectionTimeoutError(
    responseCode: -2,
    description: AppConstants.apiConnectionTimeoutError,
  ),
  sendTimeoutError(
    responseCode: -3,
    description: AppConstants.apiConnectionTimeoutError,
  ),
  receiveTimeoutError(
    responseCode: -4,
    description: AppConstants.apiConnectionTimeoutError,
  ),
  badCertificateError(
    responseCode: -5,
    description: AppConstants.apiBadCertificateError,
  ),
  connectionError(
    responseCode: -6,
    description: AppConstants.apiConnectionError,
  ),
  dioClientError(responseCode: -7, description: AppConstants.dioClientError),
  jsonParsingTypeError(
    responseCode: -8,
    description: AppConstants.jsonParsingError,
  ),
  downloadFileError(
    responseCode: -9,
    description: AppConstants.downloadFileError,
  ),
  badRequest(responseCode: 400, description: AppConstants.apiBadRequestError),
  badRequestPath(
    responseCode: 404,
    description: AppConstants.apiBadRequestPathError,
  ),
  badRequestPathGone(
    responseCode: 410,
    description: AppConstants.apiBadRequestPathError,
  ),
  gatewayTimeout(
    responseCode: 504,
    description: AppConstants.apiTimeoutGatewayError,
  );

  const ApiErrorType({required this.responseCode, required this.description});

  final int responseCode;
  final String description;

  static ApiErrorType getByResponseCode(final int code) {
    return ApiErrorType.values.firstWhere(
      (element) => element.responseCode == code,
      orElse: () => ApiErrorType.unknown,
    );
  }
}

// unknown(
//   responseCode: -1,
//   description: AppConstants.apiUnknownError,
//   actionText: AppConstants.actionRepeatUpdateText,
//   assetImagePath: AppSvgIcons.errorImage,
// ),
// connectionTimeoutError(
//   responseCode: -2,
//   description: AppConstants.apiConnectionTimeoutError,
//   actionText: AppConstants.actionUpdateText,
//   assetImagePath: AppSvgIcons.errorConnectionImage,
// ),
// sendTimeoutError(
//   responseCode: -3,
//   description: AppConstants.apiSendTimeoutError,
//   actionText: AppConstants.actionUpdateText,
//   assetImagePath: AppSvgIcons.errorConnectionImage,
// ),
// receiveTimeoutError(
//   responseCode: -4,
//   description: AppConstants.apiReceiveTimeoutError,
//   actionText: AppConstants.actionUpdateText,
//   assetImagePath: AppSvgIcons.errorConnectionImage,
// ),
// badCertificateError(
//   responseCode: -5,
//   description: AppConstants.apiBadCertificateError,
//   actionText: AppConstants.actionUpdateText,
//   assetImagePath: AppSvgIcons.errorConnectionImage,
// ),
// connectionError(
//   responseCode: -6,
//   description: AppConstants.apiConnectionError,
//   actionText: AppConstants.actionUpdateText,
//   assetImagePath: AppSvgIcons.errorConnectionImage,
// ),
// dioClientError(
//   responseCode: -7,
//   description: AppConstants.dioClientError,
//   actionText: AppConstants.actionRepeatUpdateText,
//   assetImagePath: AppSvgIcons.errorImage,
// ),
// jsonParsingTypeError(
//   responseCode: -8,
//   description: AppConstants.jsonParsingError,
//   actionText: AppConstants.actionRepeatUpdateText,
//   assetImagePath: AppSvgIcons.errorImage,
// ),
// badRequest(
//   responseCode: 400,
//   description: AppConstants.apiBadRequestError,
//   actionText: AppConstants.actionRepeatUpdateText,
//   assetImagePath: AppSvgIcons.errorImage,
// ),
// badRequestPath(
//   responseCode: 404,
//   description: AppConstants.apiBadRequestPathError,
//   actionText: AppConstants.actionRepeatUpdateText,
//   assetImagePath: AppSvgIcons.errorImage,
// ),
// badRequestPathGone(
//   responseCode: 410,
//   description: AppConstants.apiBadRequestPathError,
//   actionText: AppConstants.actionRepeatUpdateText,
//   assetImagePath: AppSvgIcons.errorImage,
// ),
// gatewayTimeout(
//   responseCode: 504,
//   description: AppConstants.apiTimeoutGatewayError,
//   actionText: AppConstants.actionRepeatUpdateText,
//   assetImagePath: AppSvgIcons.errorImage,
// );

// static ApiErrorType getByResponseCode(final int code) {
//   return ApiErrorType.values.firstWhere(
//     (element) => element.responseCode == code,
//     orElse: () => ApiErrorType.unknown,
//   );
// }
//
// static bool containsCode(final dynamic code) {
//   return ApiErrorType.values
//           .indexWhere((element) => element.responseCode == code) !=
//       -1;
// }
