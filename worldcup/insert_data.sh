#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

#add all the teams
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
 if [[ $YEAR != 'year' ]]
 then
 #get winner
 WINNER_=$($PSQL "SELECT name FROM teams WHERE name = '$WINNER'")
 #not found do insert
if [[ -z $WINNER_ ]]
then
$PSQL "INSERT INTO teams(name) VALUES('$WINNER')"
fi
 #get loser
LOSER_=$($PSQL "SELECT name FROM teams WHERE name = '$OPPONENT'")
 #not found do insert
 if [[ -z $LOSER_ ]]
then
$PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')"
fi

WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER'")
OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT'")
$PSQL "INSERT INTO games(year,round,winner_id,opponent_id,winner_goals,opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID,$WINNER_GOALS,$OPPONENT_GOALS) "

fi
done

