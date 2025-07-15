//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//|        ___ ___ ___ ___ ___ _____   ___ _____ _   ___ _  _        |
//|       / __| __/ __| _ \ __|_   _| / __|_   _/_\ / __| || |       |
//|       \__ \ _| (__|   / _|  | |   \__ \ | |/ _ \\__ \ __ |       |
//|       |___/___\___|_|_\___| |_|   |___/ |_/_/ \_\___/_||_|       |
//|                                                                  |
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

#include <LikeAPro/errors.mqh>

enum trade_risk_types

  {
   risk_by_lots=0, //Risk By Lotsize
   risk_by_cash=1, //Risk By Cash
   risk_by_account_percentage=2 //Risk By Account %
  };

enum starting_lot_settings
  {
   enum_fixed_lots = 0,     // FIXED STARTING LOT
   enum_lotsize_per_5k = 1, // LOTSIZE PER 5K
  };

string humanised_buy = "[BUY]";
string humanised_sell = "[SELL]";
//+------------------------------------------------------------------+
//|        GET PIP VALUE WITH ANY OF THESE FUNCTIONS BELOW           |
//+------------------------------------------------------------------+
double _grab_pip_value(string symbol = "")
  {
   if(symbol == "")
      symbol = Symbol();
   int digits = (int)SymbolInfoInteger(symbol, SYMBOL_DIGITS);
   if(digits == 2 || digits == 3)
      return 0.01;
   else
      if(digits == 4 || digits == 5)
         return 0.0001;
   return 1;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double get_pip_value(string symbol = "")
  {
   if(symbol == "")
      symbol = Symbol();
   int digits = (int)SymbolInfoInteger(symbol, SYMBOL_DIGITS);
   if(digits == 2 || digits == 3)
      return 0.01;
   else
      if(digits == 4 || digits == 5)
         return 0.0001;
   return 1;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double grab_pip_value(string symbol = "")
  {
   if(symbol == "")
      symbol = Symbol();
   int digits = (int)SymbolInfoInteger(symbol, SYMBOL_DIGITS);
   if(digits == 2 || digits == 3)
      return 0.01;
   else
      if(digits == 4 || digits == 5)
         return 0.0001;
   return 1;
  }
//+------------------------------------------------------------------+
//|               GET ASK PRICE OF ANY ASSET                         |
//+------------------------------------------------------------------+
double ask(string symbol="")
  {
   if(symbol=="")
      symbol=_Symbol;
   return SymbolInfoDouble(symbol,SYMBOL_ASK);
  }
//+------------------------------------------------------------------+
//|             GET BID PRICE OF ANY ASSET                           |
//+------------------------------------------------------------------+
double bid(string symbol="")
  {
   if(symbol=="")
      symbol=_Symbol;
   return SymbolInfoDouble(symbol,SYMBOL_BID);
  }

//+------------------------------------------------------------------+
//|  RETURN THE AVERAGE PRICE (OF BID AND ASK) OF ANY ASSET          |
//+------------------------------------------------------------------+
double price(string symbol="")
  {
   if(symbol=="")
      symbol=_Symbol;
   int digits = (int)SymbolInfoInteger(symbol,SYMBOL_DIGITS);
   return NormalizeDouble((bid(symbol)+ask(symbol))/2,digits);
  }

//+------------------------------------------------------------------+
//|            RETURN HUMAISED ORDER TYPE (0=BUY, 1=SELL)            |
//+------------------------------------------------------------------+
string o_type(int _order_type)
  {
   if(_order_type==ORDER_TYPE_BUY)
      return humanised_buy;
   if(_order_type==ORDER_TYPE_SELL)
      return humanised_sell;
   return "[ERROR]";
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void expire(datetime expire_date)
  {
   if(TimeCurrent() >= expire_date)
     {
      Alert("EA EXPIRED");
      ExpertRemove();
     }
  }
//+------------------------------------------------------------------+
//|             BACKLOG OF PREDEFINED COLOURS                        |
//+------------------------------------------------------------------+

color colors[25] =
  {
   clrAliceBlue,
   clrAntiqueWhite,
   clrAqua,
   clrAquamarine,
   clrAzure,
   clrBeige,
   clrBisque,
   clrBlanchedAlmond,
   clrBlue,
   clrBlueViolet,
   clrBrown,
   clrBurlyWood,
   clrCadetBlue,
   clrChartreuse,
   clrChocolate,
   clrCoral,
   clrCornflowerBlue,
   clrCornsilk,
   clrCrimson,
   clrCyan,
   clrDarkBlue,
   clrDarkCyan,
   clrDarkGoldenrod,
   clrDarkGray,
   clrDarkGreen
  };

//+------------------------------------------------------------------+
//|                RETURN A RANDOM COL0UR                            |
//+------------------------------------------------------------------+
color r_colour()
  {
   return colors[rint(0,ArraySize(colors)-1)];
  }

//+------------------------------------------------------------------+
//|              RETURN A RANDOM INTEGER                             |
//+------------------------------------------------------------------+
int rint(const int min, const int max)
  {
   double f = (MathRand() / 32768.0);
   return min + (int)(f * (max - min));
  }
//+------------------------------------------------------------------+
//|             ONLY ALLOW EA FOR BACKTESTING                        |
//+------------------------------------------------------------------+
void only_allow_backtesting()
  {
   if(!MQLInfoInteger(MQL_TESTER))
     {
      Alert("EA available only for backtesting");
      ExpertRemove();
     }
  }
//+------------------------------------------------------------------+
//|              ONLY ALLOW THIS ACCOUNT (x)                         |
//+------------------------------------------------------------------+
void only_allow_this_account(int acc_number_lock)
  {
   if(acc_number_lock != AccountInfoInteger(ACCOUNT_LOGIN))
     {
      Alert("EA Not Licensed for Your Account Number, contant the owner");
      ExpertRemove();
     }
  }
//+------------------------------------------------------------------+
//|               ONLY ALLOW DEMO TRADING                            |
//+------------------------------------------------------------------+
void only_allow_demo()
  {
   if(AccountInfoInteger(ACCOUNT_TRADE_MODE) != ACCOUNT_TRADE_MODE_DEMO)
     {
      Alert("EA available only for DEMO account trading");
      ExpertRemove();
     }
  }
//+------------------------------------------------------------------+
//|               ONLY ALLOW LIVE TRADING                            |
//+------------------------------------------------------------------+
void only_allow_live()
  {
   if(AccountInfoInteger(ACCOUNT_TRADE_MODE) != ACCOUNT_TRADE_MODE_REAL)
     {
      Alert("EA available only for LIVE account trading");
      ExpertRemove();
     }
  }
//+------------------------------------------------------------------+
//|              CHECK EXPRIRY DATE                                  |
//+------------------------------------------------------------------+
void check_expiry(datetime expiry_date)
  {
   if(TimeCurrent() > expiry_date)
     {
      Alert("EA has expired!");
      ExpertRemove();   // remove EA
     }
   else
     {
      Print("EA is still valid!");
      Print("EA expires in " + IntegerToString(get_days_until_expiry(expiry_date)) + " days");
     }
  }
//+------------------------------------------------------------------+
//|              DAYS UNTIL EXPIRY                                   |
//+------------------------------------------------------------------+
int get_days_until_expiry(datetime expiry_date)
  {
   if(TimeCurrent() > expiry_date)
     {
      return 0;
     }
   else
     {
      datetime expiry_date = expiry_date;
      datetime current_date_time = TimeCurrent();
      // Calculate the number of seconds between the current date and time and the expiry date
      int seconds_until_expiry = int(MathAbs(expiry_date - current_date_time));
      // Convert the number of seconds to days
      int days_until_expiry = seconds_until_expiry / (60 * 60 * 24);
      return days_until_expiry;
     }
  }
//+------------------------------------------------------------------+
//|                ACCOUNT EQUITY                                    |
//+------------------------------------------------------------------+
double equity()
  {
   return AccountInfoDouble(ACCOUNT_EQUITY);
  }
//+------------------------------------------------------------------+
//|                ACCOUNT BALANCE                                   |
//+------------------------------------------------------------------+
double balance()
  {
   return AccountInfoDouble(ACCOUNT_BALANCE);
  }
//+------------------------------------------------------------------+
//|                TOTAL OPEN PNL CASH                               |
//+------------------------------------------------------------------+
double calculate_pnl_cash()
  {
   return NormalizeDouble(equity()-balance(),2);
  }
//+------------------------------------------------------------------+
//|                TOTAL PnL AS A PERCENTAGE                         |
//+------------------------------------------------------------------+
double calculate_pnl_percent()
  {
   double b = balance();
   double e = equity();
   double percent = b/100;

   if(e>b)
     {
      return NormalizeDouble((e-b)/percent,2);
     }

   if(b>e)
      return -NormalizeDouble((b-e)/percent,2);
   return 0;
  }
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
