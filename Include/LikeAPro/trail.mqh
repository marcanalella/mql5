//+---------------------------------------------------------------------------------------------------------+
//|                                                                                                         |
//+---------------------------------------------------------------------------------------------------------+

//████████╗██████╗  █████╗ ██╗██╗     ██╗███╗   ██╗ ██████╗     ███████╗████████╗ ██████╗ ██████╗
//╚══██╔══╝██╔══██╗██╔══██╗██║██║     ██║████╗  ██║██╔════╝     ██╔════╝╚══██╔══╝██╔═══██╗██╔══██╗
//   ██║   ██████╔╝███████║██║██║     ██║██╔██╗ ██║██║  ███╗    ███████╗   ██║   ██║   ██║██████╔╝
//   ██║   ██╔══██╗██╔══██║██║██║     ██║██║╚██╗██║██║   ██║    ╚════██║   ██║   ██║   ██║██╔═══╝
//   ██║   ██║  ██║██║  ██║██║███████╗██║██║ ╚████║╚██████╔╝    ███████║   ██║   ╚██████╔╝██║
//   ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝╚══════╝╚═╝╚═╝  ╚═══╝ ╚═════╝     ╚══════╝   ╚═╝    ╚═════╝ ╚═╝
//+---------------------------------------------------------------------------------------------------------+
//|                                                                                                         |
//+---------------------------------------------------------------------------------------------------------+


#include <LikeAPro/trade.mqh>
#include  <LikeAPro/shapes.mqh>

enum trailing_stop_type
  {
   TRAILING_STOP_NORMAL=0,
   TRAILING_STOP_MA=1,
   TRAILING_STOP_CANDLE=2
  };


struct ts
  {
   int               type;
   int               ticket;


   double            start_at;
   double            trail_at;
   double            step;
   int               period;
   int               trail_candles_behind;
   ENUM_MA_METHOD    ma_type;
   ENUM_APPLIED_PRICE applied_price;
   ENUM_TIMEFRAMES   timeframe;

  };



//+------------------------------------------------------------------+
//|             TRAILING STOP CLASS                                  |
//+------------------------------------------------------------------+
class TrailingStop
  {
public:
   void              trail_by_pips(int ticket, double start_at,double trail_at, double step);
   void              trail_by_ma(int ticket, int period,ENUM_TIMEFRAMES _timeframe=PERIOD_CURRENT,ENUM_MA_METHOD _ma_type=MODE_EMA,ENUM_APPLIED_PRICE _applied_price=PRICE_CLOSE);
   void              trail_by_candle(int ticket, int candles_behind, ENUM_TIMEFRAMES timeframe = PERIOD_CURRENT);
   void              remove(int ticket);
   void              check();
private:
   void              check_trail_candle(int _array_reference);
   void              check_trail_pips(int _array_reference);
   void              check_trail_ma(int _array_reference);
   ts                t[];
  };
//+------------------------------------------------------------------+
//|  ADD TRAILING STOP BY PIPS TO THE TRAILING STOP ARRAY            |
//+------------------------------------------------------------------+
void TrailingStop::trail_by_pips(
   int ticket,
   double start_at,
   double trail_at,
   double step
)
  {
   ts new_trail;

   new_trail.type = TRAILING_STOP_NORMAL; //Set trail type

   new_trail.step = step;
   new_trail.start_at = start_at;
   new_trail.trail_at = trail_at;
   new_trail.ticket = ticket;


   //Add to array:
   ArrayResize(t,ArraySize(t)+1);
   t[ArraySize(t)-1]=new_trail;

   check();

  }
//+------------------------------------------------------------------+
//|  ADD TRAILING STOP BY MOVING AVERAGE TO THE TRAILING STOP ARRAY  |
//+------------------------------------------------------------------+
void TrailingStop::trail_by_ma(
   int ticket,
   int period,
   ENUM_TIMEFRAMES _timeframe=PERIOD_CURRENT,
   ENUM_MA_METHOD _ma_type=MODE_EMA,
   ENUM_APPLIED_PRICE _applied_price=PRICE_CLOSE
)
  {
   ts new_trail;

   new_trail.type = TRAILING_STOP_MA; //Set trail type

   new_trail.ticket = ticket;
   new_trail.applied_price = _applied_price;
   new_trail.ma_type = _ma_type;
   new_trail.period = period;
   new_trail.timeframe = _timeframe;

   // Add to array
   ArrayResize(t,ArraySize(t)+1);
   t[ArraySize(t)-1]=new_trail;

  }

//+------------------------------------------------------------------+
//|  ADD TRAILING STOP BY CANDLE TO THE TRAILING STOP ARRAY          |
//+------------------------------------------------------------------+
void TrailingStop::trail_by_candle(int ticket,int candles_behind,ENUM_TIMEFRAMES timeframe=0)
  {
   ts new_trail;

   new_trail.type = TRAILING_STOP_CANDLE; //Set trail type

   new_trail.timeframe =timeframe;
   new_trail.ticket = ticket;
   new_trail.trail_candles_behind = candles_behind;

// Add to array
   ArrayResize(t,ArraySize(t)+1);
   t[ArraySize(t)-1]=new_trail;
  }
//+------------------------------------------------------------------+
//|  REMOVE TRAILING STOP FROM THE TRAILING STOP ARRAY               |
//+------------------------------------------------------------------+
void TrailingStop::remove(int ticket)
  {
   int number_to_delete=0;
   for(int i=0; i<ArraySize(t); i++)
     {
      if(t[i].ticket==ticket)
        {
         number_to_delete=i;
         break;
        }
     }
   ArrayRemove(t,number_to_delete,1);
  }
//+------------------------------------------------------------------+
//|  CHECK TRAILING STOP BY MA                                       |
//+------------------------------------------------------------------+
void TrailingStop::check_trail_ma(int _array_reference)
  {
   int i = _array_reference;
   ap_trade open_trade();
   if(open_trade.get_open_trade_by_ticket(t[i].ticket))
     {
      int ma_handle = iMA(_Symbol,t[i].timeframe,t[i].period,0,t[i].ma_type,t[i].applied_price);
      double ma_array[];
      ArraySetAsSeries(ma_array, true);
      CopyBuffer(ma_handle, 0, 0, 3, ma_array);

      double ma_value =  NormalizeDouble(ma_array[1],_Digits);
      if(ma_value==0)
         return;

      if(open_trade.order_type == ORDER_TYPE_BUY)
         if(open_trade.close_price<ma_value)
            open_trade.close();

      if(open_trade.order_type == ORDER_TYPE_SELL)
         if(open_trade.close_price>ma_value)
            open_trade.close();
     }
  }
//+------------------------------------------------------------------+
//|  CHECK TRAILING STOP BY CANDLE                                   |
//+------------------------------------------------------------------+
void TrailingStop::check_trail_candle(int _array_reference)
  {
   int i = _array_reference;
   ap_trade open_trade();
   if(open_trade.get_open_trade_by_ticket(t[i].ticket))
     {
      if(open_trade.order_type == ORDER_TYPE_BUY)
        {
         int lowest_candle = iLowest(Symbol(), t[i].timeframe, MODE_LOW, t[i].trail_candles_behind);
         double low_price = iLow(_Symbol,t[i].timeframe,lowest_candle);
         if(low_price>open_trade.sl_price)
            open_trade.modify_sl_by_price(low_price);

        }
      if(open_trade.order_type == ORDER_TYPE_SELL)
        {
         int highest_candle = iHighest(Symbol(), t[i].timeframe, MODE_HIGH, t[i].trail_candles_behind);
         double high_price = iHigh(_Symbol,t[i].timeframe,highest_candle);
         if(high_price<open_trade.sl_price)
            open_trade.modify_sl_by_price(high_price);
        }
     }
  }
//+------------------------------------------------------------------+
//|  CHECK TRAILING STOP BY PIPS                                     |
//+------------------------------------------------------------------+
void TrailingStop::check_trail_pips(int array_reference)
  {
   int i = array_reference;
   ap_trade open_trade();
   if(open_trade.get_open_trade_by_ticket(t[i].ticket))
      if(open_trade.pnl_pips >= t[i].start_at)
        {
         if(open_trade.order_type==ORDER_TYPE_BUY)
           {
            if(t[i].start_at>0 && open_trade.pnl_pips>t[i].start_at)
              {
               double new_sl_price = open_trade.close_price - (t[i].trail_at*open_trade.pip_value);
               open_trade.modify_sl_by_price(new_sl_price);
               t[i].start_at = 0;
              }

            double gap = (open_trade.close_price - open_trade.sl_price) / open_trade.pip_value;
            if(t[i].start_at==0 && gap > t[i].step+t[i].trail_at)
              {
               open_trade.modify_sl_by_price(open_trade.close_price - (t[i].trail_at*open_trade.pip_value));
              }
           }
         if(open_trade.order_type==ORDER_TYPE_SELL)
           {
            if(t[i].start_at>0 && open_trade.pnl_pips>t[i].start_at)
              {
               double new_sl_price = open_trade.close_price + (t[i].trail_at*open_trade.pip_value);
               open_trade.modify_sl_by_price(new_sl_price);
               t[i].start_at = 0;
              }

            double gap = (open_trade.sl_price - open_trade.close_price) / open_trade.pip_value;
            if(t[i].start_at==0 && gap > t[i].step+t[i].trail_at)
              {
               open_trade.modify_sl_by_price(open_trade.close_price+ (t[i].trail_at*open_trade.pip_value));
              }
           }
        }
  }
//+------------------------------------------------------------------+
//|  CHECK TRAILING STOP ARRAY FOR ACTIVE TRAILING STOPS             |
//+------------------------------------------------------------------+
void TrailingStop::check()
  {
   int tickets_to_delete_array[];
   for(int i=0; i<ArraySize(t); i++)
     {
      ap_trade open_trade();
      if(!open_trade.get_open_trade_by_ticket(t[i].ticket)) //If we cannot get by ticket assume trade has closed
        {
         ArrayResize(tickets_to_delete_array,ArraySize(tickets_to_delete_array)+1); //Add ticket to be removed from the trailing stop array
         tickets_to_delete_array[ArraySize(tickets_to_delete_array)-1] = t[i].ticket;
         continue;
        }

      if(t[i].type == TRAILING_STOP_NORMAL)
         check_trail_pips(i);
      if(t[i].type == TRAILING_STOP_MA)
         check_trail_ma(i);
      if(t[i].type == TRAILING_STOP_CANDLE)
         check_trail_candle(i);
     }

   // Remove all closed trades from the trailing stop array
   for(int i=ArraySize(tickets_to_delete_array)-1; i >= 0; i--)
     {
      remove(tickets_to_delete_array[i]);
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
