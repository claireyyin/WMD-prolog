import re, csv

# Parse timings from text file and write to CSV file
def parseFile(file_path, output):
    source = open(file_path,'r')
    source_reader = source.readlines()
    print('Reading file: ',file_path)
    allvalues = []
    # Regex pattern to extract numbers
    pattern = re.compile(r'\d+(,\d+)*\.?\d*')
    for line in source_reader: 
        if line.startswith('%'):
            info = line.split()
            values = [num.replace(',', '') for num in info if pattern.match(num)]
            allvalues.append(values)
    # Write the CSV File
    with open(output, 'w') as outfile:
        # CSV Format: Inferences, CPU, Seconds, Lips
        writer = csv.writer(outfile)
        outfile.write('Inferences, CPU, Seconds, Lips\n')
        writer.writerows(allvalues)
    print("Info Parsed and written to:", output)
    return 

def main():
    parseFile('time10.txt', 'time10.csv')

if __name__ == "__main__":
    main()