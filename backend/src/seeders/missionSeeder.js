const Mission = require('../models/Mission');

const missions = [
  {
    title: 'Read for 30 minutes',
    description: 'Spend 30 minutes reading a book of your choice. This helps improve your knowledge and vocabulary.',
    category: 'reading',
    experienceReward: 50,
    coinsReward: 10,
    difficulty: 'easy',
    duration: 30
  },
  {
    title: 'Complete 25 minutes of focused study',
    description: 'Study any subject for 25 minutes without distractions. Use the Pomodoro technique for best results.',
    category: 'study',
    experienceReward: 40,
    coinsReward: 8,
    difficulty: 'easy',
    duration: 25
  },
  {
    title: '15 minutes of meditation',
    description: 'Practice mindfulness or meditation for 15 minutes to improve focus and reduce stress.',
    category: 'meditation',
    experienceReward: 30,
    coinsReward: 6,
    difficulty: 'easy',
    duration: 15
  },
  {
    title: 'Write 200 words',
    description: 'Write 200 words in a journal, blog post, or any creative writing exercise.',
    category: 'study',
    experienceReward: 35,
    coinsReward: 7,
    difficulty: 'easy',
    duration: 20
  },
  {
    title: 'Learn a new coding concept',
    description: 'Spend 45 minutes learning a new programming concept or technology.',
    category: 'coding',
    experienceReward: 60,
    coinsReward: 12,
    difficulty: 'medium',
    duration: 45
  },
  {
    title: 'Exercise for 40 minutes',
    description: 'Complete a 40-minute workout session. This could be running, cycling, or any physical activity.',
    category: 'exercise',
    experienceReward: 55,
    coinsReward: 11,
    difficulty: 'medium',
    duration: 40
  },
  {
    title: 'Practice a new language for 30 minutes',
    description: 'Spend 30 minutes learning or practicing a new language using apps or online resources.',
    category: 'study',
    experienceReward: 45,
    coinsReward: 9,
    difficulty: 'medium',
    duration: 30
  },
  {
    title: 'Complete a challenging puzzle',
    description: 'Spend 60 minutes solving a complex puzzle or brain teaser to improve problem-solving skills.',
    category: 'study',
    experienceReward: 70,
    coinsReward: 14,
    difficulty: 'hard',
    duration: 60
  },
  {
    title: 'Code for 90 minutes',
    description: 'Spend 90 minutes coding on a personal project or learning new programming skills.',
    category: 'coding',
    experienceReward: 100,
    coinsReward: 20,
    difficulty: 'hard',
    duration: 90
  },
  {
    title: 'Run 5 kilometers',
    description: 'Complete a 5-kilometer run to improve cardiovascular health and endurance.',
    category: 'exercise',
    experienceReward: 80,
    coinsReward: 16,
    difficulty: 'hard',
    duration: 50
  }
];

const seedMissions = async () => {
  try {
    // Clear existing missions
    await Mission.deleteMany({});
    
    // Insert new missions
    await Mission.insertMany(missions);
    
    console.log('Missions seeded successfully!');
  } catch (error) {
    console.error('Error seeding missions:', error);
  }
};

module.exports = seedMissions;