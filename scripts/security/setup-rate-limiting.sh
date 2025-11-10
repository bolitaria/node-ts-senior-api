#!/bin/bash

echo "🛡️ SETTING UP RATE LIMITING"
echo "============================"

# Install additional dependencies
npm install express-slow-down

# Create rate limiting middleware
cat > backend/src/shared/middleware/rateLimiting.ts << 'EOF'
import rateLimit from 'express-rate-limit';
import slowDown from 'express-slow-down';

// Rate limiting for authentication
export const authLimiter = rateLimit({
    windowMs: 15 * 60 * 1000, // 15 minutes
    max: 5, // 5 attempts per window
    message: {
        error: 'Too many login attempts, try again after 15 minutes',
    },
    standardHeaders: true,
    legacyHeaders: false,
    skipSuccessfulRequests: true // Don't count successful attempts
});

// Rate limiting for general API
export const apiLimiter = rateLimit({
    windowMs: 1 * 60 * 1000, // 1 minute
    max: 100, // 100 requests per minute
    message: {
        error: 'Too many requests, please try again later',
    },
    standardHeaders: true
});

// Slow down for brute force protection
export const speedLimiter = slowDown({
    windowMs: 15 * 60 * 1000,
    delayAfter: 3, // Allow 3 quick requests
    delayMs: 500 // Add 500ms delay after
});
EOF

echo "✅ Rate limiting configured"