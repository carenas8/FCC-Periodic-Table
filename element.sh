#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

INPUT=$1

if [[ $INPUT == "" ]]
  then
    echo Please provide an element as an argument.
  else
    # lookup atomic number
    if [[ $INPUT =~ ^[0-9]+$ ]]
      then
        ATOMIC_NUM=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number = $INPUT")

      else
      # lookup symbol
      if [[ ${#INPUT} -le 2 ]]
        then
        ATOMIC_NUM=$($PSQL "SELECT atomic_number FROM elements WHERE symbol = '$INPUT'")
        else
      # lookup name
        ATOMIC_NUM=$($PSQL "SELECT atomic_number FROM elements WHERE name = '$INPUT'")
      fi
    fi
    
    if [[ $ATOMIC_NUM == "" ]]
      then
      echo I could not find that element in the database.
      else
      # declare values from elements
      NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number = $ATOMIC_NUM")

      SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number = $ATOMIC_NUM")

      # declare values from properties
      TYPE=$($PSQL "SELECT element_type FROM properties WHERE atomic_number = $ATOMIC_NUM")

      MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number = $ATOMIC_NUM")

      MELTING=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number = $ATOMIC_NUM")

      BOILING=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number = $ATOMIC_NUM")
  
      #update statement to include values
      echo "The element with atomic number $ATOMIC_NUM is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."

    fi
    
fi
