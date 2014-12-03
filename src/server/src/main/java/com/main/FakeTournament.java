package com.main;

import java.util.Random;

import org.joda.time.DateTime;
import org.joda.time.Duration;

import com.backend.models.Game;
import com.backend.models.School;
import com.backend.models.SchoolDuration;
import com.backend.models.SchoolInteger;
import com.backend.models.SkillsCompetition;
import com.backend.models.Tournament;
import com.backend.models.GameEvent.ActuatorStateChangedEvent;
import com.backend.models.GameEvent.EndGameEvent;
import com.backend.models.GameEvent.StartGameEvent;
import com.backend.models.GameEvent.TargetHitEvent;
import com.backend.models.enums.ActuatorStateEnum;
import com.backend.models.enums.SideEnum;
import com.backend.models.enums.TargetEnum;
import com.framework.helpers.Database;
import com.framework.helpers.Database.DatabaseType;
import com.framework.models.Essentials;

public class FakeTournament 
{
	public static void resetMatches(Essentials essentials)
	{
		Tournament tournament = Tournament.getTournament(essentials);
		for(int i = 0; i < tournament.games.size(); i++)
		{
			Game currentGame = tournament.games.get(i).getInitialState();
			essentials.database.save(currentGame);
		}
	}
	
	public static void main(String[] args) 
	{
		Random random = new Random(0);
		try(Essentials essentials = new Essentials(new Database(DatabaseType.PRODUCTION), null, null, null, null))
		{
			Tournament tournament = Tournament.getTournament(essentials);
			/*
			SkillsCompetition skills = SkillsCompetition.get(essentials.database);
			for(School school : tournament.schools)
			{
				skills.pickBalls.set(skills.pickBalls.indexOf(school), new SchoolInteger(school, random.nextInt(20)));
				skills.twoActuatorChanged.set(skills.twoActuatorChanged.indexOf(school), new SchoolDuration(school, new Duration(random.nextInt(10*60*1000))));
				skills.twoTargetHits.set(skills.twoTargetHits.indexOf(school), new SchoolDuration(school, new Duration(random.nextInt(10*60*1000))));
			}
			essentials.database.save(skills);
			*/
			
			for(int i = 0; i < tournament.games.size() / 2; i++)
			{
				Game currentGame = tournament.games.get(i).getInitialState();
				currentGame.addGameEvent(new StartGameEvent(DateTime.now()));
				
				int nbEvents = random.nextInt(30) + 20;
				
				for(int eventNo = 0; eventNo < nbEvents; eventNo++)
				{
					SideEnum side = SideEnum.values()[random.nextInt(SideEnum.values().length)];
					TargetEnum target = TargetEnum.values()[random.nextInt(TargetEnum.values().length)];
					
					boolean isTargetHit = random.nextBoolean();
					if(isTargetHit)
					{
						currentGame.addGameEvent(new TargetHitEvent(side, target, DateTime.now()));
					}
					else
					{
						ActuatorStateEnum actuator = ActuatorStateEnum.values()[random.nextInt(ActuatorStateEnum.values().length)];
						currentGame.addGameEvent(new ActuatorStateChangedEvent(side, target, actuator, DateTime.now()));
					}
				}
				
				currentGame.addGameEvent(new EndGameEvent(DateTime.now()));
				
				essentials.database.save(currentGame);
			}
		}
	}
}
