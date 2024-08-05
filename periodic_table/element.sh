#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ -z $1 ]]
then
echo Please provide an element as an argument.
else
#is it a number?
if [[ $1 =~ [0-9]+ ]]
then
INFO=$($PSQL "SELECT * FROM elements INNER JOIN properties USING (atomic_number) RIGHT JOIN types USING (type_id) WHERE atomic_number = $1")
elif [[ $1 =~ ^[A-Z]$ || $1 =~ ^[A-Z][a-z]$ ]]
then
INFO=$($PSQL "SELECT * FROM elements INNER JOIN properties USING (atomic_number) RIGHT JOIN types USING (type_id) WHERE symbol = '$1'")
else
INFO=$($PSQL "SELECT * FROM elements INNER JOIN properties USING (atomic_number) RIGHT JOIN types USING (type_id) WHERE name = '$1'")
fi

if [[ -z $INFO ]]
then
echo I could not find that element in the database.

else
echo "$INFO" | while IFS="|" read TYPE_ID ATOMIC_NUMBER SYMBOL NAME MASS MELT BOIL TYPE; do
  echo -e "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELT celsius and a boiling point of $BOIL celsius."
done
fi

fi
