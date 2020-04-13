#pragma semicolon 1

#include <sourcemod>
#include <multicolors>
#include <cstrike>
#include <clientprefs>
#include <geoip>

#define PLUGIN_VERSION "1.0"
#define PLUGIN_AUTHOR "Benjamín Morozov"

#define LoopClients(%1) for(int %1 = 1; %1 <= MaxClients; %1++)

int g_iEnable;

char g_sTag[50];
char g_sTime[32];

KeyValues g_hMessages;

char FILE_PATH[PLATFORM_MAX_PATH];

Handle Cv_filepath = INVALID_HANDLE;
float g_fMessageDelay;


public Plugin myinfo =
{
name = "automessage",
author = PLUGIN_AUTHOR,
version = PLUGIN_VERSION,
description = "automessage",
};

public OnPluginStart()
{
AutoExecConfig(true);
CreateConVar("automessage_version", PLUGIN_VERSION, "automessage", FCVAR_PLUGIN | FCVAR_SPONLY | FCVAR_REPLICATED | FCVAR_NOTIFY);
Cv_filepath = CreateConVar("ServerAdvertisement_filepath", "addons/sourcemod/configs/ServerAdvertisement.cfg", "Path for file with settings");
GetConVarString(Cv_filepath, FILE_PATH, sizeof(FILE_PATH));
LoadConfig();
}
public OnMapStart()
{
LoadMessages();
CreateTimer(g_fMessageDelay, Event_PrintAdvert, _, TIMER_REPEAT | TIMER_FLAG_NO_MAPCHANGE);
}
public OnMapEnd()
{

}
public Action Event_PrintAdvert(Handle timer)
{
PrintAdverToAll();
}
public Action PrintAdverToAll()
{
if (g_iEnable)
{
char cookievalue[12];
if (!g_hMessages.GotoNextKey())
{
g_hMessages.GoBack();
g_hMessages.GotoFirstSubKey();
}
LoopClients(i)
{
if (IsValidPlayer(i) && StrEqual(cookievalue, ""))
{
char sType[12];
char sText[256];
char sBuffer[256];
char sCountryTag[3];
char sAdminList[128];
char sIP[26];

GetClientIP(i, sIP, sizeof(sIP));
GeoipCode2(sIP, sCountryTag);
KvGetString(g_hMessages, sCountryTag, sText, sizeof(sText), "LANGMISSING");
if (StrEqual(sText, "LANGMISSING"))
g_hMessages.GetString("default", sText, sizeof(sText));

char lines[10][256];

for (int line = 0; line < ExplodeString(sText, "\\n", lines, sizeof lines, sizeof lines[]); line++)
{
if (StrContains(lines[line], "{NEXTMAP}") != -1)
{
GetNextMap(sBuffer, sizeof(sBuffer));
ReplaceString(lines[line], sizeof(lines[]), "{NEXTMAP}", sBuffer);
}
if (StrContains(lines[line], "{CURRENTMAP}") != -1)
{
GetCurrentMap(sBuffer, sizeof(sBuffer));
ReplaceString(lines[line], sizeof(lines[]), "{CURRENTMAP}", sBuffer);
}
if (StrContains(lines[line], "{CURRENTTIME}") != -1)
{
FormatTime(sBuffer, sizeof(sBuffer), g_sTime);
ReplaceString(lines[line], sizeof(lines[]), "{CURRENTTIME}", sBuffer);
}
if (StrContains(lines[line], "{SERVERIP}") != -1)
{
int ips[4];
int ip = GetConVarInt(FindConVar("hostip"));
int port = GetConVarInt(FindConVar("hostport"));
ips[0] = (ip >> 24) & 0x000000FF;
ips[1] = (ip >> 16) & 0x000000FF;
ips[2] = (ip >> 8) & 0x000000FF;
ips[3] = ip & 0x000000FF;
Format(sBuffer, sizeof(sBuffer), "%d.%d.%d.%d:%d", ips[0], ips[1], ips[2], ips[3], port);
ReplaceString(lines[line], sizeof(lines[]), "{SERVERIP}", sBuffer);
}
if (StrContains(lines[line], "{SERVERNAME}") != -1)
{
GetConVarString(FindConVar("hostname"), sBuffer, sizeof(sBuffer));
ReplaceString(lines[line], sizeof(lines[]), "{SERVERNAME}", sBuffer);
}
if (StrContains(lines[line], "{ADMINSONLINE}") != -1)
{
LoopClients(x)
{
if (IsValidPlayer(x) && IsPlayerAdmin(x))
{
if (sAdminList[0] == 0)Format(sAdminList, sizeof(sAdminList), "'%N'", x);
else Format(sAdminList, sizeof(sAdminList), "%s,'%N'", sAdminList, x);
}
}
ReplaceString(lines[line], sizeof(lines[]), "{ADMINSONLINE}", sAdminList);
}
if (StrContains(lines[line], "{TIMELEFT}") != -1)
{
int i_Minutes;
int i_Seconds;
int i_Time;
if (GetMapTimeLeft(i_Time) && i_Time > 0)
{
i_Minutes = i_Time / 60;
i_Seconds = i_Time % 60;
}
Format(sBuffer, sizeof(sBuffer), "%d:%02d", i_Minutes, i_Seconds);
ReplaceString(lines[line], sizeof(lines[]), "{TIMELEFT}", sBuffer);
}
if (StrContains(lines[line], "{PLAYERNAME}") != -1)
{
Format(sBuffer, sizeof(sBuffer), "%N", i);
ReplaceString(lines[line], sizeof(lines[]), "{PLAYERNAME}", sBuffer);
}
g_hMessages.GetString("type", sType, sizeof(sType), "T");
if (StrEqual(sType, "T", false))
{
CPrintToChat(i, "%s %s", g_sTag, lines[line]);
}

if (StrEqual(sType, "C", false))
{
PrintHintText(i, "%s", lines[line]);
}
}
}
}
}
}

public LoadMessages()
{
g_hMessages = new KeyValues("ServerAdvertisement");
if (!FileExists(FILE_PATH))
{
SetFailState("[ServerAdvertisement] '%s' not found!", FILE_PATH);
return;
}
g_hMessages.ImportFromFile(FILE_PATH);
if (g_hMessages.JumpToKey("Messages"))
{
g_hMessages.GotoFirstSubKey();
}
}
public LoadConfig()
{
KeyValues hConfig = new KeyValues("ServerAdvertisement");
if (!FileExists(FILE_PATH))
{
SetFailState("[ServerAdvertisement] '%s' not found!", FILE_PATH);
return;
}
hConfig.ImportFromFile(FILE_PATH);
if (hConfig.JumpToKey("Settings"))
{
g_iEnable = hConfig.GetNum("Enable");
g_fMessageDelay = hConfig.GetFloat("Delay_between_messages");
hConfig.GetString("Time_Format", g_sTime, sizeof(g_sTime));
hConfig.GetString("Advertisement_tag", g_sTag, sizeof(g_sTag));
}
else
{
SetFailState("Config for 'Server Advertisement' not found!");
return;
}
delete hConfig;
}
stock bool IsValidPlayer(int client, bool alive = false)
{
if (client >= 1 && client <= MaxClients && IsClientConnected(client) && IsClientInGame(client) && (alive == false || IsPlayerAlive(client))) {
return true;
}
return false;
}
stock bool IsPlayerAdmin(client)
{
if (GetAdminFlag(GetUserAdmin(client), Admin_Generic))
{
return true;
}
return false;
}