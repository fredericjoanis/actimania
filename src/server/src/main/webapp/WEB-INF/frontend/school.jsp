<%@page import="org.joda.time.format.PeriodFormatterBuilder"%>
<%@page import="org.joda.time.format.PeriodFormatter"%>
<%@page import="com.backend.models.SkillsCompetition"%>
<%@page import="com.framework.helpers.Helpers"%>
<%@page import="com.backend.models.GameState"%>
<%@page import="com.backend.models.Game"%>
<%@page import="com.backend.models.enums.GameTypeEnum"%>
<%@page import="com.backend.models.Tournament"%>
<%@page import="com.google.common.collect.ImmutableMap"%>
<%@page import="com.framework.helpers.LocalizedString"%>
<%@page import="java.util.Locale"%>
<%@page import="com.backend.models.School"%>
<%@page import="java.util.ArrayList"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<%
Tournament tournament = (Tournament) request.getAttribute("tournament");
School school	= (School) request.getAttribute("school");
Integer rank 	= (Integer) request.getAttribute("rank");
Integer score	= (Integer) request.getAttribute("score");
SkillsCompetition skillsCompetition = (SkillsCompetition) request.getAttribute("skillsCompetition");
int schoolCount = tournament.schools.size();

Locale currentLocale = request.getLocale();

LocalizedString strTournament = new LocalizedString(ImmutableMap.of( 	
		Locale.ENGLISH, "Tournament", 
		Locale.FRENCH, 	"Tournoi"
		), currentLocale);

LocalizedString strCumulative = new LocalizedString(ImmutableMap.of( 	
		Locale.ENGLISH, "Preliminary round position : ", 
		Locale.FRENCH, 	"Position ronde pr�liminaire : "
		), currentLocale);

LocalizedString strRank = new LocalizedString(ImmutableMap.of( 	
		Locale.ENGLISH, "Rank", 
		Locale.FRENCH, 	"Position"
		), currentLocale);

LocalizedString strRankScore = new LocalizedString(ImmutableMap.of( 	
		Locale.ENGLISH, "Cumulative value", 
		Locale.FRENCH, 	"Valeure globale"
		), currentLocale);

LocalizedString strScore = new LocalizedString(ImmutableMap.of( 	
		Locale.ENGLISH, "Score", 
		Locale.FRENCH, 	"Pointage"
		), currentLocale);

LocalizedString strPickupRace = new LocalizedString(ImmutableMap.of( 	
		Locale.ENGLISH, "Pick-up race", 
		Locale.FRENCH, 	"Ramassage de vitesse"
		), currentLocale);

LocalizedString strTwoTargetHits = new LocalizedString(ImmutableMap.of( 	
		Locale.ENGLISH, "Two target hits", 
		Locale.FRENCH, 	"Toucher deux cibles"
		), currentLocale);

LocalizedString strTwoActuatorChanged = new LocalizedString(ImmutableMap.of( 	
		Locale.ENGLISH, "Two actuator changed", 
		Locale.FRENCH, 	"Changer deux actuateurs"
		), currentLocale);

LocalizedString strSchool = new LocalizedString(ImmutableMap.of( 	
		Locale.ENGLISH, "School", 
		Locale.FRENCH, 	"�cole"
		), currentLocale);

LocalizedString strSchedule = new LocalizedString(ImmutableMap.of( 	
		Locale.ENGLISH, "Schedule", 
		Locale.FRENCH, 	"Horaire"
		), currentLocale);

LocalizedString strRanking = new LocalizedString(ImmutableMap.of( 	
		Locale.ENGLISH, "Ranking", 
		Locale.FRENCH, 	"Classement"
		), currentLocale);

LocalizedString strGameNumber = new LocalizedString(ImmutableMap.of( 	
		Locale.ENGLISH, "Game #", 
		Locale.FRENCH, 	"# Partie"
		), currentLocale);

LocalizedString strGameTime = new LocalizedString(ImmutableMap.of( 	
		Locale.ENGLISH, "Game date/time", 
		Locale.FRENCH, 	"Date/Heure de la partie"
		), currentLocale);

LocalizedString strSchoolScore = new LocalizedString(ImmutableMap.of( 	
		Locale.ENGLISH, "School score", 
		Locale.FRENCH, 	"Pointage de l'�cole"
		), currentLocale);

LocalizedString strBlueScore = new LocalizedString(ImmutableMap.of( 	
		Locale.ENGLISH, "Blue score", 
		Locale.FRENCH, 	"Pointage �quipe bleue"
		), currentLocale);

LocalizedString strYellowScore = new LocalizedString(ImmutableMap.of( 	
		Locale.ENGLISH, "Yellow score", 
		Locale.FRENCH, 	"Pointage �quipe jaune"
		), currentLocale);

LocalizedString strLiveGame = new LocalizedString(ImmutableMap.of( 	
		Locale.ENGLISH, "Live game", 
		Locale.FRENCH, 	"Partie en cours"
		), currentLocale);

LocalizedString strPreliminaryGames = new LocalizedString(ImmutableMap.of( 	
		Locale.ENGLISH, "Preliminary", 
		Locale.FRENCH, 	"Parties pr�liminaires"
		), currentLocale);

LocalizedString strPlayoffDraft = new LocalizedString(ImmutableMap.of( 	
		Locale.ENGLISH, "Draft", 
		Locale.FRENCH, 	"Rep�chage"
		), currentLocale);

LocalizedString strPlayoffSemi = new LocalizedString(ImmutableMap.of( 	
		Locale.ENGLISH, "Semi-final", 
		Locale.FRENCH, 	"Semi finale"
		), currentLocale);

LocalizedString strPlayoffDemi = new LocalizedString(ImmutableMap.of( 	
		Locale.ENGLISH, "Demi-final", 
		Locale.FRENCH, 	"Demi finale"
		), currentLocale);

LocalizedString strPlayoffFinal = new LocalizedString(ImmutableMap.of( 	
		Locale.ENGLISH, "Final", 
		Locale.FRENCH, 	"Finale"
		), currentLocale);
%>

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<link rel="shortcut icon" href="images/favicon.ico" />
<title><%= strSchool %></title>
</head>
<body>

<h1><%= school.name %></h1>

<table>
<tr><td></td>								<td><%= strScore %></td></tr>
<tr><td><%= strTournament %></td>			<td><%= score %></td></tr>
<tr><td><%= strPickupRace %></td>			<td><%= skillsCompetition.getPickballs(school).integer %></td></tr>
<tr><td><%= strTwoTargetHits %></td>		<td><%= Helpers.stopwatchFormatter.print(skillsCompetition.getTwoTargetHits(school).duration.toPeriod()) %></td></tr>
<tr><td><%= strTwoActuatorChanged %></td>	<td><%= Helpers.stopwatchFormatter.print(skillsCompetition.getTwoActuatorChanged(school).duration.toPeriod()) %></td></tr>
</table>
<br/>
<b><%= strCumulative %> <%= tournament.getCumulativeRanking(skillsCompetition).indexOf(school) + 1 %> / <%= schoolCount %></b>
<br/>
<br/>

<% 
for(int i = GameTypeEnum.values().length - 1; i >= 0; i--)
{
	GameTypeEnum gameType = GameTypeEnum.values()[i];
	ArrayList<Game> games = Tournament.getGamesPlayed(tournament.games, school, gameType);
	if(games.size() == 0)
	{
		continue;
	}
	
	LocalizedString h2Str = null;
	switch(gameType)
	{
	case PRELIMINARY:
		h2Str = strPreliminaryGames;
		break;
	case PLAYOFF_DRAFT:
		h2Str = strPlayoffDraft;
		break;
	case PLAYOFF_DEMI:
		h2Str = strPlayoffDemi;
		break;
	case PLAYOFF_SEMI:
		h2Str = strPlayoffSemi;
		break;
	case PLAYOFF_FINAL:
		h2Str = strPlayoffFinal;
		break;
	}
%>
<h2><%= h2Str %></h2>
<table>
<tr>
<td><%= strGameNumber %></td><td><%= strGameTime %></td><td><%= strSchoolScore %></td><td><%= strBlueScore %></td><td><%= strYellowScore %></td>
</tr>
<%

for( Game game : games )
{
	ArrayList<GameState> gameStates = game.getGameStates();
	String blueScore = "";
	String yellowScore = "";
	
	if(gameStates.size() > 0)
	{
		GameState gameState = gameStates.get(gameStates.size() - 1);
		blueScore = String.valueOf(gameState.blueScore);
		yellowScore = String.valueOf(gameState.yellowScore);
	}
%>
<tr>
	<td><a href="game?gameId=<%= game._id %>"><%= game.gameNumber %></a></td>
	<td><%= Helpers.dateTimeFormatter.print(game.scheduledTime) %></td>
	<td><%= game.getScore(school) %></td>
	<td><%= blueScore %></td>
	<td><%= yellowScore %></td>
</tr>
<%
}
%>
</table>
<%
} // End of for GameTypeEnum
%>
<br/>
<a href="schedule"><%= strSchedule %></a><br/>
<a href="ranking"><%= strRanking %></a><br/>
<a href="live"><%= strLiveGame %></a>
</body>
</html>