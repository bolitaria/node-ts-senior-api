#!/bin/bash

echo "🛡️ APPLYING INCREMENTAL SECURITY IMPROVEMENTS"
echo "=============================================="

# Create scripts directory if it doesn't exist
mkdir -p scripts/security

# 1. Apply rate limiting
echo "🛡️ Applying rate limiting..."
./scripts/security/setup-rate-limiting.sh

# 2. Apply security headers
echo "🛡️ Applying security headers..."
./scripts/security/setup-security-headers.sh

# 3. Apply security logging
echo "🛡️ Applying security logging..."
./scripts/security/setup-logging.sh

echo "✅ All security improvements applied"


#echo "🔒 APPLYING SECURITY IMPROVEMENTS"
#echo "================================"
#echo "🛡️ Running security audit..."
#npm audit --audit-level moderate
#echo "🛡️ Checking for vulnerable dependencies..."
#npx better-npm-audit audit
#echo "✅ Security checks completed"