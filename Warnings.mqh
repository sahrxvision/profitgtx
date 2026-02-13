#ifndef WARNINGS_MQH
#define WARNINGS_MQH

void DetectWarnings()
{
   Active_Warnings = 0;

   if(ma_fast_value < ma_slow_value)
      Active_Warnings++;

   double spread_points = (SymbolInfoDouble(_Symbol, SYMBOL_ASK) - SymbolInfoDouble(_Symbol, SYMBOL_BID)) / _Point;
   if(spread_points > 30.0)
      Active_Warnings++;
}

#endif
