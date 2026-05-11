require('dotenv').config();
const express = require('express');
const jwt = require('jsonwebtoken');
const crypto = require('crypto');
const authMiddleware = require('./lib/auth');
const blockchain = require('./lib/blockchain');

const app = express();
app.use(express.json());

const JWT_SECRET = process.env.JWT_SECRET || 'supersecret';

// --- MOCK DATABASE ---
// Pour la démonstration, on simule une base de données
const db = {
  transactions: [],
  votes: [],
  reports: []
};

// ==========================================
// ROUTES PUBLIQUES
// ==========================================

/**
 * POST /auth/login
 * @body { phone, pin }
 * @return { token, member }
 */
app.post('/auth/login', (req, res) => {
  const { phone, pin } = req.body;
  
  // Validation simulée
  if (phone === '123456789' && pin === '1234') {
    const member = {
      memberId: 'mem_001',
      phone: phone,
      name: 'John Doe',
      role: 'MEMBER',
      walletAddress: '0x1234567890123456789012345678901234567890'
    };

    const token = jwt.sign(
      { memberId: member.memberId, role: member.role },
      JWT_SECRET,
      { expiresIn: '24h' }
    );

    return res.json({ token, member });
  }

  return res.status(401).json({ error: "Identifiants incorrects" });
});


// ==========================================
// ROUTES PROTÉGÉES (API)
// ==========================================
app.use('/api', authMiddleware);

/**
 * GET /api/coop/:id/balance
 */
app.get('/api/coop/:id/balance', (req, res) => {
  // Simule une balance récupérée depuis la BD
  return res.json({
    balance: 15000,
    updatedAt: new Date().toISOString()
  });
});

/**
 * GET /api/coop/:id/transactions
 * @query page, limit, type
 */
app.get('/api/coop/:id/transactions', (req, res) => {
  const { page = 1, limit = 10, type } = req.query;
  
  let txs = db.transactions;
  if (type) {
    txs = txs.filter(tx => tx.type === type);
  }

  // Pagination basique simulée
  const start = (page - 1) * limit;
  const paginated = txs.slice(start, start + Number(limit));

  return res.json(paginated);
});

/**
 * GET /api/coop/:id/transactions/:txId
 */
app.get('/api/coop/:id/transactions/:txId', (req, res) => {
  const { txId } = req.params;
  const tx = db.transactions.find(t => t.id === txId);
  
  if (!tx) return res.status(404).json({ error: "Transaction non trouvée" });
  
  return res.json(tx);
});

/**
 * POST /api/coop/:id/transactions
 * @body { type, amount, description }
 */
app.post('/api/coop/:id/transactions', async (req, res) => {
  try {
    const { type, amount, description } = req.body;
    const memberAddress = "0x0000000000000000000000000000000000000000"; // En vrai, récupérer via req.member depuis la DB

    // 1. Enregistrement sur la blockchain
    const txHash = await blockchain.recordTx(type, amount, memberAddress, description);

    // 2. Enregistrement en base de données
    const newTx = {
      id: `tx_${Date.now()}`,
      coopId: req.params.id,
      type,
      amount,
      description,
      memberId: req.member.memberId,
      blockchainHash: txHash,
      createdAt: new Date().toISOString()
    };
    db.transactions.push(newTx);

    return res.status(201).json({ 
      message: "Transaction enregistrée avec succès",
      txHash,
      transaction: newTx 
    });
  } catch (error) {
    return res.status(500).json({ error: error.message });
  }
});

/**
 * GET /api/coop/:id/votes
 */
app.get('/api/coop/:id/votes', (req, res) => {
  return res.json(db.votes);
});

/**
 * POST /api/coop/:id/votes/:voteId/cast
 * @body { choice }
 */
app.post('/api/coop/:id/votes/:voteId/cast', async (req, res) => {
  try {
    const { voteId } = req.params;
    const { choice } = req.body;
    
    // Par convention, 1=Pour, 2=Contre. (Doit être un entier > 0)
    const choiceInt = Number(choice);
    if (!choiceInt || choiceInt <= 0) {
      return res.status(400).json({ error: "Choix invalide." });
    }

    const memberAddress = "0x0000000000000000000000000000000000000000"; // Récupéré de la DB

    // Appel à la blockchain
    const txHash = await blockchain.castVote(voteId, choiceInt, memberAddress);

    return res.json({ 
      message: "A voté avec succès", 
      txHash 
    });
  } catch (error) {
    return res.status(500).json({ error: error.message });
  }
});

/**
 * GET /api/coop/:id/reports/:month
 */
app.get('/api/coop/:id/reports/:month', (req, res) => {
  const { month } = req.params;
  const report = db.reports.find(r => r.month === month);
  
  if (!report) return res.status(404).json({ error: "Rapport non trouvé" });
  
  return res.json(report);
});

/**
 * POST /api/coop/:id/reports/:month/anchor
 */
app.post('/api/coop/:id/reports/:month/anchor', async (req, res) => {
  try {
    const { month } = req.params;
    
    // 1. Simulation de la génération d'un PDF
    // En conditions réelles, utiliser pdfkit, puppeteer, etc.
    const mockPdfBuffer = Buffer.from(`Report for ${month}`);

    // 2. Ancrage sur la blockchain
    const { txHash, pdfHash } = await blockchain.anchorReport(month, mockPdfBuffer);

    // 3. Enregistrement en DB
    const newReport = {
      month,
      pdfHash,
      txHash,
      createdAt: new Date().toISOString()
    };
    db.reports.push(newReport);

    return res.json({ 
      message: "Rapport ancré avec succès", 
      txHash,
      pdfHash
    });
  } catch (error) {
    return res.status(500).json({ error: error.message });
  }
});

// ==========================================
// DÉMARRAGE DU SERVEUR
// ==========================================
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Backend server running on port ${PORT}`);
});
