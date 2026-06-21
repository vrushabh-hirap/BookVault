class ApiConstants {
  static const int connectTimeoutMs = 10000; // 10 seconds timeout
  static const int receiveTimeoutMs = 10000;

  static String googleBooksUrl(String isbn) =>
      'https://www.googleapis.com/books/v1/volumes?q=isbn:$isbn&maxResults=1';

  static String openLibraryUrl(String isbn) =>
      'https://openlibrary.org/api/books?bibkeys=ISBN:$isbn&format=json&jscmd=data';
}
