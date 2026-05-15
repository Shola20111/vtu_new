// import "package:vtu_app/core/services/vtu_service.dart";
// import "package:vtu_app/core/models/transaction.dart";
// import "package:vtu_app/core/models/data_plan.dart";
// import "package:flutter/material.dart";
// import 'package:flutter/material.dart';
// import 'package:vtu_app/core/models/data_plan.dart';
// import 'package:vtu_app/core/models/transaction.dart';
// import 'package:vtu_app/core/services/vtu_service.dart';

// class VTUProvider extends ChangeNotifier {
//   final VTUService _vtuService = VTUService();
  
//   bool _isLoading = false;
//   String? _error;
//   List<DataPlan> _dataPlans = [];
//   List<Transaction> _transactions = [];
//   VTUResponse? _lastTransaction;

//   bool get isLoading => _isLoading;
//   String? get error => _error;
//   List<DataPlan> get dataPlans => _dataPlans;
//   List<Transaction> get transactions => _transactions;
//   VTUResponse? get lastTransaction => _lastTransaction;

//   // Airtime
//   Future<bool> purchaseAirtime(String network, String phone, double amount) async {
//     _setLoading(true);
//     _clearError();

//     try {
//       final response = await _vtuService.purchaseAirtime(
//         AirtimeRequest(network: network, phone: phone, amount: amount),
//       );
      
//       if (response.success) {
//         _lastTransaction = response;
//         _setLoading(false);
//         return true;
//       } else {
//         _setError(response.message);
//         _setLoading(false);
//         return false;
//       }
//     } catch (e) {
//       _setError(e.toString());
//       _setLoading(false);
//       return false;
//     }
//   }

//   // Data Plans
//   Future<void> loadDataPlans(String network) async {
//     _setLoading(true);
//     _clearError();

//     try {
//       final response = await _vtuService.getDataPlans(network);
//       _dataPlans = response.plans;
//       _setLoading(false);
//     } catch (e) {
//       _setError(e.toString());
//       _setLoading(false);
//     }
//   }

//   // Purchase Data
//   Future<bool> purchaseData(String network, String phone, String dataPlan) async {
//     _setLoading(true);
//     _clearError();

//     try {
//       final response = await _vtuService.purchaseData(
//         DataRequest(network: network, phone: phone, dataPlan: dataPlan),
//       );
      
//       if (response.success) {
//         _lastTransaction = response;
//         _setLoading(false);
//         return true;
//       } else {
//         _setError(response.message);
//         _setLoading(false);
//         return false;
//       }
//     } catch (e) {
//       _setError(e.toString());
//       _setLoading(false);
//       return false;
//     }
//   }

//   // Electricity
//   Future<bool> purchaseElectricity({
//     required String disco,
//     required String meterNumber,
//     required double amount,
//     required String meterType,
//   }) async {
//     _setLoading(true);
//     _clearError();

//     try {
//       final response = await _vtuService.purchaseElectricity({
//         'disco': disco,
//         'meterNumber': meterNumber,
//         'amount': amount,
//         'meterType': meterType,
//       });
      
//       if (response.success) {
//         _lastTransaction = response;
//         _setLoading(false);
//         return true;
//       } else {
//         _setError(response.message);
//         _setLoading(false);
//         return false;
//       }
//     } catch (e) {
//       _setError(e.toString());
//       _setLoading(false);
//       return false;
//     }
//   }

//   // TV Subscription
//   Future<bool> purchaseTV({
//     required String provider,
//     required String smartcardNumber,
//     required String package,
//   }) async {
//     _setLoading(true);
//     _clearError();

//     try {
//       final response = await _vtuService.purchaseTV({
//         'provider': provider,
//         'smartcardNumber': smartcardNumber,
//         'package': package,
//       });
      
//       if (response.success) {
//         _lastTransaction = response;
//         _setLoading(false);
//         return true;
//       } else {
//         _setError(response.message);
//         _setLoading(false);
//         return false;
//       }
//     } catch (e) {
//       _setError(e.toString());
//       _setLoading(false);
//       return false;
//     }
//   }

//   // Exam PIN
//   Future<bool> purchaseExamPIN(String examType, int quantity) async {
//     _setLoading(true);
//     _clearError();

//     try {
//       final response = await _vtuService.purchaseExamPIN({
//         'examType': examType,
//         'quantity': quantity,
//       });
      
//       if (response.success) {
//         _lastTransaction = response;
//         _setLoading(false);
//         return true;
//       } else {
//         _setError(response.message);
//         _setLoading(false);
//         return false;
//       }
//     } catch (e) {
//       _setError(e.toString());
//       _setLoading(false);
//       return false;
//     }
//   }

//   // Load Transactions
//   Future<void> loadTransactions({int page = 1, String? serviceType}) async {
//     _setLoading(true);
//     _clearError();

//     try {
//       final newTransactions = await _vtuService.getTransactions(
//         page: page,
//         serviceType: serviceType,
//       );
      
//       if (page == 1) {
//         _transactions = newTransactions;
//       } else {
//         _transactions.addAll(newTransactions);
//       }
      
//       _setLoading(false);
//     } catch (e) {
//       _setError(e.toString());
//       _setLoading(false);
//     }
//   }

//   void _setLoading(bool value) {
//     _isLoading = value;
//     notifyListeners();
//   }

//   void _setError(String error) {
//     _error = error;
//     notifyListeners();
//   }

//   void _clearError() {
//     _error = null;
//     notifyListeners();
//   }

//   void clearLastTransaction() {
//     _lastTransaction = null;
//     notifyListeners();
//   }
// }



// import 'package:flutter/material.dart';

// import 'package:vtu_app/core/models/data_plan.dart';
// import 'package:vtu_app/core/models/transaction.dart';

// import 'package:vtu_app/core/services/vtu_service.dart';

// class VTUProvider extends ChangeNotifier {
//   final VTUService _vtuService =
//       VTUService();

//   /// Separate loading states
//   bool _isPurchasing =
//       false;

//   bool _isLoadingPlans =
//       false;

//   bool _isLoadingTransactions =
//       false;

//   String? _error;

//   List<DataPlan> _dataPlans =
//       [];

//   List<Transaction>
//       _transactions = [];

//   VTUResponse?
//       _lastTransaction;

//   /// Prevent duplicate request IDs
//   final Set<String>
//       _activeRequests = {};

//   bool get isPurchasing =>
//       _isPurchasing;

//   bool get isLoadingPlans =>
//       _isLoadingPlans;

//   bool get isLoadingTransactions =>
//       _isLoadingTransactions;

//   String? get error =>
//       _error;

//   List<DataPlan>
//       get dataPlans =>
//           _dataPlans;

//   List<Transaction>
//       get transactions =>
//           _transactions;

//   VTUResponse?
//       get lastTransaction =>
//           _lastTransaction;

//   /// Airtime
//   Future<bool>
//       purchaseAirtime({
//     required String network,
//     required String phone,
//     required double amount,
//     required String requestId,
//   }) async {
//     return _executePurchase(
//       requestId: requestId,

//       operation: () async {
//         final response =
//             await _vtuService
//                 .purchaseAirtime(
//           AirtimeRequest(
//             network: network,

//             phone: phone,

//             amountInKobo:
//                 (amount * 100)
//                     .round(),

//             requestId:
//                 requestId,
//           ),
//         );

//         return response;
//       },
//     );
//   }

//   /// Data Purchase
//   Future<bool>
//       purchaseData({
//     required String network,
//     required String phone,
//     required String dataPlan,
//     required String requestId,
//   }) async {
//     return _executePurchase(
//       requestId: requestId,

//       operation: () async {
//         final response =
//             await _vtuService
//                 .purchaseData(
//           DataRequest(
//             network: network,

//             phone: phone,

//             dataPlan:
//                 dataPlan,

//             requestId:
//                 requestId,
//           ),
//         );

//         return response;
//       },
//     );
//   }

//   /// Electricity
//   Future<bool>
//       purchaseElectricity({
//     required String disco,
//     required String meterNumber,
//     required double amount,
//     required String meterType,
//     required String requestId,
//   }) async {
//     return _executePurchase(
//       requestId: requestId,

//       operation: () async {
//         final response =
//             await _vtuService
//                 .purchaseElectricity(
//           ElectricityRequest(
//             disco: disco,

//             meterNumber:
//                 meterNumber,

//             amountInKobo:
//                 (amount * 100)
//                     .round(),

//             meterType:
//                 meterType,

//             requestId:
//                 requestId,
//           ),
//         );

//         return response;
//       },
//     );
//   }

//   /// TV
//   Future<bool> purchaseTV({
//     required String provider,
//     required String smartcardNumber,
//     required String package,
//     required String requestId,
//   }) async {
//     return _executePurchase(
//       requestId: requestId,

//       operation: () async {
//         final response =
//             await _vtuService
//                 .purchaseTV(
//           TVRequest(
//             provider:
//                 provider,

//             smartcardNumber:
//                 smartcardNumber,

//             package:
//                 package,

//             requestId:
//                 requestId,
//           ),
//         );

//         return response;
//       },
//     );
//   }

//   /// Exam PIN
//   Future<bool>
//       purchaseExamPIN({
//     required String examType,
//     required int quantity,
//     required String requestId,
//   }) async {
//     return _executePurchase(
//       requestId: requestId,

//       operation: () async {
//         final response =
//             await _vtuService
//                 .purchaseExamPIN(
//           ExamPinRequest(
//             examType:
//                 examType,

//             quantity:
//                 quantity,

//             requestId:
//                 requestId,
//           ),
//         );

//         return response;
//       },
//     );
//   }

//   /// Generic purchase executor
//   Future<bool>
//       _executePurchase({
//     required String requestId,

//     required Future<
//             VTUResponse>
//         Function()
//         operation,
//   }) async {
//     if (_activeRequests
//         .contains(requestId)) {
//       return false;
//     }

//     _activeRequests
//         .add(requestId);

//     _setPurchasing(true);

//     _clearError();

//     try {
//       final response =
//           await operation();

//       if (response.success) {
//         _lastTransaction =
//             response;

//         return true;
//       }

//       _setError(
//         response.message,
//       );

//       return false;
//     } catch (e) {
//       _setError(
//         e.toString(),
//       );

//       return false;
//     } finally {
//       _activeRequests
//           .remove(requestId);

//       _setPurchasing(false);
//     }
//   }

//   /// Data Plans
//   Future<void>
//       loadDataPlans(
//     String network,
//   ) async {
//     _setLoadingPlans(true);

//     _clearError();

//     try {
//       final response =
//           await _vtuService
//               .getDataPlans(
//         network,
//       );

//       _dataPlans =
//           response.plans;
//     } catch (e) {
//       _setError(
//         e.toString(),
//       );
//     } finally {
//       _setLoadingPlans(
//         false,
//       );
//     }
//   }

//   /// Transactions
//   Future<void>
//       loadTransactions({
//     int page = 1,
//     String? serviceType,
//   }) async {
//     _setLoadingTransactions(
//       true,
//     );

//     _clearError();

//     try {
//       final fetched =
//           await _vtuService
//               .getTransactions(
//         page: page,
//         serviceType:
//             serviceType,
//       );

//       if (page == 1) {
//         _transactions =
//             fetched;
//       } else {
//         _transactions = [
//           ..._transactions,
//           ...fetched,
//         ];
//       }
//     } catch (e) {
//       _setError(
//         e.toString(),
//       );
//     } finally {
//       _setLoadingTransactions(
//         false,
//       );
//     }
//   }

//   void clearLastTransaction() {
//     _lastTransaction =
//         null;

//     notifyListeners();
//   }

//   void clearTransactions() {
//     _transactions.clear();

//     notifyListeners();
//   }

//   void clearError() {
//     _error = null;

//     notifyListeners();
//   }

//   void _setPurchasing(
//     bool value,
//   ) {
//     _isPurchasing =
//         value;

//     notifyListeners();
//   }

//   void _setLoadingPlans(
//     bool value,
//   ) {
//     _isLoadingPlans =
//         value;

//     notifyListeners();
//   }

//   void
//       _setLoadingTransactions(
//     bool value,
//   ) {
//     _isLoadingTransactions =
//         value;

//     notifyListeners();
//   }

//   void _setError(
//     String error,
//   ) {
//     _error = error;

//     notifyListeners();
//   }

//   void _clearError() {
//     _error = null;
//   }
// }

import 'package:flutter/material.dart';

import 'package:vtu_app/core/models/data_plan.dart';
import 'package:vtu_app/core/models/transaction.dart';

import 'package:vtu_app/core/services/vtu_service.dart';

class VTUProvider extends ChangeNotifier {
  final VTUService _vtuService = VTUService();

  bool _isPurchasing = false;

  bool _isLoadingPlans = false;

  bool _isLoadingTransactions = false;

  String? _error;

  List<DataPlan> _dataPlans = [];

  List<Transaction> _transactions = [];

  VTUResponse? _lastTransaction;

  final Set<String> _activeRequests = {};

  bool get isPurchasing => _isPurchasing;

  bool get isLoadingPlans => _isLoadingPlans;

  bool get isLoadingTransactions => _isLoadingTransactions;

  String? get error => _error;

  List<DataPlan> get dataPlans => _dataPlans;

  List<Transaction> get transactions => _transactions;

  VTUResponse? get lastTransaction => _lastTransaction;

  /// AIRTIME
  Future<bool> purchaseAirtime({
    required String network,
    required String phone,
    required double amount,
    required String requestId,
  }) async {
    return _executePurchase(
      requestId: requestId,
      operation: () async {
        return await _vtuService.purchaseAirtime(
          AirtimeRequest(
            network: network,
            phone: phone,
            amountInKobo: (amount * 100).round(),
            requestId: requestId,
          ),
        );
      },
    );
  }

  /// DATA
  Future<bool> purchaseData({
    required String network,
    required String phone,
    required String dataPlan,
    required String requestId,
  }) async {
    return _executePurchase(
      requestId: requestId,
      operation: () async {
        return await _vtuService.purchaseData(
          DataRequest(
            network: network,
            phone: phone,
            dataPlan: dataPlan,
            requestId: requestId,
          ),
        );
      },
    );
  }

  /// ELECTRICITY
  Future<bool> purchaseElectricity({
    required String disco,
    required String meterNumber,
    required double amount,
    required String meterType,
    required String requestId,
  }) async {
    return _executePurchase(
      requestId: requestId,
      operation: () async {
        return await _vtuService.purchaseElectricity(
          ElectricityRequest(
            disco: disco,
            meterNumber: meterNumber,
            amountInKobo: (amount * 100).round(),
            meterType: meterType,
            requestId: requestId,
          ),
        );
      },
    );
  }

  /// TV
  Future<bool> purchaseTV({
    required String provider,
    required String smartcardNumber,
    required String package,
    required String requestId,
  }) async {
    return _executePurchase(
      requestId: requestId,
      operation: () async {
        return await _vtuService.purchaseTV(
          TVRequest(
            provider: provider,
            smartcardNumber: smartcardNumber,
            package: package,
            requestId: requestId,
          ),
        );
      },
    );
  }

  /// EXAM PIN
  Future<bool> purchaseExamPIN({
    required String examType,
    required int quantity,
    required String requestId,
  }) async {
    return _executePurchase(
      requestId: requestId,
      operation: () async {
        return await _vtuService.purchaseExamPIN(
          ExamPinRequest(
            examType: examType,
            quantity: quantity,
            requestId: requestId,
          ),
        );
      },
    );
  }

  /// EXECUTE PURCHASE
  Future<bool> _executePurchase({
    required String requestId,
    required Future<VTUResponse> Function() operation,
  }) async {
    if (_activeRequests.contains(requestId)) {
      return false;
    }

    _activeRequests.add(requestId);

    _setPurchasing(true);

    _clearError();

    try {
      final response = await operation();

      if (response.success) {
        _lastTransaction = response;

        return true;
      }

      _setError(response.message);

      return false;
    } catch (e) {
      _setError(e.toString());

      return false;
    } finally {
      _activeRequests.remove(requestId);

      _setPurchasing(false);
    }
  }

  /// LOAD DATA PLANS
  Future<void> loadDataPlans(String network) async {
    _setLoadingPlans(true);

    _clearError();

    try {
      final response = await _vtuService.getDataPlans(network);

      _dataPlans = response.plans;
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoadingPlans(false);
    }
  }

  /// LOAD TRANSACTIONS
  Future<void> loadTransactions({
    int page = 1,
    String? serviceType,
  }) async {
    _setLoadingTransactions(true);

    _clearError();

    try {
      final fetched = await _vtuService.getTransactions(
        page: page,
        serviceType: serviceType,
      );

      if (page == 1) {
        _transactions = fetched;
      } else {
        _transactions.addAll(fetched);
      }
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoadingTransactions(false);
    }
  }

  void clearLastTransaction() {
    _lastTransaction = null;

    notifyListeners();
  }

  void clearTransactions() {
    _transactions.clear();

    notifyListeners();
  }

  void clearError() {
    _error = null;

    notifyListeners();
  }

  void _setPurchasing(bool value) {
    _isPurchasing = value;

    notifyListeners();
  }

  void _setLoadingPlans(bool value) {
    _isLoadingPlans = value;

    notifyListeners();
  }

  void _setLoadingTransactions(bool value) {
    _isLoadingTransactions = value;

    notifyListeners();
  }

  void _setError(String error) {
    _error = error;

    notifyListeners();
  }

  void _clearError() {
    _error = null;
  }
}