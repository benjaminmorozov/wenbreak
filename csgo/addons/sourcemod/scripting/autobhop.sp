#include <sourcemod>
#include <multicolors>
#include <sdktools>

new Handle:gh_AutoBhop = INVALID_HANDLE;
new Handle:gh_EnableBhop = INVALID_HANDLE;
new bool:gb_ClientAutoBhop[MAXPLAYERS+1];

public Plugin myinfo =
{
	name = "autobhop",
	author = "Benjamín Morozov",
	description = "Autobunnyhop plugin pro VIP a Adminy.",
	version = "1.0",
};

public void OnPluginStart()
{
    HookEvent("player_jump", Event_PlayerJump);
    gh_AutoBhop = FindConVar("sv_autobunnyhopping");
    gh_EnableBhop = FindConVar("sv_enablebunnyhopping");

    SetConVarBool(gh_AutoBhop, false);
    SetConVarBool(gh_EnableBhop, true);

    RegConsoleCmd("sm_autobhop", Command_AutoBhop);
}

public void OnClientConnected(client)
{
    gb_ClientAutoBhop[client] = false;
}

public Action Command_AutoBhop(int client, int args)
{
    gb_ClientAutoBhop[client] = !gb_ClientAutoBhop[client];

    if (GetUserFlagBits(client) & (ADMFLAG_RESERVATION) == (ADMFLAG_RESERVATION) || (ADMFLAG_ROOT) == (ADMFLAG_ROOT))
    {
        if(gb_ClientAutoBhop[client])
        {
        CReplyToCommand(client, "{green}[WenBreak] {orange}AutoBhop {default}byl {green}zapnut{default}.");
        SendConVarValue(client, gh_AutoBhop, "1");
        } else {
            CReplyToCommand(client, "{green}[WenBreak] {orange}AutoBhop {default}byl {darkred}vypnut{default}.");
            SendConVarValue(client, gh_AutoBhop, "0");
        }
    } else {
        CReplyToCommand(client, "{green}[WenBreak] {darkred}Nemáte přístup {default}k tomuto {orange}příkazu{default}.");
    }
    return Plugin_Handled;
}

public Action:OnPlayerRunCmd(client, &buttons, &impulse, Float:vel[3], Float:angles[3], &weapon, &subtype, &cmdnum, &tickcount, &seed, mouse[2])
{
    if (gb_ClientAutoBhop[client] && IsPlayerAlive(client))
    {
        if (buttons & IN_JUMP)
        {
            if (!(GetEntityFlags(client) & FL_ONGROUND))
            {
                if (!(GetEntityMoveType(client) & MOVETYPE_LADDER))
                {
                    if (GetEntProp(client, Prop_Data, "m_nWaterLevel") <= 1)
                    {
                        buttons &= ~IN_JUMP;
                    }
                }
            }
        }
    }
} 

public Action Event_PlayerJump(Handle event, const char[] name, bool dontBroadcast)
{
    int client = GetClientOfUserId(GetEventInt(event, "userid"));
    CreateTimer(0.0, CheckMaxSpeed, client);
}

public Action CheckMaxSpeed(Handle timer, any client)
{
    float fVelocity[3];
    GetEntPropVector(client, Prop_Data, "m_vecVelocity", fVelocity);
    float currentspeed = SquareRoot(Pow(fVelocity[0],2.0)+Pow(fVelocity[1],2.0));
    
    float maxspeed = 420.0;
    
    if (currentspeed > maxspeed)
    {
        float Multpl = currentspeed / maxspeed;
    
        if(Multpl != 0.0)
        {
            fVelocity[0] /= Multpl;
            fVelocity[1] /= Multpl;
            TeleportEntity(client, NULL_VECTOR, NULL_VECTOR, fVelocity);
        }
    }
}