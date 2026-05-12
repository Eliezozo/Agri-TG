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
const db = {
  transactions: [],
  votes: [
    { id: "0", title: "Achat de tracteur", status: "open", closingDate: new Date(Date.now() + 86400000).toISOString() }
  ],
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
  
  if (phone === '123456789' && pin === '1234') {
    const member = {
      memberId: 'mem_001',
      phone: phone,
      name: 'John Doe',
      role: 'MEMBER',
      walletAddress: '0x1234567890123456789012345678901234567890'
    };

    const token = jwt.sign(
      {
        memberId: member.memberId,
        role: member.role,
        walletAddress: member.walletAddress
      },
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
  return res.json({
    balance: 15000,
    updatedAt: new Date().toISOString()
  });
});

/**
 * GET /api/coop/:id/transactions
 */
app.get('/api/coop/:id/transactions', (req, res) => {
  const { page = 1, limit = 10, type } = req.query;
  
  let txs = db.transactions;
  if (type) {
    txs = txs.filter(tx => tx.type === type);
  }

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
    const memberAddress = req.member.walletAddress;

    if (!memberAddress) {
      return res.status(400).json({ error: "Adresse de wallet du membre manquante" });
    }

    const txHash = await blockchain.recordTx(type, amount, memberAddress, description);

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
    
    const choiceInt = Number(choice);
    if (!choiceInt || choiceInt < 1 || choiceInt > 3) {
      return res.status(400).json({ error: "Choix invalide (1=Pour, 2=Contre, 3=Abstention)." });
    }

    const memberAddress = req.member.walletAddress;
    if (!memberAddress) {
      return res.status(400).json({ error: "Adresse de wallet du membre manquante" });
    }

    const txHash = await blockchain.castVote(voteId, choiceInt, memberAddress);

    return res.json({ 
      message: "Vote enregistré avec succès sur la blockchain",
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
    
    const mockPdfBuffer = Buffer.from(`Report for ${month}`);

    const { txHash, pdfHash } = await blockchain.anchorReport(month, mockPdfBuffer);

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

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Backend server running on port ${PORT}`);
});
