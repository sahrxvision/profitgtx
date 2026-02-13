#ifndef TRADE_EXECUTION_MQH
#define TRADE_EXECUTION_MQH

bool OpenBuy(const string reason, double lot_multiplier = 1.0)
{
   double lots = NormalizeLots(BaseLotSize * lot_multiplier);
   bool ok = Trade.Buy(lots, _Symbol, 0.0, 0.0, 0.0, reason);
   if(ok)
   {
      TodayTrades++;
      BuyTrades++;
   }
   return ok;
}

bool OpenSell(const string reason, double lot_multiplier = 1.0)
{
   double lots = NormalizeLots(BaseLotSize * lot_multiplier);
   bool ok = Trade.Sell(lots, _Symbol, 0.0, 0.0, 0.0, reason);
   if(ok)
   {
      TodayTrades++;
      SellTrades++;
   }
   return ok;
}

#endif
