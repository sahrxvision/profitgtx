#ifndef AI_LABELS_MQH
#define AI_LABELS_MQH

void UpdateAILabel()
{
   if(!IsAIEnabled())
   {
      ObjectDelete(0, "AILabel");
      ObjectDelete(0, "AIStatsLabel");
      ObjectDelete(0, "AIAnalysisBox");
      return;
   }

   if(ObjectFind(0, "AILabel") < 0)
      ObjectCreate(0, "AILabel", OBJ_LABEL, 0, 0, 0);

   ObjectSetInteger(0, "AILabel", OBJPROP_CORNER, CORNER_RIGHT_UPPER);
   ObjectSetInteger(0, "AILabel", OBJPROP_XDISTANCE, 10);
   ObjectSetInteger(0, "AILabel", OBJPROP_YDISTANCE, 20);
   ObjectSetString(0, "AILabel", OBJPROP_TEXT, AI_Initialized ? "AI: ACTIVE" : "AI: INACTIVE");
   ObjectSetInteger(0, "AILabel", OBJPROP_COLOR, AI_Initialized ? clrLime : clrGray);
   ObjectSetInteger(0, "AILabel", OBJPROP_FONTSIZE, 10);

   if(AI_Validate_Trades && AI_Initialized)
   {
      if(ObjectFind(0, "AIStatsLabel") < 0)
         ObjectCreate(0, "AIStatsLabel", OBJ_LABEL, 0, 0, 0);

      int total_validations = AI_Validation_Accepts + AI_Validation_Rejects;
      double accept_rate = (total_validations > 0) ? ((double)AI_Validation_Accepts / total_validations) * 100.0 : 0.0;

      string stats_text = "AI Validation: +" + IntegerToString(AI_Validation_Accepts) +
                          " -" + IntegerToString(AI_Validation_Rejects) +
                          " (" + DoubleToString(accept_rate, 1) + "%)";

      ObjectSetInteger(0, "AIStatsLabel", OBJPROP_CORNER, CORNER_RIGHT_UPPER);
      ObjectSetInteger(0, "AIStatsLabel", OBJPROP_XDISTANCE, 10);
      ObjectSetInteger(0, "AIStatsLabel", OBJPROP_YDISTANCE, 40);
      ObjectSetString(0, "AIStatsLabel", OBJPROP_TEXT, stats_text);
      ObjectSetInteger(0, "AIStatsLabel", OBJPROP_COLOR, clrYellow);
      ObjectSetInteger(0, "AIStatsLabel", OBJPROP_FONTSIZE, 9);
   }

   if(StringLen(Last_AI_Analysis) > 0)
   {
      if(ObjectFind(0, "AIAnalysisBox") < 0)
         ObjectCreate(0, "AIAnalysisBox", OBJ_LABEL, 0, 0, 0);

      string display_text = Last_AI_Analysis;
      if(StringLen(display_text) > 300)
         display_text = StringSubstr(display_text, 0, 297) + "...";

      ObjectSetInteger(0, "AIAnalysisBox", OBJPROP_CORNER, CORNER_RIGHT_LOWER);
      ObjectSetInteger(0, "AIAnalysisBox", OBJPROP_XDISTANCE, 10);
      ObjectSetInteger(0, "AIAnalysisBox", OBJPROP_YDISTANCE, 100);
      ObjectSetString(0, "AIAnalysisBox", OBJPROP_TEXT, "AI: " + display_text);
      ObjectSetInteger(0, "AIAnalysisBox", OBJPROP_COLOR, clrAqua);
      ObjectSetInteger(0, "AIAnalysisBox", OBJPROP_FONTSIZE, 8);
   }
}

void CleanupAILabels()
{
   ObjectDelete(0, "AILabel");
   ObjectDelete(0, "AIStatsLabel");
   ObjectDelete(0, "AIAnalysisBox");
}

void DisplayAIValidation(const string setup, const bool approved, const string reasoning)
{
   Last_AI_Analysis = "AI Validation " + setup + ": " + (approved ? "APPROVED" : "REJECTED") + " | " + reasoning;
   UpdateAILabel();
}

#endif
