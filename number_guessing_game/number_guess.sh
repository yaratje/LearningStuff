#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

#USER SETUP
echo Enter your username:
read USERNAME
USER=$($PSQL "SELECT * FROM number_guess WHERE name = '$USERNAME'")
if [[ -z $USER ]] 
then
echo -e "Welcome, $USERNAME! It looks like this is your first time here."
else
echo $USER | while IFS="|" read NAME GAMES BEST; do
echo -e "Welcome back, $NAME! You have played $GAMES games, and your best game took $BEST guesses."
done
fi

#NUMBER GUESSING
RANDOM_NUMBER=$(( $RANDOM%1000+1 ))
echo $RANDOM_NUMBER
echo Guess the secret number between 1 and 1000:
TRIES=0
while [[ $GUESS != $RANDOM_NUMBER ]]
do
read GUESS
if [[ $GUESS =~ ^[0-9]+$ ]]
then
  if [[ $GUESS > $RANDOM_NUMBER ]]
  then
  echo "It's lower than that, guess again:"
  elif [[ $GUESS < $RANDOM_NUMBER ]]
  then
  echo "It's higher than that, guess again:"
fi
TRIES=$(( $TRIES+1 ))
else
echo That is not an integer, guess again:
fi
done

#KEEPING SCORE
if [[ -z $USER ]]
then
INSERT_USER=$($PSQL "INSERT INTO number_guess(name,games_played,best_game) VALUES('$USERNAME',1,$TRIES)")
else
echo $USER | while IFS="|" read NAME GAMES BEST; do
GAMES=$(( $GAMES+1 ))
UPDATE_USER=$($PSQL "UPDATE number_guess SET games_played = $GAMES WHERE name = '$NAME'")
if [[ $TRIES < $BEST ]]
then
UPDATE_USER=$($PSQL "UPDATE number_guess SET best_game = $TRIES WHERE name = '$NAME'")
fi
done
fi

echo "You guessed it in $TRIES tries. The secret number was $RANDOM_NUMBER. Nice job!"
