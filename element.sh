#!/bin/bash

ARGUMENT=$1
PSQL="psql --username=freecodecamp --dbname=periodic_table -c "

MSG1(){
  echo "$QUERY_RESULT" | while read AT_NUMBER BAR NAME BAR SYMBOL BAR TYPE BAR AT_MASS BAR MEL_POINT BAR BOI_POINT
  do
    if [[ "$NAME" != "name" && -n "$NAME"  ]]
    then 
      echo "The element with atomic number $AT_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $AT_MASS amu. $NAME has a melting point of $MEL_POINT celsius and a boiling point of $BOI_POINT celsius."
    fi
  done
}

SQL_QUERY(){
  QUERY_RESULT="$($PSQL "$1")"
}

SEARCH_ELEMENT(){
  if [[ $ARGUMENT =~ ^[0-9]+$ ]]
  then
    SQL_QUERY "SELECT atomic_number, name, symbol, types.type,atomic_mass,melting_point_celsius,boiling_point_celsius FROM properties INNER JOIN elements USING(atomic_number) INNER JOIN types USING(type_id) WHERE atomic_number=$ARGUMENT"
  elif [[ ${#ARGUMENT} -ge 1 && ${#ARGUMENT} -le 2  ]]
  then
    SQL_QUERY "SELECT atomic_number, name, symbol, types.type,atomic_mass,melting_point_celsius,boiling_point_celsius FROM properties INNER JOIN elements USING(atomic_number) INNER JOIN types USING(type_id) WHERE symbol='$ARGUMENT'"
  else
    SQL_QUERY "SELECT atomic_number, name, symbol, types.type,atomic_mass,melting_point_celsius,boiling_point_celsius FROM properties INNER JOIN elements USING(atomic_number) INNER JOIN types USING(type_id) WHERE name='$ARGUMENT'"
  fi
}

MAIN(){
  if [[ -z $ARGUMENT ]]
  then
    echo "Please provide an element as an argument."
  else
    SEARCH_ELEMENT
    if [[ $(echo $QUERY_RESULT | grep "0 rows" | wc -l) -eq 1 ]]
    then
      echo "I could not find that element in the database."
      
    else
      MSG1
    fi
  fi
}

MAIN