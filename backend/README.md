# Gamifikasi Backend API

Backend API for the Gamifikasi mobile application, built with Node.js, Express, and MongoDB.

## Features

- User authentication (register, login, profile management)
- Mission management system with gamification elements
- Progress tracking and experience points
- Leveling system with streaks
- RESTful API design

## Tech Stack

- **Node.js** - JavaScript runtime
- **Express.js** - Web framework
- **MongoDB** - NoSQL database
- **Mongoose** - ODM for MongoDB
- **JWT** - Authentication tokens
- **bcryptjs** - Password hashing
- **cors** - Cross-origin resource sharing
- **dotenv** - Environment variables

## Project Structure

```
backend/
├── src/
│   ├── models/           # MongoDB models
│   │   ├── User.js       # User model with gamification stats
│   │   ├── Mission.js    # Mission/task model
│   │   └── Progress.js   # User progress tracking
│   ├── controllers/      # Route controllers
│   │   ├── authController.js
│   │   └── missionController.js
│   ├── routes/           # API routes
│   │   ├── authRoutes.js
│   │   └── missionRoutes.js
│   ├── utils/            # Utility functions
│   │   └── auth.js       # Authentication helpers
│   ├── app.js            # Express app configuration
│   └── server.js         # Server entry point
├── seeders/              # Database seeders
│   └── missionSeeder.js  # Sample missions
├── .env.example          # Environment variables template
├── .gitignore           # Git ignore rules
└── package.json         # Project dependencies
```

## Installation

1. Clone the repository
2. Navigate to the backend directory
3. Install dependencies:
   ```bash
   npm install
   ```

## Configuration

1. Copy `.env.example` to `.env`:
   ```bash
   cp .env.example .env
   ```

2. Update the `.env` file with your configuration:
   ```
   NODE_ENV=development
   PORT=5000
   MONGODB_URI=mongodb://localhost:27017/gamifikasi
   JWT_SECRET=your_jwt_secret_key_here
   JWT_EXPIRES_IN=7d
   ```

## Usage

### Development
Start the development server with nodemon:
```bash
npm run dev
```

### Production
Start the production server:
```bash
npm start
```

### Seeding Data
Seed the database with sample missions:
```bash
npm run seed
```

## API Endpoints

### Authentication
- `POST /api/auth/register` - User registration
- `POST /api/auth/login` - User login
- `GET /api/auth/profile` - Get user profile (protected)
- `PUT /api/auth/profile` - Update user profile (protected)
- `POST /api/auth/change-password` - Change password (protected)

### Missions
- `GET /api/missions` - Get all available missions
- `GET /api/missions/:id` - Get mission by ID
- `GET /api/missions/category/:category` - Get missions by category
- `POST /api/missions/start` - Start a mission (protected)
- `POST /api/missions/complete` - Complete a mission (protected)
- `GET /api/missions/user/progress` - Get user progress (protected)

## Database Models

### User
- username, email, password (hashed)
- level, experience, coins, streak
- lastLogin, createdAt

### Mission
- title, description, category
- experienceReward, coinsReward
- difficulty, duration, isActive

### Progress
- userId, missionId
- status (pending, in_progress, completed)
- startTime, endTime, duration
- isCompleted

## Authentication

The API uses JWT (JSON Web Tokens) for authentication. Include the token in the Authorization header:

```
Authorization: Bearer <your-jwt-token>
```

## Development

### Adding New Missions
1. Create mission data in the seeder file
2. Run the seed command to populate the database
3. Or use the admin endpoints to create missions programmatically

### Adding New Features
1. Create/update models in `src/models/`
2. Add controller logic in `src/controllers/`
3. Define routes in `src/routes/`
4. Update the main app in `src/app.js`

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## License

MIT License

## Contact

For questions and support, please contact the development team.