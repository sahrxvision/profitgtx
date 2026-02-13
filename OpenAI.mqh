#ifndef OPENAI_MQH
#define OPENAI_MQH

bool InitializeOpenAI(const string api_key)
{
   return (StringLen(api_key) > 0);
}

bool IsAIEnabled()
{
   return (Use_OpenAI && AI_Initialized);
}

string ValidateTradeWithAI(const string setup_name, const bool is_buy)
{
   string dir = is_buy ? "BUY" : "SELL";
   return "MAYBE|placeholder|" + setup_name + "|" + dir;
}

string GetAIDailyBriefing()
{
   return "AI briefing placeholder: connect your OpenAI request function here.";
}

void DisplayAIBriefing(const string briefing)
{
   Last_AI_Analysis = briefing;
   Print("[AI BRIEFING] ", briefing);
}

string IdentifyPatternsWithAI()
{
   return "Pattern scan placeholder";
}

#endif
