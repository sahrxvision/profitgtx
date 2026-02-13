#ifndef CHART_STRUCTURE_MQH
#define CHART_STRUCTURE_MQH

enum ENUM_SWING_TYPE
{
   SWING_HIGH,
   SWING_LOW
};

enum ENUM_MARKET_STRUCTURE
{
   STRUCTURE_UPTREND,
   STRUCTURE_DOWNTREND,
   STRUCTURE_RANGING,
   STRUCTURE_BREAKING
};

struct SwingPoint
{
   ENUM_SWING_TYPE type;
   double price;
   datetime time;
   int bar_index;
   bool is_higher_high;
   bool is_lower_low;
   bool is_higher_low;
   bool is_lower_high;
};

SwingPoint g_SwingPoints[];
int g_SwingCount = 0;
const int MAX_SWINGS = 50;
ENUM_MARKET_STRUCTURE g_CurrentStructure = STRUCTURE_RANGING;

bool InitializeChartStructure()
{
   ArrayResize(g_SwingPoints, MAX_SWINGS);
   g_SwingCount = 0;
   return true;
}

void SortSwingsByTime()
{
   for(int i = 0; i < g_SwingCount - 1; ++i)
   {
      for(int j = 0; j < g_SwingCount - i - 1; ++j)
      {
         if(g_SwingPoints[j].time < g_SwingPoints[j + 1].time)
         {
            SwingPoint t = g_SwingPoints[j];
            g_SwingPoints[j] = g_SwingPoints[j + 1];
            g_SwingPoints[j + 1] = t;
         }
      }
   }
}

void IdentifySwingPoints(const MqlRates &rates[])
{
   g_SwingCount = 0;
   const int swing_bars = 5;

   for(int i = swing_bars; i < ArraySize(rates) - swing_bars && g_SwingCount < MAX_SWINGS; ++i)
   {
      bool is_high = true;
      bool is_low = true;

      for(int j = 1; j <= swing_bars; ++j)
      {
         if(rates[i].high <= rates[i - j].high || rates[i].high <= rates[i + j].high) is_high = false;
         if(rates[i].low >= rates[i - j].low || rates[i].low >= rates[i + j].low) is_low = false;
      }

      if(is_high)
      {
         SwingPoint s;
         s.type = SWING_HIGH;
         s.price = rates[i].high;
         s.time = rates[i].time;
         s.bar_index = i;
         s.is_higher_high = false;
         s.is_lower_low = false;
         s.is_higher_low = false;
         s.is_lower_high = false;
         g_SwingPoints[g_SwingCount++] = s;
      }

      if(is_low && g_SwingCount < MAX_SWINGS)
      {
         SwingPoint s2;
         s2.type = SWING_LOW;
         s2.price = rates[i].low;
         s2.time = rates[i].time;
         s2.bar_index = i;
         s2.is_higher_high = false;
         s2.is_lower_low = false;
         s2.is_higher_low = false;
         s2.is_lower_high = false;
         g_SwingPoints[g_SwingCount++] = s2;
      }
   }

   SortSwingsByTime();
}

void ClassifySwingRelationships()
{
   if(g_SwingCount < 2) return;

   for(int i = 0; i < g_SwingCount; ++i)
   {
      for(int j = i + 1; j < g_SwingCount; ++j)
      {
         if(g_SwingPoints[i].type != g_SwingPoints[j].type)
            continue;

         if(g_SwingPoints[i].type == SWING_HIGH)
         {
            if(g_SwingPoints[i].price > g_SwingPoints[j].price) g_SwingPoints[i].is_higher_high = true;
            else g_SwingPoints[i].is_lower_high = true;
         }
         else
         {
            if(g_SwingPoints[i].price > g_SwingPoints[j].price) g_SwingPoints[i].is_higher_low = true;
            else g_SwingPoints[i].is_lower_low = true;
         }
         break;
      }
   }
}

void DetermineMarketStructure()
{
   int hh = 0, hl = 0, lh = 0, ll = 0;
   int lookback = MathMin(10, g_SwingCount);

   for(int i = 0; i < lookback; ++i)
   {
      if(g_SwingPoints[i].is_higher_high) hh++;
      if(g_SwingPoints[i].is_higher_low) hl++;
      if(g_SwingPoints[i].is_lower_high) lh++;
      if(g_SwingPoints[i].is_lower_low) ll++;
   }

   if(hh >= 2 && hl >= 1) g_CurrentStructure = STRUCTURE_UPTREND;
   else if(lh >= 2 && ll >= 1) g_CurrentStructure = STRUCTURE_DOWNTREND;
   else g_CurrentStructure = STRUCTURE_RANGING;
}

void DetectMarketStructure()
{
   MqlRates rates[];
   ArraySetAsSeries(rates, true);
   int copied = CopyRates(_Symbol, _Period, 0, 220, rates);
   if(copied < 60) return;

   IdentifySwingPoints(rates);
   ClassifySwingRelationships();
   DetermineMarketStructure();
}

string GetStructureString()
{
   if(g_CurrentStructure == STRUCTURE_UPTREND) return "UPTREND";
   if(g_CurrentStructure == STRUCTURE_DOWNTREND) return "DOWNTREND";
   if(g_CurrentStructure == STRUCTURE_BREAKING) return "BREAKING";
   return "RANGING";
}

int GetStructureStrength()
{
   int hh = 0, hl = 0, lh = 0, ll = 0;
   int lookback = MathMin(8, g_SwingCount);

   for(int i = 0; i < lookback; ++i)
   {
      if(g_SwingPoints[i].is_higher_high) hh++;
      if(g_SwingPoints[i].is_higher_low) hl++;
      if(g_SwingPoints[i].is_lower_high) lh++;
      if(g_SwingPoints[i].is_lower_low) ll++;
   }

   if(g_CurrentStructure == STRUCTURE_UPTREND) return MathMin(100, hh * 20 + hl * 15);
   if(g_CurrentStructure == STRUCTURE_DOWNTREND) return MathMin(100, lh * 20 + ll * 15);
   return 35;
}

void CleanupStructureObjects()
{
   for(int i = ObjectsTotal(0) - 1; i >= 0; --i)
   {
      string name = ObjectName(0, i);
      if(StringFind(name, "STRUCTURE_") == 0)
         ObjectDelete(0, name);
   }
}

#endif
