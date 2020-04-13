#include <sourcemod>
#include <multicolors>
#include <sdktools>
#include <cstrike>

public Plugin myinfo =
{
	name = "kill",
	author = "Benjamín Morozov",
	description = "kill",
	version = "1.0",
};

public void OnPluginStart()
{
	RegConsoleCmd("sm_kill", Command_Kill);
}

public Action Command_Kill(int client, int args)
{
    if (args < 1) {
        ForcePlayerSuicide(client);
        CReplyToCommand(client, "{green}[WenBreak] {darkred}Zabil {default}jsi{orange} se{default}.");
        PrintCenterText(client, "Zabil jsi se!");
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

    ForcePlayerSuicide(target);
    CReplyToCommand(client, "{green}[WenBreak] {darkred}Zabil {default}jsi hráče{orange} %s{default}.", name);
    PrintCenterText(target, "Byl jsi zabit!");
    return Plugin_Handled;
}