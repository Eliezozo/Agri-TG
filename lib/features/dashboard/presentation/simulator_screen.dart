import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class BlockchainSimulatorScreen extends StatefulWidget {
  const BlockchainSimulatorScreen({super.key});

  @override
  State<BlockchainSimulatorScreen> createState() => _BlockchainSimulatorScreenState();
}

class _BlockchainSimulatorScreenState extends State<BlockchainSimulatorScreen> {
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  final List<SimulatedBlock> _blocks = [
    SimulatedBlock(
      index: 0,
      timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
      data: "Initialisation du registre Agri-TG",
      previousHash: "0" * 64,
      hash: "000d8e2b8c5f492298b49265f29f074697926b47594921f0084534f9a0d8e2b8",
    ),
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _addBlock() {
    final name = _nameController.text.trim();
    final amount = _amountController.text.trim();

    if (name.isEmpty || amount.isEmpty) return;

    setState(() {
      final prevBlock = _blocks.last;
      final index = prevBlock.index + 1;
      final timestamp = DateTime.now();
      final data = "Membre: $name, Cotisation: $amount FCFA";

      // Simulation simple de hachage SHA256
      final content = "$index$timestamp$data${prevBlock.hash}";
      final hash = sha256.convert(utf8.encode(content)).toString();

      _blocks.add(SimulatedBlock(
        index: index,
        timestamp: timestamp,
        data: data,
        previousHash: prevBlock.hash,
        hash: hash,
      ));

      _nameController.clear();
      _amountController.clear();
    });

    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Simulateur de Bloc')),
      body: Column(
        children: [
          // Input Section
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Nouvelle Transaction',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Nom du membre',
                        prefixIcon: Icon(Icons.person_outline),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Cotisation (FCFA)',
                        prefixIcon: Icon(Icons.account_balance_wallet_outlined),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.security),
                        label: const Text('Certifier la transaction'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: _addBlock,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const Divider(),

          // Blockchain visualization
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              itemCount: _blocks.length,
              reverse: true, // Show latest blocks on top
              itemBuilder: (context, index) {
                final block = _blocks[(_blocks.length - 1) - index];
                return _buildBlockItem(block);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBlockItem(SimulatedBlock block) {
    final isGenesis = block.index == 0;

    return Column(
      children: [
        if (block.index < _blocks.length - 1)
          const Icon(Icons.link, color: AppColors.primaryLight),
        Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          color: isGenesis ? AppColors.bgAccent : AppColors.bgCard,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: AppColors.primary.withOpacity(0.5)),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'BLOC #${block.index}',
                      style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryLight),
                    ),
                    if (isGenesis)
                      const Text('GENESIS', style: TextStyle(fontSize: 10, color: Colors.orange, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 12),
                _buildField('Données:', block.data),
                const SizedBox(height: 8),
                _buildField('Hash:', block.hash, isHash: true),
                const SizedBox(height: 4),
                _buildField('Précédent:', block.previousHash, isHash: true),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    block.timestamp.toString().substring(0, 19),
                    style: const TextStyle(fontSize: 10, color: AppColors.textMuted),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildField(String label, String value, {bool isHash = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textMuted, fontWeight: FontWeight.w600)),
        Text(
          value,
          style: TextStyle(
            fontSize: isHash ? 10 : 13,
            fontFamily: isHash ? 'monospace' : null,
            color: isHash ? AppColors.textSecondary : AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

class SimulatedBlock {
  final int index;
  final DateTime timestamp;
  final String data;
  final String previousHash;
  final String hash;

  SimulatedBlock({
    required this.index,
    required this.timestamp,
    required this.data,
    required this.previousHash,
    required this.hash,
  });
}
