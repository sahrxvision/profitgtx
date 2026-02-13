#ifndef OPENAI_MQH
#define OPENAI_MQH

string g_openai_base_url = "https://api.openai.com/v1/chat/completions";

string JSONEscape(const string s)
{
   string x = s;
   StringReplace(x, "\\", "\\\\");
   StringReplace(x, "\"", "\\\"");
   StringReplace(x, "\n", " ");
   StringReplace(x, "\r", " ");
   return x;
}

bool InitializeOpenAI(const string api_key)
{
   if(StringLen(api_key) < 20)
      return false;

   OpenAI_Model = OpenAI_Model_Choice;
   return true;
}

bool IsAIEnabled()
{
   return AI_Initialized;
}

bool OpenAIRequest(const string system_prompt, const string user_prompt, string &content)
{
   if(!AI_Initialized)
      return false;

   string headers = "Content-Type: application/json\r\nAuthorization: Bearer " + OpenAI_API_Key + "\r\n";

   string payload = "{";
   payload += "\"model\":\"" + JSONEscape(OpenAI_Model_Choice) + "\",";
   payload += "\"temperature\":0.0,";
   payload += "\"messages\":[";
   payload += "{\"role\":\"system\",\"content\":\"" + JSONEscape(system_prompt) + "\"},";
   payload += "{\"role\":\"user\",\"content\":\"" + JSONEscape(user_prompt) + "\"}";
   payload += "]}";

   char post_data[];
   StringToCharArray(payload, post_data, 0, WHOLE_ARRAY, CP_UTF8);

   char result[];
   string result_headers = "";
   ResetLastError();
   int code = WebRequest("POST", g_openai_base_url, headers, 10000, post_data, result, result_headers);

   if(code <= 0)
      return false;

   string resp = CharArrayToString(result, 0, -1, CP_UTF8);

   int k = StringFind(resp, "\"content\":\"");
   if(k < 0)
      return false;

   int start = k + StringLen("\"content\":\"");
   int end = start;
   while(end < StringLen(resp))
   {
      string ch = StringSubstr(resp, end, 1);
      string prev = (end > start) ? StringSubstr(resp, end - 1, 1) : "";
      if(ch == "\"" && prev != "\\")
         break;
      end++;
   }

   if(end <= start)
      return false;

   content = StringSubstr(resp, start, end - start);
   StringReplace(content, "\\n", " ");
   StringReplace(content, "\\\"", "\"");
   return true;
}

string ValidateTradeWithAI(const string setup_name, const bool is_buy)
{
   string system_prompt = "You are a strict trading risk validator. Reply with exactly one of YES, NO, MAYBE then short reason.";

   string user_prompt = "Validate trade. Symbol=" + _Symbol +
                        ", setup=" + setup_name +
                        ", direction=" + (is_buy ? "BUY" : "SELL") +
                        ", mode=" + ModeToString(Current_Mode) +
                        ", state=" + StateToString(Current_State) +
                        ", warnings=" + IntegerToString(Active_Warnings) +
                        ", praise=" + IntegerToString(Active_Praise_Signals) +
                        ", nn_bias=" + IntegerToString(NN_Bias) +
                        ", nn_conf=" + DoubleToString(NN_Confidence, 1) +
                        ", news_bias=" + IntegerToString(News_Bias_Direction) +
                        ", news_strength=" + DoubleToString(News_Bias_Strength, 1) +
                        ", cluster_strength=" + DoubleToString(Coordinator_Cluster_Strength, 1) +
                        ", cluster_conflict=" + DoubleToString(Coordinator_Conflict_Score, 1);

   string content = "";
   if(!OpenAIRequest(system_prompt, user_prompt, content))
      return "NO | OpenAI request failed";

   string u = StringUpper(content);
   if(StringFind(u, "YES") >= 0) return "YES | " + content;
   if(StringFind(u, "NO") >= 0) return "NO | " + content;
   if(StringFind(u, "MAYBE") >= 0) return "MAYBE | " + content;

   return "NO | Invalid AI response";
}

string GetAIDailyBriefing()
{
   string system_prompt = "You are a market briefing assistant. Keep output concise and actionable.";

   string user_prompt = "Give short market briefing for " + _Symbol +
                        ". Include directional bias (bull/bear/neutral), key risk events, and tactical plan for trending/ranging/chop.";

   string content = "";
   if(!OpenAIRequest(system_prompt, user_prompt, content))
      return "AI briefing unavailable (request failed).";

   return content;
}

void DisplayAIBriefing(const string briefing)
{
   Last_AI_Analysis = briefing;
   Print("[AI BRIEFING] ", briefing);
}

string IdentifyPatternsWithAI()
{
   string system_prompt = "You summarize technical context from given state.";
   string user_prompt = "Symbol=" + _Symbol +
                        ", mode=" + ModeToString(Current_Mode) +
                        ", state=" + StateToString(Current_State) +
                        ", warnings=" + IntegerToString(Active_Warnings) +
                        ", praise=" + IntegerToString(Active_Praise_Signals) +
                        ". Return short pattern interpretation.";

   string content = "";
   if(!OpenAIRequest(system_prompt, user_prompt, content))
      return "Pattern AI unavailable.";

   return content;
}

#endif
