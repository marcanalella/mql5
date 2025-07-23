//+------------------------------------------------------------------+
//|                                                         macd.mq5 |
//|                                  Copyright 2023, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"

#include <LikeAPro/macd.mqh>
#include <LikeAPro/dashboard.mqh> 
#include <LikeAPro/trade.mqh>

MACD macd;

input double risk_per_trade = 1; //RISK (x) PERCENT PER TRADE:
input double sl_pips = 20; // STOP LOSS IN PIPS:
input double risk_reward = 2; // RISK REWARD 1:x
input int fast_ema = 12; // FAST EMA:
input int slow_ema = 26; // SLOW EMA:
input int signal_period = 9; //SIGNAL PERIOD:
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   dashboard.init("MACD",8,35,20,20);
   dashboard.r_style();
   macd.macd(PERIOD_CURRENT,fast_ema,slow_ema,signal_period,PRICE_CLOSE);
   add_log("We are running our MACD EA");
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
   if(macd.strong_downtrend())
     {
      buy();
     }
   else
      if(macd.strong_uptrend())
        {
         sell();
        }



  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void buy()
  {
   ap_trade trade();
   if(trade.number_of_open_buys()>0)
      return;
 //  trade.close_all_trades();
   trade.order_type = ORDER_TYPE_BUY;
   trade.sl_pips = sl_pips;
   trade.tp_pips = sl_pips * risk_reward;
   trade.risk_percent =risk_per_trade;
  
   trade.open();

  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void sell()
  {
   ap_trade trade();
   if(trade.number_of_open_sells()>0)
      return;
 //  trade.close_all_trades();
   trade.order_type = ORDER_TYPE_SELL;
   trade.sl_pips = sl_pips;
   trade.tp_pips = sl_pips * risk_reward;
   trade.risk_percent =risk_per_trade;
   trade.open();

  }
//+------------------------------------------------------------------+
