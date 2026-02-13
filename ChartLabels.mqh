#ifndef CHART_LABELS_MQH
#define CHART_LABELS_MQH

string STATUS_LABEL = "VZ_STATUS";

void UpdateLabels()
{
   string text = "Mode: " + ModeToString(Current_Mode) +
                 " | State: " + StateToString(Current_State) +
                 " | Warn: " + IntegerToString(Active_Warnings) +
                 " | Praise: " + IntegerToString(Active_Praise_Signals);

   if(!ObjectFind(0, STATUS_LABEL))
      ObjectCreate(0, STATUS_LABEL, OBJ_LABEL, 0, 0, 0);

   ObjectSetInteger(0, STATUS_LABEL, OBJPROP_CORNER, CORNER_LEFT_UPPER);
   ObjectSetInteger(0, STATUS_LABEL, OBJPROP_XDISTANCE, 10);
   ObjectSetInteger(0, STATUS_LABEL, OBJPROP_YDISTANCE, 15);
   ObjectSetInteger(0, STATUS_LABEL, OBJPROP_COLOR, clrWhite);
   ObjectSetString(0, STATUS_LABEL, OBJPROP_TEXT, text);
}

void CleanupLabels()
{
   ObjectDelete(0, STATUS_LABEL);
}

#endif
