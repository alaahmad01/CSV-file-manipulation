# Text-Manipulation-In-Shell

### Program Structure

The structure of the program is simple and basic, it uses multiple commands from the native
shell environment to manipulate the data file to work out some useful statistics about it. At first,
the user is prompted to enter the data file name which he wants to process, the program reads
that file name and searches for it in the local directory, if the file wasn’t found, the program
raises a warning and the user then is prompted to enter another file name. However, if the file
exists, the program runs some commands to check the format of that file; the file is considered
“correct”, or in the right format, if it was a (.csv) file and it has the same number of columns in
each row.

When the file is found and marked to be in the right format, the program asks the user what type
of operation he wants to proceed with, the program gives the user three main options; D for
finding the dimension of the program, C to run some statistics basic statistics for the data file and
S to do basic file correction by substituting missing column values with the mean of that column.
The user is always given the choice of existing the program by inputting E.

The program is structured to make all functions dependent on each other, that is, if you want to
substitute missing values, the functions to find the dimension and the computing statistics will be
executed if they weren’t executed before. This led to reducing the lines of the program and thus
the program needed less data and memory to operate and made it easier to understand its
structure.

The input file, as mentioned before, should be in the csv format for the program to accept and
process. The csv format is a well-known format for data sets, as it stores the data in a specific
way. A csv file should contain a header first row which describes each column of data, it also
specifies columns in each row by separating their values with a comma “,”. Below is an examplf of the csv file format:

    spal.length,sepal.width,petal.length,petal.width
    5.1,3.5,1.3,0.2
    4.9,3,1.4,0.3
    4.7,3.2,1.3,
    4.6,3.1,1.4,0.2
    5,3.6,1.4,0.1
    
Run the code on your linux maxhine by typing into the terminal:
>$ ./main.sh
