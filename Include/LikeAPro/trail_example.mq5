#include <LikeAPro/trail.mqh> TrailingStop trail;


//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
   ap_trade t();
   t.order_type = ORDER_TYPE_SELL;
   t.open();
   int ticket = t.ticket;
   
 //  trail.trail_by_candle(ticket,10,PERIOD_D1);
 //  trail.trail_by_ma(ticket,5,PERIOD_D1);
 //  trail.trail_by_pips(ticket,20,20,20);
   
   
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
  
  trail.check();

  }
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
