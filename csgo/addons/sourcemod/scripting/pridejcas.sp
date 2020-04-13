#include <sourcemod>
#include <multicolors>
#include <warden>

public Plugin myinfo =
{
	name = "pridejcas",
	author = "Benjamín Morozov",
	description = "Přidá čas kola (+5minut).",
	version = "1.0",
};

public void OnPluginStart()
{
    RegConsoleCmd("sm_pridejcas", Command_AddTime);
}

public Action Command_AddTime(int client, int args)
{
    CPrintToChatAll("Čas byl prodloužen o 5 minut.")
    int value = 5;
    ExtendMapTimeLimit(value * 60);
    return Plugin_Handled;
}