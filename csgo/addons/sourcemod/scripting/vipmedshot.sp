#include <sourcemod>
#include <cstrike>
#include <multicolors>
#include <sdktools>
#include <sdkhooks>

public Plugin:myinfo = {
    name = "vipmedshot",
    author = "Benjamín Morozov",
    description = "Gives a medshot to every VIP player on the server.",
    version = "1.0.0"
};

public void OnPluginStart()
{
    HookEvent("round_start", OnRoundStart, EventHookMode_PostNoCopy);
}

public OnRoundStart(Handle:event, const String:name[], bool:dontBroadcast)
{
	for (int i = 1; i <= MaxClients; i++)
	{
        if (GetUserFlagBits(i) & (ADMFLAG_RESERVATION) == (ADMFLAG_RESERVATION))
        {
            GivePlayerItem(i, "weapon_healthshot");
            GivePlayerItem(i, "item_kevlar");
        }
	}
} 