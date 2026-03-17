const cors = require('cors');

const corsOptions = {
  origin: [
    'http://localhost:5000',
    'http://127.0.0.1:5000',
    'http://192.168.18.171:5000',
    'https://debi-unpeculating-hollie.ngrok-free.dev',
    'https://*.ngrok.io'
  ],
  credentials: true,
  methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
  allowedHeaders: ['Content-Type', 'Authorization', 'ngrok-skip-browser-warning', 'Accept'],
  exposedHeaders: ['Content-Type', 'Authorization']
};

module.exports = cors(corsOptions);