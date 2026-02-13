#ifndef TRADE_EXECUTION_MQH
#define TRADE_EXECUTION_MQH

#include "AISignalConfirmation.mqh"

void UpdateLastTradeInfo(const string direction);

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
   if(News_Trade_Block_Active)
      return false;

   if(IsInCooldown())
      return false;

   if(CountOpenTradesForSymbol() >= Max_Open_Trades)
      return false;

   return true;
}

int GetSLPoints(const bool continuation)
{
   if(Symbol_Profile_Initialized)
   {
      if(continuation) return Symbol_SL_Points;
      return MathMax(20, Symbol_SL_Points / 2);
   }
   return continuation ? Continuation_SL_Points : Counter_SL_Points;
}

int GetTPPoints(const bool continuation)
{
   if(Symbol_Profile_Initialized)
   {
      if(continuation) return Symbol_TP_Points;
      return MathMax(80, (int)((double)Symbol_TP_Points * 0.85));
   }
   return continuation ? Continuation_TP_Points : Counter_TP_Points;
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

   if(Use_Signal_Coordinator)
      mult *= Coordinator_Lot_Multiplier;

   return mult;
}

bool OpenBuy(const string reason, double lot_multiplier = 1.0)
{
   if(!CanOpenNewTrade())
      return false;

   double ai_mult = 1.0;
   if(!AIApproveTrade(true, reason, ai_mult))
      return false;

   bool continuation = (Current_Mode == MODE_TRENDING && Current_State == STATE_CONTINUATION);
   double entry = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
   int sl_pts = GetSLPoints(continuation);
   int tp_pts = GetTPPoints(continuation);

   double lots = NormalizeLots(BaseLotSize * lot_multiplier * BuildLotMultiplier() * ai_mult);
   double sl = NormalizePrice(entry - (sl_pts * _Point));
   double tp = NormalizePrice(entry + (tp_pts * _Point));

   bool ok = Trade.Buy(lots, _Symbol, 0.0, sl, tp, reason);
   if(ok)
   {
      Last_Trade_Time = TimeCurrent();
      UpdateLastTradeInfo("bullish");
      TodayTrades++;
      BuyTrades++;
   }
   return ok;
}

bool OpenSell(const string reason, double lot_multiplier = 1.0)
{
   if(!CanOpenNewTrade())
      return false;

   double ai_mult = 1.0;
   if(!AIApproveTrade(false, reason, ai_mult))
      return false;

   bool continuation = (Current_Mode == MODE_TRENDING && Current_State == STATE_CONTINUATION);
   double entry = SymbolInfoDouble(_Symbol, SYMBOL_BID);
   int sl_pts = GetSLPoints(continuation);
   int tp_pts = GetTPPoints(continuation);

   double lots = NormalizeLots(BaseLotSize * lot_multiplier * BuildLotMultiplier() * ai_mult);
   double sl = NormalizePrice(entry + (sl_pts * _Point));
   double tp = NormalizePrice(entry - (tp_pts * _Point));

   bool ok = Trade.Sell(lots, _Symbol, 0.0, sl, tp, reason);
   if(ok)
   {
      Last_Trade_Time = TimeCurrent();
      UpdateLastTradeInfo("bearish");
      TodayTrades++;
      SellTrades++;
   }
   return ok;
}

#endif
