//+------------------------------------------------------------------+
//|                                                      ap_macd.mqh |
//|                                  Copyright 2023, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, MetaQuotes Ltd."
#property link      "https://www.mql5.com"

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class MACD
  {
public:
   double            main_value(int index=1);
   double            signal_value(int index=1);
   bool              downtrend();
   bool              uptrend();
   bool              strong_uptrend();
   bool              strong_downtrend();
   bool uptrend_to_downtrend();
   bool downtrend_to_uptrend();


   int               macd_handle;

   void              macd(ENUM_TIMEFRAMES _timeframe,
                          int _fast_ema,
                          int _slow_ema,
                          int _signal_period,
                          ENUM_APPLIED_PRICE _applied_price = PRICE_CLOSE,
                          string _symbol=""
                         );

   string            symbol;
   ENUM_TIMEFRAMES   timeframe;
   int               fast_ema;
   int               slow_ema;
   int               signal_period;
   ENUM_APPLIED_PRICE applied_price;





  };

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void MACD::macd(ENUM_TIMEFRAMES _timeframe,
                int _fast_ema,
                int _slow_ema,
                int _signal_period,
                ENUM_APPLIED_PRICE _applied_price=PRICE_CLOSE,
                string _symbol="")
  {
   if(_symbol == "")
      symbol = _Symbol;
   else
      symbol = _symbol;
   timeframe = _timeframe;
   fast_ema = _fast_ema;
   slow_ema = _slow_ema;
   signal_period = _signal_period;
   applied_price = _applied_price;

   macd_handle = iMACD(symbol,timeframe,fast_ema,slow_ema,signal_period,applied_price);


  }



//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double MACD::main_value(int index=1)
  {
   double main_array[];
   ArraySetAsSeries(main_array,true);
   CopyBuffer(macd_handle,MAIN_LINE,0,5,main_array);
   return NormalizeDouble(main_array[index],6);

  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double MACD::signal_value(int index=1)
  {
   double signal_array[];
   ArraySetAsSeries(signal_array,true);
   CopyBuffer(macd_handle,SIGNAL_LINE,0,5,signal_array);
   return NormalizeDouble(signal_array[index],6);

  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool MACD::downtrend()
  {

   double signal = signal_value();
   double main = main_value();
   if(main< signal)
      return true;
   return false;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool MACD::uptrend()
  {

   double signal = signal_value();
   double main = main_value();
   if(main> signal)
      return true;
   return false;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool MACD::strong_downtrend()
  {

   double signal = signal_value();
   double main = main_value();
   if(main< signal
      && main <0
      && signal<0
     )
      return true;
   return false;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool MACD::strong_uptrend()
  {

   double signal = signal_value();
   double main = main_value();
   if(main> signal
      &&main >0
      &&signal>0
     )
      return true;
   return false;
  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool MACD::uptrend_to_downtrend()
  {
   double signal = signal_value(1);
   double main = main_value(1);

   double previous_signal = signal_value(2);
   double previous_main = main_value(2);

   if(previous_main>previous_signal && main < signal)
      {return true;}

   return false;


  }
  
bool MACD::downtrend_to_uptrend()
  {
   double signal = signal_value(1);
   double main = main_value(1);

   double previous_signal = signal_value(2);
   double previous_main = main_value(2);

   if(previous_main<previous_signal && main > signal)
      {return true;}

   return false;


  }
//+------------------------------------------------------------------+
