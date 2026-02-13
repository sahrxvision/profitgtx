#ifndef GLOBAL_VARIABLES_MQH
#define GLOBAL_VARIABLES_MQH

int      SetupCount[32];
datetime LastEntryTime[32];

int      Active_Warnings       = 0;
int      Active_Praise_Signals = 0;

int      TodayTrades       = 0;
int      BuyTrades         = 0;
int      SellTrades        = 0;
int      ClosedByReversal  = 0;

int      Current_Mode  = MODE_CHOP;
int      Current_State = STATE_PULLBACK;

bool     AI_Initialized         = false;
string   OpenAI_Model           = "";
string   Last_AI_Analysis       = "";
datetime Last_AI_Briefing_Time  = 0;

double   NN_Bias                = 0.0;
double   NN_Confidence          = 0.0;

#endif
