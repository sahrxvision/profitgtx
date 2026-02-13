#ifndef TRADING_SETUPS_MQH
#define TRADING_SETUPS_MQH

bool HasOpenPositionForSymbol()
{
   for(int i = PositionsTotal() - 1; i >= 0; --i)
   {
      ulong ticket = PositionGetTicket(i);
      if(ticket == 0 || !PositionSelectByTicket(ticket))
         continue;

      string symbol = PositionGetString(POSITION_SYMBOL);
      long magic = PositionGetInteger(POSITION_MAGIC);
      if(symbol == _Symbol && magic == MagicNumber)
         return true;
   }
   return false;
}

void ExecuteContinuationSetups()
{
   if(HasOpenPositionForSymbol()) return;
   if(Current_Mode != MODE_TRENDING) return;

   if(Active_Praise_Signals >= 2 && ma_fast_value > ma_slow_value)
      OpenBuy("Continuation Setup", War_Survivor_Lot_Multiplier);
}

void ExecuteRangeSetups()
{
   if(HasOpenPositionForSymbol()) return;
   if(Current_Mode != MODE_RANGING) return;

   if(Active_Warnings == 0 && Active_Praise_Signals >= 1)
      OpenBuy("Range Setup");
}

void ExecuteChopSetups()
{
   if(HasOpenPositionForSymbol()) return;
   if(Current_Mode != MODE_CHOP) return;

   if(Active_Warnings >= 2)
      OpenSell("Chop Mean Reversion");
}

#endif
