//+--------------------------------------------------------------------------------------------------+
//|**************************************************************************************************|
//+--------------------------------------------------------------------------------------------------+
// ██████╗ █████╗ ███╗   ██╗██████╗ ██╗     ███████╗███████╗████████╗██╗ ██████╗██╗  ██╗███████╗
//██╔════╝██╔══██╗████╗  ██║██╔══██╗██║     ██╔════╝██╔════╝╚══██╔══╝██║██╔════╝██║ ██╔╝██╔════╝
//██║     ███████║██╔██╗ ██║██║  ██║██║     █████╗  ███████╗   ██║   ██║██║     █████╔╝ ███████╗
//██║     ██╔══██║██║╚██╗██║██║  ██║██║     ██╔══╝  ╚════██║   ██║   ██║██║     ██╔═██╗ ╚════██║
//╚██████╗██║  ██║██║ ╚████║██████╔╝███████╗███████╗███████║   ██║   ██║╚██████╗██║  ██╗███████║
// ╚═════╝╚═╝  ╚═╝╚═╝  ╚═══╝╚═════╝ ╚══════╝╚══════╝╚══════╝   ╚═╝   ╚═╝ ╚═════╝╚═╝  ╚═╝╚══════╝
//+--------------------------------------------------------------------------------------------------+
//|**************************************************************************************************|
//+--------------------------------------------------------------------------------------------------+
#include <shapes.mqh>
#include <stash.mqh>
double pip;

struct ohlc // learn about 'struct' here: https://tinyurl.com/ap-structs

  {
   ENUM_TIMEFRAMES   tf;
   double            high(int shfit=0);
   double            low(int shfit=0);
   double            close(int shfit=0);
   double            open(int shfit=0);

   double            highest(int lookback);
   double            lowest(int lookback);

   bool              bullish(int shift=0);
   bool              bearish(int shift=0);

   double            full_size_pips(int shift=0);
   double            body_size_pips(int shift=0);
   double            upper_wick_pips(int shift=0);
   double            lower_wick_pips(int shift=0);

   double            full_size_percent(int shift=0);
   double            body_size_percent(int shift=0);
   double            upper_wick_percent(int shift=0);
   double            lower_wick_percent(int shift=0);
  }
;

struct candlestick_metadata
  {
   bool              bullish;
   bool              bearish;
   double            full_size_pips;
   double            body_size_pips;
   double            upper_wick_pips;
   double            lower_wick_pips;
   double            body_size_percent;
   double            upper_wick_percent;
   double            lower_wick_percent;

  };

//+------------------------------------------------------------------+
//|               CANDLE CLASS                                       |
//+------------------------------------------------------------------+
class Candle
  {
public:
   double            open;
   double            close;
   double            high;
   double            low;
   datetime          time;
   int               index;
                     Candle(
      int _index = 1,
      bool load_full = false,
      ENUM_TIMEFRAMES timeframe = PERIOD_CURRENT

   );
   candlestick_metadata meta;

  };
//+------------------------------------------------------------------+
//|                INITIALISE THE CANDLE                             |
//+------------------------------------------------------------------+
void Candle::Candle(
   int _index=1,
   bool load_full=false,
   ENUM_TIMEFRAMES timeframe= PERIOD_CURRENT
)
  {
   index= _index;
   open = iOpen(_Symbol,timeframe,_index);
   close = iClose(_Symbol,timeframe,_index);
   high = iHigh(_Symbol,timeframe,_index);
   low = iLow(_Symbol,timeframe,_index);
   time = iTime(_Symbol,timeframe,index);

   if(load_full)
     {
      meta.upper_wick_pips = 0;
      meta.lower_wick_pips = 0;
      meta.upper_wick_percent = 0;
      meta.lower_wick_percent = 0;
      meta.body_size_pips = 0;
      meta.bullish = false;
      meta.bearish = false;

      if(open>close)
        {
         meta.bearish = true;
         meta.body_size_pips = (open-close) / pip;
         meta.upper_wick_pips = (high-open) / pip;
         meta.lower_wick_pips = (close-low) / pip;
        }
      if(open<close)
        {
         meta.bullish = true;
         meta.body_size_pips = (close-open) / pip;
         meta.upper_wick_pips = (high-close) / pip;
         meta.lower_wick_pips = (open-low) / pip;
        }

      meta.full_size_pips = (high-low) / pip;
      meta.body_size_percent = (meta.body_size_pips / meta.full_size_pips) * 100.0;
      meta.upper_wick_percent = (meta.upper_wick_pips / meta.full_size_pips) * 100.0;
      meta.lower_wick_percent = (meta.lower_wick_pips / meta.full_size_pips) * 100.0;
     }
  }
//+------------------------------------------------------------------+
//|                   CANDLE SELECTOR CLASS                          |
//+------------------------------------------------------------------+
class CandleSelector
  {
public:
   void              settings(
      double _buffer_percent=10,
      color _bullish_colour=clrDarkGreen,
      color _bearish_colour=clrDarkRed,
      color _bullish_fill_colour=clrLightGreen,
      color _bearish_fil_colour=clrRed,
      int _text_size=12,
      string _text_font="Consolas",
      color _text_colour=clrBlack
   );

   double            buffer_percent;
   color             bullish_colour;
   color             bearish_colour;
   color             bearish_fill_colour;
   color             bullish_fill_colour;
   int               text_size;
   string            text_font;
   color             text_color;

  };
//+------------------------------------------------------------------+
//|            CANDLE SELECTOR SETTINGS                              |
//+------------------------------------------------------------------+
void CandleSelector::settings(
   double _buffer_percent=10,
   color _bullish_colour=clrDarkGreen,
   color _bearish_colour=clrDarkRed,
   color _bullish_fill_colour=clrLightGreen,
   color _bearish_fill_colour=clrRed,
   int _text_size=12,
   string _text_font="Consolas",
   color _text_colour=clrBlack
)
  {
   buffer_percent = _buffer_percent;
   bullish_colour = _bullish_colour;
   bearish_colour = _bearish_colour;
   bullish_fill_colour = _bullish_fill_colour;
   bearish_fill_colour = _bearish_fill_colour;
   text_size = _text_size;
   text_font = _text_font;
   text_color = _text_colour;
  }

CandleSelector cs;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void highlight_candle(
   Candle &c,
   bool bullish,
   bool fill,
   string text=""
)
  {
   string internal_name = text + "-"+TimeToString(c.time);
   datetime time1=iTime(_Symbol,PERIOD_CURRENT,c.index+1);
   datetime time2=iTime(_Symbol,PERIOD_CURRENT,c.index-1);

   double buff = ((c.high-c.low)/100)*cs.buffer_percent;

   double price1=c.low - buff;
   double price2=c.high + buff;

   if(!ObjectCreate(0,internal_name,OBJ_RECTANGLE,0,time1,price1,time2,price2))
     {
      Print(__FUNCTION__+": failed to create a rectangle! Error code = "+IntegerToString(GetLastError()));
     }
   color shape_col = cs.bearish_fill_colour;
   if(bullish)
      shape_col = cs.bullish_fill_colour;
   ObjectSetInteger(0,internal_name,OBJPROP_COLOR,shape_col);
   ObjectSetInteger(0,internal_name,OBJPROP_STYLE,STYLE_SOLID);
   ObjectSetInteger(0,internal_name,OBJPROP_WIDTH,2);

   ObjectSetInteger(0,internal_name,OBJPROP_FILL,fill);
   if(!fill)
      ObjectSetInteger(0,internal_name,OBJPROP_BACK,false);
   else
      ObjectSetInteger(0,internal_name,OBJPROP_BACK,true);

   ObjectSetInteger(0,internal_name,OBJPROP_SELECTABLE,false);
   ObjectSetInteger(0,internal_name,OBJPROP_SELECTED,false);
   ObjectSetInteger(0,internal_name,OBJPROP_HIDDEN,false);
   ObjectSetInteger(0,internal_name,OBJPROP_ZORDER,0);
   if(text!="")\
     {
      double text_price=price1;
      if(bullish)
         text_price=price2;

      text_label(
         text,
         c.time,
         text_price,
         shape_col,
         cs.text_font,
         cs.text_size
      );
     }
  }
//+------------------------------------------------------------------+
//|  HIGHLIGHT MORE THAN ONE CANDLE WITH A START & END CANDLE        |
//+------------------------------------------------------------------+
void highlight_candles(
   Candle &candle_1,
   Candle &candle_2,
   bool bullish,
   bool fill,
   string text=""
)
  {
   Candle start_candle(candle_2.index);
   Candle end_candle(candle_1.index);
   if(candle_1.index>candle_2.index)
     {
      Candle start_candle(candle_1.index);
      Candle end_candle(candle_2.index);
     }

   string internal_name = text + "-"+TimeToString(start_candle.time);
   datetime time1=iTime(_Symbol,PERIOD_CURRENT,start_candle.index);
   datetime time2=iTime(_Symbol,PERIOD_CURRENT,end_candle.index-1);

   int lowest_bar_back = iLowest(Symbol(),PERIOD_CURRENT,MODE_LOW,start_candle.index-end_candle.index,end_candle.index);
   int highest_bar_back = iHighest(Symbol(),PERIOD_CURRENT,MODE_HIGH,start_candle.index-end_candle.index,end_candle.index);

// add_log(start_candle.index+" "+end_candle.index+ " "+lowest_bar_back+ " "+highest_bar_back);

   double price2=iHigh(Symbol(),PERIOD_CURRENT,highest_bar_back);
   double price1=iLow(Symbol(),PERIOD_CURRENT,lowest_bar_back);

   double buff = ((price2-price1)/100)*cs.buffer_percent;

   price2+=buff;
   price1-=buff;

   if(!ObjectCreate(0,internal_name,OBJ_RECTANGLE,0,time1,price1,time2,price2))
     {
      Print(__FUNCTION__+": failed to create a rectangle! Error code = "+IntegerToString(GetLastError()));
     }
   color shape_col = cs.bearish_fill_colour;
   if(bullish)
      shape_col = cs.bullish_fill_colour;
   ObjectSetInteger(0,internal_name,OBJPROP_COLOR,shape_col);
   ObjectSetInteger(0,internal_name,OBJPROP_STYLE,STYLE_SOLID);
   ObjectSetInteger(0,internal_name,OBJPROP_WIDTH,2);

   ObjectSetInteger(0,internal_name,OBJPROP_FILL,fill);
   if(!fill)
      ObjectSetInteger(0,internal_name,OBJPROP_BACK,false);
   else
      ObjectSetInteger(0,internal_name,OBJPROP_BACK,true);

   ObjectSetInteger(0,internal_name,OBJPROP_SELECTABLE,false);
   ObjectSetInteger(0,internal_name,OBJPROP_SELECTED,false);
   ObjectSetInteger(0,internal_name,OBJPROP_HIDDEN,false);
   ObjectSetInteger(0,internal_name,OBJPROP_ZORDER,0);
   if(text!="")
     {
      double text_price=price1;
      if(bullish)
         text_price=price2;

      color txt_colour = shape_col;
      if(fill)
         txt_colour = cs.text_color;

      text_label(
         text,
         start_candle.time,
         text_price,
         txt_colour,
         cs.text_font,
         cs.text_size
      );
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double ohlc::high(int shift=0)
  {
   return iHigh(Symbol(),tf,shift);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double ohlc::low(int shift=0)
  {
   return iLow(Symbol(),tf,shift);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double ohlc::open(int shift=0)
  {
   return iOpen(Symbol(),tf,shift);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double ohlc::close(int shift=0)
  {
   return iClose(Symbol(),tf,shift);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double ohlc::highest(int lookback)
  {
   int shift = iHighest(Symbol(), tf, MODE_HIGH, lookback);
   return high(shift);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double ohlc::lowest(int lookback)
  {
   int shift = iLowest(Symbol(), tf, MODE_LOW, lookback);
   return low(shift);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool ohlc::bullish(int shift=0)
  {
   return close(shift) > open(shift);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool ohlc::bearish(int shift=0)
  {
   return close(shift) < open(shift);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double ohlc::full_size_pips(int shift=0)
  {
   return (high(shift) - low(shift)) / pip;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double ohlc::body_size_pips(int shift=0)
  {
   if(bullish(shift))
      return (close(shift) - open(shift)) / pip;
   else
      return (open(shift) - close(shift)) / pip;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double ohlc::upper_wick_pips(int shift=0)
  {
   if(bullish(shift))
      return (high(shift) - close(shift)) / pip;
   else
      return (high(shift) - open(shift)) / pip;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double ohlc::lower_wick_pips(int shift=0)
  {
   if(bullish(shift))
      return (open(shift) - low(shift)) / pip;
   else
      return (close(shift) - low(shift)) / pip;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double ohlc::full_size_percent(int shift=0)
  {
   return 100;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double ohlc::body_size_percent(int shift=0)
  {
   return (body_size_pips(shift) / full_size_pips(shift)) * 100.0;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double ohlc::upper_wick_percent(int shift=0)
  {
   return (upper_wick_pips(shift) / full_size_pips(shift)) * 100.0;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double ohlc::lower_wick_percent(int shift=0)
  {
   return (lower_wick_pips(shift) / full_size_pips(shift)) * 100.0;
  }

struct ap_candle
  {
   ohlc              current;
   ohlc              daily;
   ohlc              weekly;
   ohlc              monthly;

   ohlc              hour_1;
   ohlc              hour_2;
   ohlc              hour_3;
   ohlc              hour_4;
   ohlc              hour_8;
   ohlc              hour_12;


   ohlc              minute_1;
   ohlc              minute_3;

   ohlc              minute_5;
   ohlc              minute_15;
   ohlc              minute_30;
  };


ap_candle candle;
void init_candles()
  {
   candle.current.tf = PERIOD_CURRENT;
   candle.daily.tf = PERIOD_D1;
   candle.weekly.tf= PERIOD_W1;
   candle.monthly.tf =PERIOD_MN1;

   candle.hour_1.tf = PERIOD_H1;
   candle.hour_2.tf = PERIOD_H2;
   candle.hour_3.tf = PERIOD_H3;
   candle.hour_4.tf = PERIOD_H4;
   candle.hour_8.tf = PERIOD_H8;
   candle.hour_12.tf = PERIOD_H12;

   candle.minute_1.tf = PERIOD_M1;
   candle.minute_5.tf = PERIOD_M5;
   candle.minute_15.tf = PERIOD_M15;
   candle.minute_30.tf = PERIOD_M30;
   candle.minute_3.tf = PERIOD_M3;
   pip = get_pip_value();

  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool new_candle(ENUM_TIMEFRAMES timeframe=PERIOD_CURRENT)
  {
   datetime current_time = iTime(Symbol(), timeframe, 0);
   if(timeframe == PERIOD_CURRENT)
     {
      static datetime previous_time = 0;
      if(previous_time != current_time)
        {
         previous_time = current_time;
         return true;
        }
     }

   if(timeframe == PERIOD_M1)
     {
      static datetime m1_previous_time = 0;
      if(m1_previous_time != current_time)
        {
         m1_previous_time = current_time;
         return true;
        }
     }
   if(timeframe == PERIOD_M2)
     {
      static datetime m2_previous_time = 0;
      if(m2_previous_time != current_time)
        {
         m2_previous_time = current_time;
         return true;
        }
     }
   if(timeframe == PERIOD_M3)
     {
      static datetime m3_previous_time = 0;
      if(m3_previous_time != current_time)
        {
         m3_previous_time = current_time;
         return true;
        }
     }
   if(timeframe == PERIOD_M4)
     {
      static datetime m4_previous_time = 0;
      if(m4_previous_time != current_time)
        {
         m4_previous_time = current_time;
         return true;
        }
     }
   if(timeframe == PERIOD_M5)
     {
      static datetime m5_previous_time = 0;
      if(m5_previous_time != current_time)
        {
         m5_previous_time = current_time;
         return true;
        }
     }
   if(timeframe == PERIOD_M6)
     {
      static datetime m6_previous_time = 0;
      if(m6_previous_time != current_time)
        {
         m6_previous_time = current_time;
         return true;
        }
     }
   if(timeframe == PERIOD_M10)
     {
      static datetime m10_previous_time = 0;
      if(m10_previous_time != current_time)
        {
         m10_previous_time = current_time;
         return true;
        }
     }
   if(timeframe == PERIOD_M12)
     {
      static datetime m12_previous_time = 0;
      if(m12_previous_time != current_time)
        {
         m12_previous_time = current_time;
         return true;
        }
     }
   if(timeframe == PERIOD_M15)
     {
      static datetime m15_previous_time = 0;
      if(m15_previous_time != current_time)
        {
         m15_previous_time = current_time;
         return true;
        }
     }
   if(timeframe == PERIOD_M20)
     {
      static datetime m20_previous_time = 0;
      if(m20_previous_time != current_time)
        {
         m20_previous_time = current_time;
         return true;
        }
     }
   if(timeframe == PERIOD_M30)
     {
      static datetime m30_previous_time = 0;
      if(m30_previous_time != current_time)
        {
         m30_previous_time = current_time;
         return true;
        }
     }
   if(timeframe == PERIOD_H1)
     {
      static datetime h1_previous_time = 0;
      if(h1_previous_time != current_time)
        {
         h1_previous_time = current_time;
         return true;
        }
     }
   if(timeframe == PERIOD_H2)
     {
      static datetime h2_previous_time = 0;
      if(h2_previous_time != current_time)
        {
         h2_previous_time = current_time;
         return true;
        }
     }
   if(timeframe == PERIOD_H3)
     {
      static datetime h3_previous_time = 0;
      if(h3_previous_time != current_time)
        {
         h3_previous_time = current_time;
         return true;
        }
     }
   if(timeframe == PERIOD_H4)
     {
      static datetime h4_previous_time = 0;
      if(h4_previous_time != current_time)
        {
         h4_previous_time = current_time;
         return true;
        }
     }
   if(timeframe == PERIOD_H6)
     {
      static datetime h6_previous_time = 0;
      if(h6_previous_time != current_time)
        {
         h6_previous_time = current_time;
         return true;
        }
     }
   if(timeframe == PERIOD_H8)
     {
      static datetime h8_previous_time = 0;
      if(h8_previous_time != current_time)
        {
         h8_previous_time = current_time;
         return true;
        }
     }
   if(timeframe == PERIOD_H12)
     {
      static datetime h12_previous_time = 0;
      if(h12_previous_time != current_time)
        {
         h12_previous_time = current_time;
         return true;
        }
     }
   if(timeframe == PERIOD_D1)
     {
      static datetime d1_previous_time = 0;
      if(d1_previous_time != current_time)
        {
         d1_previous_time = current_time;
         return true;
        }
     }
   if(timeframe == PERIOD_W1)
     {
      static datetime w1_previous_time = 0;
      if(w1_previous_time != current_time)
        {
         w1_previous_time = current_time;
         return true;
        }
     }
   if(timeframe == PERIOD_MN1)
     {
      static datetime mn1_previous_time = 0;
      if(mn1_previous_time != current_time)
        {
         mn1_previous_time = current_time;
         return true;
        }
     }

   return false;
  }
//+------------------------------------------------------------------+
