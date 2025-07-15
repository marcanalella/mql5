//+------------------------------------------------------------------+
//|                                                    array_102.mq5 |
//|                                  Copyright 2023, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"
#include <ap_ma.mqh> MovingAverage ma;
#include <dashboard.mqh>

input string emas = "10,20,30,40,50,75,81,99,110,35,200,300,225";
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   int new_ma_periods[];
   ma.init(MODE_EMA,PRICE_CLOSE,PERIOD_CURRENT);
   dashboard.init("Array 2.0");
   dashboard.style();
   ma_string_split(emas,new_ma_periods);
   for(int i=0; i<ArraySize(new_ma_periods); i++)
      ma.add_ma(new_ma_periods[i]);

// example 2
 //  for(int i=10; i<1000; i+=15)
 //  ma.add_ma(i);

//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---

  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
if(ma_new_candle_check()){

if(ma.is_bullish())v_line(TimeCurrent(),clrGreen);
if(ma.is_bearish())v_line(TimeCurrent(),clrRed);

}
  }
//+------------------------------------------------------------------+
