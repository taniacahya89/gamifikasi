const mongoose = require('mongoose');

const missionSchema = new mongoose.Schema({
  title: {
    type: String,
    required: [true, 'Mission title is required'],
    trim: true,
    maxlength: [100, 'Title cannot exceed 100 characters']
  },
  description: {
    type: String,
    required: [true, 'Mission description is required'],
    maxlength: [500, 'Description cannot exceed 500 characters']
  },
  category: {
    type: String,
    required: [true, 'Mission category is required'],
    enum: ['study', 'exercise', 'reading', 'meditation', 'coding', 'other'],
    default: 'other'
  },
  experienceReward: {
    type: Number,
    required: [true, 'Experience reward is required'],
    min: [1, 'Experience reward must be at least 1'],
    max: [1000, 'Experience reward cannot exceed 1000']
  },
  coinsReward: {
    type: Number,
    required: [true, 'Coins reward is required'],
    min: [1, 'Coins reward must be at least 1'],
    max: [500, 'Coins reward cannot exceed 500']
  },
  difficulty: {
    type: String,
    required: [true, 'Mission difficulty is required'],
    enum: ['easy', 'medium', 'hard'],
    default: 'easy'
  },
  duration: {
    type: Number,
    required: [true, 'Mission duration is required'],
    min: [1, 'Duration must be at least 1 minute'],
    max: [480, 'Duration cannot exceed 480 minutes (8 hours)']
  },
  isActive: {
    type: Boolean,
    default: true
  },
  createdAt: {
    type: Date,
    default: Date.now
  }
});

module.exports = mongoose.model('Mission', missionSchema);