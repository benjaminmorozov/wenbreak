#include <sourcemod>
#include <multicolors>

public Plugin myinfo =
{
	name = "Pravidla",
	author = "Benjamín Morozov",
	description = "Zobrazuje web stránku pro pravidla po spuštění příkazu !pravidla, nebo !rules",
	version = "1.0",
};

public void OnPluginStart()
{
    RegConsoleCmd("sm_pravidla", Command_Pravidla);
    RegConsoleCmd("sm_rules", Command_Pravidla);
}

public Action Command_Pravidla(int client, int args)
{
    CReplyToCommand(client, "{green}[WenBreak]{default} Pravidla můžeš nalézt {orange}na stránce{orange}: \n{grey}http://wenbreak.ga/pravidla");
    return Plugin_Handled;
}