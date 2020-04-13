#include <sourcemod>
#include <multicolors>

new String:name[MAX_NAME_LENGTH]
new bool:alreadyDisplayed[MAXPLAYERS]


public Plugin:myinfo =
{
	name = "welcomemsg",
	author = "Benjamín Morozov",
	description = "Zobrazí uvítací zprávu, když se připojí jakýkoliv hráč.",
	version = "1.0",
}


public OnPluginStart()
{
	RegConsoleCmd("jointeam", jointeam)
	
}


public OnMapStart()
{
	for (new i = 0; i < MAXPLAYERS; ++i)
	{
		alreadyDisplayed[i] = false
	}
}	

public Action:TimerWelcomeHint(Handle:timer, any:clientSerial)
{
	
	new client = GetClientFromSerial(clientSerial)
	
	if (IsClientInGame(client))
	{
		GetClientName(client, name, 32)
		CPrintToChatAll("%s", name)
	}
	
}


public Action:TimerWelcomeCenter(Handle:timer, any:clientSerial)
{
	
	new client = GetClientFromSerial(clientSerial)
	
	if (IsClientInGame(client))
	{
		GetClientName(client, name, 32)
		CPrintToChatAll("%s", name)
	}
	
}


public Action:jointeam(client, team)
{
	

	alreadyDisplayed[client] = true
	return Plugin_Continue
	
}


public OnClientDisconnect(client)
{

	alreadyDisplayed[client] = false

}