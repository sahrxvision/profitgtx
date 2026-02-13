#ifndef AI_SIGNAL_CONFIRMATION_MQH
#define AI_SIGNAL_CONFIRMATION_MQH

bool AIApproveTrade(const bool is_buy, const string setup_name, double &size_multiplier)
{
   if(!Use_OpenAI || !AI_Validate_Trades || !AI_Initialized)
      return true;

   string ai_response = ValidateTradeWithAI(setup_name, is_buy);

   if(StringFind(ai_response, "YES") >= 0)
   {
      AI_Validation_Accepts++;
      return true;
   }

   if(StringFind(ai_response, "NO") >= 0)
   {
      AI_Validation_Rejects++;
      return false;
   }

   if(StringFind(ai_response, "MAYBE") >= 0)
   {
      size_multiplier *= 0.5;
      return true;
   }

   // Unknown response: fail-open with reduced size.
   size_multiplier *= 0.7;
   return true;
}

#endif
