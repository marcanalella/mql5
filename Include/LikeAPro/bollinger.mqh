//+-----------------------------------------------------------------------+
//|                                                                       |
//+-----------------------------------------------------------------------+
//  ____        _ _ _                         ____                  _     
// | __ )  ___ | | (_)_ __   __ _  ___ _ __  | __ )  __ _ _ __   __| |___ 
// |  _ \ / _ \| | | | '_ \ / _` |/ _ \ '__| |  _ \ / _` | '_ \ / _` / __|
// | |_) | (_) | | | | | | | (_| |  __/ |    | |_) | (_| | | | | (_| \__ \
// |____/ \___/|_|_|_|_| |_|\__, |\___|_|    |____/ \__,_|_| |_|\__,_|___/

//+-----------------------------------------------------------------------+
//|                 WELCOME TO THE CLASS!                                 |
//+-----------------------------------------------------------------------+
class Bollinger
  {
public:
   double            upper_band_value(int index=1);
   double            lower_band_value(int index=1);
   double            middle_band_value(int index=1);

   bool              is_above_upper();
   bool              is_below_lower();
   bool              upper_crossover(int index=1);
   bool              lower_crossover(int index=1);



   ENUM_TIMEFRAMES   timeframe;
   int               period;
   double            deviation;
   int               shift;
   ENUM_APPLIED_PRICE applied_price;
   string            symbol;

   int               bollinger_handle;

   void              band(
      ENUM_TIMEFRAMES   _timeframe,
      int               _period,
      double            _deviation,
      int               _shift,
      ENUM_APPLIED_PRICE _applied_price,
      string            _symbol=""
   );

  };



//+------------------------------------------------------------------+
//|               INITIALISE THE BOLLINGER BAND CLASS                |
//+------------------------------------------------------------------+
void Bollinger::band(
   ENUM_TIMEFRAMES _timeframe,
   int _period,
   double _deviation,
   int _shift,
   ENUM_APPLIED_PRICE _applied_price,
   string _symbol=""
)
  {
   if(_symbol == "")
     {
      symbol = _Symbol;
     }
   else
     {
      symbol = _symbol;
     }
   timeframe = _timeframe;
   period = _period;
   deviation = _deviation;
   shift = _shift;
   applied_price = _applied_price;

   bollinger_handle = iBands(symbol,timeframe,period,shift,deviation,applied_price);


  }
//+------------------------------------------------------------------+
//|                 RETURN THE LOWER BAND VALUE                      |
//+------------------------------------------------------------------+
double Bollinger::lower_band_value(int index=1)
  {
   double lower_band_array[];
   CopyBuffer(bollinger_handle,LOWER_BAND,0,index+1,lower_band_array);
   ArraySetAsSeries(lower_band_array,true);
   return NormalizeDouble(lower_band_array[index],_Digits);

  }

//+------------------------------------------------------------------+
//|                  RETURN THE UPPER BAND VALUE                     |
//+------------------------------------------------------------------+
double Bollinger::upper_band_value(int index=1)
  {
   double upper_band_array[];
   CopyBuffer(bollinger_handle,UPPER_BAND,0,index+1,upper_band_array);
   ArraySetAsSeries(upper_band_array,true);
   return NormalizeDouble(upper_band_array[index],_Digits);

  }
//+------------------------------------------------------------------+


//+------------------------------------------------------------------+
//|                 RETURN THE MIDDLE BAND VALUE                     |
//+------------------------------------------------------------------+
double Bollinger::middle_band_value(int index=1)
  {
   double middle_band_array[];
   CopyBuffer(bollinger_handle,BASE_LINE,0,index+1,middle_band_array);
   ArraySetAsSeries(middle_band_array,true);
   return NormalizeDouble(middle_band_array[index],_Digits);

  }


//+------------------------------------------------------------------+
//|                 RETURN THE AVERAGE PRICE                         |
//+------------------------------------------------------------------+
double get_the_price()
  {
   double ask = SymbolInfoDouble(_Symbol,SYMBOL_ASK);
   double bid = SymbolInfoDouble(_Symbol,SYMBOL_BID);
   return NormalizeDouble((ask+bid)/2,_Digits);

  }

//+------------------------------------------------------------------+
//|           RETURN TRUE IF PRICE IS ABOVE UPPER BAND               |
//+------------------------------------------------------------------+
bool Bollinger::is_above_upper()
  {
   double price = get_the_price();
   double upper = upper_band_value();

   if(price>upper)
      return true;
   else
      return false;

  }

//+------------------------------------------------------------------+
//|             RETURN TRUE IF PRICE IS BELOW LOWER BAND             |
//+------------------------------------------------------------------+
bool Bollinger::is_below_lower()
  {
   double price = get_the_price();
   double lower = lower_band_value();

   if(price<lower)
      return true;
   else
      return false;

  }
//+------------------------------------------------------------------+
//|                 RETURN TRUE IF UPPER BAND CROSSOVER              |
//+------------------------------------------------------------------+
bool Bollinger::upper_crossover(int index=1)
  {

   double upper = upper_band_value(index);
   double previous_upper = upper_band_value(index+1);
   double price = get_the_price();
   double previous_price = iClose(_Symbol,PERIOD_CURRENT,index+1);

   if(previous_price<previous_upper && price > upper)
      return true;
   else
      return false;


  }

//+------------------------------------------------------------------+
//|                RETURN TRUE IF LOWER BAND CROSSOVER               |
//+------------------------------------------------------------------+
bool Bollinger::lower_crossover(int index=1)
  {

   double lower = lower_band_value(index);
   double previous_lower = lower_band_value(index+1);
   double price = get_the_price();
   double previous_price = iClose(_Symbol,PERIOD_CURRENT,index+1);

   if(previous_price>previous_lower && price < lower)
      return true;
   else
      return false;


  }
//+------------------------------------------------------------------+
