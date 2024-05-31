#!/bin/bash
# Get find_person1() query timings; run 10 times
echo "Timing started"
# Start Prolog interpreter and write to txt file
swipl -s singlequery.pl <<EOF > time10.txt 2>&1
repeat_time_query(10). 
halt.
EOF
echo "Timing complete"
