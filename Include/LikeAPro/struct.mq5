//+------------------------------------------------------------------+
//|                                                       struct.mq5 |
//|                                  Copyright 2023, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"
#include <dashboard.mqh>
#include <variable_example.mqh>





struct trade_data
  {
   double            open_price;
   double            close_price;
   datetime          open_time;
   datetime          close_time;
   double            volume;
   int               order_type;
   string            asset;
   string            comment;
   double            tp_price;
   double            sl_price;
   double            pnl_cash;
   string            meta_data;

  };

struct price_data
  {
   string            asset;
   double            bid_price;
   double            ask_price;
   double            daily_high;
   double            daily_low;


  };

struct risk_settings
  {
   bool              daily_stop;
   double            daily_stop_limit;
   bool              max_dd;
   double            max_dd_percentage;
   bool              percentage_profit;
   double            close_at_percent_profit;


  };
trade_data t;
price_data p;

risk_settings r;

enum day_of_week
  {
   sunday=0,
   monday=1,
   tuesday=2,
   wednesday=3,
   thursday=4,
   friday=5,
   saturday=6

  };

input day_of_week day_to_chose = sunday;
int line_number = 1;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   r.max_dd = true;
   r.max_dd_percentage = 5;
   r.percentage_profit = true;
   r.close_at_percent_profit =2;
   dashboard.init("Struct");
   dashboard.style();
   
   v_line("anything",clrGreen,false);



   t.asset="EURUSD";
   t.close_price = 1.222;
   t.comment = "testing";
   t.meta_data = "asdfa;kdslfajsd;fkjasdfasdfasdf";

   p.asset = "EURUSD";
   p.ask_price = 1.111;
   p.bid_price = 1.0;
   p.daily_high = 1.222;
   p.daily_low = 0.9;

   add_log("Max Drawdown is set to: "+r.max_dd);
   if(r.max_dd==true)
      add_log("EA will close with a drawdown of "+r.max_dd_percentage+"%");

   MqlDateTime time;
   datetime time_current = TimeCurrent();
   datetime time_local = TimeLocal();
   TimeToStruct(time_current,time);
   add_log("Day of week is "+time.day_of_week);
   add_log("Current hour is "+time.hour);
   add_log("Current minute is "+time.min);

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
bool new_day = true;

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
   MqlDateTime time;
   datetime time_current = TimeCurrent();
   TimeToStruct(time_current,time);
   if(time.day_of_week == day_to_chose && time.hour==0 && new_day==true)
     {
     line_number=line_number+1;
      v_line("anything"+line_number,clrRed,true);
   //   open_buy(1,100,100,"pips","midnight express");
   //   open_sell(1,50,100,"pips","midnight express");
      
      new_day=false;
      
      

     }
   if(time.day_of_week!=day_to_chose &&time.hour==0 && time.min==0 && new_day==false)
     {

      new_day=true;
      add_log("New day set to "+new_day);
     }

  }
//+------------------------------------------------------------------+

void line(){
      line_number = line_number+1;
      ObjectCreate(0,"line"+line_number,OBJ_VLINE,0,TimeCurrent(),0);
      ObjectSetInteger(0,"line"+line_number,OBJPROP_STYLE,STYLE_SOLID);
      ObjectSetInteger(0,"line"+line_number,OBJPROP_COLOR,clrOrangeRed);
     

}
