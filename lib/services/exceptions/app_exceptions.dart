class AppExceptions implements Exception {
  final String? message;
  final String? prefix;
  final String? url;

  AppExceptions([this.message, this.prefix, this.url]);
}

class BadRequestException extends AppExceptions {
  BadRequestException([String? message, String? url])
      : super(message, "Bad Request", url);
}

class AccountAlreadyDeletedException extends AppExceptions {
  AccountAlreadyDeletedException([String? message, String? email])
      : super(message, email);
}

class MultipleChoiceException extends AppExceptions {
  MultipleChoiceException([String? message, String? email])
      : super(message, email);
}

class FetchDataException extends AppExceptions {
  FetchDataException([String? message, String? url])
      : super(message, "Unable to process", url);
}

class ApiNotRespondingException extends AppExceptions {
  ApiNotRespondingException([String? message, String? url])
      : super(message, "Api not responding", url);
}

class UnAuthorizedException extends AppExceptions {
  UnAuthorizedException([String? message, String? url])
      : super(message, "UnAuthorized request", url);
}

class PageNotFoundException extends AppExceptions {
  PageNotFoundException([String? message, String? url]) : super(message, url);
}

class ValidationException extends AppExceptions{
  ValidationException([String? message, String? url])
      : super(message,"Validation errors", url);
}