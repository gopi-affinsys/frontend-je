  #!/bin/bash
  
  FILE="report.txt"
  
  export low=0
  export medium=0
  export high=0
  export critical=0
  export unknown=0
  
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
