//+------------------------------------------------------------------+
//|                                                RangeBreakout.mq5 |
//|                                                  Mario Canalella |
//|                               https://mariocanalella.netlify.app |
//+------------------------------------------------------------------+
#property copyright "Mario Canalella"
#property link      "https://mariocanalella.netlify.app"
#property version   "1.02"

#include <LikeAPro/dashboard.mqh>
#include <LikeAPro/trade.mqh>
#include <LikeAPro/shapes.mqh>
#include <LikeAPro/errors.mqh>
//+------------------------------------------------------------------+
//| exit Mode ENUM                                                   |
//+------------------------------------------------------------------+
enum exitMode {
   NO_EXIT=0,
   CLOSE_ALL_AT=1,
   CLOSE_ALL_IN_PROFIT_AT=2,
};
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
input group "General Settings"
input int magicNumber = 1; // Magic Number
input group "Range Settings"
input int startHour = 1; // Start Hour
input int startMinute = 0; // Start Minute
input int endHour = 9; // End Hour
input int endMinute = 0; // End Minute
input group "Money Management"
input double riskByAccountPercentage = 1; // Risk By Account Percentage
input exitMode exitModeSel = NO_EXIT; // Exit Mode
input int closeHour = 18; // Close Trade Hour
input int closeMinute = 0; // Close Trade Hour
input bool useTpFactor = false; // Use TP Factor
input double tpFactor = 1.0; // TP Factor
input bool onlyOneTrade = false; // Only One Trade
input group "Prop Firm Settings"
input bool propMode = false; //Prop Mode
input double accountBase = 10000; // Account Base
input double target = 800; // Target
input double riskMultiplier = 4; // Risk Multiplier
input double profitBeforeMultiplier = 400; // Profit Before Multiplier
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
bool calculateRange;
bool openTrade;
double maxPrice;
double minPrice;
datetime lastDay;
int lastMonth;
ap_trade trade();
MqlDateTime timeEa;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit() {

   if(startHour > endHour) {
      Alert("Range beetween days not supported yet");
      return(INIT_FAILED);
   }

   if(endHour > closeHour) {
      Alert("Close Hour not valid, beetwen range calculation hour");
      return(INIT_FAILED);
   }

   maxPrice = 0;
   minPrice = 0;
   calculateRange = true;
   openTrade =  true;
   lastDay = TimeCurrent() - (TimeCurrent() % 86400); // Initialize to today's midnight
   lastMonth = timeEa.mon;
   trade.magic_number = magicNumber;
   dashboard.init("Range Breakout Dashboard", 8, 35,10,20,500,190);
   dashboard.style(14772545,16777215,16119285,0);
   dashboard.add_log("Starting to make money!");
   dashboard.add_log("Server Time " + (string)TimeCurrent());
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

   if(propMode && ( ((AccountInfoDouble(ACCOUNT_BALANCE) - accountBase) >= target) ||
                    (AccountInfoDouble(ACCOUNT_BALANCE) - accountBase + AccountInfoDouble(ACCOUNT_PROFIT) >= target))) {
      dashboard.add_log("Prop Target reached!");
      closeAll();
      return;
   }

//calculate range
   calculateMaxMinForRange();

//open trades
   openTrades();

//exit
   exit();

//new day
   checkNewDay();
}
//+------------------------------------------------------------------+

// Function to calculate Max and Min prices between 08:00 and 10:00 for a specific day
void calculateMaxMinForRange() {

   TimeCurrent(timeEa);
   if(calculateRange && (timeEa.hour == endHour && timeEa.min >= endMinute)) {

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
         dashboard.add_log("rangeStart: " + (string)rangeStart + "startBar: " + (string)startBar);
         dashboard.add_log("rangeEnd: " + (string)rangeEnd + "endBar: " + (string)endBar);
         dashboard.add_log("No data found for the specified time range.");
         return;
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
         return;
      }

      calculateRange = false;

      dashboard.add_log("Final maxPrice " + (string)maxPrice + " at bar " + (string)maxBar);
      dashboard.add_log("Final minPrice " + (string)minPrice + " at bar " + (string)minBar);

      h_line("maxPrice", clrGreen, maxPrice, "maxPrice", NULL);
      h_line("minPrice",clrRed, minPrice, "minPrice",NULL);
   }
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
      calculateRange = true;
      openTrade = true;
      maxPrice = 0;
      minPrice = 0;
   }

}


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool isNewMonth() {

   // Check if the current month is different from the previous one
   if (timeEa.mon != lastMonth) {
      dashboard.add_log("A new month has started: " + string(timeEa.mon));
      lastMonth = timeEa.mon;
      return true;
   }
   return false;
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void openTrades() {

   if(openTrade && getPendingOrders() <= 0 && (timeEa.hour == endHour && timeEa.min >= endMinute)) {

      double riskPercent = 0;
      if(propMode && ((AccountInfoDouble(ACCOUNT_BALANCE) - accountBase) >= profitBeforeMultiplier)) {
         riskPercent = riskByAccountPercentage *  riskMultiplier;
      } else {
         riskPercent = riskByAccountPercentage;
      }

      double tpBuyStop = 0;
      if(useTpFactor) {
         tpBuyStop = calculateTakeProfit(maxPrice, minPrice, ORDER_TYPE_BUY_STOP);
      }

      dashboard.add_log("BS - OP " + (string)maxPrice);
      dashboard.add_log("BS - TP " + (string)tpBuyStop);
      dashboard.add_log("BS - SL " + (string)minPrice);

      bool openBuy = open_buy_stop(2, riskPercent, maxPrice, minPrice, tpBuyStop, magicNumber, "", "BUY STOP");
      if(!openBuy) {
         dashboard.add_log("Unable to open buy stop order");
         dashboard.add_log("[" + (string)GetLastError() + "] : " + get_error(GetLastError()));
      }

      double tpSellStop = 0;
      if(useTpFactor) {
         tpSellStop = calculateTakeProfit(minPrice, maxPrice, ORDER_TYPE_SELL_STOP);
      }

      dashboard.add_log("SS - OP " + (string)minPrice);
      dashboard.add_log("SS - TP " + (string)tpSellStop);
      dashboard.add_log("SS - SL " + (string)maxPrice);

      bool openSell = open_sell_stop(2, riskPercent, minPrice, maxPrice, tpSellStop, magicNumber, "", "SELL STOP");
      if(!openSell) {
         dashboard.add_log("Unable to open sell stop order");
         dashboard.add_log("[" + (string)GetLastError() + "] : " + get_error(GetLastError()));
      }

      openTrade = false;
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

   if(onlyOneTrade && getOpenPositions() > 0) {
      closePendingOrders();
   }

   if(getOpenPositions() > 0 || getPendingOrders() > 0) {
      TimeCurrent(timeEa);
      switch (exitModeSel) {
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
      default:
         return;
      }
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
   trade.cancel_all_buy_stop_orders(magicNumber);
   trade.cancel_all_sell_stop_orders(magicNumber);
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void closeAll() {
   trade.close_all_buys(magicNumber);
   trade.close_all_sells(magicNumber);
   trade.cancel_all_buy_stop_orders(magicNumber);
   trade.cancel_all_sell_stop_orders(magicNumber);
}


//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
