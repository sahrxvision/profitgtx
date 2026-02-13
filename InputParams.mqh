#ifndef INPUT_PARAMS_MQH
#define INPUT_PARAMS_MQH

input long   MagicNumber                 = 580001;
input bool   Show_Levels                 = true;
input double BaseLotSize                 = 0.10;

input double War_Survivor_Lot_Multiplier = 2.5;

input bool   Use_OpenAI                  = false;
input string OpenAI_API_Key              = "";
input string OpenAI_Model_Choice         = "gpt-4o-mini";
input bool   AI_Validate_Trades          = false;
input bool   AI_Daily_Briefing           = false;
input int    AI_Briefing_Hour            = 7;

#endif
