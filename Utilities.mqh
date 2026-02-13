#ifndef UTILITIES_MQH
#define UTILITIES_MQH

string ModeToString(const int mode)
{
   if(mode == MODE_TRENDING) return "TRENDING";
   if(mode == MODE_RANGING)  return "RANGING";
   return "CHOP";
}

string StateToString(const int state)
{
   if(state == STATE_CONTINUATION) return "CONTINUATION";
   if(state == STATE_REVERSAL)     return "REVERSAL";
   return "PULLBACK";
}

double MidPrice()
{
   return (SymbolInfoDouble(_Symbol, SYMBOL_BID) + SymbolInfoDouble(_Symbol, SYMBOL_ASK)) * 0.5;
}

bool NearLevel(const double price, const double level, const double buffer_points)
{
   return (MathAbs(price - level) <= buffer_points * _Point);
}

double NormalizePrice(const double price)
{
   return NormalizeDouble(price, (int)SymbolInfoInteger(_Symbol, SYMBOL_DIGITS));
}

double NormalizeLots(double lots)
{
   double min_lot  = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MIN);
   double max_lot  = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MAX);
   double lot_step = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_STEP);

   if(lot_step <= 0.0) lot_step = 0.01;
   lots = MathMax(min_lot, MathMin(max_lot, lots));
   lots = MathFloor(lots / lot_step) * lot_step;
   return NormalizeDouble(lots, 2);
}

#endif
