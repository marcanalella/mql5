//_____/\\\\\\\\\____        __/\\\\\\\\\\\\\\\_        ____/\\\\\\\\\_____
// ___/\\\\\\\\\\\\\__        _\///////\\\/////__        __/\\\///////\\\___
//  __/\\\/////////\\\_        _______\/\\\_______        _\/\\\_____\/\\\___
//   _\/\\\_______\/\\\_        _______\/\\\_______        _\/\\\\\\\\\\\/____
//    _\/\\\\\\\\\\\\\\\_        _______\/\\\_______        _\/\\\//////\\\____
//     _\/\\\/////////\\\_        _______\/\\\_______        _\/\\\____\//\\\___
//      _\/\\\_______\/\\\_        _______\/\\\_______        _\/\\\_____\//\\\__
//       _\/\\\_______\/\\\_        _______\/\\\_______        _\/\\\______\//\\\_
//       _\///________\///__        _______\///________        _\///________\///__
//+------------------------------------------------------------------+
//| ATR CLASS                                                        |
//+------------------------------------------------------------------+
class ap_atr
  {
public:
   ENUM_TIMEFRAMES   tf;

   int               atr_handle(int ma_period);
   double            value(int ma_period);

   double            current(int period);
   double            daily(int period);
   double            weekly(int period);
   double            monthly(int period);
   double            hour_1(int period);
   double            hour_2(int period);
   double            hour_3(int period);
   double            hour_4(int period);
   double            hour_8(int period);
   double            hour_12(int period);
   double            minute_3(int period);
   double            minute_1(int period);
   double            minute_5(int period);
   double            minute_15(int period);
   double            minute_30(int period);


  };
//+------------------------------------------------------------------+
//|   GET PIP VALUE                                                  |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double get_pip_value_()
  {
   if(_Digits==3 || _Digits == 5)
      return 10*_Point;
   else
      return _Point;
  }
//+------------------------------------------------------------------+
//| GET ATR HANDLE                                                   |
//+------------------------------------------------------------------+
int ap_atr::atr_handle(int ma_period)
  {
   return iATR(_Symbol, tf, ma_period);
  }



//+------------------------------------------------------------------+
//| GET ATR VALUE IN PIPS                                            |
//+------------------------------------------------------------------+
double ap_atr::value(int ma_period)
  {
   double atr_array[];
   int handle = iATR(_Symbol,tf,ma_period);
   ArraySetAsSeries(atr_array,true);
   CopyBuffer(handle,0,0,3,atr_array);
   return NormalizeDouble(atr_array[0]/get_pip_value_(),1);
  }




//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double ap_atr::current(int period)
  {
   return atr_tf.current.value(period);
  }
//+------------------------------------------------------------------+
//| GET ATR VALUE IN PIPS FOR DAILY TIMEFRAME                        |
//+------------------------------------------------------------------+
double ap_atr::daily(int period)
  {
   return atr_tf.daily.value(period);
  }

//+------------------------------------------------------------------+
//| GET ATR VALUE IN PIPS FOR WEEKLY TIMEFRAME                       |
//+------------------------------------------------------------------+
double ap_atr::weekly(int period)
  {
   return atr_tf.weekly.value(period);
  }

//+------------------------------------------------------------------+
//| GET ATR VALUE IN PIPS FOR MONTHLY TIMEFRAME                      |
//+------------------------------------------------------------------+
double ap_atr::monthly(int period)
  {
   return atr_tf.monthly.value(period);
  }

//+------------------------------------------------------------------+
//| GET ATR VALUE IN PIPS FOR HOUR_1 TIMEFRAME                       |
//+------------------------------------------------------------------+
double ap_atr::hour_1(int period)
  {
   return atr_tf.hour_1.value(period);
  }

//+------------------------------------------------------------------+
//| GET ATR VALUE IN PIPS FOR HOUR_2 TIMEFRAME                       |
//+------------------------------------------------------------------+
double ap_atr::hour_2(int period)
  {
   return atr_tf.hour_2.value(period);
  }

//+------------------------------------------------------------------+
//| GET ATR VALUE IN PIPS FOR HOUR_3 TIMEFRAME                       |
//+------------------------------------------------------------------+
double ap_atr::hour_3(int period)
  {
   return atr_tf.hour_3.value(period);
  }

//+------------------------------------------------------------------+
//| GET ATR VALUE IN PIPS FOR HOUR_4 TIMEFRAME                       |
//+------------------------------------------------------------------+
double ap_atr::hour_4(int period)
  {
   return atr_tf.hour_4.value(period);
  }

//+------------------------------------------------------------------+
//| GET ATR VALUE IN PIPS FOR HOUR_8 TIMEFRAME                       |
//+------------------------------------------------------------------+
double ap_atr::hour_8(int period)
  {
   return atr_tf.hour_8.value(period);
  }

//+------------------------------------------------------------------+
//| GET ATR VALUE IN PIPS FOR HOUR_12 TIMEFRAME                      |
//+------------------------------------------------------------------+
double ap_atr::hour_12(int period)
  {
   return atr_tf.hour_12.value(period);
  }

//+------------------------------------------------------------------+
//| GET ATR VALUE IN PIPS FOR MINUTE_1 TIMEFRAME                     |
//+------------------------------------------------------------------+
double ap_atr::minute_1(int period)
  {
   return atr_tf.minute_1.value(period);
  }

//+------------------------------------------------------------------+
//| GET ATR VALUE IN PIPS FOR MINUTE_3 TIMEFRAME                     |
//+------------------------------------------------------------------+
double ap_atr::minute_3(int period)
  {
   return atr_tf.minute_3.value(period);
  }

//+------------------------------------------------------------------+
//| GET ATR VALUE IN PIPS FOR MINUTE_5 TIMEFRAME                     |
//+------------------------------------------------------------------+
double ap_atr::minute_5(int period)
  {
   return atr_tf.minute_5.value(period);
  }

//+------------------------------------------------------------------+
//| GET ATR VALUE IN PIPS FOR MINUTE_15 TIMEFRAME                    |
//+------------------------------------------------------------------+
double ap_atr::minute_15(int period)
  {
   return atr_tf.minute_15.value(period);
  }

//+------------------------------------------------------------------+
//| GET ATR VALUE IN PIPS FOR MINUTE_30 TIMEFRAME                    |
//+------------------------------------------------------------------+
double ap_atr::minute_30(int period)
  {
   return atr_tf.minute_30.value(period);
  }

//+------------------------------------------------------------------+


//+------------------------------------------------------------------+
//|  DECLARE TIMEFRAMES FOR EACH PERIOD                           |
//+------------------------------------------------------------------+
struct ap_atr_timeframes
  {
   ap_atr              current;
   ap_atr              daily;
   ap_atr              weekly;
   ap_atr              monthly;

   ap_atr              hour_1;
   ap_atr              hour_2;
   ap_atr              hour_3;
   ap_atr              hour_4;
   ap_atr              hour_8;
   ap_atr              hour_12;

   ap_atr              minute_1;
   ap_atr              minute_3;

   ap_atr              minute_5;
   ap_atr              minute_15;
   ap_atr              minute_30;
  };


ap_atr_timeframes atr_tf;


//+------------------------------------------------------------------+
//|  INITIALIZE TIMEFRAMES FOR EACH PERIOD                           |
//+------------------------------------------------------------------+
void atr_init_times()
  {
   atr_tf.current.tf = PERIOD_CURRENT;
   atr_tf.daily.tf = PERIOD_D1;
   atr_tf.weekly.tf= PERIOD_W1;
   atr_tf.monthly.tf =PERIOD_MN1;

   atr_tf.hour_1.tf = PERIOD_H1;
   atr_tf.hour_2.tf = PERIOD_H2;
   atr_tf.hour_3.tf = PERIOD_H3;
   atr_tf.hour_4.tf = PERIOD_H4;
   atr_tf.hour_8.tf = PERIOD_H8;
   atr_tf.hour_12.tf = PERIOD_H12;

   atr_tf.minute_1.tf = PERIOD_M1;
   atr_tf.minute_5.tf = PERIOD_M5;
   atr_tf.minute_15.tf = PERIOD_M15;
   atr_tf.minute_30.tf = PERIOD_M30;
   atr_tf.minute_3.tf = PERIOD_M3;
  }


ap_atr atr;
//+------------------------------------------------------------------+
