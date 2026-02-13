#ifndef REENTRY_MQH
#define REENTRY_MQH

bool CanReEnter(const int direction)
{
   // Lightweight gate; can be expanded with your 10-combo logic.
   if(direction > 0)
      return (Active_Praise_Signals >= 1 && Active_Warnings <= 1);
   if(direction < 0)
      return (Active_Warnings >= 1 && Active_Praise_Signals <= 1);
   return false;
}

#endif
