#ifndef FIB_LEVELS_MQH
#define FIB_LEVELS_MQH

string FIB_OBJECT_PREFIX = "VZ_FIB_";
double FibHigh = 0.0;
double FibLow  = 0.0;

void CalculateLevels()
{
   int lookback = 200;
   int hi_index = iHighest(_Symbol, PERIOD_CURRENT, MODE_HIGH, lookback, 0);
   int lo_index = iLowest(_Symbol, PERIOD_CURRENT, MODE_LOW, lookback, 0);
   if(hi_index < 0 || lo_index < 0) return;

   FibHigh = iHigh(_Symbol, PERIOD_CURRENT, hi_index);
   FibLow  = iLow(_Symbol, PERIOD_CURRENT, lo_index);
}

void DrawLevels()
{
   if(FibHigh <= 0.0 || FibLow <= 0.0 || FibHigh <= FibLow)
      return;

   string name_high = FIB_OBJECT_PREFIX + "HIGH";
   string name_low  = FIB_OBJECT_PREFIX + "LOW";

   ObjectCreate(0, name_high, OBJ_HLINE, 0, 0, FibHigh);
   ObjectSetInteger(0, name_high, OBJPROP_COLOR, clrLimeGreen);

   ObjectCreate(0, name_low, OBJ_HLINE, 0, 0, FibLow);
   ObjectSetInteger(0, name_low, OBJPROP_COLOR, clrTomato);
}

void CleanupLevels()
{
   ObjectsDeleteAll(0, FIB_OBJECT_PREFIX);
}

#endif
