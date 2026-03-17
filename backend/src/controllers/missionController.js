const Mission = require('../models/Mission');
const Progress = require('../models/Progress');
const User = require('../models/User');

// Get all available missions
const getAllMissions = async (req, res) => {
  try {
    const missions = await Mission.find({ isActive: true })
      .sort({ difficulty: 1, experienceReward: -1 })
      .lean();

    res.json({
      success: true,
      data: {
        missions
      }
    });

  } catch (error) {
    console.error('Get missions error:', error);
    res.status(500).json({
      success: false,
      message: 'Internal server error'
    });
  }
};

// Get mission by ID
const getMissionById = async (req, res) => {
  try {
    const { id } = req.params;
    const mission = await Mission.findById(id);

    if (!mission) {
      return res.status(404).json({
        success: false,
        message: 'Mission not found'
      });
    }

    if (!mission.isActive) {
      return res.status(404).json({
        success: false,
        message: 'Mission is not available'
      });
    }

    res.json({
      success: true,
      data: {
        mission
      }
    });

  } catch (error) {
    console.error('Get mission by ID error:', error);
    res.status(500).json({
      success: false,
      message: 'Internal server error'
    });
  }
};

// Get missions by category
const getMissionsByCategory = async (req, res) => {
  try {
    const { category } = req.params;
    const missions = await Mission.find({ 
      category, 
      isActive: true 
    }).sort({ difficulty: 1, experienceReward: -1 });

    res.json({
      success: true,
      data: {
        missions
      }
    });

  } catch (error) {
    console.error('Get missions by category error:', error);
    res.status(500).json({
      success: false,
      message: 'Internal server error'
    });
  }
};

// Create a new mission (admin only)
const createMission = async (req, res) => {
  try {
    const { title, description, category, experienceReward, coinsReward, difficulty, duration } = req.body;

    // Validation
    if (!title || !description || !category || !experienceReward || !coinsReward || !difficulty || !duration) {
      return res.status(400).json({
        success: false,
        message: 'All fields are required'
      });
    }

    const mission = new Mission({
      title,
      description,
      category,
      experienceReward,
      coinsReward,
      difficulty,
      duration
    });

    await mission.save();

    res.status(201).json({
      success: true,
      message: 'Mission created successfully',
      data: {
        mission
      }
    });

  } catch (error) {
    console.error('Create mission error:', error);
    res.status(500).json({
      success: false,
      message: 'Internal server error'
    });
  }
};

// Update mission (admin only)
const updateMission = async (req, res) => {
  try {
    const { id } = req.params;
    const updateData = req.body;

    const mission = await Mission.findByIdAndUpdate(
      id,
      updateData,
      { new: true, runValidators: true }
    );

    if (!mission) {
      return res.status(404).json({
        success: false,
        message: 'Mission not found'
      });
    }

    res.json({
      success: true,
      message: 'Mission updated successfully',
      data: {
        mission
      }
    });

  } catch (error) {
    console.error('Update mission error:', error);
    res.status(500).json({
      success: false,
      message: 'Internal server error'
    });
  }
};

// Delete mission (admin only)
const deleteMission = async (req, res) => {
  try {
    const { id } = req.params;

    const mission = await Mission.findByIdAndDelete(id);

    if (!mission) {
      return res.status(404).json({
        success: false,
        message: 'Mission not found'
      });
    }

    // Also delete related progress records
    await Progress.deleteMany({ missionId: id });

    res.json({
      success: true,
      message: 'Mission deleted successfully'
    });

  } catch (error) {
    console.error('Delete mission error:', error);
    res.status(500).json({
      success: false,
      message: 'Internal server error'
    });
  }
};

// Get user's mission progress
const getUserProgress = async (req, res) => {
  try {
    const userId = req.user._id;
    
    const progress = await Progress.find({ userId })
      .populate('missionId', 'title category difficulty experienceReward coinsReward')
      .sort({ createdAt: -1 });

    const summary = await Progress.getUserProgressSummary(userId);

    res.json({
      success: true,
      data: {
        progress,
        summary
      }
    });

  } catch (error) {
    console.error('Get user progress error:', error);
    res.status(500).json({
      success: false,
      message: 'Internal server error'
    });
  }
};

// Start a mission
const startMission = async (req, res) => {
  try {
    const { missionId } = req.body;
    const userId = req.user._id;

    // Check if mission exists and is active
    const mission = await Mission.findById(missionId);
    if (!mission || !mission.isActive) {
      return res.status(404).json({
        success: false,
        message: 'Mission not found or not available'
      });
    }

    // Check if user already has this mission in progress
    const existingProgress = await Progress.findOne({
      userId,
      missionId,
      status: { $in: ['pending', 'in_progress'] }
    });

    if (existingProgress) {
      return res.status(400).json({
        success: false,
        message: 'You already have this mission in progress'
      });
    }

    // Create new progress record
    const progress = new Progress({
      userId,
      missionId,
      status: 'in_progress',
      startTime: new Date()
    });

    await progress.save();

    res.json({
      success: true,
      message: 'Mission started successfully',
      data: {
        progress
      }
    });

  } catch (error) {
    console.error('Start mission error:', error);
    res.status(500).json({
      success: false,
      message: 'Internal server error'
    });
  }
};

// Complete a mission
const completeMission = async (req, res) => {
  try {
    const { progressId } = req.body;
    const userId = req.user._id;

    // Find and update progress
    const progress = await Progress.findOne({
      _id: progressId,
      userId,
      status: 'in_progress'
    }).populate('missionId');

    if (!progress) {
      return res.status(404).json({
        success: false,
        message: 'Progress not found or already completed'
      });
    }

    const endTime = new Date();
    const duration = Math.floor((endTime - progress.startTime) / (1000 * 60)); // in minutes

    // Check if duration meets minimum requirement
    if (duration < progress.missionId.duration) {
      return res.status(400).json({
        success: false,
        message: `Mission requires at least ${progress.missionId.duration} minutes to complete`
      });
    }

    // Update progress
    progress.status = 'completed';
    progress.endTime = endTime;
    progress.duration = duration;
    progress.isCompleted = true;
    await progress.save();

    // Update user stats
    const user = await User.findById(userId);
    const experienceGained = progress.missionId.experienceReward;
    const coinsGained = progress.missionId.coinsReward;

    user.coins += coinsGained;
    const levelUpResult = user.addExperience(experienceGained);
    await user.save();

    res.json({
      success: true,
      message: 'Mission completed successfully',
      data: {
        progress,
        rewards: {
          experience: experienceGained,
          coins: coinsGained,
          levelUp: levelUpResult.leveledUp,
          newLevel: levelUpResult.leveledUp ? levelUpResult.newLevel : user.level
        },
        user: {
          id: user._id,
          level: user.level,
          experience: user.experience,
          coins: user.coins,
          streak: user.streak
        }
      }
    });

  } catch (error) {
    console.error('Complete mission error:', error);
    res.status(500).json({
      success: false,
      message: 'Internal server error'
    });
  }
};

module.exports = {
  getAllMissions,
  getMissionById,
  getMissionsByCategory,
  createMission,
  updateMission,
  deleteMission,
  getUserProgress,
  startMission,
  completeMission
};