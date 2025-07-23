//+------------------------------------------------------------------+
//|                                                      ProjectName |
//|                                      Copyright 2020, CompanyName |
//|                                       http://www.companyname.net |
//+------------------------------------------------------------------+
double BUFFER_PERCENT = 20;
color BULLISH_FILL_COLOUR = clrDarkGreen;
color BEARISH_FILL_COLOUR = clrDarkRed;
color TEXT_COLOUR = clrBlack;
string TEXT_FONT = "Arial Bold";
int TEXT_SIZE = 10;

double pip = 1;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void highlight_candle(
   int index,
   bool bullish,
   bool fill
)
  {
   datetime start_time = iTime(Symbol(),PERIOD_CURRENT,index);
   string internal_name = TimeToString(start_time);

   datetime time1=iTime(_Symbol,PERIOD_CURRENT,index+1);
   datetime time2=iTime(_Symbol,PERIOD_CURRENT,index-1);

   double candle_high = iHigh(Symbol(),PERIOD_CURRENT,index);
   double candle_low = iLow(Symbol(),PERIOD_CURRENT,index);
   double buff = ((candle_high-candle_low)/100)*BUFFER_PERCENT;

   double price1=candle_low - buff;
   double price2=candle_high + buff;

   if(!ObjectCreate(0,internal_name,OBJ_RECTANGLE,0,time1,price1,time2,price2))
     {
      Print(__FUNCTION__+": failed to create a rectangle! Error code = "+IntegerToString(GetLastError()));
     }
   color shape_col = BEARISH_FILL_COLOUR;
   if(bullish)
      shape_col = BULLISH_FILL_COLOUR;
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
  }

//+------------------------------------------------------------------+
//|  HIGHLIGHT MORE THAN ONE CANDLE WITH A START & END CANDLE        |
//+------------------------------------------------------------------+
void highlight_candles(
   int index_1,
   int index_2,
   bool bullish,
   bool fill
)
  {
   int start_index = index_1;
   int end_index = index_2;

   if(start_index<end_index)
     {
      start_index = index_2;
      end_index= index_1;
     }

   datetime start_time = iTime(Symbol(),PERIOD_CURRENT,start_index);
   string internal_name = TimeToString(start_time);
   datetime time1=iTime(_Symbol,PERIOD_CURRENT,start_index+1);
   datetime time2=iTime(_Symbol,PERIOD_CURRENT,end_index-1);
   if(end_index==0)
      time2 = TimeCurrent();

   int lowest_bar_back = iLowest(Symbol(),PERIOD_CURRENT,MODE_LOW,start_index-end_index+1,end_index);
   int highest_bar_back = iHighest(Symbol(),PERIOD_CURRENT,MODE_HIGH,start_index-end_index+1,end_index);

   double price2=iHigh(Symbol(),PERIOD_CURRENT,highest_bar_back);
   double price1=iLow(Symbol(),PERIOD_CURRENT,lowest_bar_back);

   double buff = ((price2-price1)/100)*BUFFER_PERCENT;

   price2+=buff;
   price1-=buff;

   if(!ObjectCreate(0,internal_name,OBJ_RECTANGLE,0,time1,price1,time2,price2))
     {
      Print(__FUNCTION__+": failed to create a rectangle! Error code = "+IntegerToString(GetLastError()));
     }
   color shape_col = BEARISH_FILL_COLOUR;
   if(bullish)
      shape_col = BULLISH_FILL_COLOUR;
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

  }

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
//|                                                                  |
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

                     Candle(int _index,bool load_full = false);

   candlestick_metadata meta;
  };

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Candle::Candle(int _index, bool load_full = false)
  {
   index = _index;
   open = NormalizeDouble(iOpen(Symbol(),PERIOD_CURRENT,index),_Digits);
   close = NormalizeDouble(iClose(Symbol(),PERIOD_CURRENT,index),_Digits);
   high= NormalizeDouble(iHigh(Symbol(),PERIOD_CURRENT,index),_Digits);
   low = NormalizeDouble(iLow(Symbol(),PERIOD_CURRENT,index),_Digits);


   time = iTime(Symbol(),PERIOD_CURRENT,index);

   if(load_full==true)
     {
      meta.upper_wick_pips = 0;
      meta.lower_wick_pips= 0;
      meta.upper_wick_percent =0;
      meta.lower_wick_percent = 0;
      meta.body_size_percent =0;
      meta.body_size_pips=0;
      meta.bullish=false;
      meta.bearish = false;

      if(open>close)
        {
         meta.bearish = true;
         meta.body_size_pips = (open-close)/ pip;
         meta.upper_wick_pips = (high-open)/pip;
         meta.lower_wick_pips = (close-low)/pip;
        }
      if(open<close)
        {
         meta.bullish = true;
         meta.body_size_pips = (close-open)/pip;
         meta.upper_wick_pips = (high-close) / pip;
         meta.lower_wick_pips = (open-low)/ pip;
        }
      meta.full_size_pips = (high-low) / pip;
      meta.body_size_percent = (meta.body_size_pips / meta.full_size_pips)*100;
      meta.upper_wick_percent = (meta.upper_wick_pips/meta.full_size_pips)*100;
      meta.lower_wick_percent = (meta.lower_wick_pips/meta.full_size_pips)*100;
     }

  }
//+------------------------------------------------------------------+
