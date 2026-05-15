// class ApiConstants {
//   // ANDROID EMULATOR: use 10.0.2.2
//   // IOS SIMULATOR: use localhost
//   // PHYSICAL DEVICE: use your computer's IP address (e.g., 192.168.1.100)
//   static const String baseUrl = 'http://localhost:5000/api';
  
//   static const int connectTimeout = 60000;
//   static const int receiveTimeout = 60000;
  
//   // Auth Endpoints
//   static const String register = '/auth/register';
//   static const String login = '/auth/login';
//   static const String profile = '/auth/profile';
  
//   // VTU Endpoints
//   static const String airtime = '/vtu/airtime';
//   static const String data = '/vtu/data';
//   static const String dataPlans = '/vtu/data-plans';
//   static const String electricity = '/vtu/electricity';
//   static const String tv = '/vtu/tv';
//   static const String exam = '/vtu/exam';
//   static const String transactions = '/vtu/transactions';
  
//   // Wallet Endpoints
//   static const String walletBalance = '/wallet/balance';
//   static const String fundWallet = '/wallet/fund';
  
//   // Headers
//   static const String authorization = 'Authorization';
//   static const String bearer = 'Bearer';
// }




class ApiConstants {

  /// ================================
  /// BASE URL
  /// ================================

  /*
    ANDROID EMULATOR:
    Use 10.0.2.2 to access your computer localhost
  */
  // static const String baseUrl = 'http://10.0.2.2:5000/api';

  /*
    IOS SIMULATOR:
  */

    static const String baseUrl = 'http://localhost:5000/api';
    
  

  /*
    REAL DEVICE:
    Replace with your computer WiFi IP

    Example:
    static const String baseUrl = 'http://192.168.1.5:5000/api';
  */


  /// ================================
  /// TIMEOUTS
  /// ================================

  static const int connectTimeout = 60000;
  static const int receiveTimeout = 60000;


  /// ================================
  /// AUTH ENDPOINTS
  /// ================================

  static const String register = '/auth/register';
  static const String login = '/auth/login';
  static const String profile = '/auth/profile';


  /// ================================
  /// VTU ENDPOINTS
  /// ================================

  static const String airtime = '/vtu/airtime';
  static const String data = '/vtu/data';
  static const String dataPlans = '/vtu/data-plans';
  static const String electricity = '/vtu/electricity';
  static const String tv = '/vtu/tv';
  static const String exam = '/vtu/exam';
  static const String transactions = '/vtu/transactions';


  /// ================================
  /// WALLET ENDPOINTS
  /// ================================

  static const String walletBalance = '/wallet/balance';
  static const String fundWallet = '/wallet/fund';


  /// ================================
  /// HEADERS
  /// ================================

  static const String authorization = 'Authorization';
  static const String bearer = 'Bearer';
}