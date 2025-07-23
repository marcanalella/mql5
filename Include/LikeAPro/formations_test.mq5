//+------------------------------------------------------------------+
//|                                                      ProjectName |
//|                                      Copyright 2020, CompanyName |
//|                                       http://www.companyname.net |
//+------------------------------------------------------------------+
#include <LikeAPro/formations.mqh>
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+

int hammer_body_size_percent = 10;
int hammer_lower_wick_percent = 55;
int hammer_upper_wick_percent = 17;


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OnInit()
  {
   ObjectsDeleteAll(0);
   for(int i=0; i<1000; i++)
     {
      check_for_bearish_hammer(i);
      check_for_bullish_hammer(i);
     }
   return(INIT_SUCCEEDED);
  }

//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void check_for_bullish_hammer(int candle_index)
  {

   Candle c(candle_index,true);
   if(c.meta.body_size_percent<hammer_body_size_percent)
      if(c.meta.lower_wick_percent>=hammer_lower_wick_percent)
         if(c.meta.upper_wick_percent<hammer_upper_wick_percent)
           {
            highlight_candle(c.index,true,true);
           }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void check_for_bearish_hammer(int candle_index)
  {
   Candle c(candle_index,true);
   if(c.meta.body_size_percent<hammer_body_size_percent)
      if(c.meta.upper_wick_percent>=hammer_lower_wick_percent)
         if(c.meta.lower_wick_percent<=hammer_upper_wick_percent)
           {
            highlight_candle(c.index,false,true);

           }

  }
//+------------------------------------------------------------------+
