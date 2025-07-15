#include <LikeAPro/shapes.mqh>
//+-----------------------------------------------------------------------------+
//|                                                                             |
//+-----------------------------------------------------------------------------+
///██████   █████  ███████ ██   ██ ██████   ██████   █████  ██████  ██████
///██   ██ ██   ██ ██      ██   ██ ██   ██ ██    ██ ██   ██ ██   ██ ██   ██
///██   ██ ███████ ███████ ███████ ██████  ██    ██ ███████ ██████  ██   ██
///██   ██ ██   ██      ██ ██   ██ ██   ██ ██    ██ ██   ██ ██   ██ ██   ██
///██████  ██   ██ ███████ ██   ██ ██████   ██████  ██   ██ ██   ██ ██████
//+-----------------------------------------------------------------------------+
//|                                                                             |
//+-----------------------------------------------------------------------------+
class Dashboard
  {
public:
   void              init(string name, int logger_text_size = 8, int dashboard_feed_length=35,int _x=10, int _y=20,int _width=300, int _height=190);
   void              style(color header_colour=clrRoyalBlue, color header_text_colour=clrWhite,color dashboard_box_colour=clrWhiteSmoke,color text_colour=clrBlack);
   void              r_style();
   void              show_dashboard_on_chart();
   void              save(string value, bool &is_full);
   void              add_log(string value);
   void              update_log();
   void              update_chart();
   string            name;
   int               logger_text_size;
   int               dashboard_feed_length;


   color             header_colour;
   color             header_text_colour;
   color             dashboard_box_colour;
   color             text_colour;


   string            dashboard_feed[]; // Array to store logging
   int               dashboard_fee_length; // Max logger history size


   int               x_axis;
   int               y_axis;
   int               width;
   int               height;
   string            prefix;
  };

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Dashboard::init(string _name,int _logger_text_size, int _dashboard_feed_length,int _x = 10, int _y=20, int _width=300, int _height=190)
  {
   prefix = PREFIX+_name;
   x_axis = _x;
   y_axis = _y;
   width = _width;
   height = _height;
   name = _name;
   logger_text_size=_logger_text_size;
   dashboard_feed_length = _dashboard_feed_length;

   ArrayResize(dashboard_feed,dashboard_feed_length); //Resize the array to hold (dashboard_feed_length) logs

  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Dashboard::style(color _header_colour,color _header_text_colour,color _dashboard_box_colour,color _text_color)
  {
   header_colour = _header_colour;
   header_text_colour = _header_text_colour;
   dashboard_box_colour = _dashboard_box_colour;
   text_colour = _text_color;
   show_dashboard_on_chart();
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Dashboard::r_style()
  {
   int nr = MathRand() % (9 - 1 + 1) + 1;
   if(nr == 1)
      style(clrLightGreen, clrBlack, clrBlack, clrWhite);
   else
      if(nr == 2)
         style(clrMediumSlateBlue, clrBlack, clrBlack, clrWhite);
      else
         if(nr == 3)
            style(clrBlue, clrLimeGreen, clrBlack, clrLimeGreen);
         else
            if(nr == 4)
               style(clrBlue, clrWhite, clrDodgerBlue, clrWhite);
            else
               if(nr == 5)
                  style(clrGray, clrWhite, clrBlack, clrWhite);
               else
                  if(nr == 6)
                     style(C'115,115,80',C'59,35,34', C'254,244,156', C'128,42,25');
                  else
                     if(nr == 7)
                        style(C'61,25,22',C'223,189,34', C'122,37,30', C'215,201,167');
                     else
                        if(nr == 8)
                           style(C'182,73,38',C'255,240,165', C'19,119,61', C'255,240,165');
                        else
                           if(nr == 9)
                              style(C'191,184,117',clrBlack, C'254,244,156', clrBlack);
                           else
                              style();
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int def_width;
void Dashboard::show_dashboard_on_chart()
  {
   int panel_x=x_axis; //Set panel X axis
   int panel_y=y_axis; //Set panel Y axis
   int panel_w=width+25; //Set panel Width
   int panel_h=height+30; //Set panel Height
   color panel_color=header_colour; //Set panel Color

   int dashboard_window_x=x_axis; //Set dashboard window X axis
   int dashboard_window_y=y_axis+45; //Set dashboard window Y axis
   int dashboard_window_w=width+25; //Set dashboard window Width
   int dashboard_window_h=750; //Set dashboard window Height
   color dashboard_window_color=dashboard_box_colour; //Set dashboard window Color

   string dashboard_title = name; //Set dashboard title
   int dashboard_title_x = x_axis+8; //Set dashboard title X axis
   int dashboard_title_y = x_axis+5; //Set dashboard title Y axis
   color dashboard_title_color=header_text_colour; //Set dashboard title color
   string dashboard_title_font = "Arial Black"; //Set dashboard title font

   rectangle("dashboard", panel_x,panel_y, panel_w, panel_h, CORNER_LEFT_UPPER, BORDER_RAISED, STYLE_SOLID, 1, panel_color); //Create dashboard panel
   def_width = ObjectGetInteger(0,PREFIX+"dashboard",OBJPROP_XSIZE);
   label("dashboard_title",dashboard_title_x,dashboard_title_y, CORNER_LEFT_UPPER,dashboard_title, logger_text_size, dashboard_title_color, dashboard_title_font); //Create dashbaord title

   rectangle("logger", dashboard_window_x, dashboard_window_y, dashboard_window_w, dashboard_window_h, CORNER_LEFT_UPPER, BORDER_FLAT, STYLE_SOLID, 1, dashboard_window_color); //Create dashboard window

  };


//+------------------------------------------------------------------+
void Dashboard::add_log(string value)
  {
   printf(value);
   value=TimeToString(TimeCurrent())+" - "+value;
   bool is_full;
   save(value,is_full); //Save the new value and return is_full as being true or false
   if(is_full==true)
     {

      update_log(); // Update the log
      save(value,is_full);// Save the log after update
     }

   update_chart();

  };


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Dashboard::save(string value,bool &is_full)
  {
   is_full = true ;
   for(int i = 0 ; i<dashboard_feed_length ; i++)
     {
      if(dashboard_feed[i]==NULL)
        {

         dashboard_feed[i] = value;
         is_full = false ;
         break ;
        }
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Dashboard::update_log()
  {
   dashboard_feed[0]=NULL;
   for(int i = 0 ; i<dashboard_feed_length ; i++)
     {
      if(dashboard_feed[i]==NULL && i+1<dashboard_feed_length)
        {
         dashboard_feed[i]=dashboard_feed[i+1];
         dashboard_feed[i+1] = NULL ;
        }
     }
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Dashboard::update_chart()
  {
   //int height_shift = height+25;
   int x_axis_position=x_axis+10;
   int y_axis_position=y_axis+50;

   int max_length=0;

   for(int i = dashboard_feed_length-1; i>=0; i--)
     {
      if(dashboard_feed[i]!=NULL)  //If there is a value in the array
        {


         uint w,h;
         string text = ">> "+dashboard_feed[i];
         TextSetFont("Arial",logger_text_size,0,0);
         TextGetSize(text,w,h);

         label("log_"+IntegerToString(i),x_axis_position, y_axis_position, CORNER_LEFT_UPPER,text, logger_text_size, text_colour);
         y_axis_position+=20;

        }
     }





  }
//+------------------------------------------------------------------+

Dashboard dashboard;

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void add_log(string string_text)
  {
   dashboard.add_log(string_text);

  }
//+------------------------------------------------------------------+
