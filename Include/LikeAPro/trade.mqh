//+---------------------------------------------------------------------------------------------------------+
//|                                                                                                         |
//+---------------------------------------------------------------------------------------------------------+
//████████╗██████╗  █████╗ ██████╗ ██╗███╗   ██╗ ██████╗     ███████╗███╗   ██╗ ██████╗ ██╗███╗   ██╗███████╗
//╚══██╔══╝██╔══██╗██╔══██╗██╔══██╗██║████╗  ██║██╔════╝     ██╔════╝████╗  ██║██╔════╝ ██║████╗  ██║██╔════╝
//   ██║   ██████╔╝███████║██║  ██║██║██╔██╗ ██║██║  ███╗    █████╗  ██╔██╗ ██║██║  ███╗██║██╔██╗ ██║█████╗
//   ██║   ██╔══██╗██╔══██║██║  ██║██║██║╚██╗██║██║   ██║    ██╔══╝  ██║╚██╗██║██║   ██║██║██║╚██╗██║██╔══╝
//   ██║   ██║  ██║██║  ██║██████╔╝██║██║ ╚████║╚██████╔╝    ███████╗██║ ╚████║╚██████╔╝██║██║ ╚████║███████╗
//   ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═╝╚═════╝ ╚═╝╚═╝  ╚═══╝ ╚═════╝     ╚══════╝╚═╝  ╚═══╝ ╚═════╝ ╚═╝╚═╝  ╚═══╝╚══════╝
//+---------------------------------------------------------------------------------------------------------+
//|                                                                                                         |
//+---------------------------------------------------------------------------------------------------------+
#include <Trade/Trade.mqh>;
#include <LikeAPro/stash.mqh>
CTrade _trade;


//+------------------------------------------------------------------+
//| ORDER TYPES                                                      |
//+------------------------------------------------------------------+
enum ap_order_type {
   BUY=0,
   SELL=1,
   BUY_LIMIT=2,
   SELL_LIMIT=3,
   BUY_STOP=4,
   SELL_STOP=5,
   BUY_AT=6,
   SELL_AT=7
};

//+------------------------------------------------------------------+
//|  INITIALIZE TRADE                                                |
//+------------------------------------------------------------------+
void start_trade_engine(int magic_number) {
   _trade.LogLevel(LOG_LEVEL_ERRORS);
   _trade.SetDeviationInPoints(30);
   _trade.SetMarginMode();
   _trade.SetTypeFilling(ORDER_FILLING_FOK);
   _trade.SetTypeFillingBySymbol(Symbol());
   _trade.SetExpertMagicNumber((int)magic_number);
}
//+------------------------------------------------------------------+
//|  TRADE CLASS                                                     |
//+------------------------------------------------------------------+
class ap_trade {

public:
   void              set_magic_number(int number);
   bool              get_open_trade_by_ticket(int ticket);
   bool              get_open_trade_by_position(int position);
   bool              get_open_order_by_ticket(int order_ticket);
   bool              get_open_pending_order_by_position(int position);
   bool              open();
   bool              close();
   bool              position_update();
   bool              order_update();
   bool              check_trade();
   bool              modify_tp_by_pips(double new_tp_pips);
   bool              modify_tp_by_price(double new_tp_price);
   bool              modify_sl_by_pips(double new_sl_pips);
   bool              modify_sl_by_price(double new_sl_price);
   bool              get_last_closed_trade();
   bool              get_last_open_trade();
   bool              get_by_position();
   bool              partial_close(double lots_to_close);
   bool              partial_close_by_percent(double percent_to_close);

   int               close_all_winning_trades(int _magic_number);
   int               close_all_trades(int _magic_number);
   int               close_all_losing_trades(int _magic_number);
   int               close_all_buys(int _magic_number);
   int               close_all_sells(int _magic_number);

   bool              cancel_pending_order(int _ticket);
   int               cancel_all_orders(int _magic_number);
   int               cancel_all_buy_limit_orders(int _magic_number);
   int               cancel_all_sell_limit_orders(int _magic_number);
   int               cancel_all_buy_stop_orders(int _magic_number);
   int               cancel_all_sell_stop_orders(int _magic_number);

   double            closed_profit(int _magic_number);
   double            open_profit(int _magic_number);
   double            open_lots(int _magic_number);

   int               number_of_open_sells(int _magic_number);
   int               number_of_open_buys(int _magic_number);
   int               number_of_open_trades(int _magic_number);

   int               number_of_pending_sell_limits(int _magic_number);
   int               number_of_pending_buy_limits(int _magic_number);
   int               number_of_pending_sell_stops(int _magic_number);
   int               number_of_pending_buy_stops(int _magic_number);
   int               number_of_pending_orders(int _magic_number);


   ap_trade();

   int               order_type;

   double            tp_pips;
   double            sl_pips;
   double            tp_price;
   double            sl_price;
   double            open_price;
   double            close_price;
   string            asset;
   string            symbol;

   double            lotsize;
   double            volume;
   double            risk_cash;
   double            risk_percent;

   double            cash_at_risk;
   double            pnl_cash;
   double            pnl_pips;
   datetime          open_time;
   datetime          close_time;
   int               ticket;
   int               magic_number;
   double            pip_value;
   string            trade_comment;
   double            commission;
   double            swap;


};


//+------------------------------------------------------------------+
//|  CONSTRUCTOR SETS EVERYTHING TO 0                                |
//+------------------------------------------------------------------+
void ap_trade::ap_trade(void) {

   order_type=0;
   tp_pips=0;
   sl_pips=0;
   tp_price=0;
   sl_price=0;
   open_price=0;
   close_price=0;
   asset=Symbol();
   symbol=Symbol();

   lotsize=0;
   volume=0;
   risk_cash=0;
   risk_percent=0;

   cash_at_risk=0;
   pnl_cash=0;
   pnl_pips=0;
   open_time=0;
   close_time=0;
   ticket=0;
   magic_number=0;
   pip_value=0;
   trade_comment="mariocana EA";
   commission=0;
   swap=0;

}
//+------------------------------------------------------------------+
//|  SET MAGIC NUMBER                                                |
//+------------------------------------------------------------------+
void ap_trade::set_magic_number(int number) {
   _trade.SetExpertMagicNumber(number);
}
//+------------------------------------------------------------------+
//|  RETURN THE LAST CLOSED TRADE                                    |
//+------------------------------------------------------------------+
bool ap_trade::get_last_closed_trade() {
//  HistoryDealSelect(HistoryDealsTotal()-1);

   HistorySelect(0, TimeCurrent());
   int total = HistoryDealsTotal();
   ulong deal_ticket = HistoryDealGetTicket(total-1);

   lotsize = HistoryDealGetDouble(deal_ticket,DEAL_VOLUME);
   asset = HistoryDealGetString(deal_ticket,DEAL_SYMBOL);
   pnl_cash = HistoryDealGetDouble(deal_ticket,DEAL_PROFIT);
   close_price = HistoryDealGetDouble(deal_ticket,DEAL_PRICE);
   commission = HistoryDealGetDouble(deal_ticket,DEAL_COMMISSION) * 2;
   magic_number = (int)HistoryDealGetInteger(deal_ticket,DEAL_MAGIC);
   tp_price = HistoryDealGetDouble(deal_ticket,DEAL_TP);
   sl_price = HistoryDealGetDouble(deal_ticket,DEAL_SL);
   swap = HistoryDealGetDouble(deal_ticket,DEAL_SWAP);
   close_time = (int)HistoryDealGetInteger(deal_ticket,DEAL_TIME);

   return true;
}

//+------------------------------------------------------------------+
//|  UPDATE VALUES OF A POSITION                                     |
//+------------------------------------------------------------------+
bool ap_trade::position_update() {
   ticket = (int)PositionGetInteger(POSITION_TICKET);
   open_price = PositionGetDouble(POSITION_PRICE_OPEN);
   order_type = (int)PositionGetInteger(POSITION_TYPE);
   volume = PositionGetDouble(POSITION_VOLUME);
   open_time = (int)PositionGetInteger(POSITION_TIME);
   close_time = 0;
   sl_price = PositionGetDouble(POSITION_SL);
   tp_price= PositionGetDouble(POSITION_TP);
   close_price = PositionGetDouble(POSITION_PRICE_CURRENT);
   magic_number = (int)PositionGetInteger(POSITION_MAGIC);
   pnl_cash = PositionGetDouble(POSITION_PROFIT);
   lotsize = PositionGetDouble(POSITION_VOLUME);
   trade_comment = PositionGetString(POSITION_COMMENT);
   asset = PositionGetString(POSITION_SYMBOL);

   sl_pips = 0;
   tp_pips = 0;

   pip_value = get_pip_value();

   if(PositionGetInteger(POSITION_TYPE)==ORDER_TYPE_BUY) {
      pnl_pips = NormalizeDouble((close_price - open_price)/pip_value,1);
      if(sl_price != 0)
         sl_pips = NormalizeDouble((open_price - sl_price)/pip_value,1);
      if(tp_price != 0)
         tp_pips = NormalizeDouble((tp_price - open_price)/pip_value,1);
   }

   if(PositionGetInteger(POSITION_TYPE)==ORDER_TYPE_SELL) {
      pnl_pips = NormalizeDouble((open_price - close_price)/pip_value,1);
      if(sl_price != 0)
         sl_pips = NormalizeDouble((sl_price - open_price)/pip_value,1);
      if(tp_price !=0)
         tp_pips = NormalizeDouble((open_price - tp_price)/pip_value,1);
   }
   return true;
}

//+------------------------------------------------------------------+
//|  UPDATE VALUES OF AN ORDER                                       |
//+------------------------------------------------------------------+
bool ap_trade::order_update() {
   ticket = (int)OrderGetInteger(ORDER_TICKET);
   open_price = OrderGetDouble(ORDER_PRICE_OPEN);
   order_type = (int)OrderGetInteger(ORDER_TYPE);
   volume = OrderGetDouble(ORDER_VOLUME_INITIAL);
   open_time = (int)OrderGetInteger(ORDER_TIME_SETUP);
   sl_price = OrderGetDouble(ORDER_SL);
   tp_price= OrderGetDouble(ORDER_TP);
   magic_number = (int)OrderGetInteger(ORDER_MAGIC);
   lotsize = OrderGetDouble(ORDER_VOLUME_INITIAL);
   trade_comment = OrderGetString(ORDER_COMMENT);
   asset = OrderGetString(ORDER_SYMBOL);

   sl_pips = 0;
   tp_pips = 0;

   pip_value = get_pip_value();

   if(OrderGetInteger(ORDER_TYPE)==ORDER_TYPE_BUY_LIMIT || OrderGetInteger(ORDER_TYPE)==ORDER_TYPE_BUY_STOP) {
      if(sl_price != 0)
         sl_pips = NormalizeDouble((open_price - sl_price)/pip_value,1);
      if(tp_price != 0)
         tp_pips = NormalizeDouble((tp_price - open_price)/pip_value,1);
   }


   if(OrderGetInteger(ORDER_TYPE)==ORDER_TYPE_SELL_LIMIT || OrderGetInteger(ORDER_TYPE)==ORDER_TYPE_SELL_STOP) {
      if(sl_price != 0)
         sl_pips = NormalizeDouble((sl_price - open_price)/pip_value,1);
      if(tp_price !=0)
         tp_pips = NormalizeDouble((open_price - tp_price)/pip_value,1);
   }

   return true;
}

//+------------------------------------------------------------------+
//|  GET OPEN TRADE BY TICKET                                        |
//+------------------------------------------------------------------+
bool ap_trade::get_open_trade_by_ticket(int _trade_ticket) {
   if(!PositionSelectByTicket(_trade_ticket))
      return false;
   position_update();
   return true;
}

//+------------------------------------------------------------------+
//|  GET OPEN TRADE BY POSITION                                      |
//+------------------------------------------------------------------+
bool ap_trade::get_open_trade_by_position(int position) {
   if(!PositionSelectByTicket(PositionGetTicket(position)))
      return false;
   position_update();
   return true;
}

//+------------------------------------------------------------------+
//|  GET OPEN TRADE BY TICKET                                        |
//+------------------------------------------------------------------+
bool ap_trade::get_open_order_by_ticket(int order_ticket) {
   if(!OrderSelect(order_ticket))
      return false;
   order_update();
   return true;
}


//+------------------------------------------------------------------+
//|  GET PENDING ORDER BY POSITION                                   |
//+------------------------------------------------------------------+
bool ap_trade::get_open_pending_order_by_position(int position) {
   if(!OrderGetTicket(position)) {
      return false;
   }
   order_update();
   return true;
}


//+------------------------------------------------------------------+
//|  CHECK TRADE                                                     |
//+------------------------------------------------------------------+
bool ap_trade::check_trade() {
   if(!ticket || pip_value==0)
      return false;
   return true;
}


//+------------------------------------------------------------------+
//|  MODIFY A TRADE TP BY PIPS                                       |
//+------------------------------------------------------------------+
bool ap_trade::modify_tp_by_pips(double new_tp_pips) {
   double new_tp_price=0;
   if(order_type == ORDER_TYPE_BUY)
      new_tp_price = NormalizeDouble(open_price+(new_tp_pips*pip_value),_Digits);
   if(order_type == ORDER_TYPE_SELL)
      new_tp_price = NormalizeDouble(open_price-(new_tp_pips*pip_value),_Digits);

   if(_trade.PositionModify(ticket,sl_price,new_tp_price)) {
      tp_price=new_tp_price;
      tp_pips=new_tp_pips;
      return true;
   }
   return false;
};


//+------------------------------------------------------------------+
//|  MODIFY A TRADE TP TO A PRICE                                    |
//+------------------------------------------------------------------+
bool ap_trade::modify_tp_by_price(double new_tp_price) {

   if(tp_price==new_tp_price)
      return true;

   if(_trade.PositionModify(ticket,sl_price,new_tp_price)) {
      tp_price=new_tp_price;
      tp_pips=NormalizeDouble((tp_price-open_price)/pip_value,_Digits);
      return true;
   }
   return false;
};


//+------------------------------------------------------------------+
//|  MOFIDY TRADE SL BY PIPS                                         |
//+------------------------------------------------------------------+
bool ap_trade::modify_sl_by_pips(double new_sl_pips) {
   double new_sl_price=0;
   if(order_type == ORDER_TYPE_BUY)
      new_sl_price = NormalizeDouble(open_price-(new_sl_pips*pip_value),_Digits);
   if(order_type == ORDER_TYPE_SELL)
      new_sl_price = NormalizeDouble(open_price+(new_sl_pips*pip_value),_Digits);

   if(_trade.PositionModify(ticket,new_sl_price,tp_price)) {
      sl_price=new_sl_price;
      sl_pips=new_sl_pips;
      return true;
   }
   return false;
}


//+------------------------------------------------------------------+
//|  MODIFY TRADE SL BY PRICE                                        |
//+------------------------------------------------------------------+
bool ap_trade::modify_sl_by_price(double new_sl_price) {
   if(sl_price==new_sl_price)
      return true;

   if(_trade.PositionModify(ticket,new_sl_price,tp_price)) {
      sl_price=new_sl_price;
      sl_pips=NormalizeDouble((open_price-sl_price)/pip_value,_Digits);
      return true;
   }
   return false;
}


//+------------------------------------------------------------------+
//|  CLOSE ONLY A PARTIAL OF LOTSIZE                                 |
//+------------------------------------------------------------------+
bool ap_trade::partial_close(double lots_to_close) {
   if(_trade.PositionClosePartial(ticket, lots_to_close))
      if(get_last_closed_trade())
         return true;
   return false;
}


//+------------------------------------------------------------------+
//|  CLOSE A PERCENTAGE OF LOTSIZE                                   |
//+------------------------------------------------------------------+
bool ap_trade::partial_close_by_percent(double percent_to_close) {
   double lots_to_close = NormalizeDouble(volume * (percent_to_close/100), 2);
   if(_trade.PositionClosePartial(ticket, lots_to_close))
      if(get_last_closed_trade())
         return true;
   return false;
}


//+------------------------------------------------------------------+
//|  CLOSE A SELECTED OPEN TRADE                                     |
//+------------------------------------------------------------------+
bool ap_trade::close() {
   if(_trade.PositionClose(ticket))
      if(get_last_closed_trade())
         return true;
   return false;
};


//+------------------------------------------------------------------+
//|  CALCULATE LOTSIZE BY PERCENT YOU WANNA RISK                     |
//+------------------------------------------------------------------+
double calculate_lotsize_by_percent(double account_percent_to_risk, double sl_pips, string symbol="") {
   if(symbol == "")
      symbol = _Symbol;
   double account_percent = AccountInfoDouble(ACCOUNT_BALANCE) / 100.0;
   double amount_we_are_risking = account_percent * account_percent_to_risk;
   return NormalizeDouble(calculate_lotsize_by_cash(amount_we_are_risking, sl_pips, symbol), 2);

}


//+------------------------------------------------------------------+
//|  CALCULATE LOTSIZE BY CASH YOU WANNA RISK                        |
//+------------------------------------------------------------------+
double calculate_lotsize_by_cash(double cash_amount_to_risk, double sl_pips, string symbol="") {
   if(symbol == "")
      symbol = _Symbol;
   double t_size = SymbolInfoDouble(symbol, SYMBOL_TRADE_TICK_VALUE);
   return NormalizeDouble(((cash_amount_to_risk/sl_pips)/t_size)/10, 2);

}

//+------------------------------------------------------------------+
//| OPEN A TRADE OR ORDER                                            |
//+------------------------------------------------------------------+
bool ap_trade::open() {
   set_magic_number(magic_number);
   pip_value = get_pip_value();
   if(order_type==ORDER_TYPE_BUY) {
      open_price=SymbolInfoDouble(symbol,SYMBOL_ASK);
      if(sl_pips>0)
         sl_price=NormalizeDouble(open_price-(sl_pips*pip_value),_Digits);
      else
         sl_pips = NormalizeDouble((open_price-sl_price)/pip_value,1);

      if(tp_pips>0)
         tp_price=NormalizeDouble(open_price+(tp_pips*pip_value),_Digits);
      else
         tp_pips = NormalizeDouble((tp_price-open_price)/pip_value,1);

      if(risk_percent>0)
         lotsize= calculate_lotsize_by_percent(risk_percent,sl_pips);
      else if(risk_cash>0)
         lotsize= calculate_lotsize_by_cash(risk_cash,sl_pips);

      if(lotsize < 0.01)
         lotsize = 0.01;
      for(int i=0; i<10; i++) {
         if(_trade.Buy(lotsize,symbol,open_price,sl_price,tp_price,trade_comment)) {
            get_open_trade_by_position(PositionsTotal()-1);
            return true;
         }
      }
   }
   if(order_type==ORDER_TYPE_SELL) {
      pip_value = get_pip_value();
      open_price=SymbolInfoDouble(symbol,SYMBOL_BID);
      if(sl_pips>0)
         sl_price=NormalizeDouble(open_price+(sl_pips*pip_value),_Digits);
      else
         sl_pips=NormalizeDouble((sl_price-open_price)/pip_value,1);

      if(tp_pips>0)
         tp_price=NormalizeDouble(open_price-(tp_pips*pip_value),_Digits);
      else
         tp_pips = (open_price-tp_price)/pip_value;

      if(risk_percent>0)
         lotsize= calculate_lotsize_by_percent(risk_percent,sl_pips);
      else if(risk_cash>0)
         lotsize= calculate_lotsize_by_cash(risk_cash,sl_pips);

      if(lotsize < 0.01)
         lotsize = 0.01;
      for(int i=0; i<10; i++) {
         if(_trade.Sell(lotsize,symbol,open_price,sl_price,tp_price,trade_comment)) {
            get_open_trade_by_position(PositionsTotal()-1);
            return true;
         }
      }
   }
   if(order_type == BUY_AT || order_type == SELL_AT) {
      double ask = SymbolInfoDouble(symbol,SYMBOL_ASK);
      double bid = SymbolInfoDouble(symbol, SYMBOL_BID);
      double av_price = NormalizeDouble((ask+bid) / 2, _Digits);
      if(order_type == BUY_AT && av_price > open_price)
         order_type = BUY_LIMIT;
      if(order_type == BUY_AT && av_price < open_price)
         order_type = BUY_STOP;
      if(order_type == SELL_AT && av_price < open_price)
         order_type = SELL_LIMIT;
      if(order_type == SELL_AT && av_price > open_price)
         order_type = SELL_STOP;
   }

   if(order_type == ORDER_TYPE_BUY_LIMIT) {
      pip_value = get_pip_value();

      open_price = NormalizeDouble(open_price,_Digits);
      if(sl_pips>0)
         sl_price=NormalizeDouble(open_price-(sl_pips*pip_value),_Digits);
      else
         sl_pips = NormalizeDouble((open_price-sl_price)/pip_value,1);

      if(tp_pips>0)
         tp_price=NormalizeDouble(open_price+(tp_pips*pip_value),_Digits);
      else
         tp_pips = NormalizeDouble((tp_price-open_price)/pip_value,1);


      if(risk_percent>0)
         lotsize= calculate_lotsize_by_percent(risk_percent,sl_pips);
      else if(risk_cash>0)
         lotsize= calculate_lotsize_by_cash(risk_cash,sl_pips);

      if(lotsize < 0.01)
         lotsize = 0.01;

      for(int i=0; i<10; i++) {
         if(_trade.BuyLimit(lotsize, open_price, symbol, sl_price, tp_price, 0, 0, trade_comment)) {
            get_open_pending_order_by_position(OrdersTotal()-1);
            return true;
         }
      }
   }

   if(order_type == ORDER_TYPE_SELL_LIMIT) {
      pip_value = get_pip_value();

      open_price = NormalizeDouble(open_price,_Digits);
      if(sl_pips>0)
         sl_price=NormalizeDouble(open_price+(sl_pips*pip_value),_Digits);
      else
         sl_pips=NormalizeDouble((sl_price-open_price)/pip_value,1);

      if(tp_pips>0)
         tp_price=NormalizeDouble(open_price-(tp_pips*pip_value),_Digits);
      else
         tp_pips = NormalizeDouble((open_price-tp_price)/pip_value,1);


      if(risk_percent>0)
         lotsize= calculate_lotsize_by_percent(risk_percent,sl_pips);
      else if(risk_cash>0)
         lotsize= calculate_lotsize_by_cash(risk_cash,sl_pips);

      if(lotsize < 0.01)
         lotsize = 0.01;

      for(int i=0; i<10; i++) {
         if(_trade.SellLimit(lotsize, open_price, symbol, sl_price, tp_price, 0, 0, trade_comment)) {
            get_open_pending_order_by_position(OrdersTotal()-1);
            return true;
         }
      }
   }

   if(order_type == ORDER_TYPE_BUY_STOP) {
      pip_value = get_pip_value();

      open_price = NormalizeDouble(open_price,_Digits);
      if(sl_pips>0)
         sl_price=NormalizeDouble(open_price-(sl_pips*pip_value),_Digits);
      else
         sl_pips = NormalizeDouble((open_price-sl_price)/pip_value,1);

      if(tp_pips>0)
         tp_price=NormalizeDouble(open_price+(tp_pips*pip_value),_Digits);
      else
         tp_pips = NormalizeDouble((tp_price-open_price)/pip_value,1);


      if(risk_percent>0)
         lotsize= calculate_lotsize_by_percent(risk_percent,sl_pips);
      else if(risk_cash>0)
         lotsize= calculate_lotsize_by_cash(risk_cash,sl_pips);

      if(lotsize < 0.01)
         lotsize = 0.01;

      for(int i=0; i<10; i++) {
         if(_trade.BuyStop(lotsize, open_price, symbol, sl_price, tp_price, 0, 0, trade_comment)) {
            get_open_pending_order_by_position(OrdersTotal()-1);
            return true;
         }
      }
   }

   if(order_type == ORDER_TYPE_SELL_STOP) {
      pip_value = get_pip_value();
      open_price = NormalizeDouble(open_price,_Digits);
      if(sl_pips>0)
         sl_price=NormalizeDouble(open_price+(sl_pips*pip_value),_Digits);
      else
         sl_pips=NormalizeDouble((sl_price-open_price)/pip_value,1);

      if(tp_pips>0)
         tp_price=NormalizeDouble(open_price-(tp_pips*pip_value),_Digits);
      else
         tp_pips = (open_price-tp_price)/pip_value;

      if(risk_percent>0)
         lotsize= calculate_lotsize_by_percent(risk_percent,sl_pips);
      else if(risk_cash>0)
         lotsize= calculate_lotsize_by_cash(risk_cash,sl_pips);

      if(lotsize < 0.01)
         lotsize = 0.01;

      for(int i=0; i<10; i++) {
         if(_trade.SellStop(lotsize, open_price, symbol, sl_price, tp_price, 0, 0, trade_comment)) {
            get_open_pending_order_by_position(OrdersTotal()-1);
            return true;
         }
      }
   }

   return false;
};


//+------------------------------------------------------------------+
//|  CLOSE ALL WINNING TRADES BY A DEFINED MAGIC NUMBER              |
//+------------------------------------------------------------------+
int ap_trade::close_all_winning_trades(int _magic_number=0) {
   int closed_trades=0;
   for(int i=PositionsTotal(); i>=0; i--) {
      if(PositionSelectByTicket(PositionGetTicket(i)))
         if(PositionGetInteger(POSITION_MAGIC)==_magic_number || _magic_number==0)
            if(PositionGetDouble(POSITION_PROFIT)>=0)
               if(_trade.PositionClose(PositionGetInteger(POSITION_TICKET)))
                  closed_trades++;
   }
   return closed_trades;
}


//+------------------------------------------------------------------+
//|  CLOSE ALL TRADES BY A DEFINED MAGIC NUMBER                      |
//+------------------------------------------------------------------+
int ap_trade::close_all_trades(int _magic_number=0) {
   int closed_trades=0;
   for(int i=PositionsTotal()-1; i>=0; i--) {
      if(PositionSelectByTicket(PositionGetTicket(i)))
         if(PositionGetInteger(POSITION_MAGIC)==_magic_number||_magic_number==0)
            if(_trade.PositionClose(PositionGetInteger(POSITION_TICKET)))
               closed_trades++;
   }
   //closed_trades+=cancel_all_orders();
   return closed_trades;
}


//+------------------------------------------------------------------+
//|  CLOSE ALL LOSING TRADES BY A DEFINED MAGIC NUMBER               |
//+------------------------------------------------------------------+
int ap_trade::close_all_losing_trades(int _magic_number=0) {
   int closed_trades=0;
   for(int i=PositionsTotal(); i>=0; i--) {
      if(PositionSelectByTicket(PositionGetTicket(i)))
         if(PositionGetInteger(POSITION_MAGIC)==_magic_number || _magic_number==0)
            if(PositionGetDouble(POSITION_PROFIT)<0)
               if(_trade.PositionClose(PositionGetInteger(POSITION_TICKET)))
                  closed_trades++;
   }
   return closed_trades;
}


//+------------------------------------------------------------------+
//|  CLOSE ALL BUYS BY A DEFINED MAGIC NUMBER                        |
//+------------------------------------------------------------------+
int ap_trade::close_all_buys(int _magic_number=0) {
   int closed_trades=0;
   for(int i=PositionsTotal(); i>=0; i--) {
      if(PositionSelectByTicket(PositionGetTicket(i)))
         if(PositionGetInteger(POSITION_MAGIC)==_magic_number || _magic_number==0)
            if(PositionGetInteger(POSITION_TYPE)==ORDER_TYPE_BUY)
               if(_trade.PositionClose(PositionGetInteger(POSITION_TICKET)))
                  closed_trades++;
   }
   return closed_trades;
}


//+------------------------------------------------------------------+
//|  CLOSE ALL SELLS BY A DEFINED MAGIC NUMBER                       |
//+------------------------------------------------------------------+
int ap_trade::close_all_sells(int _magic_number=0) {
   int closed_trades=0;
   for(int i=PositionsTotal(); i>=0; i--) {
      if(PositionSelectByTicket(PositionGetTicket(i)))
         if(PositionGetInteger(POSITION_MAGIC)==_magic_number || _magic_number==0)
            if(PositionGetInteger(POSITION_TYPE)==ORDER_TYPE_SELL)
               if(_trade.PositionClose(PositionGetInteger(POSITION_TICKET)))
                  closed_trades++;
   }
   return closed_trades;
}




//+------------------------------------------------------------------+
//| CANCEL A PENDING ORDER BY TICKET                                 |
//+------------------------------------------------------------------+
bool ap_trade::cancel_pending_order(int _ticket) {
   if(OrderSelect(_ticket))
      if(_trade.OrderDelete(OrderGetInteger(ORDER_TICKET)))
         return true;

   return false;
}




//+------------------------------------------------------------------+
//|  CANCEL ALL ORDERS BY A DEFINED MAGIC NUMBER                     |
//+------------------------------------------------------------------+
int ap_trade::cancel_all_orders(int _magic_number=0) {
   int canceled_orders=0;
   for(int i=OrdersTotal(); i>=0; i--) {
      if(OrderSelect(OrderGetTicket(i)))
         if(OrderGetInteger(ORDER_MAGIC)==_magic_number || _magic_number==0)
            if(_trade.OrderDelete(OrderGetInteger(ORDER_TICKET)))
               canceled_orders++;

   }
   return canceled_orders;
}


//+------------------------------------------------------------------+
//|  CANCEL ALL BUY LIMIT ORDERS BY A DEFINED MAGIC NUMBER           |
//+------------------------------------------------------------------+
int ap_trade::cancel_all_buy_limit_orders(int _magic_number=0) {
   int canceled_orders=0;

   for(int i=OrdersTotal(); i>=0; i--) {
      if(OrderSelect(OrderGetTicket(i)))
         if(OrderGetInteger(ORDER_MAGIC)==_magic_number || _magic_number==0)
            if(OrderGetInteger(ORDER_TYPE)==ORDER_TYPE_BUY_LIMIT)
               if(_trade.OrderDelete(OrderGetInteger(ORDER_TICKET)))
                  canceled_orders++;
   }
   return canceled_orders;
}


//+------------------------------------------------------------------+
//|  CANCEL ALL SELL LIMIT ORDERS BY A DEFINED MAGIC NUMBER          |
//+------------------------------------------------------------------+
int ap_trade::cancel_all_sell_limit_orders(int _magic_number=0) {
   int cancelled_orders=0;

   for(int i=OrdersTotal(); i>=0; i--) {
      if(OrderSelect(OrderGetTicket(i)))
         if(OrderGetInteger(ORDER_MAGIC)==_magic_number || _magic_number==0)
            if(OrderGetInteger(ORDER_TYPE)==ORDER_TYPE_SELL_LIMIT)
               if(_trade.OrderDelete(OrderGetInteger(ORDER_TICKET)))
                  cancelled_orders++;
   }
   return cancelled_orders;
}


//+------------------------------------------------------------------+
//|  CANCEL ALL BUY STOP ORDERS BY A DEFINED MAGIC NUMBER            |
//+------------------------------------------------------------------+
int ap_trade::cancel_all_buy_stop_orders(int _magic_number=0) {
   int cancelled_orders=0;

   for(int i=OrdersTotal(); i>=0; i--) {
      if(OrderSelect(OrderGetTicket(i)))
         if(OrderGetInteger(ORDER_MAGIC)==magic_number|| _magic_number==0)
            if(OrderGetInteger(ORDER_TYPE)==ORDER_TYPE_BUY_STOP)
               if(_trade.OrderDelete(OrderGetInteger(ORDER_TICKET)))
                  cancelled_orders++;
   }
   return cancelled_orders;
}


//+------------------------------------------------------------------+
//|  CANCEL ALL SELL STOP ORDERS BY A DEFINED MAGIC NUMBER           |
//+------------------------------------------------------------------+
int ap_trade::cancel_all_sell_stop_orders(int _magic_number=0) {
   int cancelled_orders=0;

   for(int i=OrdersTotal(); i>=0; i--) {
      if(OrderSelect(OrderGetTicket(i)))
         if(OrderGetInteger(ORDER_MAGIC)==_magic_number || _magic_number==0)
            if(OrderGetInteger(ORDER_TYPE)==ORDER_TYPE_SELL_STOP)
               if(_trade.OrderDelete(OrderGetInteger(ORDER_TICKET)))
                  cancelled_orders++;
   }
   return cancelled_orders;
}


//+------------------------------------------------------------------+
//|  HOW MUCH PROFIT HAS THE EA MADE BASED ON MAGIC NUMBER           |
//+------------------------------------------------------------------+
double ap_trade::closed_profit(int _magic_number=0) {
   double profit=0;
   HistorySelect(0, TimeCurrent());
   for(int i = HistoryDealsTotal(); i >= 0; i--) {
      ulong _ticket;
      _ticket = HistoryDealGetTicket(i);
      if((ticket > 0)) {
         long entry = HistoryDealGetInteger(_ticket, DEAL_ENTRY);
         if(entry == DEAL_ENTRY_IN)
            continue;
         if(HistoryDealGetInteger(_ticket,DEAL_MAGIC)==_magic_number || _magic_number==0) {
            profit+=HistoryDealGetDouble(_ticket,DEAL_PROFIT);
         }
      }
   }
   return NormalizeDouble(profit,2);
}


//+------------------------------------------------------------------+
//|  HOW MUCH OPEN PROFIT THE EA CURRENTLY HAS ON MAGIC NUMBER       |
//+------------------------------------------------------------------+
double ap_trade::open_profit(int _magic_number=0) {
   double number=0;
   for(int i = PositionsTotal(); i >= 0; i--) {
      if(PositionSelectByTicket(PositionGetTicket(i)))
         if(PositionGetInteger(POSITION_MAGIC)==_magic_number || _magic_number==0)
            number+=(PositionGetDouble(POSITION_PROFIT)+PositionGetDouble(POSITION_SWAP));
   }
   return number;
}


//+------------------------------------------------------------------+
//|  HOW MANY OPEN LOST THE EA CURRENTLY HAS ON MAGIC NUMBER         |
//+------------------------------------------------------------------+
double ap_trade::open_lots(int _magic_number=0) {
   double number=0;
   for(int i = PositionsTotal(); i >= 0; i--) {
      if(PositionSelectByTicket(PositionGetTicket(i)))
         if(PositionGetInteger(POSITION_MAGIC)==_magic_number || _magic_number==0)
            number+=(PositionGetDouble(POSITION_VOLUME));
   }
   return number;
}


//+------------------------------------------------------------------+
//|  RETURN THE NUMBER OF OPEN TRADES                                |
//+------------------------------------------------------------------+
int ap_trade::number_of_open_trades(int _magic_number=0) {
   int number=0;
   for(int i = PositionsTotal(); i >= 0; i--) {
      if(PositionSelectByTicket(PositionGetTicket(i)))
         if(PositionGetInteger(POSITION_MAGIC)==_magic_number || _magic_number==0)
            number++;
   }
   return number;
}


//+------------------------------------------------------------------+
//|  RETURN THE NUMBER OF OPEN BUYS                                  |
//+------------------------------------------------------------------+
int ap_trade::number_of_open_buys(int _magic_number=0) {
   int number=0;
   for(int i = PositionsTotal(); i >= 0; i--) {
      if(PositionSelectByTicket(PositionGetTicket(i)))
         if(PositionGetInteger(POSITION_MAGIC)==_magic_number || _magic_number==0)
            if(PositionGetInteger(POSITION_TYPE)==ORDER_TYPE_BUY)
               number++;
   }
   return number;
}


//+------------------------------------------------------------------+
//|  RETURN THE NUMBER OF OPEN SELLS                                 |
//+------------------------------------------------------------------+
int ap_trade::number_of_open_sells(int _magic_number=0) {
   int number=0;
   for(int i = PositionsTotal(); i >= 0; i--) {
      if(PositionSelectByTicket(PositionGetTicket(i)))
         if(PositionGetInteger(POSITION_MAGIC)==_magic_number || _magic_number==0)
            if(PositionGetInteger(POSITION_TYPE)==ORDER_TYPE_SELL)
               number++;
   }
   return number;
}


//+------------------------------------------------------------------+
//|  RETURN THE NUMBER OF OPEN SELL LIMITS                           |
//+------------------------------------------------------------------+
int ap_trade::number_of_pending_sell_limits(int _magic_number=0) {
   int number=0;
   for(int i = OrdersTotal(); i >= 0; i--) {
      if(OrderSelect(OrderGetTicket(i)))
         if(PositionGetInteger(POSITION_MAGIC)==_magic_number || _magic_number==0)
            if(OrderGetInteger(ORDER_TYPE)==ORDER_TYPE_SELL_LIMIT)
               number++;
   }
   return number;
}


//+------------------------------------------------------------------+
//|  RETURN THE NUMBER OF OPEN BUY LIMITS                            |
//+------------------------------------------------------------------+
int ap_trade::number_of_pending_buy_limits(int _magic_number=0) {
   int number=0;
   for(int i = OrdersTotal(); i >= 0; i--) {
      if(OrderSelect(OrderGetTicket(i)))
         if(PositionGetInteger(POSITION_MAGIC)==_magic_number ||_magic_number==0)
            if(OrderGetInteger(ORDER_TYPE)==ORDER_TYPE_BUY_LIMIT)
               number++;
   }
   return number;
}


//+------------------------------------------------------------------+
//|  RETURN THE NUMBER OF OPEN SELL STOPS                            |
//+------------------------------------------------------------------+
int ap_trade::number_of_pending_sell_stops(int _magic_number=0) {
   int number=0;
   for(int i = OrdersTotal(); i >= 0; i--) {
      if(OrderSelect(OrderGetTicket(i)))
         if(PositionGetInteger(POSITION_MAGIC)==_magic_number || _magic_number==0)
            if(OrderGetInteger(ORDER_TYPE)==ORDER_TYPE_SELL_STOP)
               number++;
   }
   return number;
}


//+------------------------------------------------------------------+
//|  RETURN THE NUMBER OF OPEN BUY STOPS                             |
//+------------------------------------------------------------------+
int ap_trade::number_of_pending_buy_stops(int _magic_number=0) {
   int number=0;
   for(int i = OrdersTotal(); i >= 0; i--) {
      if(OrderSelect(OrderGetTicket(i)))
         if(PositionGetInteger(POSITION_MAGIC)==_magic_number || _magic_number==0)
            if(OrderGetInteger(ORDER_TYPE)==ORDER_TYPE_BUY_STOP)
               number++;
   }
   return number;
}


//+------------------------------------------------------------------+
//|  RETURN THE NUMBER OF OPEN PENDING ORDERS                        |
//+------------------------------------------------------------------+
int ap_trade::number_of_pending_orders(int _magic_number=0) {
   int number=0;
   for(int i = OrdersTotal(); i >= 0; i--) {
      if(OrderSelect(OrderGetTicket(i)))
         if(OrderGetInteger(ORDER_MAGIC)==_magic_number || _magic_number==0)
            number++;
   }
   return number;
}



// risk setting
// 0 = lots
// 1 = cash
// 2 = percent
//+------------------------------------------------------------------+
//|  OPEN BY ORDER                                                   |
//+------------------------------------------------------------------+
bool open_buy(
   int risk_setting,
   double risk_variable,
   double sl=0,
   double tp=0,
   int magic_nr=999,
   string pips_or_price="pips",
   string comment="BUY"
) {
   ap_trade t();
   t.order_type = BUY;
   if(pips_or_price=="pips") {
      t.tp_pips = tp;
      t.sl_pips = sl;
   } else {
      t.tp_price = tp;
      t.sl_price = sl;
   }

   t.lotsize = risk_variable;
   if(risk_setting == 1 && sl != 0) {
      t.risk_cash = risk_variable;
   } else if(risk_setting == 2 && sl != 0) {
      t.risk_percent = risk_variable;
   }
   t.magic_number = magic_nr;
   t.trade_comment = comment;

   return t.open();

}


//+------------------------------------------------------------------+
//|  OPEN SELL ORDER                                                 |
//+------------------------------------------------------------------+
bool open_sell(
   int risk_setting,
   double risk_variable,
   double sl=0,
   double tp=0,
   int magic_nr=999,
   string pips_or_price="pips",
   string comment="SELL"
) {
   ap_trade t();
   t.order_type = SELL;
   if(pips_or_price=="pips") {
      t.tp_pips = tp;
      t.sl_pips = sl;
   } else {
      t.tp_price = tp;
      t.sl_price = sl;
   }



   t.lotsize = risk_variable;
   if(risk_setting == 1 && sl != 0) {
      t.risk_cash = risk_variable;
   } else if(risk_setting == 2 && sl != 0) {
      t.risk_percent = risk_variable;
   }
   t.magic_number = magic_nr;
   t.trade_comment = comment;

   return t.open();
}


//+------------------------------------------------------------------+
//|  OPEN BUY LIMIT ORDER                                            |
//+------------------------------------------------------------------+
bool open_buy_limit
(
   int risk_setting,
   double risk_variable,
   double pending_price,
   double sl=0,
   double tp=0,
   int magic_nr=999,
   string pips_or_price="pips",
   string comment="BUY LIMIT"
) {
   ap_trade t();
   t.order_type = BUY_LIMIT;
   t.open_price = pending_price;
   if(pips_or_price=="pips") {
      t.tp_pips = tp;
      t.sl_pips = sl;
   } else {
      t.tp_price = tp;
      t.sl_price = sl;
   }

   t.lotsize = risk_variable;
   if(risk_setting == 1 && sl != 0) {
      t.risk_cash = risk_variable;
   } else if(risk_setting == 2 && sl != 0) {
      t.risk_percent = risk_variable;
   }
   t.magic_number = magic_nr;
   t.trade_comment = comment;
   return t.open();
}


//+------------------------------------------------------------------+
//|  OPEN SELL LIMIT ORDER                                           |
//+------------------------------------------------------------------+
bool open_sell_limit
(
   int risk_setting,
   double risk_variable,
   double pending_price,
   double sl=0,
   double tp=0,
   int magic_nr=999,
   string pips_or_price="pips",
   string comment="SELL LIMIT"
) {
   ap_trade t();
   t.order_type = SELL_LIMIT;
   t.open_price = pending_price;
   if(pips_or_price=="pips") {
      t.tp_pips = tp;
      t.sl_pips = sl;
   } else {
      t.tp_price = tp;
      t.sl_price = sl;
   }

   t.lotsize = risk_variable;
   if(risk_setting == 1 && sl != 0) {
      t.risk_cash = risk_variable;
   } else if(risk_setting == 2 && sl != 0) {
      t.risk_percent = risk_variable;
   }
   t.magic_number = magic_nr;
   t.trade_comment = comment;
   return t.open();
}


//+------------------------------------------------------------------+
//|  OPEN BUY STOP ORDER                                             |
//+------------------------------------------------------------------+
bool open_buy_stop
(
   int risk_setting,
   double risk_variable,
   double pending_price,
   double sl=0,
   double tp=0,
   int magic_nr=999,
   string pips_or_price="pips",
   string comment="BUY STOP"
) {
   ap_trade t();
   t.order_type = BUY_STOP;
   t.open_price = pending_price;
   if(pips_or_price=="pips") {
      t.tp_pips = tp;
      t.sl_pips = sl;
   } else {
      t.tp_price = tp;
      t.sl_price = sl;
   }

   t.lotsize = risk_variable;
   if(risk_setting == 1 && sl != 0) {
      t.risk_cash = risk_variable;
   } else if(risk_setting == 2 && sl != 0) {
      t.risk_percent = risk_variable;
   }
   t.magic_number = magic_nr;
   t.trade_comment = comment;
   return t.open();
}


//+------------------------------------------------------------------+
//|  OPEN SELL STOP ORDER                                            |
//+------------------------------------------------------------------+
bool open_sell_stop
(
   int risk_setting,
   double risk_variable,
   double pending_price,
   double sl=0,
   double tp=0,
   int magic_nr=999,
   string pips_or_price="pips",
   string comment="SELL STOP"
) {
   ap_trade t();
   t.order_type = SELL_STOP;
   t.open_price = pending_price;
   if(pips_or_price=="pips") {
      t.tp_pips = tp;
      t.sl_pips = sl;
   } else {
      t.tp_price = tp;
      t.sl_price = sl;
   }

   t.lotsize = risk_variable;
   if(risk_setting == 1 && sl != 0) {
      t.risk_cash = risk_variable;
   } else if(risk_setting == 2 && sl != 0) {
      t.risk_percent = risk_variable;
   }
   t.magic_number = magic_nr;
   t.trade_comment = comment;
   return t.open();
}



//+------------------------------------------------------------------+


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool buy_at(
   int risk_setting,
   double risk_variable,
   double pending_price,
   double sl=0,
   double tp=0,
   int magic_nr=999,
   string pips_or_price="pips",
   string comment="BUY AT"
) {
   ap_trade t();
   t.order_type = BUY_AT;
   t.open_price = pending_price;
   if(pips_or_price=="pips") {
      t.tp_pips = tp;
      t.sl_pips = sl;
   } else {
      t.tp_price = tp;
      t.sl_price = sl;
   }

   t.lotsize = risk_variable;
   if(risk_setting == 1 && sl != 0) {
      t.risk_cash = risk_variable;
   } else if(risk_setting == 2 && sl != 0) {
      t.risk_percent = risk_variable;
   }
   t.magic_number = magic_nr;
   t.trade_comment = comment;
   return t.open();
}
//+------------------------------------------------------------------+


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool sell_at(
   int risk_setting,
   double risk_variable,
   double pending_price,
   double sl=0,
   double tp=0,
   int magic_nr=999,
   string pips_or_price="pips",
   string comment="SELL AT"
) {
   ap_trade t();
   t.order_type = SELL_AT;
   t.open_price = pending_price;
   if(pips_or_price=="pips") {
      t.tp_pips = tp;
      t.sl_pips = sl;
   } else {
      t.tp_price = tp;
      t.sl_price = sl;
   }

   t.lotsize = risk_variable;
   if(risk_setting == 1 && sl != 0) {
      t.risk_cash = risk_variable;
   } else if(risk_setting == 2 && sl != 0) {
      t.risk_percent = risk_variable;
   }
   t.magic_number = magic_nr;
   t.trade_comment = comment;
   return t.open();
}
//+------------------------------------------------------------------+
//|             CALCULATE PROFIT AT RISK                             |
//+------------------------------------------------------------------+
double calculate_profit_by_distance(double lotsize, double pip_distance) {
   double t_size = SymbolInfoDouble(Symbol(),SYMBOL_TRADE_TICK_VALUE);
   return NormalizeDouble(((t_size*lotsize)*pip_distance)*10,2);

}
//+------------------------------------------------------------------+
