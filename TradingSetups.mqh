#ifndef TRADING_SETUPS_MQH
#define TRADING_SETUPS_MQH

void FireSetup(const bool buy, const string name, const bool continuation)
{
   if(continuation)
   {
      if(buy) OpenBuy(name, 1.0);
      else OpenSell(name, 1.0);
   }
   else
   {
      if(buy) OpenBuy(name, 0.8);
      else OpenSell(name, 0.8);
   }
}

void ExecuteContinuationSetups()
{
   if(Current_Mode != MODE_TRENDING || Current_State != STATE_CONTINUATION)
      return;

   double current = MidPrice();
   double buffer = MA_Touch_Buffer;
   int dir = BiasDirection();

   // 1) MA14 cross pressure.
   if(MA_Previous[1] <= MA_Previous[3] && MA_Current[1] > MA_Current[3]) FireSetup(true,  "MA14-CROSS-UP",  true);
   if(MA_Previous[1] >= MA_Previous[3] && MA_Current[1] < MA_Current[3]) FireSetup(false, "MA14-CROSS-DN",  true);

   // 2) MA50 bounce.
   if(NearLevel(current, MA_Current[3], buffer))
   {
      if(dir >= 0) FireSetup(true, "MA50-BOUNCE-UP", true);
      if(dir <= 0) FireSetup(false, "MA50-BOUNCE-DN", true);
   }

   // 3) MA140 bounce.
   if(NearLevel(current, MA_Current[4], buffer))
   {
      if(dir >= 0) FireSetup(true, "MA140-BOUNCE-UP", true);
      if(dir <= 0) FireSetup(false, "MA140-BOUNCE-DN", true);
   }

   // 4) MA230 bounce.
   if(NearLevel(current, MA_Current[5], buffer))
   {
      if(dir >= 0) FireSetup(true, "MA230-BOUNCE-UP", true);
      if(dir <= 0) FireSetup(false, "MA230-BOUNCE-DN", true);
   }

   // 5) MA500 touch.
   if(NearLevel(current, MA_Current[6], buffer))
   {
      if(dir >= 0) FireSetup(true, "MA500-TOUCH-UP", true);
      if(dir <= 0) FireSetup(false, "MA500-TOUCH-DN", true);
   }

   // 6) FIB break.
   for(int i = 1; i <= 5; ++i)
   {
      double c0 = iClose(_Symbol, PERIOD_CURRENT, 0);
      double c1 = iClose(_Symbol, PERIOD_CURRENT, 1);
      if(c1 <= PriceLevels[i] && c0 > PriceLevels[i]) FireSetup(true, "FIB-BREAK-UP", true);
      if(c1 >= PriceLevels[i] && c0 < PriceLevels[i]) FireSetup(false, "FIB-BREAK-DN", true);
   }

   // 7) FIB reclaim.
   for(int i = 1; i <= 5; ++i)
   {
      double c0 = iClose(_Symbol, PERIOD_CURRENT, 0);
      double c1 = iClose(_Symbol, PERIOD_CURRENT, 1);
      if(c1 < PriceLevels[i] && c0 > PriceLevels[i]) FireSetup(true, "FIB-RECLAIM-UP", true);
      if(c1 > PriceLevels[i] && c0 < PriceLevels[i]) FireSetup(false, "FIB-RECLAIM-DN", true);
   }

   // 8) Magnet walk around MA21.
   bool hugging = (Current_ATR > 0.0 && (MathAbs(current - MA_Current[2]) / Current_ATR) < 0.7);
   if(hugging && dir >= 0) FireSetup(true, "MAGNET-WALK-UP", true);
   if(hugging && dir <= 0) FireSetup(false, "MAGNET-WALK-DN", true);

   // 9) MFIB ladder.
   if(NearLevel(current, MFIB_Level_382, buffer) || NearLevel(current, MFIB_Level_618, buffer))
   {
      if(dir >= 0) FireSetup(true, "MFIB-LADDER-UP", true);
      if(dir <= 0) FireSetup(false, "MFIB-LADDER-DN", true);
   }

   // 10) Staircase advance.
   bool stack_bull = (MA_Current[0] > MA_Current[1] && MA_Current[1] > MA_Current[2] && MA_Current[2] > MA_Current[3]);
   bool stack_bear = (MA_Current[0] < MA_Current[1] && MA_Current[1] < MA_Current[2] && MA_Current[2] < MA_Current[3]);
   if(stack_bull && Current_ADX > 25) FireSetup(true, "STAIRCASE-UP", true);
   if(stack_bear && Current_ADX > 25) FireSetup(false, "STAIRCASE-DN", true);

   // 11) Controlled pullback.
   if(dir > 0 && MA_Current[0] > MA_Current[3] && Stoch_K_Current > Stoch_Weak_Low && Stoch_K_Current < Stoch_Mid)
      FireSetup(true, "CTRL-PB-UP", true);
   if(dir < 0 && MA_Current[0] < MA_Current[3] && Stoch_K_Current < Stoch_Weak_High && Stoch_K_Current > Stoch_Mid)
      FireSetup(false, "CTRL-PB-DN", true);

   // 12) Timeframe reset.
   if(dir > 0 && MA_Previous[0] < MA_Previous[3] && MA_Current[0] >= MA_Current[3]) FireSetup(true, "TF-RESET-UP", true);
   if(dir < 0 && MA_Previous[0] > MA_Previous[3] && MA_Current[0] <= MA_Current[3]) FireSetup(false, "TF-RESET-DN", true);

   // 13) MFIB press.
   if(dir > 0 && (NearLevel(current, MFIB_Level_618, buffer) || NearLevel(current, MFIB_Level_786, buffer)) && Stoch_K_Current > Stoch_Mid)
      FireSetup(true, "MFIB-PRESS-UP", true);
   if(dir < 0 && (NearLevel(current, MFIB_Level_236, buffer) || NearLevel(current, MFIB_Level_382, buffer)) && Stoch_K_Current < Stoch_Mid)
      FireSetup(false, "MFIB-PRESS-DN", true);

   // 14) Break+Retest continuation.
   if(dir > 0 && iClose(_Symbol, PERIOD_CURRENT, 1) > MA_Current[3] && NearLevel(iLow(_Symbol, PERIOD_CURRENT, 0), MA_Current[3], buffer))
      FireSetup(true, "BREAK-RETEST-UP", true);
   if(dir < 0 && iClose(_Symbol, PERIOD_CURRENT, 1) < MA_Current[3] && NearLevel(iHigh(_Symbol, PERIOD_CURRENT, 0), MA_Current[3], buffer))
      FireSetup(false, "BREAK-RETEST-DN", true);
}

void ExecuteRangeSetups()
{
   if(Current_Mode != MODE_RANGING)
      return;

   double current = MidPrice();
   double buffer = MA_Touch_Buffer;

   // 1) Range edge buy.
   if(NearLevel(current, PriceLevels[1], buffer) && Stoch_K_Current < Stoch_Weak_Low)
      FireSetup(true, "RANGE-EDGE-BUY", false);

   // 2) Range edge sell.
   if(NearLevel(current, PriceLevels[5], buffer) && Stoch_K_Current > Stoch_Weak_High)
      FireSetup(false, "RANGE-EDGE-SELL", false);

   // 3) MFIB reject range buy.
   if(NearLevel(current, MFIB_Level_382, buffer) && Stoch_K_Current < Stoch_Mid)
      FireSetup(true, "RANGE-MFIB-BUY", false);

   // 4) MFIB reject range sell.
   if(NearLevel(current, MFIB_Level_618, buffer) && Stoch_K_Current > Stoch_Mid)
      FireSetup(false, "RANGE-MFIB-SELL", false);
}

void ExecuteChopSetups()
{
   if(Current_Mode != MODE_CHOP)
      return;

   // 1) Mean reversion from oversold.
   if(Stoch_K_Current <= Stoch_Oversold && Active_Warnings >= Active_Praise_Signals)
      FireSetup(true, "CHOP-REV-BUY", false);

   // 2) Mean reversion from overbought.
   if(Stoch_K_Current >= Stoch_Overbought && Active_Warnings >= Active_Praise_Signals)
      FireSetup(false, "CHOP-REV-SELL", false);

   // 3) Counter snap at MA7.
   double current = MidPrice();
   if(NearLevel(current, MA_Current[0], MA_Touch_Buffer) && Active_Warnings >= 2)
   {
      if(iClose(_Symbol, PERIOD_CURRENT, 0) < MA_Current[0]) FireSetup(true, "CHOP-SNAP-BUY", false);
      if(iClose(_Symbol, PERIOD_CURRENT, 0) > MA_Current[0]) FireSetup(false, "CHOP-SNAP-SELL", false);
   }
}

#endif
