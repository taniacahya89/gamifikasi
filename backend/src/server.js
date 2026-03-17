const app = require('./app');
const mongoose = require('mongoose');
const { MongoMemoryServer } = require('mongodb-memory-server');
const proxyMiddleware = require('./middleware/proxyMiddleware');

const PORT = process.env.PORT || 5000;

// Connect to MongoDB
async function connectToDatabase() {
  try {
    if (process.env.NODE_ENV === 'test') {
      // Use in-memory MongoDB for testing
      const mongod = await MongoMemoryServer.create();
      const uri = mongod.getUri();
      await mongoose.connect(uri);
      console.log('Connected to in-memory MongoDB');
    } else {
      // Use real MongoDB for development/production
      await mongoose.connect(process.env.MONGODB_URI);
      console.log('Connected to MongoDB');
    }
  } catch (error) {
    console.error('MongoDB connection error:', error);
    process.exit(1);
  }
}

// Middleware untuk mengizinkan request dari proxy/Ngrok
app.use(proxyMiddleware);
// ... kode sebelumnya tetap sama

// Start server
connectToDatabase().then(() => {
  // Tambahkan '0.0.0.0' di sini
  app.listen(PORT, '0.0.0.0', () => {
    console.log(`Server running on port ${PORT}`);
    // Log ini membantu Anda memastikan IP mana yang harus dipakai di Flutter
    console.log(`Local Access: http://localhost:${PORT}`);
    console.log(`Network Access (untuk HP): http://192.168.1.3:${PORT}`); // Ganti dengan IP laptop Anda
    console.log(`Ngrok Access: https://debi-unpeculating-hollie.ngrok-free.dev`);
  });
});
// ... kode shutdown tetap sama

// Graceful shutdown
process.on('SIGINT', async () => {
  try {
    await mongoose.connection.close();
    console.log('MongoDB connection closed through app termination');
    process.exit(0);
  } catch (error) {
    console.error('Error during graceful shutdown:', error);
    process.exit(1);
  }
});
