#!/bin/bash

echo "🔍 CHECKING LINE ENDINGS"
echo "========================"

# Check for files with CRLF line endings
echo "Files with CRLF line endings:"
find . -type f -name "*.js" -o -name "*.ts" -o -name "*.tsx" -o -name "*.jsx" -o -name "*.json" -o -name "*.md" -o -name "*.yml" -o -name "*.yaml" -o -name "*.html" -o -name "*.css" | xargs file | grep CRLF || echo "✅ No files with CRLF found"

# Check git status for line ending changes
echo ""
echo "Git status for line endings:"
git status | grep "modified:" | grep -v ".sh" || echo "✅ No line ending modifications"

echo ""
echo "💡 If you see CRLF files, run:"
echo "   git add --renormalize ."
echo "   git commit -m 'fix: normalize line endings'"