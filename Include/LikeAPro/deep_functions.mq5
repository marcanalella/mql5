//+------------------------------------------------------------------+
//|                                               deep_functions.mq5 |
//|                                  Copyright 2023, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"

#include <dashboard.mqh>

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   dashboard.init("Deep functions");
   dashboard.style(clrBeige,clrOrangeRed,clrTeal,clrBlue);
   add_log("The bot has started!");
//---
   return(INIT_SUCCEEDED);
  }

//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
   check_our_ea_logic();
  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void check_our_ea_logic()
  {

   add_log("Checking Logic for our EA");

   bool news = check_news();
   bool ema = check_ema();
   bool bullish = check_for_bullish_signal();
   bool check_weird_rsi_rule = true;
   bool toupee_colour = check_donald_trump_toupee();
   if(
   news
   && ema 
   && bullish 
   && check_weird_rsi_rule 
   && toupee_colour

   )
     {
      open_buy();
     }


  }
  
bool check_donald_trump_toupee(){
return false;


}


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool check_ema()
  {

   double ema_value_50 = get_ema_value(50);
   double ema_value_100 = get_ema_value(100);
   double ask_price = get_ask_price();

   bool return_value = false;

   if(ema_value_50 < ask_price)
     {
      return_value =  false;
     }

   if(ema_value_100 > ema_value_50)
     {
      return_value= true;
     }

   if(ema_value_50 < ema_value_100 || ask_price > ema_value_100)
     {
      return_value= false;
     }

   else
      if(ema_value_100 == ask_price)
        {
         return_value = true;
        }

   if(return_value = false)
     {
      return_value = check_ema_exception();
     }

   return return_value;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool check_ema_exception()
  {

   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double get_ask_price()
  {
   return 1.112;

  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double get_ema_value(int period)
  {

   return 1.225;

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool check_news()
  {
   string news_feed = "ForexFactory";
   bool ignore_red = true;
   bool ignore_orange = false;
   bool ignore_yellow = true;

   string news_blob_of_text = get_news_blob(news_feed);
   string filtered_news = filter_the_news(news_blob_of_text);
   bool news_condition = decide_on_news(filtered_news);

//  return decide_on_news(filter_the_news(get_news_blob(news_feed)));
   return news_condition;


  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool decide_on_news(string filtered_news)
  {
   return true;

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string filter_the_news(string news_blob)
  {
   return "Good results";

  }
//+------------------------------------------------------------------+
//|                FETCH THE NEWS FROM A TRUSTED THIRD PARTY         |
//+------------------------------------------------------------------+
string get_news_blob(string news_to_fetch)
  {
   return "<Forex news blah! blah blah>> orange";

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool check_for_bullish_signal()
  {
   bool is_candle_bullish = is_candle_bullish();
   return true;
  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void open_buy()
  {
   double lotsize = calculate_lotsize();



  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double calculate_lotsize()
  {

   return 0.01;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int is_candle_bullish()
  {
   return 1;

  }
//+------------------------------------------------------------------+
