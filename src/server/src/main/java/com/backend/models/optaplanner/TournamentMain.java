package com.backend.models.optaplanner;

import java.util.ArrayList;
import java.util.Scanner;

import org.joda.time.DateTime;
import org.joda.time.Duration;

import com.backend.models.Game;
import com.backend.models.School;
import com.backend.models.Tournament;
import com.backend.models.GameEvent.GameEvent;
import com.backend.models.enums.GameTypeEnum;
import com.framework.helpers.Database;
import com.framework.models.Essentials;

public class TournamentMain 
{
	public static void main(String[] args) 
	{
		try(Essentials essentials = new Essentials(new Database(Database.DatabaseType.PRODUCTION), null, null, null, null))
		{
			ArrayList<School> schools = School.getSchools(essentials);
			if((schools.size() * Tournament.GAME_PER_SCHOOL) % (Tournament.SCHOOLS_PER_TEAM * 2) != 0 )
			{
	        	System.out.println("There's no possible solution. Please change Tournament.GAME_PER_SCHOOL value.");
	        	return;
			}
			
			Duration TIME_BETWEEN_GAMES = new Duration(3 * 60 * 1000);
			DateTime[] RoundStartHour = new DateTime[Tournament.BLOCK_NUMBERS];
			RoundStartHour[0] = new DateTime(2015, 2, 5, 12, 0);
			RoundStartHour[1] = new DateTime(2015, 2, 5, 18, 0);
			RoundStartHour[2] = new DateTime(2015, 2, 6, 8, 0);
			RoundStartHour[3] = new DateTime(2015, 2, 6, 13, 0);
			
			TournamentSolution solvedTournament = TournamentSolver.solve(essentials, Tournament.GAME_PER_SCHOOL / (Tournament.SCHOOLS_PER_TEAM * 2), Tournament.SCHOOLS_PER_TEAM * 2, "com/backend/models/optaplanner/TournamentSolverConfig.xml");
			if(solvedTournament != null)
			{
				solvedTournament.outputTournamentSolution();
				
				if(solvedTournament != null)
		        {
		        	System.out.println("Do you want to save this schedule? (y/n)\nWARNING! This will erase all previously saved games.");
		        	Scanner keyboard = new Scanner(System.in);
		        	String valueEntered = "";
		        	while(!(valueEntered.toLowerCase().equals("y") || valueEntered.toLowerCase().equals("n")))
		        	{
		        		valueEntered = keyboard.next();
		        	}
		        	keyboard.close();
		        	if(valueEntered.toLowerCase().equals("y"))
		        	{
		        		essentials.database.dropCollection(Game.class);
		        		ArrayList<GameProcess> games = solvedTournament.getGames();
		        		int blockStart = 0;
		        		for(int currentGame = 0; currentGame < games.size(); currentGame++)
		        		{
		        			int blockNumber = TournamentScoreCalculator.getBlockForIndex(currentGame, games.size());
		        			if(TournamentScoreCalculator.isStartOfBlock(currentGame, games.size()))
		        			{
		        				blockStart = currentGame;
		        			}
		        			int currentGameInBlock = currentGame - blockStart;
		        			Duration delta = new Duration(currentGameInBlock * Game.getGameLength().getMillis() + currentGameInBlock * TIME_BETWEEN_GAMES.getMillis()); 
		        			Game game = new Game(null, 
		        					currentGame + 1,
		        					RoundStartHour[blockNumber].plus(delta),
		        					GameTypeEnum.PRELIMINARY, 
		        					games.get(currentGame).getBlueTeam(), 
		        					games.get(currentGame).getYellowTeam(), 
		        					new ArrayList<GameEvent>(),
		        					(currentGame == 0) ? true : false
		        					);
		        			
		        			essentials.database.save(game);
		        		}
		        	}
		        	
		        }
			}
		}
	}
}
