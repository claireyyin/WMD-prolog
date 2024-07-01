# CSE Independent Research Spring 2024 
**by Claire Yin**  
**advised by Professor Peter Kogge**  
Project on using Prolog to model the relationships of complex WMD graph and find Person1

## Main Files
`read2prolog.py`: Python script to convert CSV dataset to Prolog dataset format  
`singlequery.pl`: one long query for Person1  
`subpatternquery.pl`: using graph subpatterns to find person1  
`get_timing.sh`: Shell script to retrieve the timings of find_person1 (10 times) -> saved to .txt file  
`parse_time.py`: Python script to parse the timing text files into CSV files  
*(Inferences, CPU, Seconds, Lips)*  
## Supporting Files
`answers.txt`: text file with IDs of correct answers for subpatterns and Person1  
`unittests.pl`: Prolog test queries to check subpatterns and final Person1

# How to run the program
Prolog version needed: SWI-Prolog version 9.0.4  
## 1. Converting original CSV data into Prolog database file
**Files needed: `read2prolog.py` and CSV files**  
*The CSV files and read2prolog.py must be in the same directory.*  
`read2prolog.py` is a Python program that reads the CSV data and converts it into Prolog, storing them in a Prolog database file. The `readFile()` function reads the CSV file and writes the Prolog database to an output file. On line 23 (in the main function), you need to input the CSV filename and Prolog database filename as arguments to `readfile()`:  `(CSV filename, Prolog database filename)`.

## 2. Mapping the graph and finding Person1
**Files needed: `singlequery.pl` or `subpatternquery.pl`**  
`singlequery.pl` is one single rule to represent relationships between facts to find Person1. 
`subpatternquery.pl` models the graph’s subpatterns as rules to find Person1. Both Prolog scripts find Person1.  
### How to conduct a query:
On lines 4-5, change the input for `consult()` and `write()` to the name of the Prolog database file. `consult()` allows the Prolog program to load in the database and have access to all the facts. *After making the changes be sure to save the file.*    
Line 4:  `:- consult('PROLOG DATABASE FILE.pl').`  
Line 5:   `:- write('Using Dataset: PROLOG DATABASE FILE.pl'), nl.`  
### Running the query in the command line:
*You must be in the same directory as the query file.*
To launch SWI-Prolog and load in the query file:  
`$ swipl -s main.pl`  
Query to execute search for Person1 in the Prolog database using the rules:  
`?- find_person1(Person1).`  
After executing the query, the Object ID of Person1 should be returned to the terminal. If Person1 is not found, False will be returned.  
`Person1 = 1128501731262832684 .`

## 3. Run timings of Prolog query for Person1:
**Files needed: `get_timing.sh`, `parse_time.py`**  
`get_timing.sh` is a shell script that runs and times the find_person1() query n times and saves the timings in a text file.
To run `get_timings.sh`, change the query filename and output timing file name:  
`swipl -s QUERYFILENAME.pl <<EOF > TIME_OUTPUT_FILENAME.txt 2>&1`  
`repeat_time_query(3).`  # You can change the number of times the query is run.  

`parse_time.py` is a Python program that parses the timing text file into a formatted CSV file.  
To run `parse_time.py`, you need to input the timings text filename and output CSV filename as arguments to `parseFile()`:  `(TIMINGS_FILENAME.txt, CSV_OUTPUT_FILENAME.csv)`. This is on line 26. 
