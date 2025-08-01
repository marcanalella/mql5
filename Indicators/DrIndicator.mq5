//+------------------------------------------------------------------+
//|                                                 DR/DRI Indicator |
//|                                  Copyright 2025, Mario Canalella |
//|                    http://www.https://mariocanalella.netlify.app |
//+------------------------------------------------------------------+
#property indicator_chart_window
#property indicator_plots 0

#property copyright "Mario Canalella"
#property link      "https://mariocanalella.netlify.app"
#property version   "1.00"


enum DrType {
   ADR = 1,
   RDR = 2,
   ODR = 3,
};

input DrType drType = RDR; //DR TYPE
input color IDR_Box_Color = clrGray;
input color DR_High_Color = clrBlue;
input color DR_Low_Color = clrOrange;
input color Fib_Color = clrMagenta;
input bool Show_Fib_Inside_IDR = true;
input bool Show_Fib_Extensions = true;
input int Fib_Extension_Steps = 6; // e.g., up to +3 and -3 in 0.5 steps
double idrHigh = -DBL_MAX, idrLow = DBL_MAX;
double drHigh = -DBL_MAX, drLow = DBL_MAX;
int IDR_Start_Hour = 10;
int IDR_Start_Minute = 30;
int IDR_End_Hour = 11;
int IDR_End_Minute = 30;
int DR_Line_End_Hour = 15;
int DR_Line_End_Minute = 30;


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OnInit() {
   setRange(drType);
   return INIT_SUCCEEDED;
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[]) {
   datetime today = TimeCurrent() - TimeCurrent() % 86400;
   datetime sessionStart = today + IDR_Start_Hour * 3600 + IDR_Start_Minute * 60;
   datetime sessionEnd = today + IDR_End_Hour * 3600 + IDR_End_Minute * 60;
   idrHigh = -DBL_MAX;
   idrLow = DBL_MAX;
   drHigh = -DBL_MAX;
   drLow = DBL_MAX;
   datetime boxStartTime = 0, boxEndTime = 0;
// Draw DR as horizontal trendlines from sessionStart to user-defined DR_Line_End_Hour
   datetime drLineStart = boxStartTime;
   datetime drLineEnd = today + DR_Line_End_Hour * 3600 + DR_Line_End_Minute * 60;
   for (int i = 0; i < rates_total; i++) {
      if (time[i] < sessionStart) continue;
      if (time[i] >= sessionEnd) break;
      double bodyHigh = MathMax(open[i], close[i]);
      double bodyLow = MathMin(open[i], close[i]);
      if (bodyHigh > idrHigh) idrHigh = bodyHigh;
      if (bodyLow < idrLow) idrLow = bodyLow;
      if (high[i] > drHigh) drHigh = high[i];
      if (low[i] < drLow) drLow = low[i];
      if (boxStartTime == 0 || time[i] < boxStartTime) boxStartTime = time[i];
      if (time[i] > boxEndTime) boxEndTime = time[i];
   }
// Draw IDR box
   string boxName = "IDR_Box";
   ObjectCreate(0, boxName, OBJ_RECTANGLE, 0, boxStartTime, idrHigh, boxEndTime, idrLow);
   ObjectSetInteger(0, boxName, OBJPROP_COLOR, IDR_Box_Color);
   ObjectSetInteger(0, boxName, OBJPROP_STYLE, STYLE_SOLID);
   ObjectSetInteger(0, boxName, OBJPROP_WIDTH, 1);
   ObjectSetInteger(0, boxName, OBJPROP_BACK, true);
// Draw DR levels
   DrawHLine("DR_High", boxStartTime, drLineEnd, drHigh, DR_High_Color, "DR High");
   DrawHLine("DR_Low",  boxStartTime, drLineEnd, drLow,  DR_Low_Color,  "DR Low");
// Detect breakout
   bool isLong = (iClose(NULL, PERIOD_CURRENT, 1) > idrHigh);
   bool isShort = (iClose(NULL, PERIOD_CURRENT, 1) < idrLow);
   double fibStart = isLong ? idrHigh : idrLow;
   double fibEnd = isLong ? idrLow : idrHigh;
// Draw Fibs inside IDR
// --- Fibonacci Inside IDR (0 to 1 in 0.1 steps) ---
   if (Show_Fib_Inside_IDR) {
      for (int i = 0; i <= 10; i++) {
         double ratio = i / 10.0;
         double level = fibStart + (fibEnd - fibStart) * ratio;
         string tag = "FibIn_" + IntegerToString(i);
         DrawHLine(tag, boxStartTime, boxStartTime + PeriodSeconds() * 30, level, Fib_Color, "Fib " + DoubleToString(ratio, 1));
      }
   }
// --- Fibonacci Extensions from IDR High/Low (±0.5 steps) ---
   if (Show_Fib_Extensions) {
      double range = MathAbs(idrHigh - idrLow);
      // Above IDR High (+ extensions)
      for (int i = 1; i <= Fib_Extension_Steps; i++) {
         double ext = idrHigh + i * 0.5 * range;
         string tag = "FibExt_Up_" + IntegerToString(i);
         DrawHLine("FibExt_Up_" + IntegerToString(i), boxStartTime, boxStartTime + PeriodSeconds() * 30, ext, Fib_Color, "+Fib " + DoubleToString(i * 0.5, 1));
      }
      // Below IDR Low (- extensions)
      for (int i = 1; i <= Fib_Extension_Steps; i++) {
         double ext = idrLow - i * 0.5 * range;
         string tag = "FibExt_Down_" + IntegerToString(i);
         DrawHLine("FibExt_Down_" + IntegerToString(i), boxStartTime, boxStartTime + PeriodSeconds() * 30, ext, Fib_Color, "-Fib " + DoubleToString(i * 0.5, 1));
      }
   }
   return rates_total;
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void DrawHLine(string name, datetime startTime, datetime endTime, double price, color clr, string labelText) {
// Create horizontal trend line
   ObjectCreate(0, name, OBJ_TREND, 0, startTime, price, endTime, price);
   ObjectSetInteger(0, name, OBJPROP_COLOR, clr);
   ObjectSetInteger(0, name, OBJPROP_STYLE, STYLE_DASH);
   ObjectSetInteger(0, name, OBJPROP_WIDTH, 1);
// Add label at end of the line
   string textName = name + "_Label";
   ObjectCreate(0, textName, OBJ_TEXT, 0, endTime, price);
   ObjectSetInteger(0, textName, OBJPROP_COLOR, clr);
   ObjectSetInteger(0, textName, OBJPROP_FONTSIZE, 8);
   ObjectSetString(0, textName, OBJPROP_TEXT, labelText);
}


//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason) {
   ObjectsDeleteAll(0);
}
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void DrawTrendLine(string name, datetime time1, double price1, datetime time2, double price2, color clr, string label) {
   ObjectCreate(0, name, OBJ_TREND, 0, time1, price1, time2, price2);
   ObjectSetInteger(0, name, OBJPROP_COLOR, clr);
   ObjectSetInteger(0, name, OBJPROP_WIDTH, 1);
   ObjectSetInteger(0, name, OBJPROP_STYLE, STYLE_SOLID);
   string textName = name + "_Label";
   ObjectCreate(0, textName, OBJ_TEXT, 0, time2, price2);
   ObjectSetInteger(0, textName, OBJPROP_COLOR, clr);
   ObjectSetInteger(0, textName, OBJPROP_FONTSIZE, 8);
   ObjectSetString(0, textName, OBJPROP_TEXT, label);
}
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void setRange(DrType type) {
   switch (type) {
   case ODR:
      IDR_Start_Hour = 10;
      IDR_Start_Minute = 0;
      IDR_End_Hour = 11;
      IDR_End_Minute = 0;
      DR_Line_End_Hour = 15;
      DR_Line_End_Minute = 30;
      break;
   case RDR:
      IDR_Start_Hour = 16;
      IDR_Start_Minute = 30;
      IDR_End_Hour = 17;
      IDR_End_Minute = 30;
      DR_Line_End_Hour = 23;
      DR_Line_End_Minute = 30;
      break;
   case ADR:
      IDR_Start_Hour = 03;
      IDR_Start_Minute = 30;
      IDR_End_Hour = 04;
      IDR_End_Minute = 30;
      DR_Line_End_Hour = 8;
      DR_Line_End_Minute = 0;
      break;
   }
}
//+------------------------------------------------------------------+
