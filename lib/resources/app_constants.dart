class AppConstants {
  AppConstants._();

  static const baseApiUrl = 'https://api.imgflip.com';

  static const String apiUnknownError = 'Произошла ошибка';
  static const String apiConnectionTimeoutError =
      'Проверьте соединение с сетью и попробуйте еще раз';
  static const String apiBadCertificateError =
      'Ошибка олучения данных, наши специалисты уже работают над ее устранением';
  static const String apiConnectionError =
      'Нет соединения с сервером, попробуйте позже';
  static const String dioClientError = 'Произошла ошибка, попробуйте еще раз';
  static const String jsonParsingError =
      'Получены некоректные данные, попробуйте позже';
  static const String downloadFileError = 'Ошибка загрузки файла.';

  static const String apiBadRequestError = 'Некорректный запрос к серверу.';
  static const String apiBadRequestPathError =
      'На сервере отсутствуют запрашиваемые данные';
  static const String apiTimeoutGatewayError =
      'Таймаут получения данных от сервера.';
}
