#!/bin/bash

line=$(sed -n '16p' report.txt)

echo $line

UNKNOWN=$(echo "$line" | grep -o 'UNKNOWN: [0-9]*' | sed 's/[^0-9]*//g')
LOW=$(echo "$line" | grep -o 'LOW: [0-9]*' | sed 's/[^0-9]*//g')
MEDIUM=$(echo "$line" | grep -o 'MEDIUM: [0-9]*' | sed 's/[^0-9]*//g')
HIGH=$(echo "$line" | grep -o 'HIGH: [0-9]*' | sed 's/[^0-9]*//g')
CRITICAL=$(echo "$line" | grep -o 'CRITICAL: [0-9]*' | sed 's/[^0-9]*//g')

TOTAL=$(echo "$line" | grep -o 'Total: [0-9]*' | sed 's/[^0-9]*//g')

echo "Total: $TOTAL"
echo "UNKNOWN: $UNKNOWN"
echo "LOW: $LOW"
echo "MEDIUM: $MEDIUM"
echo "HIGH: $HIGH"
echo "CRITICAL: $CRITICAL"
