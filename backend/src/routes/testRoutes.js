const express = require('express');
const router = express.Router();

router.get('/test', (req, res) => {
  res.json({
    success: true,
    message: 'Test endpoint berhasil',
    trusted: req.trusted,
    clientIP: req.header('x-forwarded-for') || req.connection.remoteAddress,
    headers: req.headers
  });
});

module.exports = router;