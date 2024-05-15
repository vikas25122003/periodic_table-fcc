#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t -c"

if [[ $1 ]];
then
  #code to go
  # echo "Argument Provided $1"
  re='^[0-9]+$'
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    GET_ELEMENT_AT_NUMBER=$($PSQL "select atomic_number from elements where atomic_number=$1")
  
  else
    GET_ELEMENT_AT_NUMBER=$($PSQL "select atomic_number from elements where symbol='$1' or name='$1'")
  fi
  

  if [[ -z $GET_ELEMENT_AT_NUMBER ]]
  then
    echo "I could not find that element in the database."
  else
    GET_ELEMENT=$($PSQL "select * from elements where atomic_number=$GET_ELEMENT_AT_NUMBER")

    GET_ELEMENT_PROPERTIES=$($PSQL "select * from properties where atomic_number=$GET_ELEMENT_AT_NUMBER")
    FINAL_VAL="$GET_ELEMENT | $GET_ELEMENT_PROPERTIES"

    ELEMENT_TYPE_ID="$($PSQL "select type_id from properties where atomic_number=$GET_ELEMENT_AT_NUMBER")"

    ELEMENT_TYPE=$($PSQL "select type from types where type_id=$ELEMENT_TYPE_ID")
     

    echo "$FINAL_VAL" | while read AT_NUM BAR SYMBOL BAR NAME BAR AT_NUM BAR AT_MASS BAR MEL_PT BAR BOI_PT BAR TYPE_ID
    do
      echo "The element with atomic number $AT_NUM is $NAME ($SYMBOL). It's a$ELEMENT_TYPE, with a mass of $AT_MASS amu. $NAME has a melting point of $MEL_PT celsius and a boiling point of $BOI_PT celsius."
    done
  fi
  
else
  echo "Please provide an element as an argument."
fi