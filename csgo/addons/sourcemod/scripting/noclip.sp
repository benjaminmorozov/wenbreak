#include <sourcemod>
#include <multicolors>
#include <sdktools>
#include <cstrike>

public Plugin myinfo =
{
	name = "noclip",
	author = "Benjamín Morozov",
	description = "noclip",
	version = "1.0",
};

g_iTarget[MAXPLAYERS + 1];

public void OnPluginStart()
{
	RegAdminCmd("sm_noclip", Command_NoClip, ADMFLAG_BAN);
}

public Action Command_NoClip(int client, int args)
{
    if (args < 1) {
        MoveType movetype = GetEntityMoveType(client);
        
	    if (movetype != MOVETYPE_NOCLIP)
	    {
		    SetEntityMoveType(client, MOVETYPE_NOCLIP);
            CReplyToCommand(client, "{green}[WenBreak] {orange}Zapnul {default}jsi{orange} si noclip{default}.");
            PrintCenterText(client, "Zapnul jsi si noclip!");
	    }
	    else
	    {
		    SetEntityMoveType(client, MOVETYPE_WALK);
            CReplyToCommand(client, "{green}[WenBreak] {darkred}Vypnul {default}jsi{orange} si noclip{default}.");
            PrintCenterText(client, "Vypnul jsi si noclip!");
	    }
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
        CReplyToCommand(client, "{green}[WenBreak] {default}hráč {orange}%s{darkred} nebyl nalezen{default}, {orange}otevírám seznam hráčů{default}.", name);
        Menu_Test1(client);
        return Plugin_Handled;
    }

        MoveType movetype = GetEntityMoveType(client);
        
	if (movetype != MOVETYPE_NOCLIP)
	{
		SetEntityMoveType(target, MOVETYPE_NOCLIP);
        CReplyToCommand(client, "{green}[WenBreak] {orange}Hráči %s {default}jsi {orange}zapnul noclip{default}.");
        PrintCenterText(client, "Byl ti zapnut noclip!");
	}
	else
	{
		SetEntityMoveType(target, MOVETYPE_WALK);
        CReplyToCommand(client, "{green}[WenBreak] {orange}Hráči %s {default}jsi {darkred}vypnul {orange}noclip{default}.");
        PrintCenterText(client, "Noclip ti byl vypnut!");
	}
    return Plugin_Handled;
}

public Action Menu_Test1(int client)
{
    char sName[MAX_NAME_LENGTH];
	char sID[24];
    Menu menu = new Menu(MenuHandler1);
    menu.SetTitle("Změnit Noclip hráči:");
    menu.AddItem("", "Zrušit");

	for (int i; i <= MaxClients; i++)
	{
		if (i != client && !IsFakeClient(i) && !IsClientSourceTV(i) && !IsClientReplay(i))
		{
			GetClientName(i, sName, sizeof(sName));
			Format(sID, sizeof(sID), "%d", GetClientSerial(i));
			
			menu.AddItem(sID, sName);
		}
	}

    menu.ExitButton = false;
    menu.Display(client, 20);
 
    return Plugin_Handled;
}

public int MenuHandler1(Menu menu, MenuAction action, int client, int option)
{
    /* If an option was selected, tell the client about the item. */
    if (action == MenuAction_Select)
    {
        if (option == 0) {
            CloseHandle(menu);
            return Plugin_Handled;
        } else {
		    char sInfo[24];
		    int iSerial;
		    int iID;
		
		    menu.GetItem(option, sInfo, sizeof(sInfo));
		
		    iSerial = StringToInt(sInfo);
		    iID     = GetClientFromSerial(iSerial);
		
		    g_iTarget[client] = iID;

            MoveType movetype = GetEntityMoveType(client);
        
	        if (movetype != MOVETYPE_NOCLIP)
	        {
		        SetEntityMoveType(client, MOVETYPE_NOCLIP);
                CReplyToCommand(client, "{green}[WenBreak] {orange}Hráči %s {default}jsi {orange}zapnul noclip{default}.");
                PrintCenterText(client, "Byl ti zapnut noclip!");
	        }
	        else {
		        SetEntityMoveType(client, MOVETYPE_WALK);
                CReplyToCommand(client, "{green}[WenBreak] {orange}Hráči %s {default}jsi {darkred}vypnul {orange}noclip{default}.");
                PrintCenterText(client, "Noclip ti byl vypnut!");
	        }
        }
    }
    /* If the menu was cancelled, print a message to the server about it. */
    else if (action == MenuAction_Cancel)
    {
        return Plugin_Handled;
    }

    return Plugin_Handled;
}