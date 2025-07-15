//+------------------------------------------------------------------+
//|                                                     function.mq5 |
//|                                  Copyright 2023, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"
#include <dashboard.mqh>

int number = 1;
string text = "hello";
double decimal = 0.01;
bool rule = false;
struct thing {};

enum day_of_week
  {
   sunday=0,
   monday=1,
   tuesday=2,
   wednesday=3,
   thursday=4,
   friday=5,
   saturday=6

  };


int uk_session_start_hh = 8;
int uk_session_start_mm = 30;

int us_session_start_hh = 13;
int us_session_start_mm = 30;

int uk_session_end_hh = 16;
int uk_session_end_mm = 30;

int us_session_end_hh = 22;
int us_session_end_mm = 30;

int asia_session_start_hh = 0;
int asia_session_start_mm = 0;

int asia_session_end_hh = 8;
int asia_session_end_mm = 0;


//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   dashboard.init("FUNCTION");
   dashboard.style();
   bool is_today_monday = is_monday();
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---

  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
   if(is_us_session()){
   v_line(TimeCurrent(),clrRed,true);
   }

  }
//+------------------------------------------------------------------+
//int number = 1;
//string text = "hello";
//double decimal = 0.01;
//bool rule = false;
//struct thing{};

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int current_day_of_the_week()
  {
   MqlDateTime time;
   datetime current_time = TimeCurrent();
   TimeToStruct(current_time,time);
   return time.day_of_week;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int current_hour()
  {

   MqlDateTime time;
   datetime current_time = TimeCurrent();
   TimeToStruct(current_time,time);
   return time.hour;

  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int current_minute()
  {

   MqlDateTime time;
   datetime current_time = TimeCurrent();
   TimeToStruct(current_time,time);
   return time.min;

  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool is_monday()
  {
   int day = current_day_of_the_week();
   if(day==monday)
     {
      return true;
     }
   return false;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool is_tuesday()
  {
   int day = current_day_of_the_week();
   if(day==tuesday)
     {
      return true;
     }
   return false;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool is_wednesday()
  {
   int day = current_day_of_the_week();
   if(day==wednesday)
     {
      return true;
     }
   return false;
  }
//+------------------------------------------------------------------+
int number_of_days_in_a_week()
  {

   return 7;

  }
//+------------------------------------------------------------------+
string say_something()
  {


   return "111";
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double get_ask_price()
  {

   return 1.1111;

  }
//+------------------------------------------------------------------+


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool is_uk_session()
  {
   int hour = current_hour();
   int min = current_minute();
   
   int start_hh = uk_session_start_hh;
   int start_mm = uk_session_start_mm;
   int end_hh = uk_session_end_hh;
   int end_mm = uk_session_end_mm;
   
   if(hour==start_hh)
     {
      if(min>=start_mm)
        {
         return true;
        }
     }
   if(hour>start_hh && hour < end_hh)
     {
      return true;
     }
   if(hour==end_hh && min < end_mm)
     {
      return true;
     }
     
     return false;
  }
//+------------------------------------------------------------------+
bool is_us_session()
  {
   int hour = current_hour();
   int min = current_minute();
   
   int start_hh = us_session_start_hh;
   int start_mm = us_session_start_mm;
   int end_hh = us_session_end_hh;
   int end_mm = us_session_end_mm;
   
   if(hour==start_hh)
     {
      if(min>=start_mm)
        {
         return true;
        }
     }
   if(hour>start_hh && hour < end_hh)
     {
      return true;
     }
   if(hour==end_hh && min < end_mm)
     {
      return true;
     }
     
     return false;
  }