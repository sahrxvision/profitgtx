#ifndef NEWS_ENGINE_MQH
#define NEWS_ENGINE_MQH

string g_symbol_base = "";
string g_symbol_quote = "";

double NewsValueToDouble(const long v)
{
   return ((double)v) / 1000000.0;
}

void InitNewsEngine()
{
   string s = StringUpper(_Symbol);
   g_symbol_base = StringSubstr(s, 0, 3);
   g_symbol_quote = StringSubstr(s, 3, 3);

   News_Bias_Direction = 0;
   News_Bias_Strength = 0.0;
   News_Trade_Block_Active = false;
   News_Last_Headline = "";
   News_Last_Update = 0;
}

int CurrencyImpactSign(const string ccy)
{
   if(ccy == g_symbol_base) return 1;
   if(ccy == g_symbol_quote) return -1;
   if(ccy == "USD" && (g_symbol_base == "XAU" || g_symbol_base == "XAG" || g_symbol_base == "BTC" || g_symbol_base == "ETH"))
      return -1;
   return 0;
}

void UpdateNewsBiasFromCalendar()
{
   if(!Use_News_Filter)
      return;

   datetime now = TimeTradeServer();
   datetime from = now - (News_Lookback_Minutes * 60);

   MqlCalendarValue vals[];
   ArrayResize(vals, 0);

   int n = CalendarValueLast(vals, from);
   if(n <= 0)
   {
      News_Last_Update = now;
      return;
   }

   double score = 0.0;
   bool high_impact_near = false;
   string last_headline = "";

   for(int i = 0; i < n; ++i)
   {
      MqlCalendarEvent evt;
      if(!CalendarEventById(vals[i].event_id, evt))
         continue;

      int sign = CurrencyImpactSign(evt.currency);
      if(sign == 0)
         continue;

      int importance = (int)evt.importance;
      double imp_weight = 1.0;
      if(importance >= 2) imp_weight = 2.0;
      if(importance >= 3) imp_weight = 3.0;

      double actual = NewsValueToDouble(vals[i].actual_value);
      double forecast = NewsValueToDouble(vals[i].forecast_value);
      double previous = NewsValueToDouble(vals[i].prev_value);

      double surprise = actual - forecast;
      if(MathAbs(surprise) < 0.000001)
         surprise = actual - previous;

      if(MathAbs(surprise) < 0.000001)
         continue;

      double ev_score = surprise * imp_weight * sign;
      score += ev_score;

      if(importance >= 3 && MathAbs(ev_score) > 0.0)
      {
         if(MathAbs((double)(vals[i].time - now)) <= (double)(News_HighImpact_Block_Minutes * 60))
            high_impact_near = true;
      }

      last_headline = evt.currency + " " + evt.name;
   }

   if(score > 0.0) News_Bias_Direction = 1;
   else if(score < 0.0) News_Bias_Direction = -1;
   else News_Bias_Direction = 0;

   News_Bias_Strength = MathMin(100.0, MathAbs(score) * 10.0);
   News_Trade_Block_Active = high_impact_near;
   if(last_headline != "") News_Last_Headline = last_headline;
   News_Last_Update = now;
}

void BuildNewsReport()
{
   string dir = "NEUTRAL";
   if(News_Bias_Direction > 0) dir = "BULL";
   if(News_Bias_Direction < 0) dir = "BEAR";

   News_Bias_Report = "NEWS " + dir +
                      " | strength=" + DoubleToString(News_Bias_Strength, 1) +
                      " | block=" + (News_Trade_Block_Active ? "YES" : "NO") +
                      " | " + News_Last_Headline;
}

void UpdateNewsEngine()
{
   UpdateNewsBiasFromCalendar();
   BuildNewsReport();
}

#endif
