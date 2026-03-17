const express = require('express');
const missionController = require('../controllers/missionController');
const { verifyToken } = require('../utils/auth');

const router = express.Router();

// Public routes (no authentication required)
router.get('/', missionController.getAllMissions);
router.get('/:id', missionController.getMissionById);
router.get('/category/:category', missionController.getMissionsByCategory);

// Protected routes (require authentication)
router.use(verifyToken);

// Mission management routes (admin only - would need additional middleware)
router.post('/', missionController.createMission);
router.put('/:id', missionController.updateMission);
router.delete('/:id', missionController.deleteMission);

// User progress routes
router.get('/user/progress', missionController.getUserProgress);
router.post('/start', missionController.startMission);
router.post('/complete', missionController.completeMission);

module.exports = router;