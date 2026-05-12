import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../transactions/domain/transaction_model.dart';
import '../../votes/domain/vote_model.dart';
import '../../reports/domain/report_model.dart';

final coopApiServiceProvider = Provider<CoopApiService>((ref) {
  return CoopApiService();
});

class CoopApiService {
  CoopApiService();

  Future<double> getBalance(String coopId) async {
    // Mock for hackathon UI development
    return 1248500.0;
  }

  Future<Map<String, dynamic>> getStats(String coopId) async {
    return {
      "activeMembers": 120,
      "openVotes": 2,
      "monthlyIn": 350000.0,
      "monthlyOut": 150000.0,
    };
  }

  Future<List<Transaction>> getTransactions(String coopId, {int limit = 20, int page = 1, String? type, DateTime? startDate}) async {
    return [
      Transaction(
        id: 'tx1',
        type: 'cotisation',
        amount: 25000.0,
        blockchainHash: '0x123abc456def789',
        date: DateTime.now().subtract(const Duration(hours: 2)),
        description: 'Cotisation mensuelle',
        memberName: 'Koffi',
      ),
      Transaction(
        id: 'tx2',
        type: 'achat',
        amount: -5000.0,
        blockchainHash: '0x987fed654cba321',
        date: DateTime.now().subtract(const Duration(days: 1)),
        description: 'Achat engrais',
        memberName: 'Afi',
      ),
    ];
  }

  Future<List<Vote>> getVotes(String coopId, {String status = 'open'}) async {
    return [
      Vote(
        id: 'vote1',
        title: 'Achat d\'un tracteur commun',
        description: 'Voulez-vous allouer 2 000 000 FCFA pour l\'achat d\'un tracteur ?',
        amountThreshold: 2000000.0,
        forCount: 45,
        againstCount: 5,
        abstainCount: 2,
        totalMembers: 120,
        closingDate: DateTime.now().add(const Duration(days: 3)),
        status: 'open',
      ),
    ];
  }

  Future<Vote> getVote(String coopId, String voteId) async {
    return (await getVotes(coopId)).first;
  }

  Future<String> castVote(String coopId, String voteId, String choice) async {
    await Future.delayed(const Duration(seconds: 2));
    return '0xabc123def456';
  }

  Future<List<MonthlyReport>> getReports(String coopId) async {
    return [
      MonthlyReport(
        id: 'rep_2026_04',
        month: '04/2026',
        totalIn: 450000.0,
        totalOut: 120000.0,
        balance: 330000.0,
        transactionCount: 45,
        byCategory: {'Cotisation': 300000.0, 'Achat': 120000.0},
        blockchainHash: '0x111222333444',
        generatedAt: DateTime.now().subtract(const Duration(days: 10)),
      ),
      MonthlyReport(
        id: 'rep_2026_03',
        month: '03/2026',
        totalIn: 380000.0,
        totalOut: 200000.0,
        balance: 180000.0,
        transactionCount: 52,
        byCategory: {'Cotisation': 380000.0, 'Achat': 200000.0},
        blockchainHash: '0x555666777888',
        generatedAt: DateTime.now().subtract(const Duration(days: 40)),
      ),
    ];
  }
}
