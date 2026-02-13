#ifndef MARKET_STATE_MQH
#define MARKET_STATE_MQH

void UpdateModeAndState()
{
   double gap = MathAbs(ma_fast_value - ma_slow_value) / _Point;

   if(gap > 250.0)
      Current_Mode = MODE_TRENDING;
   else if(gap > 80.0)
      Current_Mode = MODE_RANGING;
   else
      Current_Mode = MODE_CHOP;

   if(Active_Praise_Signals > Active_Warnings)
      Current_State = STATE_CONTINUATION;
   else if(Active_Warnings >= 2)
      Current_State = STATE_REVERSAL;
   else
      Current_State = STATE_PULLBACK;
}

#endif
