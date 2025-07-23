//+------------------------------------------------------------------+
//|                                                       stats1.mq5 |
//|                                  Copyright 2023, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"
#include <LikeAPro/stats.mqh> Stat stat;
#include <LikeAPro/shapes.mqh>
#include <LikeAPro/trade.mqh>
#include  <LikeAPro/candle.mqh>
//+------------------------------------------------------------------+
//|           CLIENT SECTION                                         |
//+------------------------------------------------------------------+

int X_DISTANCE = 10;
int Y_DISTANCE = 20;
int WIDTH = 300;
int HEIGHT = 400;
color BACKGROUND_COLOUR=clrBlack;
int DASHBOARD_FONT_SIZE = 12;
color DASHBOARD_TEXT_COLOUR = clrLightGreen;
string DASHBOARD_TEXT_FONT = "Consolas Bold";
int TEXT_BUFFER_X = 10;
int TEXT_BUFFER_Y = 15;
int MAGIC_NUMBER = 123;
int OPEN_TRADE_AFTER_X_CANDLES = 15;
//+------------------------------------------------------------------+
//|            DO NOT GO FURTHER THAN HERE                           |
//+------------------------------------------------------------------+
int candle_counter = 0;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   ObjectsDeleteAll(0);
   start_trade_engine(MAGIC_NUMBER);
   populate_dashboard();
   
   stat.initialise(MAGIC_NUMBER," ");
   update_dashboard();
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
   stat.update();
   update_dashboard();
   if(new_candle(PERIOD_CURRENT))
     {
      candle_counter++;
      if(candle_counter>=OPEN_TRADE_AFTER_X_CANDLES)
        {
         candle_counter = 0;
         random_trade();
        }
     }
  }
//+------------------------------------------------------------------+
void populate_dashboard()
  {
   int x_distance = X_DISTANCE+TEXT_BUFFER_X;
   int y_distance = Y_DISTANCE+TEXT_BUFFER_Y;

   rectangle("stats",X_DISTANCE,Y_DISTANCE,WIDTH,HEIGHT,CORNER_LEFT_UPPER,BORDER_FLAT,STYLE_SOLID,1,BACKGROUND_COLOUR);

   label("open_trade_number",x_distance,y_distance,CORNER_LEFT_UPPER," ",DASHBOARD_FONT_SIZE,DASHBOARD_TEXT_COLOUR,DASHBOARD_TEXT_FONT);
   label("open_trade_lots",x_distance,y_distance+=TEXT_BUFFER_Y,CORNER_LEFT_UPPER," ",DASHBOARD_FONT_SIZE,DASHBOARD_TEXT_COLOUR,DASHBOARD_TEXT_FONT);
   label("open_trade_cash",x_distance,y_distance+=TEXT_BUFFER_Y,CORNER_LEFT_UPPER," ",DASHBOARD_FONT_SIZE,DASHBOARD_TEXT_COLOUR,DASHBOARD_TEXT_FONT);

   y_distance = y_distance +TEXT_BUFFER_Y;
   y_distance = y_distance +TEXT_BUFFER_Y;

   label("open_buy_number",x_distance,y_distance,CORNER_LEFT_UPPER," ",DASHBOARD_FONT_SIZE,DASHBOARD_TEXT_COLOUR,DASHBOARD_TEXT_FONT);
   label("open_buy_lots",x_distance,y_distance+=TEXT_BUFFER_Y,CORNER_LEFT_UPPER," ",DASHBOARD_FONT_SIZE,DASHBOARD_TEXT_COLOUR,DASHBOARD_TEXT_FONT);
   label("open_buy_cash",x_distance,y_distance+=TEXT_BUFFER_Y,CORNER_LEFT_UPPER," ",DASHBOARD_FONT_SIZE,DASHBOARD_TEXT_COLOUR,DASHBOARD_TEXT_FONT);


   y_distance = y_distance +TEXT_BUFFER_Y;
   y_distance = y_distance +TEXT_BUFFER_Y;

   label("open_sell_number",x_distance,y_distance,CORNER_LEFT_UPPER," ",DASHBOARD_FONT_SIZE,DASHBOARD_TEXT_COLOUR,DASHBOARD_TEXT_FONT);
   label("open_sell_lots",x_distance,y_distance+=TEXT_BUFFER_Y,CORNER_LEFT_UPPER," ",DASHBOARD_FONT_SIZE,DASHBOARD_TEXT_COLOUR,DASHBOARD_TEXT_FONT);
   label("open_sell_cash",x_distance,y_distance+=TEXT_BUFFER_Y,CORNER_LEFT_UPPER," ",DASHBOARD_FONT_SIZE,DASHBOARD_TEXT_COLOUR,DASHBOARD_TEXT_FONT);


   y_distance = y_distance +TEXT_BUFFER_Y;
   y_distance = y_distance +TEXT_BUFFER_Y;

   label("closed_trade_number",x_distance,y_distance,CORNER_LEFT_UPPER," ",DASHBOARD_FONT_SIZE,DASHBOARD_TEXT_COLOUR,DASHBOARD_TEXT_FONT);
   label("closed_trade_lots",x_distance,y_distance+=TEXT_BUFFER_Y,CORNER_LEFT_UPPER," ",DASHBOARD_FONT_SIZE,DASHBOARD_TEXT_COLOUR,DASHBOARD_TEXT_FONT);
   label("closed_trade_cash",x_distance,y_distance+=TEXT_BUFFER_Y,CORNER_LEFT_UPPER," ",DASHBOARD_FONT_SIZE,DASHBOARD_TEXT_COLOUR,DASHBOARD_TEXT_FONT);

   y_distance = y_distance +TEXT_BUFFER_Y;
   y_distance = y_distance +TEXT_BUFFER_Y;

   label("closed_buy_number",x_distance,y_distance,CORNER_LEFT_UPPER," ",DASHBOARD_FONT_SIZE,DASHBOARD_TEXT_COLOUR,DASHBOARD_TEXT_FONT);
   label("closed_buy_lots",x_distance,y_distance+=TEXT_BUFFER_Y,CORNER_LEFT_UPPER," ",DASHBOARD_FONT_SIZE,DASHBOARD_TEXT_COLOUR,DASHBOARD_TEXT_FONT);
   label("closed_buy_cash",x_distance,y_distance+=TEXT_BUFFER_Y,CORNER_LEFT_UPPER," ",DASHBOARD_FONT_SIZE,DASHBOARD_TEXT_COLOUR,DASHBOARD_TEXT_FONT);


   y_distance = y_distance +TEXT_BUFFER_Y;
   y_distance = y_distance +TEXT_BUFFER_Y;

   label("closed_sell_number",x_distance,y_distance,CORNER_LEFT_UPPER," ",DASHBOARD_FONT_SIZE,DASHBOARD_TEXT_COLOUR,DASHBOARD_TEXT_FONT);
   label("closed_sell_lots",x_distance,y_distance+=TEXT_BUFFER_Y,CORNER_LEFT_UPPER," ",DASHBOARD_FONT_SIZE,DASHBOARD_TEXT_COLOUR,DASHBOARD_TEXT_FONT);
   label("closed_sell_cash",x_distance,y_distance+=TEXT_BUFFER_Y,CORNER_LEFT_UPPER," ",DASHBOARD_FONT_SIZE,DASHBOARD_TEXT_COLOUR,DASHBOARD_TEXT_FONT);

  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void update_dashboard()
  {
   ObjectSetString(0,"open_trade_number",OBJPROP_TEXT,"Open Trades: "+IntegerToString(stat.trades.open.buys_and_sells.number));
   ObjectSetString(0,"open_trade_lots",OBJPROP_TEXT,"Open Trade Lots: "+DoubleToString(stat.trades.open.buys_and_sells.lots,2));
   ObjectSetString(0,"open_trade_cash",OBJPROP_TEXT,"Open Trade Cash: "+DoubleToString(stat.trades.open.buys_and_sells.pnl_cash,2));

   ObjectSetString(0,"open_buy_number",OBJPROP_TEXT,"Open Buys: "+IntegerToString(stat.trades.open.buys.number));
   ObjectSetString(0,"open_buy_lots",OBJPROP_TEXT,"Open Buy Lots: "+DoubleToString(stat.trades.open.buys.lots,2));
   ObjectSetString(0,"open_buy_cash",OBJPROP_TEXT,"Open Buy Cash: "+DoubleToString(stat.trades.open.buys.pnl_cash,2));


   ObjectSetString(0,"open_sell_number",OBJPROP_TEXT,"Open Sells: "+IntegerToString(stat.trades.open.sells.number));
   ObjectSetString(0,"open_sell_lots",OBJPROP_TEXT,"Open Sell Lots: "+DoubleToString(stat.trades.open.sells.lots,2));
   ObjectSetString(0,"open_sell_cash",OBJPROP_TEXT,"Open Sell Cash: "+DoubleToString(stat.trades.open.sells.pnl_cash,2));

   ObjectSetString(0,"closed_trade_number",OBJPROP_TEXT,"Closed Trades: "+IntegerToString(stat.trades.closed.buys_and_sells.number));
   ObjectSetString(0,"closed_trade_lots",OBJPROP_TEXT,"Closed Trade Lots: "+DoubleToString(stat.trades.closed.buys_and_sells.lots,2));
   ObjectSetString(0,"closed_trade_cash",OBJPROP_TEXT,"Closed Trade Cash: "+DoubleToString(stat.trades.closed.buys_and_sells.pnl_cash,2));

   ObjectSetString(0,"closed_buy_number",OBJPROP_TEXT,"Closed Buys: "+IntegerToString(stat.trades.closed.buys.number,2));
   ObjectSetString(0,"closed_buy_lots",OBJPROP_TEXT,"Closed Buy Lots: "+DoubleToString(stat.trades.closed.buys.lots,2));
   ObjectSetString(0,"closed_buy_cash",OBJPROP_TEXT,"Closed Buy Cash: "+DoubleToString(stat.trades.closed.buys.pnl_cash,2));


   ObjectSetString(0,"closed_sell_number",OBJPROP_TEXT,"Closed Sells: "+IntegerToString(stat.trades.closed.sells.number));
   ObjectSetString(0,"closed_sell_lots",OBJPROP_TEXT,"Closed Sell Lots: "+DoubleToString(stat.trades.closed.sells.lots,2));
   ObjectSetString(0,"closed_sell_cash",OBJPROP_TEXT,"Close Sell Cash: "+DoubleToString(stat.trades.closed.sells.pnl_cash,2));




  }
//+------------------------------------------------------------------+
ENUM_ORDER_TYPE o_type;

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void random_trade()
  {
   if(o_type == ORDER_TYPE_BUY)
      o_type = ORDER_TYPE_SELL;
   else
      o_type = ORDER_TYPE_BUY;

   ap_trade t();
   t.order_type = o_type;
   t.tp_pips = random_int(10,50);
   t.sl_pips = random_int(10,40);
   t.magic_number = MAGIC_NUMBER;
   t.lotsize = random_int(1,10)/10;
   t.open();


  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int random_int(const int minimum, const int maximum)
  {
   double f = (MathRand() / 32983.0);
   return minimum +(int)(f*(maximum-minimum));
  }
//+------------------------------------------------------------------+
