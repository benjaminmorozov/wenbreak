#include <sourcemod>
#include <multicolors>

public Plugin myinfo =
{
	name = "TeamSpeak",
	author = "Benjamín Morozov",
	description = "Zobrazuje IP adresu na náš TeamSpeak server po napsání příkazu !teamspeak do chatu.",
	version = "1.0",
};

public void OnPluginStart()
{
    RegConsoleCmd("sm_teamspeak", Command_Teamspeak);
	RegConsoleCmd("sm_ts", Command_Teamspeak);
}

public Action Command_Teamspeak(int client, int args)
{
    CReplyToCommand(client, "{green}[WenBreak]{default} {orange}Náš TeamSpeak{default}: {grey}89.203.249.158{default}.");
    return Plugin_Handled;
}