#!/bin/bash

counter=0

while [ $counter -lt 50 ]; do # here we gonna loop if counter is less than 50
  let counter=counter+1
  # Example string "1	Denice,Caudle"
  # nl - will show line number of each newline item
  # grep -w $counter - will grab the string or item base on the incremented $counter
  # awk - is use for splitting string in space by default
  # awk '{print $1}' - will print the 1st column(ie 1)
  # awk '{print $2}' - will print the 2nd column(ie Denice,Caudle)
  # awk -F ',' - "-F" indicate that we're going to split it by delimeter and the delimeter is ","
  # awk -F ',' '{print $1}') - is for 1st column(ie Denice)
  # awk -F ',' '{print $2}') - is for 2st column(ie Caudle)
  # shuf - is gonna return a random number base on the parameter
  # shuf -i 20-25 - is gonna return random number from the range of 20-25 in a list
  # shuf -i 20-25 -n 1 - "-n 1" is gonna grab the first and the whole command is gonna grab the first random number from the list
  name=$(nl people.txt | grep -w $counter | awk '{print $2}' | awk -F ',' '{print $1}')
  lastname=$(nl people.txt | grep -w $counter | awk '{print $2}' | awk -F ',' '{print $2}')
  age=$(shuf -i 20-25 -n 1)

  # this will insert the info grab to the "register" table in the database
  mysql -u root -p1234 people -e "insert into register values ($counter, '$name', '$lastname', $age)"
  echo "$counter, $name $lastname, $age was correctly imported"
done