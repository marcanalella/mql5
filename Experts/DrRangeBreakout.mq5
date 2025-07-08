//+------------------------------------------------------------------+
//|                                         DR/IDR RangeBreakout.mq5 |
//|                                                  Mario Canalella |
//|                               https://mariocanalella.netlify.app |
//+------------------------------------------------------------------+
#property copyright "Mario Canalella"
#property link      "https://mariocanalella.netlify.app"
#property version   "1.01"

#include <AlgoPro/dashboard.mqh>
#include <AlgoPro/ap_trade.mqh>
#include <AlgoPro/shapes.mqh>
#include <AlgoPro/ap_errors.mqh>
//+------------------------------------------------------------------+
//| exit Mode ENUM                                                   |
//+------------------------------------------------------------------+
enum exitMode {
   CLOSE_ALL_AT = 1,
   CLOSE_ALL_IN_PROFIT_AT = 2,
   CLOSE_ALL_AFTER_DR_SESSION = 3,
};
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
input group "General Settings"
input int magicNumber = 1; // Magic Number
input group "ODR Range Settings - London"
input bool useOdrRange = true;
input int odrStartHour = 10; // Start Hour
input int odrStartMinute = 0; // Start Minute
input int odrEndHour = 11; // End Hour
input int odrEndMinute = 0; // End Minute
input int odrEnd = 15; // End ODR Operativity
input group "ADR Range Settings - Tokyo"
input bool useAdrRange = true;
input int adrStartHour = 2; // Start Hour
input int adrStartMinute = 30; // Start Minute
input int adrEndHour = 3; // End Hour
input int adrEndMinute = 30; // End Minute
input int adrEnd = 8; // End ADR Operativity
input group "RDR Range Settings - NY"
input bool useRdrRange = true;
input int rdrStartHour = 16; // Start Hour
input int rdrStartMinute = 30; // Start Minute
input int rdrEndHour = 17; // End Hour
input int rdrEndMinute = 30; // End Minute
input int rdrEnd = 23; // End RDR Operativity
input group "Money Management"
input double riskByAccountPercentage = 1; // Risk By Account Percentage
input exitMode exitModeSel = CLOSE_ALL_AFTER_DR_SESSION; // Exit Mode
input int closeHour = 18; // Close Trade Hour
input int closeMinute = 0; // Close Trade Hour
input bool useTpFactor = false; // Use TP Factor
input double tpFactor = 1.0; // TP Factor
input bool onlyOneTradeForSession = false; // Only One Trade
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
bool calculateOdrRange, calculateAdrRange, calculateRdrRange;
bool openOdrTrade, openAdrTrade, openRdrTrade;
double maxPrice;
double minPrice;
datetime lastDay;
int lastMonth;
int currentOdrSession = 0;  //0 - ODR | 1 - ADR | 2 - RDR
ap_trade trade();
MqlDateTime timeEa;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit() {
   maxPrice = 0;
   minPrice = 0;
   calculateOdrRange =  true;
   calculateAdrRange = true;
   calculateRdrRange = true;
   openOdrTrade =  true;
   openAdrTrade =  true;
   openRdrTrade =  true;
   lastDay = TimeCurrent() - (TimeCurrent() % 86400); // Initialize to today's midnight
   lastMonth = timeEa.mon;
   trade.magic_number = magicNumber;
   dashboard.init("DR/IDR Range Breakout Dashboard", 8, 35, 10, 20, 500, 190);
   dashboard.style(14772545, 16777215, 16119285, 0);
   dashboard.add_log("Starting to make money!");
   dashboard.add_log("Server Time: " + (string)TimeCurrent());
   dashboard.add_log("Machine Time: " + (string)TimeLocal());
   return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason) {
   ObjectsDeleteAll(0);
}
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick() {
//calculate range
   TimeCurrent(timeEa);
   if(useOdrRange && calculateOdrRange && (timeEa.hour == odrEndHour && timeEa.min >= odrEndMinute) && getOpenPositions() <= 0) {
      if(calculateMaxMinForRange(odrStartHour, odrEndMinute, odrEndHour, odrEndMinute, "ODR")) {
         calculateOdrRange = false;
         currentOdrSession = 0;
         if(openOdrTrade) {
            openTrades("ODR");
         }
      }
   } else if(useAdrRange && calculateAdrRange && (timeEa.hour == adrEndHour && timeEa.min >= adrEndMinute) && getOpenPositions() <= 0) {
      if(calculateMaxMinForRange(adrStartHour, adrEndMinute, adrEndHour, adrEndMinute, "ADR")) {
         calculateAdrRange =  false;
         currentOdrSession = 1;
         if(openAdrTrade) {
            openTrades("ADR");
         }
      }
   } else if(useRdrRange && calculateRdrRange && (timeEa.hour == rdrEndHour && timeEa.min >= rdrEndMinute) && getOpenPositions() <= 0) {
      if(calculateMaxMinForRange(rdrStartHour, rdrEndMinute, rdrEndHour, rdrEndMinute, "RDR")) {
         calculateRdrRange = false;
         currentOdrSession = 2;
         if(openAdrTrade) {
            openTrades("RDR");
         }
      }
   }
//EXIT
   closePendingOrders();
   if(getOpenPositions() > 0 || getPendingOrders() > 0) {
      exit();
   }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   checkNewDay();
}
//+------------------------------------------------------------------+

// Function to calculate Max and Min prices between 08:00 and 10:00 for a specific day
bool calculateMaxMinForRange(int startHour, int startMinute, int endHour, int endMinute, string session) {
// Initialize max and min prices
   maxPrice = -DBL_MAX;
   minPrice = DBL_MAX;
// Calculate start and end times for the range
   datetime rangeStart = lastDay + (startHour * 3600) + (startMinute * 60); // Add 08:00 to the day's start
   datetime rangeEnd = lastDay + endHour * 3600 + (endMinute * 60);         // Add 10:00 to the day's start
   int maxBar = 0;
   int minBar = 0;
// Get the start and end bar indices for the range
   int startBar = iBarShift(NULL, PERIOD_M1, rangeStart); // Find the first bar in the range
   int endBar = iBarShift(NULL, PERIOD_M1, rangeEnd);     // Find the last bar in the range
   if(startBar < 0 || endBar < 0) {
      dashboard.add_log(session + " rangeStart: " + (string)rangeStart + "startBar: " + (string)startBar);
      dashboard.add_log(session + " rangeEnd: " + (string)rangeEnd + "endBar: " + (string)endBar);
      dashboard.add_log("No data found for the specified time range.");
      return false;
   }
// Loop through bars in the range
   for(int i = endBar; i <= startBar; i++) {
      double high = iHigh(NULL, PERIOD_M1, i); // High price of the bar
      double low = iLow(NULL, PERIOD_M1, i);  // Low price of the bar
      if(high > maxPrice) {
         maxPrice = high;
         maxBar = i;
      }
      if(low < minPrice) {
         minPrice = low;
         minBar = i;
      }
   }
// If no valid price data is found
   if(maxPrice == -DBL_MAX || minPrice == DBL_MAX) {
      dashboard.add_log("No price data available in the specified range.");
      return false;
   }
   dashboard.add_log("Final maxPrice " + session + " " + (string)maxPrice + " at bar " + (string)maxBar);
   dashboard.add_log("Final minPrice " + session + " " + (string)minPrice + " at bar " + (string)minBar);
   h_line("maxPrice " + session, clrGreen, maxPrice, "maxPrice", NULL);
   h_line("minPrice " + session, clrRed, minPrice, "minPrice", NULL);
   return true;
}
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void checkNewDay() {
// Get the start of the current day
   datetime currentDay = TimeCurrent() - (TimeCurrent() % 86400);
// Check if a new day has started
   if(currentDay != lastDay) {
      dashboard.add_log("A new day has started: " + TimeToString(currentDay, TIME_DATE));
      // Update the last day
      lastDay = currentDay;
      calculateAdrRange = true;
      calculateRdrRange = true;
      calculateOdrRange =  true;
      openOdrTrade =  true;
      openAdrTrade =  true;
      openRdrTrade =  true;
      maxPrice = 0;
      minPrice = 0;
   }
}


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool isNewMonth() {
// Check if the current month is different from the previous one
   if(timeEa.mon != lastMonth) {
      dashboard.add_log("A new month has started: " + string(timeEa.mon));
      lastMonth = timeEa.mon;
      return true;
   }
   return false;
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void openTrades(string session) {
   double riskPercent = riskByAccountPercentage;
   dashboard.add_log("riskPercent: " + session + " % " + (string)riskPercent);
   double tpBuyStop = 0;
   if(useTpFactor) {
      tpBuyStop = calculateTakeProfit(maxPrice, minPrice, ORDER_TYPE_BUY_STOP);
   }
   dashboard.add_log("BuyStop " + session + " - OpenPrice " + (string)maxPrice);
   dashboard.add_log("BuyStop " + session + " - TakeProfit " + (string)tpBuyStop);
   dashboard.add_log("BuyStop " + session + " - StopLoss " + (string)minPrice);
   bool openBuy = open_buy_stop(2, riskPercent, maxPrice, minPrice, tpBuyStop, magicNumber, "", "BUY STOP " + session);
   if(!openBuy) {
      dashboard.add_log("Unable to open buy stop order");
      dashboard.add_log("[" + (string)GetLastError() + "] : " + get_error(GetLastError()));
   }
   double tpSellStop = 0;
   if(useTpFactor) {
      tpSellStop = calculateTakeProfit(minPrice, maxPrice, ORDER_TYPE_SELL_STOP);
   }
   dashboard.add_log("SellStop " + session + " - OpenPrice " + (string)minPrice);
   dashboard.add_log("SellStop " + session + " - TakeProfit " + (string)tpSellStop);
   dashboard.add_log("SellStop " + session + " - StopLoss " + (string)maxPrice);
   bool openSell = open_sell_stop(2, riskPercent, minPrice, maxPrice, tpSellStop, magicNumber, "", "SELL STOP " + session);
   if(!openSell) {
      dashboard.add_log("Unable to open sell stop order");
      dashboard.add_log("[" + (string)GetLastError() + "] : " + get_error(GetLastError()));
   }
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int getPendingOrders() {
   int totalOrders = OrdersTotal();
   if(totalOrders == 0) {
      return 0;
   }
   int countOrder = 0;
   for(int i = 0; i < totalOrders; i++) {
      if(OrderSelect(OrderGetTicket(i))) { // Select the order by index
         int orderMagic = (int)OrderGetInteger(ORDER_MAGIC); // Get the magic number of the order
         string symbol =  OrderGetString(ORDER_SYMBOL);
         if(orderMagic == magicNumber && symbol == Symbol()) { // Check if it matches the desired magic number
            countOrder++;
         }
      }
   }
   return countOrder;
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int getOpenPositions() {
   int countPosition = 0;
   int totalPositions = PositionsTotal();
   if(totalPositions == 0) {
      return 0;
   }
   for(int i = 0; i < totalPositions; i++) {
      if(PositionSelectByTicket(PositionGetTicket(i))) {
         int positionMagic = (int)PositionGetInteger(POSITION_MAGIC); // Get the magic number of the order
         string symbol = PositionGetSymbol(i);
         if(positionMagic == magicNumber && symbol == Symbol()) { // Check if it matches the desired magic number
            countPosition++;
         }
      }
   }
   return countPosition;
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void exit() {
   TimeCurrent(timeEa);
   switch(exitModeSel) {
   case CLOSE_ALL_AT:
      if(timeEa.hour == closeHour && timeEa.min >= closeMinute) {
         closeAll();
      }
      break;
   case CLOSE_ALL_IN_PROFIT_AT:
      if(timeEa.hour == closeHour && timeEa.min >= closeMinute) {
         trade.close_all_winning_trades(magicNumber);
         closePendingOrders();
      }
      break;
   case CLOSE_ALL_AFTER_DR_SESSION:
      if((currentOdrSession == 0 && timeEa.hour >= odrEnd) || (currentOdrSession == 1 && timeEa.hour >= adrEnd) || (currentOdrSession == 2 && timeEa.hour >= rdrEnd)) {
         trade.close_all_winning_trades(magicNumber);
         closePendingOrders();
      }
      break;
   }
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double calculateTakeProfit(double openPrice, double stopLoss, int tradeType) {
// Calculate the risk distance
   double riskDistance = fabs(openPrice - stopLoss);
// Calculate the TP distance
   double tpDistance = riskDistance * tpFactor;
// Determine the TP based on trade type
   if(tradeType == ORDER_TYPE_BUY_STOP) {
      return openPrice + tpDistance; // Buy: Add TP distance to Open Price
   } else if(tradeType == ORDER_TYPE_SELL_STOP) {
      return openPrice - tpDistance; // Sell: Subtract TP distance from Open Price
   }
// Invalid trade type
   return 0.0;
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void closePendingOrders() {
   if(onlyOneTradeForSession && getOpenPositions() > 0) {
      trade.cancel_all_buy_stop_orders(magicNumber);
      trade.cancel_all_sell_stop_orders(magicNumber);
   }
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void closeAll() {
   trade.close_all_buys(magicNumber);
   trade.close_all_sells(magicNumber);
   closePendingOrders();
}
//+------------------------------------------------------------------+
