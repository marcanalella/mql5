//+---------------------------------------------------------------------------------------------------------------------+
//|                                                                                                                     |
//+---------------------------------------------------------------------------------------------------------------------+

//████████╗██████╗  █████╗ ██████╗ ███████╗    ███████╗████████╗ █████╗ ████████╗██╗███████╗████████╗██╗ ██████╗███████╗
//╚══██╔══╝██╔══██╗██╔══██╗██╔══██╗██╔════╝    ██╔════╝╚══██╔══╝██╔══██╗╚══██╔══╝██║██╔════╝╚══██╔══╝██║██╔════╝██╔════╝
//   ██║   ██████╔╝███████║██║  ██║█████╗      ███████╗   ██║   ███████║   ██║   ██║███████╗   ██║   ██║██║     ███████╗
//   ██║   ██╔══██╗██╔══██║██║  ██║██╔══╝      ╚════██║   ██║   ██╔══██║   ██║   ██║╚════██║   ██║   ██║██║     ╚════██║
//   ██║   ██║  ██║██║  ██║██████╔╝███████╗    ███████║   ██║   ██║  ██║   ██║   ██║███████║   ██║   ██║╚██████╗███████║
//   ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═╝╚═════╝ ╚══════╝    ╚══════╝   ╚═╝   ╚═╝  ╚═╝   ╚═╝   ╚═╝╚══════╝   ╚═╝   ╚═╝ ╚═════╝╚══════╝
//+---------------------------------------------------------------------------------------------------------------------+
//|                                                                                                                     |
//+---------------------------------------------------------------------------------------------------------------------+
#include <LikeAPro/stash.mqh>

struct report
  {
   double            pnl_pips;
   double            pnl_cash;
   double            lots;
   int               number;

  };

struct trade_reports
  {
   report             buys;
   report             sells;
   report             buys_and_sells;

  };

struct trade_status
  {

   trade_reports       open;
   trade_reports       closed;
   trade_reports       open_and_closed;

   void              reset_open();
   void              reset_closed();
   void              reset_combined();
  };

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void trade_status::reset_open()
  {
   open.buys.lots=0;
   open.buys.number=0;
   open.buys.pnl_cash=0;
   open.buys.pnl_pips=0;

   open.sells.lots=0;
   open.sells.number=0;
   open.sells.pnl_cash=0;
   open.sells.pnl_pips=0;

   open.buys_and_sells.lots=0;
   open.buys_and_sells.number=0;
   open.buys_and_sells.pnl_cash=0;
   open.buys_and_sells.pnl_pips=0;
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void trade_status::reset_closed()
  {
   closed.buys.lots=0;
   closed.buys.number=0;
   closed.buys.pnl_cash=0;
   closed.buys.pnl_pips=0;

   closed.sells.lots=0;
   closed.sells.number=0;
   closed.sells.pnl_cash=0;
   closed.sells.pnl_pips=0;

   closed.buys_and_sells.lots=0;
   closed.buys_and_sells.number=0;
   closed.buys_and_sells.pnl_cash=0;
   closed.buys_and_sells.pnl_pips=0;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void trade_status::reset_combined()
  {
   open_and_closed.buys.lots=0;
   open_and_closed.buys.number=0;
   open_and_closed.buys.pnl_cash=0;
   open_and_closed.buys.pnl_pips=0;

   open_and_closed.sells.lots=0;
   open_and_closed.sells.number=0;
   open_and_closed.sells.pnl_cash=0;
   open_and_closed.sells.pnl_pips=0;

   open_and_closed.buys_and_sells.lots=0;
   open_and_closed.buys_and_sells.number=0;
   open_and_closed.buys_and_sells.pnl_cash=0;
   open_and_closed.buys_and_sells.pnl_pips=0;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class Stat
  {
public:
   void              initialise(int _magic_number, string _name);
   void              update_open();
   void              update_closed();
   void              update();
   void              update_combined_stats();
   bool              trades_are_open();
   bool              trades_have_closed();
   bool              buys_are_open();
   bool              sells_are_open();
   void              add_magic_number(int _magic_number);
   void              remove_magic_number(int _magic_number);
   bool              are_we_tracking_magic_number(int _magic_number);
   double            latest_open_price();
   double            highest_lotsize();

   void              close_all(int order_type);

   trade_status       trades;


   int               magic_number[];
   string            name;
   double            max_drawdown;
   datetime          last_close_time;


  };
//+------------------------------------------------------------------+
//|  RETURN TRUE IF ANY BUYS ARE OPEN                                |
//+------------------------------------------------------------------+
bool Stat::buys_are_open()
  {
   if(trades.open.buys.number > 0)
      return true;
   return false;
  }
//+------------------------------------------------------------------+
//| RETURN TRUE IF ANY SELLS ARE OPEN                                |
//+------------------------------------------------------------------+
bool Stat::sells_are_open()
  {
   if(trades.open.sells.number > 0)
      return true;
   return false;
  }
//+------------------------------------------------------------------+
//| RETURN TRUE IF ANY TRADES ARE OPEN                               |
//+------------------------------------------------------------------+
bool Stat::trades_are_open()
  {
   if(trades.open.buys_and_sells.number > 0)
      return true;
   return false;
  }
//+------------------------------------------------------------------+
//|  RETURN TRUE IF ANY TRADES HAVE CLOSED                           |
//+------------------------------------------------------------------+
bool Stat::trades_have_closed()
  {
   if(trades.closed.buys_and_sells.number > 0)
      return true;
   return false;
  }

//+------------------------------------------------------------------+
//|   UPDATE ALL THE STATS                                           |
//+------------------------------------------------------------------+
void Stat::update()
  {
   update_open();
   update_closed();
   update_combined_stats();
  }
//+------------------------------------------------------------------+
//|   INITIALISE THE STATISTICS ENGINE                               |
//+------------------------------------------------------------------+
void Stat::initialise(int _magic_number, string _name)
  {
   add_magic_number(_magic_number);
   name = _name;
   last_close_time = 0;


   trades.reset_combined();
   trades.reset_open();
   trades.reset_closed();
   update();
  }

//+------------------------------------------------------------------+
//|     ADD A MAGIC NUMBER TO THE STATISTICS CALCULATOR              |
//+------------------------------------------------------------------+
void Stat::add_magic_number(int _magic_number)
  {
   ArrayResize(magic_number,ArraySize(magic_number)+1);
   magic_number[ArraySize(magic_number)-1]=_magic_number;
  }

//+------------------------------------------------------------------+
//|     REMOVE A MAGIC NUMBER FROM THE STATISTICS CALCULATOR         |
//+------------------------------------------------------------------+
void Stat::remove_magic_number(int _magic_number)
  {
   int number_to_delete=-1;
   for(int i=0; i<ArraySize(magic_number); i++)
     {
      if(magic_number[i] == _magic_number)
        {
         number_to_delete=i;
         break;
        }
     }
   if(number_to_delete>-1)
      ArrayRemove(magic_number,number_to_delete);
  }
//+------------------------------------------------------------------+
//|     CHECK IF WE ARE TRACKING A MAGIC NUMBER IN THE STATISTICS    |
//+------------------------------------------------------------------+
bool Stat::are_we_tracking_magic_number(int _magic_number)
  {
   for(int i=0; i<ArraySize(magic_number); i++)
     {
      if(magic_number[i]==_magic_number)
         return true;

     }
   return false;
  }
//+------------------------------------------------------------------+
//|      UPDATE STATISTICS OF OPEN TRADES                            |
//+------------------------------------------------------------------+
void Stat::update_open()
  {
   trades.reset_open();
   for(int i = PositionsTotal(); i >= 0; i--)
     {
      if(PositionSelectByTicket(PositionGetTicket(i)))
        {
         if(are_we_tracking_magic_number((int)PositionGetInteger(POSITION_MAGIC)))
           {
            if(PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY)
              {
               trades.open.buys.lots += PositionGetDouble(POSITION_VOLUME);
               trades.open.buys.number += 1;
               trades.open.buys.pnl_cash += PositionGetDouble(POSITION_PROFIT)+PositionGetDouble(POSITION_SWAP);
               double open_price = PositionGetDouble(POSITION_PRICE_OPEN);
               double current_price = PositionGetDouble(POSITION_PRICE_CURRENT);
               double profit_in_pips = (current_price - open_price) / _grab_pip_value(PositionGetString(POSITION_SYMBOL));
               trades.open.buys.pnl_pips += profit_in_pips;
              }
            else
               if(PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_SELL)
                 {
                  trades.open.sells.lots += PositionGetDouble(POSITION_VOLUME);
                  trades.open.sells.number += 1;
                  trades.open.sells.pnl_cash += PositionGetDouble(POSITION_PROFIT)+PositionGetDouble(POSITION_SWAP);
                  double open_price = PositionGetDouble(POSITION_PRICE_OPEN);
                  double current_price = PositionGetDouble(POSITION_PRICE_CURRENT);
                  double profit_in_pips = (open_price - current_price) / _grab_pip_value(PositionGetString(POSITION_SYMBOL));
                  trades.open.sells.pnl_pips += profit_in_pips;
                 }
           }
        }
     }
   trades.open.buys_and_sells.lots = NormalizeDouble(trades.open.buys.lots + trades.open.sells.lots,2);
   trades.open.buys_and_sells.number = trades.open.buys.number + trades.open.sells.number;
   trades.open.buys_and_sells.pnl_cash = NormalizeDouble(trades.open.buys.pnl_cash + trades.open.sells.pnl_cash,2);
   trades.open.buys_and_sells.pnl_pips = NormalizeDouble(trades.open.buys.pnl_pips + trades.open.sells.pnl_pips,1);
  }

//+------------------------------------------------------------------+
//|       UPDATE STATISTICS FOR CLOSED TRADES                        |
//+------------------------------------------------------------------+
void Stat::update_closed()
  {
   trades.reset_closed();

   HistorySelect(0, TimeCurrent());
   for(int i = HistoryDealsTotal(); i >= 0; i--)
     {
      ulong ticket;
      ticket = HistoryDealGetTicket(i);
      if((ticket > 0))
        {
         long entry = HistoryDealGetInteger(ticket, DEAL_ENTRY);
         if(entry == DEAL_ENTRY_IN)
            continue;


         if(are_we_tracking_magic_number((int)HistoryDealGetInteger(ticket, DEAL_MAGIC)))
           {
            long deal = HistoryDealGetInteger(ticket, DEAL_TYPE);
            if(deal == ORDER_TYPE_BUY)
              {
               trades.closed.sells.lots += HistoryDealGetDouble(ticket, DEAL_VOLUME);
               trades.closed.sells.number += 1;
               trades.closed.sells.pnl_cash+=HistoryDealGetDouble(ticket,DEAL_PROFIT);
               double open_price = HistoryDealGetDouble(ticket, DEAL_PRICE);
               double closed_price = HistoryDealGetDouble(ticket, DEAL_PRICE);
               trades.closed.sells.pnl_pips += (open_price - closed_price) / _grab_pip_value();
              }
            if(deal == ORDER_TYPE_SELL)
              {
               trades.closed.buys.lots += HistoryDealGetDouble(ticket, DEAL_VOLUME);
               trades.closed.buys.number += 1;
               trades.closed.buys.pnl_cash += HistoryDealGetDouble(ticket, DEAL_PROFIT);
               double open_price = HistoryDealGetDouble(ticket, DEAL_PRICE);
               double closed_price = HistoryDealGetDouble(ticket, DEAL_PRICE);
               trades.closed.buys.pnl_pips += (closed_price - open_price) / _grab_pip_value();
              }
           }
        }
     }
   trades.closed.buys_and_sells.lots = NormalizeDouble(trades.closed.buys.lots + trades.closed.sells.lots,2);
   trades.closed.buys_and_sells.number = trades.closed.buys.number + trades.closed.sells.number;
   trades.closed.buys_and_sells.pnl_cash = NormalizeDouble(trades.closed.buys.pnl_cash + trades.closed.sells.pnl_cash,2);
   trades.closed.buys_and_sells.pnl_pips = NormalizeDouble(trades.closed.buys.pnl_pips + trades.closed.sells.pnl_pips,1);

   last_close_time = TimeCurrent();
  }
//+------------------------------------------------------------------+
//|       UPDATE THE COMBINED STATISTICS FOR OPEN AND CLOSED TRADES  |
//+------------------------------------------------------------------+
void Stat::update_combined_stats()
  {
   trades.open_and_closed.buys.lots = NormalizeDouble(trades.open.buys.lots + trades.closed.buys.lots,2);
   trades.open_and_closed.buys.number = trades.open.buys.number + trades.closed.buys.number;
   trades.open_and_closed.buys.pnl_cash = NormalizeDouble(trades.open.buys.pnl_cash + trades.closed.buys.pnl_cash,2);
   trades.open_and_closed.buys.pnl_pips = NormalizeDouble(trades.open.buys.pnl_pips + trades.closed.buys.pnl_pips,1);
   trades.open_and_closed.sells.lots = NormalizeDouble(trades.open.sells.lots + trades.closed.sells.lots,2);
   trades.open_and_closed.sells.number = trades.open.sells.number + trades.closed.sells.number;
   trades.open_and_closed.sells.pnl_cash = NormalizeDouble(trades.open.sells.pnl_cash + trades.closed.sells.pnl_cash,2);
   trades.open_and_closed.sells.pnl_pips = NormalizeDouble(trades.open.sells.pnl_pips + trades.closed.sells.pnl_pips,1);
   trades.open_and_closed.buys_and_sells.lots = NormalizeDouble(trades.open_and_closed.buys.lots + trades.open_and_closed.sells.lots,2);
   trades.open_and_closed.buys_and_sells.number = trades.open_and_closed.buys.number + trades.open_and_closed.sells.number;
   trades.open_and_closed.buys_and_sells.pnl_cash = NormalizeDouble(trades.open_and_closed.buys.pnl_cash + trades.open_and_closed.sells.pnl_cash,2);
   trades.open_and_closed.buys_and_sells.pnl_pips = NormalizeDouble(trades.open_and_closed.buys.pnl_pips + trades.open_and_closed.sells.pnl_pips,1);
   if(max_drawdown > trades.open_and_closed.buys_and_sells.pnl_cash)
      max_drawdown = trades.open_and_closed.buys_and_sells.pnl_cash;
  }

//+------------------------------------------------------------------+
double Stat::latest_open_price()
  {
   datetime latest_time = 0;
   double open_price=0;
   for(int i = PositionsTotal(); i >= 0; i--)
     {
      if(PositionSelectByTicket(PositionGetTicket(i)))
        {
         if(are_we_tracking_magic_number((int)PositionGetInteger(POSITION_MAGIC)))
           {
            if(PositionGetInteger(POSITION_TIME)>latest_time)
              {
               open_price = PositionGetDouble(POSITION_PRICE_OPEN);
               latest_time = (int)PositionGetInteger(POSITION_TIME);
              }
           }
        }
     }
   return open_price;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double Stat::highest_lotsize()
  {
   datetime latest_time = 0;
   double highest=0;
   for(int i = PositionsTotal(); i >= 0; i--)
     {
      if(PositionSelectByTicket(PositionGetTicket(i)))
        {
         if(are_we_tracking_magic_number((int)PositionGetInteger(POSITION_MAGIC)))
           {
            if(PositionGetDouble(POSITION_VOLUME)>highest)
              {
               highest = PositionGetDouble(POSITION_VOLUME);
              }
           }
        }
     }
   return highest;
  }

////+------------------------------------------------------------------+
////|         PIP VALUE                                                |
////+------------------------------------------------------------------+
//double _grab_pip_value(string symbol = "")
//  {
//   if(symbol == "")
//      symbol = Symbol();
//   int digits = (int)SymbolInfoInteger(symbol, SYMBOL_DIGITS);
//   if(digits == 2 || digits == 3)
//      return 0.01;
//   else
//      if(digits == 4 || digits == 5)
//         return 0.0001;
//   return 1;
//  }
////+------------------------------------------------------------------+

double get_commission()
  {
   HistorySelect(0, TimeCurrent());
   for(int i = HistoryDealsTotal(); i >= 0; i--)
     {
      ulong _ticket = HistoryDealGetTicket(i);
      if(HistoryDealGetString(_ticket,DEAL_SYMBOL) == Symbol())
        {
         return NormalizeDouble((HistoryDealGetDouble(_ticket,DEAL_COMMISSION) / HistoryDealGetDouble(_ticket,DEAL_VOLUME)),2);
        }
     }
     return 0;
  }
