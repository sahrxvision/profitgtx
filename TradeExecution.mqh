#ifndef TRADE_EXECUTION_MQH
#define TRADE_EXECUTION_MQH

bool IsInCooldown()
{
   datetime now = TimeCurrent();
   return (now - Last_Trade_Time < Trade_Cooldown_Seconds);
}

int CountOpenTradesForSymbol()
{
   int count = 0;
   for(int i = PositionsTotal() - 1; i >= 0; --i)
   {
      ulong ticket = PositionGetTicket(i);
      if(ticket == 0 || !PositionSelectByTicket(ticket))
         continue;

      if(PositionGetString(POSITION_SYMBOL) == _Symbol && PositionGetInteger(POSITION_MAGIC) == MagicNumber)
         count++;
   }
   return count;
}

bool CanOpenNewTrade()
{
   if(IsInCooldown())
      return false;

   if(CountOpenTradesForSymbol() >= Max_Open_Trades)
      return false;

   return true;
}

double BuildLotMultiplier()
{
   double mult = 1.0;

   if(Active_Praise_Signals >= 4)
      mult *= 2.0;
   else if(Active_Praise_Signals == 3)
      mult *= 1.5;

   if(Active_Warnings >= 3)
      mult *= 0.5;

   if(Current_State == STATE_CONTINUATION)
      mult *= War_Survivor_Lot_Multiplier;

   return mult;
}

bool OpenBuy(const string reason, double lot_multiplier = 1.0)
{
   if(!CanOpenNewTrade())
      return false;

   double entry = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
   double lots = NormalizeLots(BaseLotSize * lot_multiplier * BuildLotMultiplier());
   double sl = NormalizePrice(entry - ((Current_Mode == MODE_TRENDING ? Continuation_SL_Points : Counter_SL_Points) * _Point));
   double tp = NormalizePrice(entry + ((Current_Mode == MODE_TRENDING ? Continuation_TP_Points : Counter_TP_Points) * _Point));

   bool ok = Trade.Buy(lots, _Symbol, 0.0, sl, tp, reason);
   if(ok)
   {
      Last_Trade_Time = TimeCurrent();
      TodayTrades++;
      BuyTrades++;
   }
   return ok;
}

bool OpenSell(const string reason, double lot_multiplier = 1.0)
{
   if(!CanOpenNewTrade())
      return false;

   double entry = SymbolInfoDouble(_Symbol, SYMBOL_BID);
   double lots = NormalizeLots(BaseLotSize * lot_multiplier * BuildLotMultiplier());
   double sl = NormalizePrice(entry + ((Current_Mode == MODE_TRENDING ? Continuation_SL_Points : Counter_SL_Points) * _Point));
   double tp = NormalizePrice(entry - ((Current_Mode == MODE_TRENDING ? Continuation_TP_Points : Counter_TP_Points) * _Point));

   bool ok = Trade.Sell(lots, _Symbol, 0.0, sl, tp, reason);
   if(ok)
   {
      Last_Trade_Time = TimeCurrent();
      TodayTrades++;
      SellTrades++;
   }
   return ok;
}

#endif
