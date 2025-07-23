//+------------------------------------------------------------------+
//|                                                   new_candle.mq5 |
//|                                  Copyright 2023, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"

#include <LikeAPro/shapes.mqh>


datetime previous_time = 0;
int line_count = 0;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {

   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {

  }

//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+

void OnTick()
  {
   if(new_candle()==true)
     {
      v_line(line_count,clrRed);
      line_count+=1;
     }
  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+



//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool new_candle()
  {
   datetime current_time = iTime(Symbol(),PERIOD_CURRENT,0);
   if(current_time!=previous_time)
     {
      previous_time = current_time;
      return true;
     }
   return false;
  }
//+------------------------------------------------------------------+
