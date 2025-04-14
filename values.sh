#!/bin/bash

FILE="report.txt"

low=0
medium=0
high=0
critical=0
unknown=0

low=$(grep  "LOW" "$FILE" | wc -l)
medium=$(grep  "MEDIUM" "$FILE" | wc -l)
high=$(grep  "HIGH" "$FILE" | wc -l)
critical=$(grep  "CIRITCAL" "$FILE" | wc -l)
unknown=$(grep "UNKNOWN" "$FILE" | wc -l)

echo "Vulnerability Severity Count:"
echo "Low:      $low"
echo "Medium:   $medium"
echo "High:     $high"
echo "Critical: $critical"
