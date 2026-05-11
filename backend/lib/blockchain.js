require('dotenv').config();
const { ethers } = require('ethers');

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

// ABIs simplifiés
const COOP_LEDGER_ABI = [
  "function recordTransaction(uint256 id, string txType, uint256 amount, address member, uint256 date, string description) external"
];

const VOTE_GOVERNANCE_ABI = [
  "function castVote(uint256 voteId, uint8 choice) external",
  "function getResults(uint256 voteId) external view returns (uint256 yesVotes, uint256 noVotes)"
];

const REPORT_ANCHOR_ABI = [
  "function anchorReport(string month, bytes32 pdfHash) external"
];

// Instanciation des contrats
const coopLedger = new ethers.Contract(COOP_LEDGER_ADDRESS, COOP_LEDGER_ABI, wallet);
const voteGovernance = new ethers.Contract(VOTE_GOVERNANCE_ADDRESS, VOTE_GOVERNANCE_ABI, wallet);
const reportAnchor = new ethers.Contract(REPORT_ANCHOR_ADDRESS, REPORT_ANCHOR_ABI, wallet);

/**
 * Enregistre une transaction sur la blockchain
 */
async function recordTx(type, amount, memberAddress, description) {
  try {
    const txId = Math.floor(Date.now() / 1000) + Math.floor(Math.random() * 10000);
    const date = Math.floor(Date.now() / 1000);
    
    // address check
    if (!ethers.isAddress(memberAddress)) {
      throw new Error("Adresse membre invalide");
    }

    const tx = await coopLedger.recordTransaction(
      txId,
      type,
      ethers.parseUnits(amount.toString(), 18), // Supposons 18 décimales
      memberAddress,
      date,
      description
    );

    const receipt = await tx.wait();
    return receipt.hash;
  } catch (error) {
    console.error("Erreur blockchain (recordTx):", error);
    throw new Error("Échec de l'enregistrement de la transaction sur la blockchain.");
  }
}

/**
 * Enregistre un vote sur la blockchain
 * Note: Le contrat actuel utilise msg.sender. Si le backend vote au nom de l'utilisateur,
 * le contrat doit être adapté pour accepter l'adresse du membre.
 */
async function castVote(voteId, choice, memberAddress) {
  try {
    // Par défaut on envoie le choix au contrat.
    // Si une évolution du contrat inclut l'adresse, on pourra la passer ici.
    const tx = await voteGovernance.castVote(voteId, choice);
    const receipt = await tx.wait();
    return receipt.hash;
  } catch (error) {
    console.error("Erreur blockchain (castVote):", error);
    throw new Error("Échec de la soumission du vote sur la blockchain.");
  }
}

/**
 * Ancre l'empreinte d'un rapport mensuel sur la blockchain
 */
async function anchorReport(month, pdfBuffer) {
  try {
    const pdfHash = ethers.sha256(pdfBuffer);
    const tx = await reportAnchor.anchorReport(month, pdfHash);
    const receipt = await tx.wait();
    return { txHash: receipt.hash, pdfHash };
  } catch (error) {
    console.error("Erreur blockchain (anchorReport):", error);
    throw new Error("Échec de l'ancrage du rapport sur la blockchain.");
  }
}

/**
 * Récupère les résultats d'un vote
 */
async function getVoteResults(voteId) {
  try {
    const [yesVotes, noVotes] = await voteGovernance.getResults(voteId);
    
    // On mappe yesVotes à "for" et noVotes à "against", et "abstain" à 0 car non géré dans le SC actuel
    return {
      for: Number(yesVotes),
      against: Number(noVotes),
      abstain: 0
    };
  } catch (error) {
    console.error("Erreur blockchain (getVoteResults):", error);
    throw new Error("Impossible de récupérer les résultats du vote.");
  }
}

module.exports = {
  recordTx,
  castVote,
  anchorReport,
  getVoteResults
};
