#include <sourcemod>
#include <multicolors>
#include <sdktools>
#include <sdkhooks>
#include <cstrike>
#include <colors>
#include <autoexecconfig>
#include <warden>
#include <myjbwarden>
#include <betterwarden>
#include <smartdm>

public Plugin:myinfo = {
    name = "noblock rewritten",
    author = "Benjamín Morozov",
    description = "noblock",
    version = "1.0.0"
};

ConVar g_bNoBlockSolid;

bool g_bNoBlock = true;

public onPluginStart()
{
    RegAdminCmd("sm_noblockk", Command_Noblock, ADMFLAG_BAN);

    HookEvent("round_end", NoBlock_RoundEnd);

    g_bNoBlockSolid = FindConVar("mp_solid_teammates");
}

public Action Command_Noblock(int client, int args)
{
    if (GetClientTeam(client) == CS_TEAM_CT)
    {
        if (!g_bNoBlock)
        {
            g_bNoBlock = true;
            CPrintToChatAll( "Noblock enabled");
            for (int i = 1; i <= MaxClients; i++) if (IsValidClient(i, true, true))
            {
                SetEntProp(i, Prop_Send, "m_CollisionGroup", 2); // 2 - Collisions disabled, 5 - default/enabled
            }
        }
    } else CReplyToCommand(client, "Not a warden")

    return Plugin_Handled;
}

public void NoBlock_RoundEnd(Event event, const char[] name, bool dontBroadcast)
{
    int x = g_bNoBlockSolid.BoolValue;
    new Handle:convar = FindConVar("mp_solid_teammates");
    SetConVarInt(convar, x & ~FCVAR_NOTIFY);
}

void NoBlock_OnAvailableLR()
{
    if (!gc_NoBlockLR.BoolValue)
        return;

    for (int i = 1; i <= MaxClients; i++)
    {
        if (!IsValidClient(i, true, true))
            continue;
        
        SetEntPop(i, Prop_Send, "m_CollisionGroup", 5)
    }

    SetCvar("mp_solid_teammates", 1);

    CPrintToChatAll(client, "disabled noblock")
}