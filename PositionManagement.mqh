#ifndef POSITION_MANAGEMENT_MQH
#define POSITION_MANAGEMENT_MQH

void ManagePositions()
{
   double bid = SymbolInfoDouble(_Symbol, SYMBOL_BID);
   double ask = SymbolInfoDouble(_Symbol, SYMBOL_ASK);

   for(int i = PositionsTotal() - 1; i >= 0; --i)
   {
      ulong ticket = PositionGetTicket(i);
      if(ticket == 0 || !PositionSelectByTicket(ticket))
         continue;

      if(PositionGetInteger(POSITION_MAGIC) != MagicNumber) continue;
      if(PositionGetString(POSITION_SYMBOL) != _Symbol) continue;

      bool is_buy = (PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY);
      double entry = PositionGetDouble(POSITION_PRICE_OPEN);
      double sl = PositionGetDouble(POSITION_SL);
      double tp = PositionGetDouble(POSITION_TP);

      double profit_points = is_buy ? ((bid - entry) / _Point) : ((entry - ask) / _Point);

      // Break-even once trade has moved enough.
      if(profit_points >= BE_Trigger_Points)
      {
         double be_sl = entry;
         if((is_buy && (sl < be_sl || sl == 0.0)) || (!is_buy && (sl > be_sl || sl == 0.0)))
            Trade.PositionModify(ticket, NormalizePrice(be_sl), tp);
      }

      int trail = Trail_Counter_Points;
      if(Current_State == STATE_CONTINUATION)
         trail = Trail_Continuation_Points;
      if(Active_Praise_Signals >= 4)
         trail = Trail_Supreme_Points;

      if(profit_points > trail)
      {
         double new_sl = is_buy ? (bid - trail * _Point) : (ask + trail * _Point);
         new_sl = NormalizePrice(new_sl);

         if((is_buy && new_sl > sl) || (!is_buy && (sl == 0.0 || new_sl < sl)))
            Trade.PositionModify(ticket, new_sl, tp);
      }
   }
}

#endif
