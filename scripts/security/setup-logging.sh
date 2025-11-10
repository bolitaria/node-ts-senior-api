#!/bin/bash

echo "📝 SETTING UP SECURITY LOGGING"
echo "==============================="

# Create security logger
cat > backend/src/shared/utils/securityLogger.ts << 'EOF'
import winston from 'winston';

export const securityLogger = winston.createLogger({
    level: 'info',
    format: winston.format.combine(
        winston.format.timestamp(),
        winston.format.errors({ stack: true }),
        winston.format.json(),
    ),
    defaultMeta: { service: 'security' },
    transports: [
        new winston.transports.File({ filename: 'logs/security-error.log', level: 'error' }),
        new winston.transports.File({ filename: 'logs/security-combined.log' }),
    ],
});

// Helper for security events
export const logSecurityEvent = (eventType: string, data: any) => {
    securityLogger.info(eventType, {
        timestamp: new Date().toISOString(),
        ip: data.ip,
        userAgent: data.userAgent,
        userId: data.userId,
        eventData: data.eventData
    });
};

// Specific events
export const SecurityEvents = {
    LOGIN_ATTEMPT: 'LOGIN_ATTEMPT',
    LOGIN_SUCCESS: 'LOGIN_SUCCESS',
    LOGIN_FAILED: 'LOGIN_FAILED',
    REGISTER_ATTEMPT: 'REGISTER_ATTEMPT',
    TOKEN_REFRESH: 'TOKEN_REFRESH',
    SUSPICIOUS_ACTIVITY: 'SUSPICIOUS_ACTIVITY'
};
EOF

echo "✅ Security logging configured"