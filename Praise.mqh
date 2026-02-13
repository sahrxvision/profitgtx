#ifndef PRAISE_MQH
#define PRAISE_MQH

void DetectPraiseSignals()
{
   Active_Praise_Signals = 0;

   if(ma_fast_value > ma_slow_value)
      Active_Praise_Signals++;

   double c0 = iClose(_Symbol, PERIOD_CURRENT, 0);
   double c1 = iClose(_Symbol, PERIOD_CURRENT, 1);
   if(c0 > c1)
      Active_Praise_Signals++;
}

#endif
