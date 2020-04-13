#include <sourcemod>
#include <multicolors>
#include <sdktools>
#include <cstrike>

public Plugin myinfo =
{
	name = "respawn",
	author = "Benjamín Morozov",
	description = "respawn",
	version = "1.0",
};

public void OnPluginStart()
{
	RegAdminCmd("sm_respawn", Command_Respawn, ADMFLAG_BAN);
}

public Action Command_Respawn(int client, int args)
{
    if (args < 1) {
        CS_RespawnPlayer(client);
        CReplyToCommand(client, "{green}[WenBreak] {orange}Respawnul {default}jsi{orange} se{default}.");
        PrintCenterText(client, "Respawnul jsi se!");
        return Plugin_Handled;
    }

    char name[32];
    int target = -1;
    GetCmdArg(1, name, sizeof(name));

    for (int i = 1; i <= MaxClients; i++)
    {
        if (!IsClientConnected(i))
        {
            continue;
        }
 
        char other[32];
        GetClientName(i, other, sizeof(other));
 
        if (StrEqual(name, other))
        {
            target = i;
        }
    }

    if (target == -1)
    {
        CReplyToCommand(client, "{green}[WenBreak] {default}hráč {orange}%s{darkred} nebyl nalezen{default}.", name);
        return Plugin_Handled;
    }

    CS_RespawnPlayer(target);
    CReplyToCommand(client, "{green}[WenBreak] {orange}Respawnul {default}jsi hráče{orange} %s{default}.", name);
    PrintCenterText(target, "Byl jsi respawnut!");
    return Plugin_Handled;
}