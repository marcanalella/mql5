//+------------------------------------------------------------------+
//|                                             simple_functions.mqh |
//|                                  Copyright 2021, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Ltd."
#property link      "https://www.mql5.com"

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double ema(int period=7)
  {
   double moving_average_values[];
   int ema_value = iMA(NULL,0,period,0,MODE_EMA,PRICE_OPEN);
   ArraySetAsSeries(moving_average_values,true);
   CopyBuffer(ema_value,0,0,3,moving_average_values);
   return NormalizeDouble(moving_average_values[0],_Digits);

  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double bid()
  {
   double current_bid = SymbolInfoDouble(_Symbol, SYMBOL_BID);
   return current_bid;
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double ask()
  {
   return SymbolInfoDouble(_Symbol, SYMBOL_ASK);

  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

double rsi(int period=7)
  {
   double rsi_values[];

   int rsi_value = iRSI(NULL,0,period,PRICE_OPEN);
   ArraySetAsSeries(rsi_values,true);
   CopyBuffer(rsi_value,0,0,3,rsi_values);
   return NormalizeDouble(rsi_values[0],2);

  }



//+------------------------------------------------------------------+
