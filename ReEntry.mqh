#ifndef REENTRY_MQH
#define REENTRY_MQH

bool CanReEnter(const int direction)
{
   if(direction > 0)
      return (Active_Praise_Signals >= Active_Warnings);
   if(direction < 0)
      return (Active_Warnings >= Active_Praise_Signals);
   return false;
}

#endif
