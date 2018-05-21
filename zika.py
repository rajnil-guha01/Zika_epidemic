
# This script reads each row from csv line and removes the opening and closing quotes from the 8th field.
# Then it writes the modified rows back into another csv file.


import csv


def modify_zika():
    open_csv = open('cdczika.csv', 'r')
    write_csv = open('newzika.csv', 'w')

    csv_reader = csv.reader(open_csv)
    csv_writer = csv.writer(write_csv)

    next(csv_reader)

    for line in csv_reader:
        if line[7].startswith('"'):
            line[7] = line[7][1:]
        if line[7].endswith('"'):
            line[7] = line[7][:-1]
        csv_writer.writerow(line)

    open_csv.close()
    write_csv.close()
