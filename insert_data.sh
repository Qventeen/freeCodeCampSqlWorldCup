#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

TRUNCATE_RESULT=$($PSQL "truncate games, teams")

function GET_TEAM_ID() {
  TEAM_ID=$($PSQL "select team_id from teams where name='$1'")
  if [[ -z $TEAM_ID ]]
  then
    TEAM_INSERT_RESULT=$($PSQL "insert into teams(name) values('$1')")
    TEAM_ID=$($PSQL "select team_id from teams where name='$1'")
  fi
}

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $YEAR -ne "year" ]]
  then
    GET_TEAM_ID "$WINNER"
    WINNER_ID=$TEAM_ID
    GET_TEAM_ID "$OPPONENT"
    OPPONENT_ID=$TEAM_ID
    GAMES_INSERT_RESULT=$($PSQL "insert into games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) values($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
  fi
done
