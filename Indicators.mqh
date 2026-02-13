#ifndef INDICATORS_MQH
#define INDICATORS_MQH

int h_ma_fast = INVALID_HANDLE;
int h_ma_slow = INVALID_HANDLE;

double ma_fast_value = 0.0;
double ma_slow_value = 0.0;

bool InitializeIndicators()
{
   h_ma_fast = iMA(_Symbol, PERIOD_CURRENT, 50, 0, MODE_EMA, PRICE_CLOSE);
   h_ma_slow = iMA(_Symbol, PERIOD_CURRENT, 200, 0, MODE_EMA, PRICE_CLOSE);

   if(h_ma_fast == INVALID_HANDLE || h_ma_slow == INVALID_HANDLE)
      return false;

   return true;
}

void UpdateIndicators()
{
   double b1[1];
   if(h_ma_fast != INVALID_HANDLE && CopyBuffer(h_ma_fast, 0, 0, 1, b1) > 0)
      ma_fast_value = b1[0];

   if(h_ma_slow != INVALID_HANDLE && CopyBuffer(h_ma_slow, 0, 0, 1, b1) > 0)
      ma_slow_value = b1[0];
}

void ReleaseIndicators()
{
   if(h_ma_fast != INVALID_HANDLE) IndicatorRelease(h_ma_fast);
   if(h_ma_slow != INVALID_HANDLE) IndicatorRelease(h_ma_slow);
   h_ma_fast = INVALID_HANDLE;
   h_ma_slow = INVALID_HANDLE;
}

#endif
