#property copyright "Copyright 2023, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"

#include <LikeAPro/shapes.mqh>
#include <LikeAPro/dashboard.mqh>
#include <LikeAPro/stash.mqh>

double pip;

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

struct candlestick_metadata
  {
   bool              bullish;
   bool              bearish;
   double            full_size_pips;
   double            body_size_pips;
   double            upper_wick_pips;
   double            lower_wick_pips;

   double            body_size_percent;
   double            upper_wick_percent;
   double            lower_wick_percent;


  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class Candle
  {
public:
   double            open;
   double            close;
   double            high;
   double            low;
   datetime          time;
   int               index;

                     Candle(int _index,bool load_full = false);

   candlestick_metadata meta;
  };

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Candle::Candle(int _index, bool load_full = false)
  {
   index = _index;
   open = NormalizeDouble(iOpen(Symbol(),PERIOD_CURRENT,index),_Digits);
   close = NormalizeDouble(iClose(Symbol(),PERIOD_CURRENT,index),_Digits);
   high= NormalizeDouble(iHigh(Symbol(),PERIOD_CURRENT,index),_Digits);
   low = NormalizeDouble(iLow(Symbol(),PERIOD_CURRENT,index),_Digits);


   time = iTime(Symbol(),PERIOD_CURRENT,index);

   if(load_full==true)
     {
      meta.upper_wick_pips = 0;
      meta.lower_wick_pips= 0;
      meta.upper_wick_percent =0;
      meta.lower_wick_percent = 0;
      meta.body_size_percent =0;
      meta.body_size_pips=0;
      meta.bullish=false;
      meta.bearish = false;

      if(open>close)
        {
         meta.bearish = true;
         meta.body_size_pips = (open-close)/ pip;
         meta.upper_wick_pips = (high-open)/pip;
         meta.lower_wick_pips = (close-low)/pip;
        }
      if(open<close)
        {
         meta.bullish = true;
         meta.body_size_pips = (close-open)/pip;
         meta.upper_wick_pips = (high-close) / pip;
         meta.lower_wick_pips = (open-low)/ pip;
        }
      meta.full_size_pips = (high-low) / pip;
      meta.body_size_percent = (meta.body_size_pips / meta.full_size_pips)*100;
      meta.upper_wick_percent = (meta.upper_wick_pips/meta.full_size_pips)*100;
      meta.lower_wick_percent = (meta.lower_wick_pips/meta.full_size_pips)*100;
     }

  }
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {

   pip = _grab_pip_value();

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
int line_count = 0;
void OnTick()
  {
   if(new_candle())
     {
      Candle c1(1,true);
      if(c1.meta.body_size_percent<20 && c1.meta.lower_wick_percent>50 && c1.meta.upper_wick_percent>1)
        {
         v_line(line_count,clrGreen);
         line_count++;
        }
      if(c1.meta.body_size_percent<20 && c1.meta.upper_wick_percent>50 && c1.meta.lower_wick_percent>1)
        {
         v_line(line_count,clrRed);
         line_count++;
        }
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
