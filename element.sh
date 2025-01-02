#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
  exit 0
fi

# Function to retrieve element information
get_element_info() {
  QUERY_RESULT=$($PSQL "SELECT elements.atomic_number, elements.name, elements.symbol, types.type, properties.atomic_mass, properties.melting_point_celsius, properties.boiling_point_celsius FROM elements JOIN properties ON elements.atomic_number = properties.atomic_number JOIN types ON properties.type_id = types.type_id WHERE $1 = '$2'")

  if [[ -z $QUERY_RESULT ]]
  then
    echo "I could not find that element in the database."
  else
    IFS="|" read ATOMIC_NUMBER NAME SYMBOL TYPE MASS MELTING_POINT BOILING_POINT <<< "$QUERY_RESULT"
    echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
  fi
}

# Determine type of argument
if [[ $1 =~ ^[0-9]+$ ]]
then
  ARG_TYPE="elements.atomic_number"
elif [[ $1 =~ ^[A-Z][a-z]?$ ]]
then
  ARG_TYPE="elements.symbol"
else
  ARG_TYPE="elements.name"
fi

# Get element info
get_element_info $ARG_TYPE $1