//+------------------------------------------------------------------+
//|                                                      ProjectName |
//|                                      Copyright 2020, CompanyName |
//|                                       http://www.companyname.net |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"
#include <LikeAPro/shapes.mqh>
#include <LikeAPro/trade.mqh>
#include <LikeAPro/stats.mqh>
#include <LikeAPro/sniper_dashboard.mqh>

string EA_NAME = "New Robot";
int EA_TITLE_FONT_SIZE=14;
color TITLE_COLOUR=clrWhite;
string TITLE_FONT = "Consolas";

int X = 10;
int Y =20;
int WIDTH =300;
int HEIGHT = 300;
color COLOUR = clrBlack;

int HEADER_HEIGHT = 35;
color HEADER_COLOUR = clrGray;
int COMPONENT_HEIGHT =  35;
color COMPONENT_COLOUR = clrWhite;
int COMPONENT_BUFFER_X = 5;
int COMPONENT_BUFFER_Y = 4;

int COMPONENT_DATA_FONT_SIZE = 8;
string COMPONTENT_DATA_FONT = "Arial";
color COMPONENT_DATA_TEXT_COLOUR = clrBlack;
int COMPONENT_TEXT_X_BUFFER = 8;
int COMPONENT_TEXT_Y_BUFFER = 5;
int COMPONENT_PNL_FONT_SIZE = 12;
int COMPONENT_PNL_WINNING_COLOUR = clrGreen;
int COMPONENT_PNL_LOSING_COLOUR = clrDarkRed;

int OVERVIEW_PANEL_HEIGHT = 50;
int OVERVIEW_PANEL_X_BUFFER = 2;
int OVERVIEW_PANEY_Y_BUFFER = 2;
color OVERVIEW_PANEL_COLOUR = clrDarkGray;


Dashboard D;


int magic_number =123;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   D.create(
      EA_NAME,
      EA_TITLE_FONT_SIZE,
      TITLE_COLOUR,
      TITLE_FONT,
      X,
      Y,
      WIDTH,
      HEIGHT,
      COLOUR,
      HEADER_HEIGHT,
      HEADER_COLOUR,
      COMPONENT_HEIGHT,
      COMPONENT_COLOUR,
      COMPONENT_BUFFER_X,
      COMPONENT_BUFFER_Y,
      COMPONENT_DATA_FONT_SIZE,
      COMPONENT_DATA_TEXT_COLOUR,
      COMPONTENT_DATA_FONT,
      COMPONENT_TEXT_X_BUFFER,
      COMPONENT_TEXT_Y_BUFFER,
      COMPONENT_PNL_FONT_SIZE,
      COMPONENT_PNL_WINNING_COLOUR,
      COMPONENT_PNL_LOSING_COLOUR,

      OVERVIEW_PANEL_HEIGHT,
      OVERVIEW_PANEL_X_BUFFER,
      OVERVIEW_PANEY_Y_BUFFER,
      OVERVIEW_PANEL_COLOUR

   );

   new_sqeuence(magic_number,(string)magic_number,1,5);
   new_sqeuence(magic_number+1,(string)magic_number+1,0,5);
   new_sqeuence(magic_number+2,(string)magic_number+2,1,5);
   D.populate_sequences();
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
//ObjectsDeleteAll(0);

  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
   check_sequences();
   D.update_sequences();
  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+


void check_sequences()
  {
   int sequence_to_delete = -1;
   for(int i=0; i<ArraySize(sequence); i++)
     {
      if(!sequence[i].is_active) {sequence_to_delete = i; break;}
      sequence[i].check();
     }
   if(sequence_to_delete>=0)
      {
      D.delete_sequences();
      ArrayRemove(sequence,sequence_to_delete,1);
      D.populate_sequences();
      D.update_sequences();
      
      }
  }