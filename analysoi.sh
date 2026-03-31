#!/bin/bash

# -----------------------------
# Analysis Script
# -----------------------------

REPORT="analysis_report.txt"
echo "Repository Analysis Report" > $REPORT
echo "===========================" >> $REPORT
echo "" >> $REPORT

echo "Starting analysis..."
echo ""

# ----------------------------------------
# 1. Detect programming languages
# ----------------------------------------
echo "Detecting programming languages..."
echo "Detected programming languages:" >> $REPORT

declare -A extensions=(
  ["Python"]="*.py"
  ["Java"]="*.java"
  ["JavaScript"]="*.js"
  ["TypeScript"]="*.ts"
  ["C++"]="*.cpp"
  ["C"]="*.c"
  ["C#"]="*.cs"
  ["Go"]="*.go"
  ["Ruby"]="*.rb"
  ["PHP"]="*.php"
  ["Kotlin"]="*.kt"
  ["Swift"]="*.swift"
)

language_found=false

for lang in "${!extensions[@]}"; do
    pattern=${extensions[$lang]}
    if find . -type f -name "$pattern" | grep -q .; then
        echo "- $lang" | tee -a $REPORT
        language_found=true
    fi
done

if [ "$language_found" = false ]; then
    echo "- No known languages detected" | tee -a $REPORT
fi

echo "" >> $REPORT
echo ""


# ----------------------------------------
# 2. Detect design patterns (heuristics)
# ----------------------------------------
echo "Detecting design patterns..."
echo "Detected design patterns:" >> $REPORT

patterns=(
  "Singleton:getInstance"
  "Singleton:static instance"
  "Factory Method:create[A-Z]"
  "Factory Method:factory"
  "Observer:notify"
  "Observer:subscribe"
  "Observer:observer"
  "Strategy:Strategy"
  "Decorator:Decorator"
  "Decorator:wrap"
)

pattern_found=false

for entry in "${patterns[@]}"; do
    name="${entry%%:*}"
    keyword="${entry#*:}"

    if grep -R -n -E "$keyword" . --exclude-dir=.git 2>/dev/null | grep -q .; then
        echo "- $name" | tee -a $REPORT
        pattern_found=true
    fi
done

if [ "$pattern_found" = false ]; then
    echo "- No common design patterns detected" | tee -a $REPORT
fi

echo "" >> $REPORT
echo ""

echo "Analysis complete. Report:"
echo "---------------------------------"
cat $REPORT
echo "---------------------------------"