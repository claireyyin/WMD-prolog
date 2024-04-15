# CSE Independent Research Spring 2024 
**by Claire Yin** 
**advised by Peter Kogge**  
Project on using Prolog to represent WMD graph and find Person1

## Main Files
read2prolog.py: Python script to convert CSV dataset to Prolog dataset format  

main.pl: Prolog code for finding Person1 (+subpatterns)  

get_timing.sh: Shell script to retrieve the timings of find_person1 (10 times) -> saved to .txt file 

parse_time.py: Python script to parse the timing text files into CSV files  
*(Inferences, CPU, Seconds, Lips)*

## Supporting Files
person1.pl: one long query for Person1  

answers.txt: text file with IDs of correct answers for subpatterns and Person1 
 
 unittests.pl: Prolog test queries to check subpatterns and final Person1

