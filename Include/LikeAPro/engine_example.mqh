#include <LikeAPro/trade.mqh>
#include <LikeAPro/candle.mqh>
#include <LikeAPro/dashboard.mqh>
#include <LikeAPro/atr.mqh>

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

int trade_ticket=0;
int new_candle_count = 0;


//+------------------------------------------------------------------+
//|            SETUP TRADE ENGINE EXAMPLE                            |
//+------------------------------------------------------------------+
void setup()
  {
   start_trade_engine(1);
   init_candles();
   atr_init_times();
  }




//+------------------------------------------------------------------+
//|               SETUP THE DASHBOARD FOR OUR TRADE                  |
//+------------------------------------------------------------------+
void create_dashboard(ap_trade &trade)
  {
   trade_ticket = trade.ticket;
   color box_color = clrDarkRed;
   color text_colour = clrOrange;
   if(trade.order_type==0)
     {
      box_color = clrDarkBlue;
      text_colour = clrAquamarine;
     }
   int line_spacing=25;
   int starting_line=40;
   rectangle("trade_engine",30,30,350,320,CORNER_LEFT_UPPER,BORDER_FLAT,STYLE_SOLID,2,box_color);
   label("1",30+10,starting_line,CORNER_LEFT_UPPER,"",12,text_colour,"Consolas");
   label("2",30+10,starting_line+=line_spacing,CORNER_LEFT_UPPER,"",12,text_colour,"Consolas");
   label("3",30+10,starting_line+=line_spacing,CORNER_LEFT_UPPER,"",12,text_colour,"Consolas");
   label("4",30+10,starting_line+=line_spacing,CORNER_LEFT_UPPER," ",12,text_colour,"Consolas");
   label("5",30+10,starting_line+=line_spacing,CORNER_LEFT_UPPER," ",12,text_colour,"Consolas");
   label("6",30+10,starting_line+=line_spacing,CORNER_LEFT_UPPER," ",12,text_colour,"Consolas");
   label("7",30+10,starting_line+=line_spacing,CORNER_LEFT_UPPER," ",12,text_colour,"Consolas");
   label("8",30+10,starting_line+=line_spacing,CORNER_LEFT_UPPER," ",12,text_colour,"Consolas");
   label("9",30+10,starting_line+=line_spacing,CORNER_LEFT_UPPER," ",12,text_colour,"Consolas");
   label("10",30+10,starting_line+=line_spacing,CORNER_LEFT_UPPER," ",12,text_colour,"Consolas");
   label("11",30+10,starting_line+=line_spacing,CORNER_LEFT_UPPER," ",12,text_colour,"Consolas");
   label("12",30+10,starting_line+=line_spacing,CORNER_LEFT_UPPER," ",12,text_colour,"Consolas");
  }

//+------------------------------------------------------------------+
//| COUNT NUMBER OF CANDLES                                          |
//+------------------------------------------------------------------+
int candle_count()
  {
   if(new_candle())
      new_candle_count++;
   return new_candle_count;

  }


//+------------------------------------------------------------------+
//|                 EDIT LABEL BY NAME AND WITH TEXT                 |
//+------------------------------------------------------------------+
void display(int line,string text)
  {
   ObjectSetString(0,IntegerToString(line),OBJPROP_TEXT,text);

  }

void update_closed_display(ap_trade &trade)
  {
   string o_type = "BUY";
   if(trade.order_type==1)
      o_type="SELL";
   display(1,o_type+" closed"+"("+DoubleToString(trade.volume,2)+"lots)"+" @"+DoubleToString(trade.close_price,_Digits));
   display(2,"PnL: "+DoubleToString(trade.pnl_cash,2)+AccountInfoString(ACCOUNT_CURRENCY)+" ("+DoubleToString(trade.pnl_pips,1)+"pips)");
   display(3," ");
   display(4," ");
   display(5," ");
   display(6," ");
   display(7," ");
   display(8," ");
   display(9," ");
   display(10," ");
   display(11," ");
   display(12," ");
   ObjectSetInteger(0,"trade_engine",OBJPROP_YSIZE,70);

  }
//+------------------------------------------------------------------+


