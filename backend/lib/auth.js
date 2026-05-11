const jwt = require('jsonwebtoken');

const JWT_SECRET = process.env.JWT_SECRET || 'supersecret';

/**
 * Middleware d'authentification pour vérifier le token JWT
 * Extrait memberId et role du payload et les assigne à req.member
 */
function authMiddleware(req, res, next) {
  const authHeader = req.headers.authorization;

  if (!authHeader || !authHeader.startsWith('Bearer ')) {
    return res.status(401).json({ error: "Non autorisé. Token manquant." });
  }

  const token = authHeader.split(' ')[1];

  try {
    const decoded = jwt.verify(token, JWT_SECRET);
    
    // Extrait memberId et role et les met dans req.member
    req.member = {
      memberId: decoded.memberId,
      role: decoded.role
    };
    
    next();
  } catch (error) {
    return res.status(403).json({ error: "Token invalide ou expiré." });
  }
}

module.exports = authMiddleware;
