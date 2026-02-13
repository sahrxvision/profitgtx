#ifndef INPUT_PARAMS_MQH
#define INPUT_PARAMS_MQH

input long   MagicNumber                 = 580001;
input bool   Show_Levels                 = true;
input double BaseLotSize                 = 0.10;
input double War_Survivor_Lot_Multiplier = 2.5;

input int    Trade_Cooldown_Seconds      = 300;
input int    Max_Open_Trades             = 3;

input int    Continuation_SL_Points      = 150;
input int    Continuation_TP_Points      = 4000;
input int    Counter_SL_Points           = 50;
input int    Counter_TP_Points           = 3000;

input int    BE_Trigger_Points           = 300;
input int    Trail_Continuation_Points   = 300;
input int    Trail_Counter_Points        = 150;
input int    Trail_Supreme_Points        = 100;

input int    MA_Touch_Buffer             = 75;
input int    Fib_Lookback_Bars           = 350;

input double Stoch_Oversold              = 20.0;
input double Stoch_Weak_Low              = 35.0;
input double Stoch_Mid                   = 50.0;
input double Stoch_Weak_High             = 65.0;
input double Stoch_Overbought            = 80.0;

input bool   Use_Signal_Coordinator      = true;
input int    Conflict_Prevention_Seconds = 300;
input double Signal_Consensus_Threshold  = 0.60;
input double Min_Cluster_Strength        = 58.0;
input double Max_Cluster_Conflict        = 40.0;
input bool   Use_NN_In_Coordinator       = true;

input bool   Use_NeuralNet               = true;
input string NN_ServerURL                = "http://127.0.0.1:8000/predict";
input int    NN_TimeoutMs                = 3000;
input int    NN_CooldownSeconds          = 15;
input double NN_MinConfidenceToUse       = 55.0;
input double NN_MaxRiskToUse             = 70.0;
input bool   NN_DebugPrint               = false;

input bool   Use_OpenAI                  = false;
input string OpenAI_API_Key              = "";
input string OpenAI_Model_Choice         = "gpt-4o-mini";
input bool   AI_Validate_Trades          = false;
input bool   AI_Daily_Briefing           = false;
input int    AI_Briefing_Hour            = 7;

#endif
