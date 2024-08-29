#! /bin/bash

PSQL="psql --username=freecodecamp --dbname=worldcup --no-align --tuples-only -c"

# Do not change code above this line. Use the PSQL variable above to query your database.

echo -e "\nTotal number of goals in all games from winning teams:"
echo "$($PSQL "SELECT SUM(winner_goals) FROM games")"

echo -e "\nTotal number of goals in all games from both teams combined:"
echo "$($PSQL "SELECT SUM(winner_goals) + SUM(opponent_goals) FROM games")"

echo -e "\nAverage number of goals in all games from the winning teams:"
echo "$($PSQL "SELECT AVG(winner_goals) FROM games")"

echo -e "\nAverage number of goals in all games from the winning teams rounded to two decimal places:"
echo "$($PSQL "SELECT ROUND(AVG(winner_goals), 2) FROM games ")"

echo -e "\nAverage number of goals in all games from both teams:"
echo "$($PSQL "SELECT AVG(winner_goals + opponent_goals) FROM games")"

echo -e "\nMost goals scored in a single game by one team:"
echo "$($PSQL "SELECT MAX(winner_goals) FROM games")"

echo -e "\nNumber of games where the winning team scored more than two goals:"
echo "$($PSQL "SELECT COUNT(game_id) FROM games WHERE winner_goals > 2")"

echo -e "\nWinner of the 2018 tournament team name:"
echo "$($PSQL "SELECT name FROM teams LEFT JOIN games ON teams.team_id = games.winner_id WHERE year = 2018 AND round = 'Final'")"

echo -e "\nList of teams who played in the 2014 'Eighth-Final' round:"
echo "$($PSQL "SELECT DISTINCT(name) FROM teams LEFT JOIN games AS games_winner ON teams.team_id = games_winner.winner_id LEFT JOIN games AS games_opponent ON teams.team_id = games_opponent.opponent_id WHERE (games_winner.year = 2014 AND games_winner.round = 'Eighth-Final') OR (games_opponent.year = 2014 AND games_opponent.round = 'Eighth-Final') ORDER BY name")"

echo -e "\nList of unique winning team names in the whole data set:"
echo "$($PSQL "SELECT DISTINCT(name) FROM teams INNER JOIN games ON teams.team_id = games.winner_id ORDER BY name")"

echo -e "\nYear and team name of all the champions:"
echo "$($PSQL "SELECT games.year, teams.name FROM teams INNER JOIN games on teams.team_id = games.winner_id WHERE round = 'Final' ORDER BY year")" 

echo -e "\nList of teams that start with 'Co':"
echo "$($PSQL "SELECT DISTINCT(t.name) FROM teams AS t LEFT JOIN games AS gw ON t.team_id = gw.winner_id LEFT JOIN games AS go ON t.team_id = go.opponent_id WHERE t.name LIKE 'Co%' ORDER BY t.name")"
