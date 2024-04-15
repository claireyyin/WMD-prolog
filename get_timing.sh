#!/bin/bash

swipl -s main.pl <<EOF > time_min.txt 2>&1
repeat_time_query(10).
halt.
EOF





