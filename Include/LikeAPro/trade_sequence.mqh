//+------------------------------------------------------------------+
//|                                               trade_sequence.mqh |
//|                                  Copyright 2022, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#include <ap_trade.mqh>
#include <ap_stats.mqh>

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class Sequence
  {
public:
   void              create(int magic_number, string name,int order_type,int number_of_trades_to_open);
   void              open();
   void              check();

   Stat              stats;
   int order_type ;
   string            name;
   int               magic_number;
   datetime          start_time;
   int               number_of_trades_to_open;
   bool              is_active;


  };


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Sequence::create(
   int _magic_number,
   string _name,
   int _order_type,
   int _number_of_trades_to_open
)
  {

   magic_number = _magic_number;
   name = _name;
   order_type = _order_type;
   start_time = TimeCurrent();
   is_active = true;
   stats.initialise(magic_number,name);
   number_of_trades_to_open =_number_of_trades_to_open;
   open();

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Sequence::open()
  {
   string o_type;
   for(int i =0; i<number_of_trades_to_open; i++)
     {

      o_type = order_type;
      ap_trade t();
      t.magic_number = magic_number;
      t.order_type = o_type;
      t.tp_pips =100;
      t.sl_pips = 200;
      t.risk_percent = 3;
      t.open();

     }


  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Sequence::check()
  {
   stats.update();
   if(stats.trades.open.buys_and_sells.number==0)
      is_active = false;

  }


Sequence sequence[];
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void new_sqeuence(int magic_number, string name, int order_type,int number_of_trades_to_open)
  {
   ArrayResize(sequence,ArraySize(sequence)+1);
   Sequence s;
   s.create(magic_number,name,order_type,number_of_trades_to_open);
   sequence[ArraySize(sequence)-1] = s;
  }


//+------------------------------------------------------------------+
