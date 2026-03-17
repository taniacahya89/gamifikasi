const cors = require('cors');

const ngrokOptions = {
  origin: (origin, callback) => {
    // Izinkan semua origin untuk request dari Ngrok
    if (origin) {
      console.log('Request dari origin:', origin);
      return callback(null, true);
    }
    callback(null, true);
  },
  credentials: true,
  methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
  allowedHeaders: ['Content-Type', 'Authorization', 'ngrok-skip-browser-warning', 'Accept'],
  exposedHeaders: ['Content-Type', 'Authorization']
};

module.exports = cors(ngrokOptions);