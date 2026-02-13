#ifndef AI_SIGNAL_CONFIRMATION_MQH
#define AI_SIGNAL_CONFIRMATION_MQH

bool AIApproveTrade(const bool is_buy, const string setup_name, double &size_multiplier)
{
   // Mandatory live AI gate: fail closed.
   if(!AI_Initialized)
      return false;

   string ai_response = ValidateTradeWithAI(setup_name, is_buy);

   if(StringFind(StringUpper(ai_response), "YES") >= 0)
   {
      AI_Validation_Accepts++;
      return true;
   }

   if(StringFind(StringUpper(ai_response), "NO") >= 0)
   {
      AI_Validation_Rejects++;
      return false;
   }

   if(StringFind(StringUpper(ai_response), "MAYBE") >= 0)
   {
      size_multiplier *= 0.5;
      return true;
   }

   // Unknown = reject to keep AI mandatory.
   AI_Validation_Rejects++;
   return false;
}

#endif
