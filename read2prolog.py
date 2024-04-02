import csv, os
from collections import defaultdict
# following are constants identifying the fields of the input records
PERSON1_COL = 1
PERSON2_COL = 2
FORUM_COL = 3
FORUM_EVENT_COL = 4
PUBLICATION_COL = 5
TOPIC_COL = 6
DATE_COL = 7
LAT_COL = 8
LON_COL = 9
dom =[31,28,31,30,31,30,31,31,30,31,30,31]

# Read in CSV File and Convert to Prolog format
def readFile(file_path):
    source = open(file_path,'r')
    source_reader = csv.reader(source)
    print('Reading file: ',file_path)
    allinfo = defaultdict(list)
    flag = None
    for line in source_reader: 
        info = line
        #num_lines += 1

        # Vertex
        if info[0]=='Person': # vertex properties = []
            info = [element for element in line if element.strip()]
            formatted_data = f"person({', '.join(info[1:])})" + "."
            allinfo['person'].append(formatted_data)
        elif info[0]=='ForumEvent': # vertex properties = []
            if info[DATE_COL]: 
                convertdate = date_to_int(info[DATE_COL])
                info[DATE_COL] = str(convertdate)
            info = [element for element in line if element.strip()]
            formatted_data = f"forumEvent({', '.join(info[1:])})" + "."
            allinfo['forumEvent'].append(formatted_data)
        elif info[0]=='Publication': # vertex properties = []
            if info[DATE_COL]: 
                convertdate = date_to_int(info[DATE_COL])
                info[DATE_COL] = str(convertdate)
            info = [element for element in line if element.strip()]
            formatted_data = f"publication({', '.join(info[1:])})" + "."
            allinfo['publication'].append(formatted_data)
        elif info[0]=='Forum': # vertex properties = []
            info = [element for element in line if element.strip()]
            formatted_data = f"forum({', '.join(info[1:])})" + "."
            allinfo['forum'].append(formatted_data)
        elif info[0]=='Topic': # vertex properties = []
            info = [element for element in line if element.strip()]
            formatted_data = f"topic({', '.join(info[1:])})" + "."
            allinfo['topic'].append(formatted_data)
        
        # Edges
        elif info[0]=='Author': # vertex properties = []
            if line[FORUM_EVENT_COL]!='': # see if target is forum_event=1
                flag = 1
            if line[PUBLICATION_COL]!='': # publication=0
                flag = 0
            info = [element for element in line if element.strip()]
            formatted_data = f"author({', '.join(info[1:])}, {str(flag)})" + "."
            allinfo['author'].append(formatted_data)
    # purchase(Buyer, Seller, Product, Date)
    # sale(Seller, Buyer, Product, Date).
        elif info[0] == 'Sale': # edge values = [[topic,date],person1,person2]
            # convert date
            if info[DATE_COL]: 
                convertdate = date_to_int(info[DATE_COL])
                date = str(convertdate)
            seller = info[PERSON1_COL] 
            buyer = info[PERSON2_COL] 
            product = info[TOPIC_COL]
            #info = [element for element in line if element.strip()]
            # formatted_data = f"sale({', '.join(info[1:])})" + "."
            sale_data = "sale(" + seller + ", " + buyer + ", " + product + ", " + date + ")."
            purchase_data = "purchase(" + buyer + ", " + seller + ", " + product + ", " + date + ")."
            allinfo['sale'].append(sale_data)
            allinfo['purchase'].append(purchase_data)

        elif info[0] == 'Includes': # edge properties = [topic,date]
            info = [element for element in line if element.strip()]
            formatted_data = f"include({', '.join(info[1:])})" + "."
            allinfo['include'].append(formatted_data)
        elif info[0] == 'HasTopic': # edge value = [[type],source, topic]
            if line[FORUM_COL]!='': # see if source is forum - type 0
                tflag = 0
            if line[FORUM_EVENT_COL]!='': # see if source is forum_event - type 1
                tflag = 1
            if line[PUBLICATION_COL]!='': # see if source is publication - type 2
                tflag = 2
            info = [element for element in line if element.strip()]
            formatted_data = f"has_topic({', '.join(info[1:])}, {str(tflag)})" + "."
            allinfo['has_topic'].append(formatted_data)
        elif info[0] == 'HasOrg': # edge value [[],pub,topic]
            info = [element for element in line if element.strip()]
            formatted_data = f"has_org({', '.join(info[1:])})" + "."
            allinfo['has_org'].append(formatted_data)
        else:
            print("Error: unknown Type")
            continue

    # Write converted data to Prolog File
    with open('dataset_r10.pl', 'w') as outfile:
        for value in allinfo.values():
            for item in value:
                outfile.write(item + '\n')
    return 

# Convert Date to Int
def date_to_int(x):
    # into days from 2000
    global dom
    mdy = x.split('/')
    y = int(mdy[2])-2000
    int_date = y*365+dom[int(mdy[0])-1]+int(mdy[1])
    return int_date

def main():
    readFile('data_r10.csv')

if __name__ == "__main__":
    main()
