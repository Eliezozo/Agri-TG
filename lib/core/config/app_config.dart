class AppConfig {
  static const String apiBaseUrl =
      String.fromEnvironment('API_BASE_URL', defaultValue: 'http://10.0.2.2:3000/api');
  static const String rpcUrl =
      String.fromEnvironment('RPC_URL', defaultValue: 'http://10.0.2.2:8545');
  static const String voteContractAddress =
      String.fromEnvironment('VOTE_CONTRACT', defaultValue: '0x...');
}
