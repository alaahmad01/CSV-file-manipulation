#Alaa Ahmed 1183339

# function to replace the null values in columns of the data file
getSubstitution(){

	colnum=$1  # first argument for column number
	colavg=$2  # second argument for column's mean value
  
  # replaces white-spaces with the column average
  cat $filename | cut -d',' -f$colnum | sed "s/^\s*$/$colavg/g" > tmp.txt
  
  if [[ ! -e $editedfile ]] 
  then
  	touch $editedfile
  	cat tmp.txt > $editedfile
  else
  	paste -d"," $editedfile tmp.txt > tmp2.txt  # temp files will be removed later
  	cat tmp2.txt > $editedfile
  fi
}

# function to evaluate some statistics for the data file
getStatistics(){

	getDimension  # first calculate the dimension of the dataset
	
	for ((i=1; i<=cols; i++))
	do
	
	# tail -n +2 eliminates header file
	# sed '/^\s*$/d' eliminates white-spaces
	max=$(cat $filename | tail -n +2 | cut -d',' -f$i | sed '/^\s*$/d' | sort | tail -1)
	min=$(cat $filename | tail -n +2 | cut -d',' -f$i | sed '/^\s*$/d' | sort | head -1)
	avg=$(cat $filename | tail -n +2 | cut -d',' -f$i | sed '/^\s*$/d' | awk '{sum+=$1; ++n} END {print 	sum/NR}')
	std=$(cat $filename | tail -n +2 | cut -d',' -f$i | sed '/^\s*$/d' | awk '{sum+=$1; sumsq+=$1^2}END{print sqrt(sumsq/NR - (sum/NR)^2)}')
	
	
	if [ "$choice" = "S" ] 
	then
		getSubstitution $i $avg  # subsitute missing values for each column with its average
	else
	
		echo
		printf "Coloumn $i:\n"
		printf "max= $max, min= $min, avg= $avg, standard deviation= $std\n"
		
		printf "$min\n$max\n$avg\n$std" > tempp.txt  # temp files will be removed later
		paste $statfile tempp.txt > tempp2.txt
		cat tempp2.txt > $statfile
		
	fi
	done

}

# function to evaluate the dimensions of the file provided
getDimension(){
  
	rows=$(expr $(cat $filename|wc -l) - 1)  # number of rows

	cols=$(awk -F ',' '{print NF}' $filename|sed -n '1p')  # number of columns
  
	dim=$(expr $cols \* $rows)
	
	if [ "$choice" = "D" ]
	then
		echo number of coloumns $cols
		echo number of rows $rows
		echo  dimension of the data $dim
	fi
  
}

# main menu of the program
menu(){
	
	while [ true ]
	do
		echo
		echo "WELCOME TO ALA'S TEXT MANIPULATION SYSTEM"
		echo "Your chosen correct file is $filename"
		echo
		echo "Choose one of operations:" 
		echo "Find Dimension of your file (D)"
		echo "Some Computing Statistics about the File (C)"
		echo "Substitution for missing values (S)"
		echo "Exit the program (E)"
		echo "(D/C/S/E)?"
		read choice
		
		case $choice in
			D)
				getDimension
				
			;;
			C)
				if [[ ! -e $statfile ]]
				then
					touch $statfile
				fi
				printf "Min\nMax\nMean\nSTDEV" > $statfile 
				
				getStatistics
				
				printf "\ndata is availabe at $statfile\n" 
				rm tempp.txt
				rm tempp2.txt
				
			;;
			S)
				getStatistics
				cat $editedfile
				rm tmp.txt
				rm tmp2.txt
				printf "\ndata is available at $editedfile\n"
				
			;;
			E)
				exit 9
			;;
			*)
				echo
				echo Wrong Input, please try agian.
			;;
		esac
	done 
}


# function to make sure the file is in the right format
checkfile(){

	failed=0  # flag for file validity

	# checking format of the file
	if ! [[ "${filename: -4}" == ".csv" ]]
	then 
	failed=1
	fi
  
	# checking if the data is valid  -- checked by asserting that each row has the same number of columns
	if [[ $(awk 'BEGIN{FS=","}!n{n=NF}n!=NF{failed=1}END{print !failed}' $filename) = 0 ]] 
	then
	failed=1
	fi
	
}


#
# Main
#

# dimension of the data file
rows=
cols=
dim= 

# menu choice
choice=

# name of the input file
filename="notafilename"

# validity of a file
failed= 

# loop to get the file name until it is found
while [ ! -e $filename ] || [ "$failed" = 1 ]
do
	echo
	echo "Input the dataset file name"
	read filename
	checkfile  # check the validaty of the file 
	if [ -e $filename ] && [ "$failed" = 0 ]
	then
		editedfile="edited_$filename"  # output edited file
		statfile="stat_$filename"  # output statistics file
	  menu  # go the menu
	elif [ "$failed" = 1 ]
	then
		echo
		echo "The file provided is not valid"
		echo "Please Try Again"
	else
	  echo
	  echo "The file doesn't exist"
	  echo "Please Try Again"
	fi
done
 
