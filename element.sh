#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

MAIN_MENU() {
  if [[ -z $1 ]]
  then
    echo "Please provide an element as an argument."
  else
    if [[ $1 =~ ^[0-9]+$ ]]
    then
      ELEMENT_RESULT=$($PSQL "SELECT elements.atomic_number, elements.symbol, elements.name, types.type, properties.atomic_mass, properties.melting_point_celsius, properties.boiling_point_celsius FROM elements INNER JOIN properties ON elements.atomic_number = properties.atomic_number INNER JOIN types ON properties.type_id = types.type_id WHERE elements.atomic_number = $1")
    else
      ELEMENT_RESULT=$($PSQL "SELECT elements.atomic_number, elements.symbol, elements.name, types.type, properties.atomic_mass, properties.melting_point_celsius, properties.boiling_point_celsius FROM elements INNER JOIN properties ON elements.atomic_number = properties.atomic_number INNER JOIN types ON properties.type_id = types.type_id WHERE elements.symbol = '$1' OR elements.name = '$1'")
    fi

    if [[ -z $ELEMENT_RESULT ]]
    then
      echo "I could not find that element in the database."
    else
      echo "$ELEMENT_RESULT" | while IFS="|" read ATOMIC_NUMBER SYMBOL NAME TYPE ATOMIC_MASS MELTING_POINT BOILING_POINT
      do
        echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
      done
    fi
  fi
}
MAIN_MENU "$1"

