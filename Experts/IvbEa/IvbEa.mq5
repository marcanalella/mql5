//+------------------------------------------------------------------+
//|                                                   Ivb Model 1 EA |
//|                                  Copyright 2025, Mario Canalella |
//|                                                                  |
//|                               https://mariocanalella.netlify.app |
//+------------------------------------------------------------------+
#property copyright "Mario Canalella"
#property link      "https://mariocanalella.netlify.app"
#property version   "1.00"
#property strict

#include <LikeAPro/dashboard.mqh>
#include <LikeAPro/trade.mqh>

enum RiskMode {
   FIXEDLOT = 0,
   PERCENTRISK = 1
};

enum EntryMode {
   MARKET = 0,
   LIMIT = 1,
   STOP = 2,
   MARKET_AND_LIMIT = 3,
};

enum tpType {
   FIBO100 = 1,
   FIBO200 = 2,
   TP05 = 3,
   TP68 = 4,
   R1R1 = 5,
   R1R2 = 6,
   R1R3 = 7,
};

enum exitMode {
   CLOSE_ALL_AT = 1,
   CLOSE_ALL_IN_PROFIT_AT = 2,
};

input tpType tpTypeSel = FIBO100; // TP
input RiskMode lotMode = FIXEDLOT; // Lot Mode
input EntryMode entryMode = MARKET; // Risk Mode
input exitMode exitModeSel = CLOSE_ALL_AT; // Exit Mode
input double lotSize   = 0.1; // Lot Size
input double riskPercent = 1.0;    // Risk Percent
input bool showDashboard = false; //Show Dashboard

input int startBoxHour = 16; // Start Box Hour
input int startBoxMinute = 30; // Start Box Minute
input int endBoxHour = 17; // End Box Hour
input int endBoxMinute = 4; //End Box Minute close of candle at 17 is at 17:04:59
input int closeHour = 23;
input int closeMinute = 0;
input int magicNum = 12; // Magic Number

input color BoxColor       = clrDodgerBlue;
input color BreakoutColor  = clrRed;
input color ConfirmColor   = clrGreen;
input color EntryLimitColor = clrGold;
input color EntryStopColor  = clrMagenta;
input color SLColor         = clrOrange;

datetime boxStartTime, boxEndTime;
double boxHigh = -DBL_MAX;
double boxLow  = DBL_MAX;
double initialBoxHigh = 0.0;
double initialBoxLow  = 0.0;
bool boxReady = false;
bool breakoutDetected = false;
bool confirmedBreakout = false;
bool ordersPlaced = false;

double breakoutCandleHigh, breakoutCandleLow, breakoutCandleClose, breakoutCandleOpen;
double confirmCandleHigh, confirmCandleLow, candleBeforeconfirmCandleClose;
int breakoutDirection = 0; // 1=LONG, -1=SHORT
datetime lastDay = 0;
double breakoutReferenceLevel = 0.0;
bool breakoutSideIsUp = false;

ap_trade trade();

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OnInit() {

   if(showDashboard) {
      dashboard.init("IVB Model 1 EA - Developed by mariocana", 8, 35,10,20,500,190);
      dashboard.style(14772545,16777215,16119285,0);
      dashboard.add_log("Starting to make money!");
      dashboard.add_log("Server Time " + (string)TimeCurrent());
   }
   return INIT_SUCCEEDED;
}

//+------------------------------------------------------------------+
void OnTick() {
   datetime current = TimeCurrent();
   MqlDateTime timeStruct;
   TimeToStruct(current, timeStruct);

   int currentMinutes = timeStruct.hour * 60 + timeStruct.min;
   int startMinutes   = startBoxHour * 60 + startBoxMinute;
   int endMinutes     = endBoxHour * 60 + endBoxMinute;

   checkNewDay();

   if(!boxReady && currentMinutes >= startMinutes && currentMinutes <= endMinutes) {
      double high = iHigh(_Symbol, PERIOD_M5, 0);
      double low  = iLow(_Symbol, PERIOD_M5, 0);

      if(high > boxHigh) boxHigh = high;
      if(low < boxLow)   boxLow  = low;

      if(boxStartTime == 0) {
         boxStartTime = iTime(_Symbol, PERIOD_M5, 0);
      }
   }

   if(!boxReady && currentMinutes >= endMinutes) {
      boxEndTime = iTime(_Symbol, PERIOD_M5, 0);
      boxReady = true;
      initialBoxHigh = boxHigh;
      initialBoxLow = boxLow;
      drawBox("BoxIniziale", boxStartTime, boxEndTime, boxHigh, boxLow, BoxColor);
      if(showDashboard) {
         dashboard.add_log("box high: " + (string)boxHigh + " - box low: " + (string)boxLow);
      }
   }

   if(boxReady && !breakoutDetected) {
      double close = iClose(_Symbol, PERIOD_M5, 1);
      double high  = iHigh(_Symbol, PERIOD_M5, 1);
      double low   = iLow(_Symbol, PERIOD_M5, 1);
      double open  = iOpen(_Symbol, PERIOD_M5, 1);
      datetime t   = iTime(_Symbol, PERIOD_M5, 1);

      if(close > boxHigh) {
         breakoutDirection = 1;
         breakoutDetected = true;
         breakoutCandleHigh = high;
         breakoutCandleLow  = low;
         breakoutCandleClose = close;
         breakoutCandleOpen  = open;

         breakoutSideIsUp = true;
         breakoutReferenceLevel = high;  // Start reference level as the breakout candle's high
         highlightCandle("BreakoutCandle", t, high, low, BreakoutColor);
      } else if(close < boxLow) {
         breakoutDirection = -1;
         breakoutDetected = true;
         breakoutCandleHigh = high;
         breakoutCandleLow  = low;
         breakoutCandleClose = close;
         breakoutCandleOpen  = open;

         breakoutSideIsUp = false;
         breakoutReferenceLevel = low;   // Start reference level as the breakout candle's low

         highlightCandle("BreakoutCandle", t, high, low, BreakoutColor);
      } else {
         if(high > boxHigh) boxHigh = high;
         if(low < boxLow)   boxLow  = low;
         ObjectDelete(0, "BoxIniziale");
         drawBox("BoxIniziale", boxStartTime, current, boxHigh, boxLow, BoxColor);
      }
   }

// Conferma direzionalità e aggiornamento spike
   if(breakoutDetected && !confirmedBreakout) {
      bool confirmResult = checkBreakoutConfirmation();

      if(confirmResult) {
         datetime t = iTime(_Symbol, PERIOD_M5, 1);
         confirmCandleHigh = iHigh(_Symbol, PERIOD_M5, 1);
         confirmCandleLow  = iLow(_Symbol, PERIOD_M5, 1);

         candleBeforeconfirmCandleClose  = iClose(_Symbol, PERIOD_M5, 2);

         highlightCandle("ConfirmCandle", t, confirmCandleHigh, confirmCandleLow, ConfirmColor);
         confirmedBreakout = true;
         if(showDashboard) {
            dashboard.add_log("Breakout confirmed.");
         }
      }
   }


   if(confirmedBreakout && !ordersPlaced && timeStruct.hour < closeHour) {

      double stopLoss = (breakoutDirection == 1) ? breakoutCandleLow : breakoutCandleHigh;
      drawLine("StopLoss", stopLoss, SLColor);

      if(entryMode  == MARKET || entryMode ==  MARKET_AND_LIMIT) {
         //MARKET
         if(breakoutDirection == 1) {
            placeOrder(ORDER_TYPE_BUY, SymbolInfoDouble(_Symbol, SYMBOL_ASK), stopLoss, true);
         } else {
            placeOrder(ORDER_TYPE_SELL, SymbolInfoDouble(_Symbol, SYMBOL_BID), stopLoss, true);
         }
         ordersPlaced = true;
      }

      if (entryMode  == STOP) { //STOP
         double entryPriceStop  = (breakoutDirection == 1) ? confirmCandleHigh : confirmCandleLow;
         drawLine("EntryStop", entryPriceStop, EntryStopColor);
         if(breakoutDirection == 1) {
            placeOrder(ORDER_TYPE_BUY_STOP, entryPriceStop, stopLoss, false);
         } else {
            placeOrder(ORDER_TYPE_SELL_STOP, entryPriceStop, stopLoss, false);
         }
         ordersPlaced = true;
      }

      if(entryMode == LIMIT || entryMode ==  MARKET_AND_LIMIT) { //LIMIT
         double entryPriceLimit = candleBeforeconfirmCandleClose;
         drawLine("EntryLimit", entryPriceLimit, EntryLimitColor);
         if(breakoutDirection == 1) {
            placeOrder(ORDER_TYPE_BUY_LIMIT, entryPriceLimit, stopLoss, false);
         } else {
            placeOrder(ORDER_TYPE_SELL_LIMIT, entryPriceLimit, stopLoss, false);
         }
         ordersPlaced = true;
      }


   }

   exit();

}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void checkNewDay() {
   datetime now = TimeCurrent();
   MqlDateTime ts;
   TimeToStruct(now, ts);

   datetime todayMidnight;
   StructToTime(ts);
   todayMidnight = now - (ts.hour*3600 + ts.min*60 + ts.sec);

   if (lastDay == 0) {
      lastDay = todayMidnight;
      return;
   }

   if (todayMidnight > lastDay) {
      // New day detected
      lastDay = todayMidnight;

      // Reset everything
      boxStartTime = 0;
      boxEndTime = 0;
      boxHigh = -DBL_MAX;
      boxLow = DBL_MAX;
      boxReady = false;
      breakoutDetected = false;
      confirmedBreakout = false;
      ordersPlaced = false;

      // Remove old objects
      ObjectDelete(0, "BoxIniziale");
      ObjectDelete(0, "BreakoutCandle");
      ObjectDelete(0, "ConfirmCandle");
      ObjectDelete(0, "EntryLimit");
      ObjectDelete(0, "EntryStop");
      ObjectDelete(0, "StopLoss");
      ObjectDelete(0, "TP100");
      ObjectDelete(0, "TP200");
      ObjectDelete(0, "TP50");
      ObjectDelete(0, "TP68");
      ObjectDelete(0, "TP_RR1");
      ObjectDelete(0, "TP_RR2");
      ObjectDelete(0, "TP_RR3");

      if(showDashboard) {
         dashboard.add_log("New trading day detected. State reset.");
      }
   }
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool checkBreakoutConfirmation() {
   datetime prevTime = iTime(_Symbol, PERIOD_M5, 1);
   double prevHigh = iHigh(_Symbol, PERIOD_M5, 1);
   double prevLow = iLow(_Symbol, PERIOD_M5, 1);
   double prevClose = iClose(_Symbol, PERIOD_M5, 1);

   if(breakoutSideIsUp) {

      if(prevClose > breakoutReferenceLevel)
         return true;

      if(prevHigh > breakoutReferenceLevel) {
         breakoutReferenceLevel = prevHigh;
         if(showDashboard) {
            dashboard.add_log("Updated UP reference level to " + (string)breakoutReferenceLevel);
         }
         return false;
      }

   } else {

      if(prevClose < breakoutReferenceLevel) {
         return true;
      }

      if(prevLow < breakoutReferenceLevel) {
         breakoutReferenceLevel = prevLow;
         if(showDashboard) {
            dashboard.add_log("Updated DOWN reference level to " + (string)breakoutReferenceLevel);
         }
         return false;
      }
   }

   return false;
}
//+------------------------------------------------------------------+



//+------------------------------------------------------------------+
//| Funzioni di disegno visuale                                      |
//+------------------------------------------------------------------+
void drawBox(string name, datetime start, datetime end, double high, double low, color col) {
   ObjectCreate(0, name, OBJ_RECTANGLE, 0, start, high, end, low);
   ObjectSetInteger(0, name, OBJPROP_COLOR, col);
   ObjectSetInteger(0, name, OBJPROP_WIDTH, 1);
   ObjectSetInteger(0, name, OBJPROP_STYLE, STYLE_SOLID);
   ObjectSetInteger(0, name, OBJPROP_BACK, true);
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void highlightCandle(string name, datetime time, double high, double low, color col) {
   datetime end = time + PeriodSeconds();
   drawBox(name, time, end, high, low, col);
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void drawLine(string name, double price, color col) {
   ObjectCreate(0, name, OBJ_HLINE, 0, 0, price);
   ObjectSetInteger(0, name, OBJPROP_COLOR, col);
   ObjectSetInteger(0, name, OBJPROP_STYLE, STYLE_DASH);
   ObjectSetInteger(0, name, OBJPROP_WIDTH, 1);
}

//+------------------------------------------------------------------+
//| Funzione per piazzare ordini                                     |
//+------------------------------------------------------------------+
void placeOrder(ENUM_ORDER_TYPE type, double price, double sl, bool isMarket) {
   MqlTradeRequest req;
   MqlTradeResult res;
   ZeroMemory(req);
   ZeroMemory(res);

   if(isMarket) {
      req.action = TRADE_ACTION_DEAL;
   } else {
      req.action = TRADE_ACTION_PENDING;
   }

   double finalLotSize = lotSize;

   if(lotMode == PERCENTRISK) {
      finalLotSize = calculateLotByRisk(price, sl);
   }

   req.symbol = _Symbol;
   req.volume = finalLotSize;
   req.price  = NormalizeDouble(price, _Digits);
   req.sl     = NormalizeDouble(sl, _Digits);
   req.type   = type;
   req.magic  = magicNum;
   req.tp = calculateTPLevels(price, sl);
   if(isMarket) {
      req.type_filling = ORDER_FILLING_IOC;
   } else {
      req.type_filling = ORDER_FILLING_RETURN;
   }
   req.deviation = 10;

   bool send = OrderSend(req, res);
   if(!send || res.retcode != TRADE_RETCODE_DONE)
      if(showDashboard) {
         dashboard.add_log("Errore ordine: " + (string)res.retcode);
      }
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double calculateTPLevels(double entryPrice, double stopLoss) {

   double range = initialBoxHigh - initialBoxLow;
   double risk = MathAbs(entryPrice - stopLoss);

   double tp100 = 0;
   double tp200 = 0;
   double tp50 = 0;
   double tp68 = 0;
   double tpRR1to1 = 0;
   double tpRR1to2  = 0;
   double tpRR1to3  = 0;

   if (breakoutDirection == 1) { // LONG
      tp100     = initialBoxHigh + range;
      tp200     = initialBoxHigh + 2 * range;
      tp50      = initialBoxHigh + (initialBoxHigh * 0.005);
      tp68      = initialBoxHigh + (initialBoxHigh * 0.0068);
      tpRR1to1  = entryPrice + risk;
      tpRR1to2  = entryPrice + (2 * risk);
      tpRR1to3  = entryPrice + (3 * risk);
   } else {
      tp100     = initialBoxLow - range;
      tp200     = initialBoxLow - 2 * range;
      tp50      = initialBoxLow - (initialBoxLow * 0.005);
      tp68      = initialBoxLow - (initialBoxLow * 0.0068);
      tpRR1to1  = entryPrice - risk;
      tpRR1to2  = entryPrice - (2 * risk);
      tpRR1to3  = entryPrice - (3 * risk);
   }

   drawLine("TP100", tp100, clrAqua);
   drawLine("TP200", tp200, clrSkyBlue);
   drawLine("TP50", tp50, clrGreenYellow);
   drawLine("TP68", tp68, clrGreenYellow);
   drawLine("TP_RR1", tpRR1to1, clrRed);
   drawLine("TP_RR2", tpRR1to2, clrRed);
   drawLine("TP_RR3", tpRR1to3, clrRed);

   switch(tpTypeSel) {
   case FIBO100:
      return tp100;
      break;
   case FIBO200:
      return tp200;
      break;
   case TP05:
      return tp50;
      break;
   case TP68:
      return tp68;
      break;
   case R1R1:
      return tpRR1to1;
      break;
   case R1R2:
      return tpRR1to2;
      break;
   case R1R3:
      return tpRR1to3;
      break;
   }

   return 0;
}
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double calculateLotByRisk(double entryPrice, double stopLossPrice) {
   double slPips;
   if(breakoutDirection == 1) {
      slPips = NormalizeDouble((entryPrice - stopLossPrice) / getPipValue(), 1);
   } else {
      slPips = NormalizeDouble((stopLossPrice - entryPrice) / getPipValue(), 1);
   }

   double accountPercent = AccountInfoDouble(ACCOUNT_BALANCE) / 100.0;
   double risk = accountPercent * riskPercent;
   double size = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_VALUE);
   double result = NormalizeDouble(((risk / slPips) / size) / 10, 2);
   return result;
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void exit() {
   MqlDateTime timeEa;
   TimeCurrent(timeEa);
   switch(exitModeSel) {
   case CLOSE_ALL_AT:
      if(timeEa.hour == closeHour && timeEa.min >= closeMinute) {
         closeAll();
      }
      break;
   case CLOSE_ALL_IN_PROFIT_AT:
      if(timeEa.hour == closeHour && timeEa.min >= closeMinute) {
         trade.close_all_winning_trades(magicNum);
         closePendingOrders();
      }
      break;
   }
}
//+------------------------------------------------------------------+
void closePendingOrders() {
   trade.cancel_all_buy_stop_orders(magicNum);
   trade.cancel_all_sell_stop_orders(magicNum);
   trade.cancel_all_buy_limit_orders(magicNum);
   trade.cancel_all_sell_limit_orders(magicNum);
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void closeAll() {
   trade.close_all_buys(magicNum);
   trade.close_all_sells(magicNum);
   closePendingOrders();
}
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double getPipValue() {
   int digits = (int)SymbolInfoInteger(_Symbol, SYMBOL_DIGITS);
   if(digits == 2 || digits == 3)
      return 0.01;
   else if(digits == 4 || digits == 5)
      return 0.0001;
   return 1;
}
//+------------------------------------------------------------------+
