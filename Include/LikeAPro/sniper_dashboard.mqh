//+------------------------------------------------------------------+
//|                                             sniper_dashboard.mqh |
//|                                  Copyright 2022, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#include <LikeAPro/shapes.mqh>
#include <LikeAPro/trade_sequence.mqh>
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class Dashboard
  {
public:
   void              create(
      string _name,
      int _title_font_size,
      color _title_colour,
      string _title_font,
      int _x_distance,
      int _y_distance,
      int _width,
      int _height,
      color _main_colour,
      int _header_height,
      color _header_colour,
      int _component_height,
      color _component_colour,
      int _component_buffer_x,
      int _component_buffer_y,
      int _component_data_font_size,
      int _component_data_text_colour,
      string _component_data_font,
      int _component_text_x_buffer,
      int _component_text_y_buffer,
      int _component_pnl_font_size,
      color _component_pnl_winning_colour,
      color _component_pnl_losing_colour,
      int _overview_panel_height,
      int _overview_panel_x_buffer,
      int _overview_panel_y_buffer,
      color _overview_panel_colour
   );


   void              build_dashboard();
   void              create_overview_panel();
   void              populate_sequences();
   void              update_sequences();
   void              delete_sequences();

   string            name;
   int               title_font_size;
   color             title_colour;
   string            title_font;
   int               x_distance;
   int               y_distance;
   int               width;
   int               height;
   color             main_colour;
   int               header_height;
   color             header_colour;
   int               component_buffer_x;
   int               component_buffer_y;
   int               component_data_font_size;
   color             component_data_text_colour;
   string            component_data_font;
   int               component_text_x_buffer;
   int               component_text_y_buffer;
   int               component_pnl_font_size;
   color             component_pnl_winning_colour;
   color             component_pnl_losing_colour;
   int               component_height;

   int               overview_panel_height;
   int               overview_panel_x_buffer;
   int               overview_panel_y_buffer;
   color             overview_panel_colour;
   color             component_colour;


  };

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Dashboard::create(
   string _name,
   int _title_font_size,
   color _title_colour,
   string _title_font,
   int _x_distance,
   int _y_distance,
   int _width,
   int _height,
   color _main_colour,
   int _header_height,
   color _header_colour,
   int _component_height,
   color _component_colour,
   int _component_buffer_x,
   int _component_buffer_y,
   int _component_data_font_size,
   int _component_data_text_colour,
   string _component_data_font,
   int _component_text_x_buffer,
   int _component_text_y_buffer,
   int _component_pnl_font_size,
   color _component_pnl_winning_colour,
   color _component_pnl_losing_colour,
   int _overview_panel_height,
   int _overview_panel_x_buffer,
   int _overview_panel_y_buffer,
   color _overview_panel_colour
)
  {
   name=_name;
   title_font_size=_title_font_size;
   title_colour=_title_colour;
   title_font=_title_font;
   x_distance=_x_distance;
   y_distance=_y_distance;
   width=_width;
   height=_height;
   main_colour=_main_colour;
   header_height=_header_height;
   header_colour=_header_colour;
   component_buffer_x=_component_buffer_x;
   component_buffer_y=_component_buffer_y;
   component_data_font_size=_component_data_font_size;
   component_data_font=_component_data_font;
   component_text_x_buffer=_component_text_x_buffer;
   component_text_y_buffer=_component_text_y_buffer;
   component_pnl_font_size=_component_pnl_font_size;
   component_pnl_winning_colour=_component_pnl_winning_colour;
   component_pnl_losing_colour=_component_pnl_losing_colour;
   component_height = _component_height;
   overview_panel_height=_overview_panel_height;
   overview_panel_x_buffer=_overview_panel_x_buffer;
   overview_panel_y_buffer=_overview_panel_y_buffer;
   overview_panel_colour=_overview_panel_colour;
   component_data_text_colour=_component_data_text_colour;
   component_colour = _component_colour;
   build_dashboard();
   create_overview_panel();
   create_overview_panel();
  }

//+------------------------------------------------------------------+
void Dashboard::build_dashboard()
  {
   rectangle("dashboard",x_distance,y_distance,width,height,CORNER_LEFT_UPPER,BORDER_FLAT,STYLE_SOLID,1,main_colour);
   rectangle("header",x_distance,y_distance,width,header_height,CORNER_LEFT_UPPER,BORDER_FLAT,STYLE_SOLID,1,header_colour);
   TextSetFont(title_font,title_font_size);
   uint w,h;
   TextGetSize(name,w,h);
   int title_x =(width/2)-(w/2)-x_distance;
   int title_y = y_distance+(header_height/2)-h;
   label("title",title_x,title_y,CORNER_LEFT_UPPER,name,title_font_size,title_colour,title_font);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Dashboard::create_overview_panel()
  {
   int x = x_distance+ overview_panel_x_buffer;
   int y = y_distance+ header_height+overview_panel_y_buffer;
   int w = width-(overview_panel_y_buffer*2);

   rectangle("overview",x,y,w,overview_panel_height,CORNER_LEFT_UPPER,BORDER_FLAT,STYLE_SOLID,0,overview_panel_colour);

  }
//+------------------------------------------------------------------+
void Dashboard::populate_sequences()
  {
   int y=y_distance +header_height+overview_panel_y_buffer+overview_panel_height+overview_panel_y_buffer;
   int x=x_distance+component_buffer_x;;
   int h=component_height;
   int w = width-(component_buffer_x*2);
   for(int i=0; i<ArraySize(sequence); i++)
     {

      datetime open_time = sequence[i].start_time;
      double open_pnl = sequence[i].stats.trades.open.buys_and_sells.pnl_cash;

      string open_time_text = TimeToString(open_time);
      string open_pnl_cash = DoubleToString(open_pnl,2)+AccountInfoString(ACCOUNT_CURRENCY);
      string open_trade_text = "Open Trades: "+sequence[i].stats.trades.open.buys_and_sells.number;
      string closed_trade_text = "Closed Trades: "+sequence[i].stats.trades.closed.buys_and_sells.number;
      open_trade_text +="    "+closed_trade_text;

      rectangle("sequence_"+(string)i,x,y,w,h,CORNER_LEFT_UPPER,BORDER_FLAT,STYLE_SOLID,1,component_colour);

      TextSetFont(component_data_font,component_data_font_size);
      uint _w,_h;
      TextGetSize(open_time_text,_w,_h);


      label("open_time_"+(string)i,x+overview_panel_x_buffer,y,CORNER_LEFT_UPPER,open_time_text,component_data_font_size,component_data_text_colour,component_data_font);
      label("open_trades_"+(string)i,x+overview_panel_x_buffer+(_w*2),y,CORNER_LEFT_UPPER,open_trade_text,component_data_font_size,component_data_text_colour,component_data_font);
      label("open_cash_"+(string)i,x+overview_panel_x_buffer,y+(2*component_text_y_buffer)+_h,CORNER_LEFT_UPPER,open_pnl_cash,component_data_font_size,component_data_text_colour,component_data_font);

      y+=(component_height+component_buffer_y);

     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Dashboard::update_sequences()
  {
   for(int i=0; i<ArraySize(sequence); i++)
     {
      double open_pnl = sequence[i].stats.trades.open.buys_and_sells.pnl_cash;
      string open_pnl_cash = DoubleToString(open_pnl,2)+AccountInfoString(ACCOUNT_CURRENCY);
      string open_trade_text = "Open Trades: "+(string) sequence[i].stats.trades.open.buys_and_sells.number;
      string closed_trade_text = "Closed Trades: "+(string) sequence[i].stats.trades.closed.buys_and_sells.number;
      open_trade_text +="    "+closed_trade_text;
      color pnl_colour = component_pnl_winning_colour;
      if(open_pnl<0)
         pnl_colour = component_pnl_losing_colour;
      ObjectSetString(0,"open_trades_"+ (string)i,OBJPROP_TEXT,open_trade_text);
      ObjectSetString(0,"open_cash_"+ (string)i,OBJPROP_TEXT,open_pnl_cash);
      ObjectSetInteger(0,"open_cash_"+ (string)i,OBJPROP_COLOR,pnl_colour);
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Dashboard::delete_sequences()
  {
   for(int i=0; i<ArraySize(sequence); i++)
     {
      ObjectDelete(0,"sequence_"+(string)i);
      ObjectDelete(0,"open_time_"+(string)i);
      ObjectDelete(0,"open_trades_"+(string)i);
      ObjectDelete(0,"open_cash_"+(string)i);
     }

  }
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
