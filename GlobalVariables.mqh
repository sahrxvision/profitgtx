#ifndef GLOBAL_VARIABLES_MQH
#define GLOBAL_VARIABLES_MQH

int      SetupCount[64];
datetime LastEntryTime[64];

datetime Last_Trade_Time       = 0;
string   LastTradeDirection    = "";

datetime Last_MA_Retest_Trade  = 0;
datetime Last_MA_Reject_Trade  = 0;

int      Active_Warnings       = 0;
int      Active_Praise_Signals = 0;
int      Warning_Confluence_Count = 0;
bool     Warning_Confluence_3Plus = false;
int      Praise_Count             = 0;

int      PatternComboWarn      = 0;
int      PatternComboPraise    = 0;
bool     DoubleTopAtFib        = false;
bool     DoubleBottomAtFib     = false;

int      TodayTrades           = 0;
int      BuyTrades             = 0;
int      SellTrades            = 0;
int      ClosedByReversal      = 0;

int      Current_Mode          = MODE_CHOP;
int      Current_State         = STATE_PULLBACK;
int      Current_Bias_Direction = 0;

double   State_Bias_Confidence = 0.0;

int      Coordinator_Bias_Direction = 0;
double   Coordinator_Cluster_Strength = 0.0;
double   Coordinator_Conflict_Score = 100.0;
double   Coordinator_Lot_Multiplier = 1.0;
bool     Coordinator_AllowTrade = false;

int      BullWarnCount         = 0;
int      BullPraiseCount       = 0;
int      BearWarnCount         = 0;
int      BearPraiseCount       = 0;

string   Symbol_Profile_Name   = "MANUAL";
int      Symbol_SL_Points      = 800;
int      Symbol_TP_Points      = 5000;
bool     Symbol_Profile_Initialized = false;

bool     AI_Initialized        = false;
string   OpenAI_Model          = "";
string   Last_AI_Analysis      = "";
datetime Last_AI_Briefing_Time = 0;
int      AI_Validation_Accepts = 0;
int      AI_Validation_Rejects = 0;

bool     NN_Initialized        = false;
int      NN_Bias               = 0;
double   NN_Confidence         = 0.0;
double   NN_RiskScore          = 50.0;
string   NN_Explain            = "";
datetime NN_LastRun            = 0;
bool     NN_UsedLastTick       = false;

int      News_Bias_Direction   = 0;
double   News_Bias_Strength    = 0.0;
bool     News_Trade_Block_Active = false;
string   News_Last_Headline    = "";
string   News_Bias_Report      = "";
datetime News_Last_Update      = 0;

// Warning flags
bool MA7_Cross_14_Warning = false;
bool MA7_Cross_21_Warning = false;
bool MA50_Break_Warning = false;
bool Fib_Reject_Warning = false;
bool MFIB_Reject_Warning = false;
bool Fib_Reclaim_Warning = false;
bool MFIB_Reclaim_Warning = false;
bool Fib_Break_Warning = false;
bool MFIB_Break_Warning = false;
bool MA_Reject_Warning = false;
bool MA_Reclaim_Warning = false;
bool MA_Break_Warning = false;
bool Stoch_Extreme_Warning = false;
bool Stoch_Reject_Warning = false;
bool Stoch_Level_Cross = false;
bool MA50_Warning = false;
bool MA140_Warning = false;
bool MA230_Warning = false;
bool MA500_Warning = false;
bool Pullback_Warning = false;
bool Retracement_Warning = false;
bool Band_Snap_Warning = false;
bool MA14_Magnet_Active = false;
bool Fib_Break_Confirmed = false;
bool MFIB_Break_Confirmed = false;
bool Strong_MA_Bounce = false;
bool Trend_Resumption = false;

// Praise flags
bool Praise_Triple_Magnet = false;
bool Praise_Power_Couple = false;
bool Praise_MFIB_Staircase = false;
bool Praise_MFIB_Express = false;
bool Praise_MFIB_Breakout = false;
bool Praise_MA_Stack = false;
bool Praise_Clean_Reclaim = false;
bool Praise_Multi_Breakout = false;

#endif
