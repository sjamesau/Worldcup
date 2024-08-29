#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo $($PSQL "TRUNCATE games, teams")

cat games.csv | while IFS=',' read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  # Skip first line (header) of file
  if [[ $WINNER != winner ]]
  then
    # Create WINNER_ID variable and get WINNER_ID of current WINNER in loop if it exists
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER'")

    # If WINNER_ID is not found
    if [[ -z $WINNER_ID ]]
    then
      # Insert WINNER into database
      INSERT_WINNER_RESULT=$($PSQL "INSERT INTO teams (name) VALUES ('$WINNER')")
      
      # Print more informative success statement
      if [[ $INSERT_WINNER_RESULT == "INSERT 0 1" ]]
      then
        echo "Inserted into teams, $WINNER"
      fi

      # Set WINNER_ID variable to newly created team_id
      WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER'")
    fi

    # Create OPPONENT_ID variable and get OPPONENT_ID of current OPPONENT in loop if it exists
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT'")

    # If OPPONENT_ID is not found
    if [[ -z $OPPONENT_ID ]]
    then
      # Insert OPPONENT into database
      INSERT_OPPONENT_RESULT=$($PSQL "INSERT INTO teams (name) VALUES ('$OPPONENT')")
      
      # Print more informative success statement
      if [[ $INSERT_OPPONENT_RESULT == "INSERT 0 1" ]]
      then
        echo "Inserted into teams, $OPPONENT"
      fi
      
      # Set OPPONENT_ID variable to newly created team_id
      OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT'")
    fi
  
    # Create GAME_ID variable and get GAME_ID of current row in loop
    GAME_ID=$($PSQL "SELECT game_id FROM games WHERE year = $YEAR AND round = '$ROUND' AND winner_id = $WINNER_ID")

    # If GAME_ID is not found
    if [[ -z $GAME_ID ]]
    then
      # Insert games table into database
      INSERT_GAMES_RESULT=$($PSQL "INSERT INTO games (year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES ($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")

      # Print more informative success statement
      if [[ $INSERT_GAMES_RESULT == "INSERT 0 1" ]]
      then
        echo "Inserted into games, $YEAR, $ROUND"
      fi
    fi
  fi
done