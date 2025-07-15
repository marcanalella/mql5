//+------------------------------------------------------------------+
//|                                           learning_variables.mqh |
//|                                  Copyright 2023, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#include <Trade/trade.mqh>
CTrade trade;

int open_buy(

   double lotsize,
   double tp,
   double sl,
   string price_or_pips,
   string comment
)
  {
// Prepare a trade
   trade.LogLevel(LOG_LEVEL_ERRORS);
   trade.SetDeviationInPoints(30);
   trade.SetMarginMode();
   trade.SetTypeFilling(ORDER_FILLING_FOK);
   trade.SetTypeFillingBySymbol(Symbol());

// Prepare the SL and TP
   double sl_price=0;
   double tp_price=0;
   double sl_pips=0;
   double tp_pips=0;

   double open_price = ask();


   double pip_value = grab_pip_value();

   if(price_or_pips=="price")
     {
      sl_price=sl;
      tp_price=tp;
      sl_pips=(open_price-sl_price)/pip_value;
      tp_pips =(tp_price -open_price)/pip_value;
      if(tp==0)
         tp_pips=0;
      if(sl==0)
         sl_pips=0;

     }
   if(price_or_pips=="pips")
     {
      sl_price = open_price - (sl*pip_value);
      tp_price = open_price + (tp*pip_value);
      sl_pips = sl;
      tp_pips = tp;
      if(tp_pips==0)
         tp=0;
      if(sl_pips==0)
         sl=0;
     }

   if(!trade.Buy(NormalizeDouble(lotsize,2),Symbol(),open_price,sl_price,tp_price,comment))
     {
      printf(IntegerToString(GetLastError()));

     }

   return 1;


  }




//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int open_sell(
   double lotsize,
   double tp,
   double sl,
   string price_or_pips,
   string comment
)
  {
// Prepare a trade
   trade.LogLevel(LOG_LEVEL_ERRORS);
   trade.SetDeviationInPoints(30);
   trade.SetMarginMode();
   trade.SetTypeFilling(ORDER_FILLING_FOK);
   trade.SetTypeFillingBySymbol(Symbol());

// Prepare the SL and TP
   double sl_price=0;
   double tp_price=0;
   double sl_pips=0;
   double tp_pips=0;
   string message = "Opening Sell ";

   double open_price = bid();


   double pip_value = grab_pip_value();

   if(price_or_pips=="price")
     {
      sl_price=sl;
      tp_price=tp;
      sl_pips=(sl_price-open_price)/pip_value;
      tp_pips =(open_price -tp_price)/pip_value;
      if(sl==0)
         sl_pips= 0;
      if(tp==0)
         tp_pips= 0;

     }
   if(price_or_pips=="pips")
     {
      sl_price = open_price + (sl*pip_value);
      tp_price = open_price - (tp*pip_value);
      sl_pips = sl;
      tp_pips = tp;
      if(sl==0)
         sl_price = 0;
      if(tp==0)
         tp_price = 0;
     }

   if(!trade.Sell(NormalizeDouble(lotsize,2),Symbol(),open_price,sl_price,tp_price,comment))
     {
      printf(IntegerToString(GetLastError()));

     }

   
   return 1;
   
   
   




  }
  
  
//+------------------------------------------------------------------+
//|                       GET ASK PRICE                              |
//+------------------------------------------------------------------+
double ask(string symbol="")
  {
   if(symbol=="")
      symbol = Symbol();
   return NormalizeDouble(SymbolInfoDouble(symbol,SYMBOL_ASK),(int)SymbolInfoInteger(symbol,SYMBOL_DIGITS));
  }

//+------------------------------------------------------------------+
//|                       GET BID PRICE                              |
//+------------------------------------------------------------------+
double bid(string symbol="")
  {
   if(symbol=="")
      symbol = Symbol();
   return NormalizeDouble(SymbolInfoDouble(symbol,SYMBOL_BID),(int)SymbolInfoInteger(symbol,SYMBOL_DIGITS));
  }



//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double grab_pip_value(string symbol="")
  {
   if(symbol=="")
      symbol=Symbol();

   int digits = (int)SymbolInfoInteger(symbol,SYMBOL_DIGITS);
   if(digits==2 || digits==3)
      return 0.01;
   else
      if(digits==4 || digits==5)
         return 0.0001;
   return 1;

  }
