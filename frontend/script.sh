#!/bin/bash

FILE="report.txt"

low=$(grep  "LOW" "$FILE" | wc -l)
medium=$(grep  "MEDIUM" "$FILE" | wc -l)
high=$(grep  "HIGH" "$FILE" | wc -l)
critical=$(grep  "CRITICAL" "$FILE" | wc -l)
unknown=$(grep "UNKNOWN" "$FILE" | wc -l)

echo "Vulnerability Severity Count:"
echo "Low:      $low"
echo "Medium:   $medium"
echo "High:     $high"
echo "Critical: $critical"
