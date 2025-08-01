//+----------------------------------------------------------------------------------------------------------------------+
//|                                                                                                                      |
//+----------------------------------------------------------------------------------------------------------------------+
//                     █████╗ ██╗      ██████╗  ██████╗ ██████╗ ██████╗  ██████╗     █████╗ ██╗                    
//                    ██╔══██╗██║     ██╔════╝ ██╔═══██╗██╔══██╗██╔══██╗██╔═══██╗   ██╔══██╗██║                    
//                    ███████║██║     ██║  ███╗██║   ██║██████╔╝██████╔╝██║   ██║   ███████║██║                    
//                    ██╔══██║██║     ██║   ██║██║   ██║██╔═══╝ ██╔══██╗██║   ██║   ██╔══██║██║                    
//                    ██║  ██║███████╗╚██████╔╝╚██████╔╝██║     ██║  ██║╚██████╔╝██╗██║  ██║██║                    
//                    ╚═╝  ╚═╝╚══════╝ ╚═════╝  ╚═════╝ ╚═╝     ╚═╝  ╚═╝ ╚═════╝ ╚═╝╚═╝  ╚═╝╚═╝                    
//                                                                                                                 
//███╗   ███╗ ██████╗ ██╗   ██╗██╗███╗   ██╗ ██████╗      █████╗ ██╗   ██╗███████╗██████╗  █████╗  ██████╗ ███████╗
//████╗ ████║██╔═══██╗██║   ██║██║████╗  ██║██╔════╝     ██╔══██╗██║   ██║██╔════╝██╔══██╗██╔══██╗██╔════╝ ██╔════╝
//██╔████╔██║██║   ██║██║   ██║██║██╔██╗ ██║██║  ███╗    ███████║██║   ██║█████╗  ██████╔╝███████║██║  ███╗█████╗  
//██║╚██╔╝██║██║   ██║╚██╗ ██╔╝██║██║╚██╗██║██║   ██║    ██╔══██║╚██╗ ██╔╝██╔══╝  ██╔══██╗██╔══██║██║   ██║██╔══╝  
//██║ ╚═╝ ██║╚██████╔╝ ╚████╔╝ ██║██║ ╚████║╚██████╔╝    ██║  ██║ ╚████╔╝ ███████╗██║  ██║██║  ██║╚██████╔╝███████╗
//╚═╝     ╚═╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝  ╚═══╝ ╚═════╝     ╚═╝  ╚═╝  ╚═══╝  ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝ ╚══════╝
//                                                                                                                
//                                            ██████╗     ██████╗                                                  
//                                            ╚════██╗   ██╔═████╗                                                 
//                                             █████╔╝   ██║██╔██║                                                 
//                                            ██╔═══╝    ████╔╝██║                                                 
//                                            ███████╗██╗╚██████╔╝                                                 
//                                            ╚══════╝╚═╝ ╚═════╝  
//+----------------------------------------------------------------------------------------------------------------------+
//|                                                                                                                      |
//+----------------------------------------------------------------------------------------------------------------------+
                                          
#include <LikeAPro/shapes.mqh>
datetime ma_current_candle_datetime;
datetime ma_previous_candle_datetime;
//+------------------------------------------------------------------+
//|       SPLIT THE PERIODS FROM A STRING                            |
//+------------------------------------------------------------------+
void ma_string_split(string periods, int &period_array[])
  {
   string temp_string_array[];
   ArrayFree(period_array);
   StringSplit(periods,StringGetCharacter(",",0),temp_string_array);
   for(int i=0; i<ArraySize(temp_string_array); i++)
     {
      ArrayResize(period_array,ArraySize(period_array)+1);
      period_array[ArraySize(period_array)-1] = (int)StringToInteger(temp_string_array[i]);

     }
  }
//+------------------------------------------------------------------+
//|          MOVING AVERAGE CLASS                                    |
//+------------------------------------------------------------------+
class MovingAverage
  {
public:
   void              init(ENUM_MA_METHOD _ma_type,ENUM_APPLIED_PRICE _applied_price, ENUM_TIMEFRAMES _timeframe);
   void              add_ma(int period);
   ENUM_MA_METHOD    ma_type;
   ENUM_APPLIED_PRICE applied_price;
   ENUM_TIMEFRAMES   timeframe;
   int               ma[];
   double            get_ma_value(int period,int index=0);
   bool              allow_bullish_signals;
   bool              allow_bearish_signals;
   bool              is_bullish();
   bool              is_bearish();
   int               highest_period;
   bool              bullish_crossover();
   bool              bearish_crossover();
  };


//+------------------------------------------------------------------+
//|               INITIALISE FIRST                                   |
//+------------------------------------------------------------------+
void MovingAverage::init(ENUM_MA_METHOD _ma_type=MODE_EMA,ENUM_APPLIED_PRICE _applied_price= PRICE_CLOSE, ENUM_TIMEFRAMES _timeframe= PERIOD_CURRENT)
  {
   ma_type=_ma_type;
   applied_price = _applied_price;
   timeframe=_timeframe;
  }

//+------------------------------------------------------------------+
//|              ADD MA TO LIST FOR MAs WE ARE WATCHING              |
//+------------------------------------------------------------------+
void MovingAverage::add_ma(int period)
  {
   ArrayResize(ma,ArraySize(ma)+1);
   ma[ArraySize(ma)-1]=period;
   ArraySort(ma);
   highest_period=ma[ArraySize(ma)-1];
  }
//+------------------------------------------------------------------+
//|              GET MA VALUE FROM MT5                               |
//+------------------------------------------------------------------+

double MovingAverage::get_ma_value(int period,int index=0)
  {
   int ma_handle = iMA(_Symbol,timeframe,period,0,ma_type,applied_price);
   double ma_array[];
   CopyBuffer(ma_handle, 0, 0, highest_period, ma_array);
   ArraySetAsSeries(ma_array, true);
   return ma_array[index];
  }

//+------------------------------------------------------------------+
//|            IS NEW CANDLE                                         |
//+------------------------------------------------------------------+
bool ma_new_candle_check()
  {
   ma_current_candle_datetime = iTime(Symbol(), Period(), 0);
   if(ma_current_candle_datetime == ma_previous_candle_datetime)
      return false;
   ma_previous_candle_datetime = ma_current_candle_datetime;
   return true;
  }

//+------------------------------------------------------------------+
//|            ARE MAs BULLISH                                       |
//+------------------------------------------------------------------+
bool MovingAverage::is_bullish()
  {
   double previous_value =0;
   double price = SymbolInfoDouble(_Symbol,SYMBOL_ASK);
   for(int i=ArraySize(ma)-1; i>=0; i--)
     {
      double ma_value = get_ma_value(ma[i]);
      if(ma_value>previous_value)
        {
         previous_value = ma_value;
         continue;
        }
      else
         return false;
     }
   return true;
  }
//+------------------------------------------------------------------+
//|            MA BULLISH CROSSOVER                                  |
//+------------------------------------------------------------------+
bool MovingAverage::bullish_crossover()
  {
   if(ArraySize(ma)==1)
     {
      double price = iClose(_Symbol,timeframe,0);
      double previous_price = iOpen(_Symbol,timeframe,1);
      double ma_value = get_ma_value(ma[0],1);
      double previous_ma_value = get_ma_value(ma[0],2);
      if(price>ma_value&&previous_price<previous_ma_value)
         return true;
      return false;
     }
   if(ArraySize(ma)==2)
     {
      double fast_ma = get_ma_value(ma[0],1);
      double previous_fast_ma = get_ma_value(ma[0],2);
      double slow_ma = get_ma_value(ma[1],1);
      double previous_slow_ma = get_ma_value(ma[1],2);
      if(fast_ma>slow_ma && previous_fast_ma<previous_slow_ma)
         return true;
      return false;
     }
   return false;
  }
//+------------------------------------------------------------------+
//|             MA BEARISH CROSSOVER                                 |
//+------------------------------------------------------------------+
bool MovingAverage::bearish_crossover()
  {
   if(ArraySize(ma)==1)
     {
      double price = iClose(_Symbol,timeframe,0);
      double previous_price = iOpen(_Symbol,timeframe,1);
      double ma_value = get_ma_value(ma[0],1);
      double previous_ma_value = get_ma_value(ma[0],2);
      if(price<ma_value&&previous_price>previous_ma_value)
         return true;
      return false;
     }
   if(ArraySize(ma)==2)
     {
      double fast_ma = get_ma_value(ma[0],1);
      double previous_fast_ma = get_ma_value(ma[0],2);
      double slow_ma = get_ma_value(ma[1],1);
      double previous_slow_ma = get_ma_value(ma[1],2);
      if(fast_ma<slow_ma && previous_fast_ma>previous_slow_ma)
         return true;
      return false;
     }
   return false;
  }
//+------------------------------------------------------------------+
//|               ARE MAs BEARISH                                    |
//+------------------------------------------------------------------+
bool MovingAverage::is_bearish()
  {
   double previous_value =99999999;
   double price = SymbolInfoDouble(_Symbol,SYMBOL_ASK);
   for(int i=ArraySize(ma)-1; i>=0; i--)
     {
      double ma_value = get_ma_value(ma[i]);
      if(ma_value<previous_value)
        {
         previous_value = ma_value;
         continue;
        }
      else
         return false;
     }
   return true;
  }
