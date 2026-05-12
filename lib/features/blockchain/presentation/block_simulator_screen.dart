import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class BlockSimulatorScreen extends StatefulWidget {
  const BlockSimulatorScreen({super.key});

  @override
  State<BlockSimulatorScreen> createState() => _BlockSimulatorScreenState();
}

class _BlockSimulatorScreenState extends State<BlockSimulatorScreen> {
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  final List<SimulatedBlock> _blocks = [];

  @override
  void initState() {
    super.initState();
    // Add Genesis Block
    _blocks.add(SimulatedBlock(
      index: 0,
      hash: "000d8e2b8c5f492298b49265f29f074697926b47",
      description: "Initialisation du registre Agri TG",
      isGenesis: true,
      previousHash: "0000000000000000000000000000000000000000",
    ));
  }

  void _certify() {
    final name = _nameController.text.trim();
    final amount = _amountController.text.trim();

    if (name.isEmpty || amount.isEmpty) return;

    setState(() {
      final prevHash = _blocks.last.hash;
      final newIndex = _blocks.length;
      final newHash = _generateFakeHash("$name$amount$prevHash");

      _blocks.add(SimulatedBlock(
        index: newIndex,
        hash: newHash,
        description: "Cotisation : $amount FCFA — $name",
        previousHash: prevHash,
      ));

      _nameController.clear();
      _amountController.clear();
    });
    FocusScope.of(context).unfocus();
  }

  String _generateFakeHash(String data) {
    final random = Random(data.hashCode);
    const chars = '0123456789abcdef';
    return List.generate(40, (_) => chars[random.nextInt(16)]).join();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Simulateur de Bloc", style: AppTextStyles.heading3),
            const Text("Découvrez comment fonctionne la blockchain", style: TextStyle(fontSize: 10, color: AppColors.textSecondary)),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: AppColors.primaryBg, borderRadius: BorderRadius.circular(12)),
              child: Text(
                "Découvrez comment une transaction est scellée de manière permanente. "
                "Entrez un montant, et observez la création cryptographique d'un nouveau bloc.",
                style: AppTextStyles.body,
              ),
            ),
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    TextField(controller: _nameController, decoration: const InputDecoration(labelText: "Nom du membre")),
                    const SizedBox(height: 16),
                    TextField(controller: _amountController, decoration: const InputDecoration(labelText: "Cotisation (FCFA)"), keyboardType: TextInputType.number),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _certify,
                        child: const Text("Certifier la transaction"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _blocks.length,
              reverse: true,
              itemBuilder: (context, index) {
                final block = _blocks[(_blocks.length - 1) - index];
                return _buildBlockCard(block);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBlockCard(SimulatedBlock block) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.divider),
        borderRadius: BorderRadius.circular(12),
        color: block.isGenesis ? AppColors.primaryBg : AppColors.bgCard,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: AppColors.primaryBg, borderRadius: BorderRadius.circular(6)),
                child: Text("Bloc #${block.index}", style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.primary)),
              ),
              const Spacer(),
              const Icon(Icons.lock, color: AppColors.success, size: 16),
            ],
          ),
          const SizedBox(height: 12),
          Text("Hash: ${block.hash}", style: GoogleFonts.sourceCodePro(fontSize: 12, color: AppColors.primary, fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text(block.description, style: AppTextStyles.bodyMuted),
          if (!block.isGenesis) ...[
            const SizedBox(height: 8),
            Text("↑ Hash précédent: ${block.previousHash.substring(0, 12)}...", style: AppTextStyles.caption),
          ],
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: AppColors.success.withOpacity(0.08), borderRadius: BorderRadius.circular(6)),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.check_circle_outline, size: 12, color: AppColors.success),
                SizedBox(width: 4),
                Text("✓ Bloc validé et immuable", style: TextStyle(fontSize: 10, color: AppColors.success, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SimulatedBlock {
  final int index;
  final String hash;
  final String description;
  final String previousHash;
  final bool isGenesis;

  SimulatedBlock({required this.index, required this.hash, required this.description, required this.previousHash, this.isGenesis = false});
}
