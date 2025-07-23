#property copyright "Copyright 2023, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"

#include <LikeAPro/shapes.mqh>


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

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnTick()
  {
//if(new_candle(PERIOD_H4))
//  {
//   v_line(line_count,clrRed);
//   line_count+=1;
//  }

   if(new_candle(PERIOD_D1))
     {
      v_line("New Day! "+line_count,clrDarkBlue);
      line_count+=1;
     }

   if(new_candle(PERIOD_W1))
     {
      v_line("New Week! "+line_count,clrBlack);
      line_count+=1;
     }
  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+



//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+


datetime previous_time_current = 0;

datetime previous_time_m1 = 0;
datetime previous_time_m2 = 0;
datetime previous_time_m3 = 0;
datetime previous_time_m4 = 0;
datetime previous_time_m5 = 0;
datetime previous_time_m6 = 0;
datetime previous_time_m10 = 0;
datetime previous_time_m12 = 0;
datetime previous_time_m20 = 0;
datetime previous_time_m15 = 0;
datetime previous_time_m30 = 0;

datetime previous_time_h1 = 0;
datetime previous_time_h2 = 0;
datetime previous_time_h3 = 0;
datetime previous_time_h4 = 0;
datetime previous_time_h6 = 0;
datetime previous_time_h8 = 0;
datetime previous_time_h12 = 0;

datetime previous_time_d1= 0;
datetime previous_time_w1= 0;
datetime previous_time_mn1 = 0;

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool new_candle(ENUM_TIMEFRAMES timeframe = PERIOD_CURRENT)
  {
   datetime current_time = iTime(Symbol(),timeframe,0);

   if(timeframe == PERIOD_CURRENT)
      if(current_time!=previous_time_current)
        {
         previous_time_current = current_time;
         return true;
        }
   if(timeframe == PERIOD_M1)
      if(current_time!=previous_time_m1)
        {
         previous_time_m1= current_time;
         return true;
        }
   if(timeframe == PERIOD_M2)
      if(current_time!=previous_time_m2)
        {
         previous_time_m2= current_time;
         return true;
        }
   if(timeframe == PERIOD_M3)
      if(current_time!=previous_time_m3)
        {
         previous_time_m3= current_time;
         return true;
        }
   if(timeframe == PERIOD_M4)
      if(current_time!=previous_time_m4)
        {
         previous_time_m4= current_time;
         return true;
        }
   if(timeframe == PERIOD_M5)
      if(current_time!=previous_time_m5)
        {
         previous_time_m5= current_time;
         return true;
        }
   if(timeframe == PERIOD_M6)
      if(current_time!=previous_time_m6)
        {
         previous_time_m6= current_time;
         return true;
        }
   if(timeframe == PERIOD_M10)
      if(current_time!=previous_time_m10)
        {
         previous_time_m10= current_time;
         return true;
        }
   if(timeframe == PERIOD_M12)
      if(current_time!=previous_time_m12)
        {
         previous_time_m12= current_time;
         return true;
        }
   if(timeframe == PERIOD_M15)
      if(current_time!=previous_time_m15)
        {
         previous_time_m15 = current_time;
         return true;
        }
   if(timeframe == PERIOD_M20)
      if(current_time!=previous_time_m20)
        {
         previous_time_m20= current_time;
         return true;
        }
   if(timeframe == PERIOD_M30)
      if(current_time!=previous_time_m30)
        {
         previous_time_m30 = current_time;
         return true;
        }
   if(timeframe==PERIOD_H1)
      if(current_time!=previous_time_h1)
        {
         previous_time_h1 = current_time;
         return true;
        }
   if(timeframe==PERIOD_H2)
      if(current_time!=previous_time_h2)
        {
         previous_time_h2 = current_time;
         return true;
        }
   if(timeframe==PERIOD_H3)
      if(current_time!=previous_time_h3)
        {
         previous_time_h3 = current_time;
         return true;
        }
   if(timeframe==PERIOD_H4)
      if(current_time!=previous_time_h4)
        {
         previous_time_h4 = current_time;
         return true;
        }
   if(timeframe==PERIOD_H6)
      if(current_time!=previous_time_h6)
        {
         previous_time_h6 = current_time;
         return true;
        }
   if(timeframe==PERIOD_H8)
      if(current_time!=previous_time_h8)
        {
         previous_time_h8 = current_time;
         return true;
        }
   if(timeframe==PERIOD_H12)
      if(current_time!=previous_time_h12)
        {
         previous_time_h12 = current_time;
         return true;
        }
   if(timeframe==PERIOD_D1)
      if(current_time!=previous_time_d1)
        {
         previous_time_d1 = current_time;
         return true;
        }
   if(timeframe==PERIOD_W1)
      if(current_time!=previous_time_w1)
        {
         previous_time_w1 = current_time;
         return true;
        }
   if(timeframe==PERIOD_MN1)
      if(current_time!=previous_time_mn1)
        {
         previous_time_mn1 = current_time;
         return true;
        }
   return false;
  }
//+------------------------------------------------------------------+
