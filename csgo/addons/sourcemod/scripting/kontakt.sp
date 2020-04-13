#include <sourcemod>
#include <multicolors>

public Plugin myinfo =
{
	name = "Kontakt",
	author = "Benjamín Morozov",
	description = "Zobrazuje kontakt na staff po napsání příkazů !contact nebo !kontakt do chatu.",
	version = "1.0",
};

public void OnPluginStart()
{
    RegConsoleCmd("sm_contact", Command_Kontakt);
    RegConsoleCmd("sm_kontakt", Command_Kontakt);
}

public Action Command_Kontakt(int client, int args)
{
    CReplyToCommand(client, "{green}[WenBreak]{default} {orange}Nějaký problém se serverem{default}? {orange}Potřebuješ pomoc{default}? {orange}Napiš{default} nám na {orange}forum {grey}http://wenbreak.ga/forum/{default}, nebo na {orange}email{default}: \n{grey}wenbreak@gmail.com{default}.");
    return Plugin_Handled;
}