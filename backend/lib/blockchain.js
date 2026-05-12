require('dotenv').config();
const { ethers } = require('ethers');
const crypto = require('crypto');

// Variables d'environnement
const {
  RPC_URL,
  PRIVATE_KEY,
  COOP_LEDGER_ADDRESS,
  VOTE_GOVERNANCE_ADDRESS,
  REPORT_ANCHOR_ADDRESS
} = process.env;

if (!RPC_URL || !PRIVATE_KEY) {
  console.warn("Variables d'environnement blockchain manquantes.");
}

// Initialisation du provider et du wallet
const provider = new ethers.JsonRpcProvider(RPC_URL);
const wallet = new ethers.Wallet(PRIVATE_KEY || '0x0000000000000000000000000000000000000000000000000000000000000000', provider);

// ABIs mis à jour pour correspondre aux contrats raffinés
const COOP_LEDGER_ABI = [
  "function recordTransaction(uint256 id, string _type, uint256 _montant, address _membre, uint256 _date, string _description) external"
];

const VOTE_GOVERNANCE_ABI = [
  "function castVote(uint256 voteId, uint8 choice, address memberAddress) external",
  "function getResults(uint256 voteId) external view returns (uint256 pour, uint256 contre, uint256 abstention)"
];

const REPORT_ANCHOR_ABI = [
  "function anchorReport(string _month, bytes32 pdfHash) external"
];

// Instanciation des contrats
const coopLedger = new ethers.Contract(COOP_LEDGER_ADDRESS || ethers.ZeroAddress, COOP_LEDGER_ABI, wallet);
const voteGovernance = new ethers.Contract(VOTE_GOVERNANCE_ADDRESS || ethers.ZeroAddress, VOTE_GOVERNANCE_ABI, wallet);
const reportAnchor = new ethers.Contract(REPORT_ANCHOR_ADDRESS || ethers.ZeroAddress, REPORT_ANCHOR_ABI, wallet);

/**
 * Enregistre une transaction sur la blockchain
 */
async function recordTx(type, amount, memberAddress, description) {
  try {
    const txId = Math.floor(Date.now() / 1000) + Math.floor(Math.random() * 10000);
    const date = Math.floor(Date.now() / 1000);
    
    if (!ethers.isAddress(memberAddress)) {
      throw new Error("Adresse membre invalide");
    }

    const tx = await coopLedger.recordTransaction(
      txId,
      type,
      ethers.parseUnits(amount.toString(), 18),
      memberAddress,
      date,
      description
    );

    const receipt = await tx.wait();
    return receipt.hash;
  } catch (error) {
    console.error("Erreur blockchain (recordTx):", error);
    throw new Error("Échec de l'enregistrement de la transaction sur la blockchain : " + error.message);
  }
}

/**
 * Enregistre un vote sur la blockchain au nom d'un membre
 */
async function castVote(voteId, choice, memberAddress) {
  try {
    if (!ethers.isAddress(memberAddress)) {
      throw new Error("Adresse membre invalide");
    }

    const tx = await voteGovernance.castVote(voteId, choice, memberAddress);
    const receipt = await tx.wait();
    return receipt.hash;
  } catch (error) {
    console.error("Erreur blockchain (castVote):", error);
    throw new Error("Échec de la soumission du vote sur la blockchain : " + error.message);
  }
}

/**
 * Ancre l'empreinte d'un rapport mensuel sur la blockchain
 */
async function anchorReport(month, pdfBuffer) {
  try {
    // Utilisation de SHA256 (via crypto) comme demandé
    const pdfHash = "0x" + crypto.createHash('sha256').update(pdfBuffer).digest('hex');
    const tx = await reportAnchor.anchorReport(month, pdfHash);
    const receipt = await tx.wait();
    return { txHash: receipt.hash, pdfHash };
  } catch (error) {
    console.error("Erreur blockchain (anchorReport):", error);
    throw new Error("Échec de l'ancrage du rapport sur la blockchain : " + error.message);
  }
}

/**
 * Récupère les résultats d'un vote
 */
async function getVoteResults(voteId) {
  try {
    const [pour, contre, abstention] = await voteGovernance.getResults(voteId);
    
    return {
      for: Number(pour),
      against: Number(contre),
      abstain: Number(abstention)
    };
  } catch (error) {
    console.error("Erreur blockchain (getVoteResults):", error);
    throw new Error("Impossible de récupérer les résultats du vote : " + error.message);
  }
}

module.exports = {
  recordTx,
  castVote,
  anchorReport,
  getVoteResults
};
