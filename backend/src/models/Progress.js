const mongoose = require('mongoose');

const progressSchema = new mongoose.Schema({
  userId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true
  },
  missionId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Mission',
    required: true
  },
  status: {
    type: String,
    enum: ['pending', 'in_progress', 'completed'],
    default: 'pending'
  },
  startTime: {
    type: Date
  },
  endTime: {
    type: Date
  },
  duration: {
    type: Number, // in minutes
    default: 0
  },
  isCompleted: {
    type: Boolean,
    default: false
  },
  createdAt: {
    type: Date,
    default: Date.now
  },
  updatedAt: {
    type: Date,
    default: Date.now
  }
});

// Update the updatedAt field before saving
progressSchema.pre('save', function(next) {
  this.updatedAt = new Date();
  next();
});

// Static method to get user's progress summary
progressSchema.statics.getUserProgressSummary = async function(userId) {
  const summary = await this.aggregate([
    {
      $match: {
        userId: new mongoose.Types.ObjectId(userId),
        isCompleted: true
      }
    },
    {
      $group: {
        _id: null,
        totalCompleted: { $sum: 1 },
        totalDuration: { $sum: '$duration' },
        totalExperience: { $sum: '$missionId.experienceReward' },
        totalCoins: { $sum: '$missionId.coinsReward' }
      }
    }
  ]);
  
  return summary[0] || {
    totalCompleted: 0,
    totalDuration: 0,
    totalExperience: 0,
    totalCoins: 0
  };
};

module.exports = mongoose.model('Progress', progressSchema);