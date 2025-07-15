//+------------------------------------------------------------------+
//|                                                    array_101.mq5 |
//|                                  Copyright 2023, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"
#include <dashboard.mqh>

string weekdays[7];
string data[];

color colours[10];
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void set_weekdays()
  {
   weekdays[0]="Monday";
   weekdays[1]="Tuesday";
   weekdays[2]= "Wednesday";
   weekdays[3]= "Thursday";
   weekdays[4]= "Friday";
   weekdays[5]="Saturday";
   weekdays[6] ="Sunday";

  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int current_colour =0;
void set_colours()
  {
   colours[0]=clrRed;
   colours[1]=clrBlue;
   colours[2]=clrGreen;
   colours[3]=clrOrange;
   colours[4]=clrGray;
   colours[5]=clrBlack;
   colours[6]=clrPurple;
   colours[7]=clrPink;
   colours[8]=clrAqua;
   colours[9]=clrBrown;

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OnInit()
  {
   dashboard.init("Arrays",12);
   dashboard.style(clrDarkGreen,clrOrange,clrBrown,clrOrange);

   set_weekdays();
   set_colours();

 add_log("Array size "+ArraySize(data));
 for(int i=0; i<100; i++)add_to_data("Piece of data "+i);

   for(int i=0; i<ArraySize(weekdays); i++)
     {
      add_log("Weekday "+i+" is "+weekdays[i]);
     }
  add_log(choose_colour());
  add_log(choose_colour());
  add_log(choose_colour());
  add_log(choose_colour());
  add_log(choose_colour());
  add_log(choose_colour());
  add_log(choose_colour());
  add_log(choose_colour());
  add_log(choose_colour());
  add_log(choose_colour());
  add_log(choose_colour());
  add_log(choose_colour());


//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
color choose_colour()
  {
   if(current_colour>=ArraySize(colours))current_colour=0;
      color col_to_return = colours[current_colour];
      current_colour ++;
      return col_to_return;

  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void add_to_data(string data_to_add)
  {
   ArrayResize(data,ArraySize(data)+1);
   data[ArraySize(data)-1] = data_to_add;
  }
//+------------------------------------------------------------------+
