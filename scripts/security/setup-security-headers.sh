#!/bin/bash

echo "🛡️ IMPROVING SECURITY HEADERS"
echo "=============================="

# Create enhanced security headers configuration
cat > backend/src/shared/middleware/securityHeaders.ts << 'EOF'
import helmet from 'helmet';

export const securityHeaders = helmet({
    contentSecurityPolicy: {
        directives: {
            defaultSrc: ["'self'"],
            scriptSrc: ["'self'", "'unsafe-inline'"],
            styleSrc: ["'self'", "'unsafe-inline'"],
            imgSrc: ["'self'", "data:", "https:"],
        },
    },
    crossOriginEmbedderPolicy: false,
    hsts: {
        maxAge: 31536000,
        includeSubDomains: true,
        preload: true
    }
});

// Additional header to prevent MIME type sniffing
export const noSniffHeader = (req: any, res: any, next: any) => {
    res.setHeader('X-Content-Type-Options', 'nosniff');
    next();
};

// Header to prevent clickjacking
export const frameGuard = (req: any, res: any, next: any) => {
    res.setHeader('X-Frame-Options', 'DENY');
    next();
};
EOF

echo "✅ Security headers configured"