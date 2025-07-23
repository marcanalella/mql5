//+------------------------------------------------------------------------------------+
//|                                                                                    |
//+------------------------------------------------------------------------------------+
// ████████╗██╗███╗   ███╗███████╗    ███████╗██╗██╗     ████████╗███████╗██████╗
// ╚══██╔══╝██║████╗ ████║██╔════╝    ██╔════╝██║██║     ╚══██╔══╝██╔════╝██╔══██╗
//    ██║   ██║██╔████╔██║█████╗      █████╗  ██║██║        ██║   █████╗  ██████╔╝
//    ██║   ██║██║╚██╔╝██║██╔══╝      ██╔══╝  ██║██║        ██║   ██╔══╝  ██╔══██╗
//    ██║   ██║██║ ╚═╝ ██║███████╗    ██║     ██║███████╗   ██║   ███████╗██║  ██║
//    ╚═╝   ╚═╝╚═╝     ╚═╝╚══════╝    ╚═╝     ╚═╝╚══════╝   ╚═╝   ╚══════╝╚═╝  ╚═
//+------------------------------------------------------------------------------------+
//|                                                                                    |
//+------------------------------------------------------------------------------------+
#include <LikeAPro/shapes.mqh>




struct trading_day
  {
   int               weekday_number; //Weekday as number
   string            times_allowed_to_trade; //An string to allow multiple times we are allowed to trade;
   color             chart_color;
  };


//+------------------------------------------------------------------+
//|             THE CLASS!                                           |
//+------------------------------------------------------------------+
class time_filter
  {
public:
   void              set_weekday(int weekday_number, string trading_times_allowed="00:00-23:59",color weekday_color=clrBlue);

   void              enable_all_trading();
   void              disable_all_trading();
   bool              is_end_of_session();
   void              check();


   void              set_sunday(string trading_times_allowed="00:00-23:59", color sunday_colour=clrRed);
   void              set_monday(string trading_times_allowed="00:00-23:59",color monday_colour=clrRed);
   void              set_tuesday(string trading_times_allowed="00:00-23:59",color tuesday_colour=clrRed);
   void              set_wednesday(string trading_times_allowed="00:00-23:59",color wedneday_colour=clrRed);
   void              set_thursday(string trading_times_allowed="00:00-23:59",color thursday_colour=clrRed);
   void              set_friday(string trading_times_allowed="00:00-23:59",color friday_colour=clrRed);
   void              set_saturday(string trading_times_allowed="00:00-23:59",color saturday_colour=clrRed);

   void              setup_trading_week_times(
      string monday_times="00:00-23:59",
      string tuesday_times="00:00-23:59",
      string wednesday_times="00:00-23:59",
      string thursday_times="00:00-23:59",
      string friday_times="00:00-23:59",
      string saturday_times="00:00-23:59",
      string sunday_times="00:00-23:59"
   );

   bool              is_new_day();

   void              update_time();

   int               current_hour;
   int               current_min;
   int               current_sec;
   int               current_weekday;

   bool              disable_trading_for_current_day();

   bool              trading_allowed();

   bool              has_session_opened();
   bool              has_session_closed();

   bool              do_we_close_all();

   bool              _has_session_opened();

   void              visualise_trading_session(bool shapes_allowed=true);


   int               previous_trading_day;
   string            previous_trading_day_time;
   bool              disabled_for_the_day;
   trading_day       trading_week[7];
   bool              able_to_open;
   bool              show_time_windows_on_chart;
   bool              previous_session_state;


   string            block_name;
   int               trading_signal;
   datetime          next_end_time;
   bool              visualise_sessions;

  };
//+------------------------------------------------------------------+
//|   RETURNS TRUE IF TRADING IS ALLOWED                             |
//+------------------------------------------------------------------+
bool time_filter::trading_allowed()
  {
   update_time();
   if(trading_week[current_weekday].times_allowed_to_trade=="0")
      return false;

   string time_string_array[];
   int size_of_array;
   string_to_array(time_string_array,trading_week[current_weekday].times_allowed_to_trade,size_of_array,",");
   if(size_of_array>0)
     {

      for(int i=0; i<size_of_array; i++)
        {
         string time_array[];
         int time_size=0;
         string_to_array(time_array,time_string_array[i],time_size,"-");
         if(time_size==2)
           {
            datetime start_time = StringToTime(TimeToString(TimeCurrent(),TIME_DATE)+" "+time_array[0]);
            datetime end_time = StringToTime(TimeToString(TimeCurrent(),TIME_DATE)+" "+time_array[1]);
            if(TimeCurrent()>=start_time && TimeCurrent() < end_time)
              {
               next_end_time = end_time;
               able_to_open=true;
               return true;
              }
           }
        }
     }

   return false;
  }
//+------------------------------------------------------------------+
//|     INITIALISE TRADING TIMES FOR EACH DAY OF WEEK                |
//+------------------------------------------------------------------+
void time_filter::setup_trading_week_times(string monday_times="00:00-23:59",
      string tuesday_times="00:00-23:59",
      string wednesday_times="00:00-23:59",
      string thursday_times="00:00-23:59",
      string friday_times="00:00-23:59",
      string saturday_times="00:00-23:59",
      string sunday_times="00:00-23:59"
                                          )
  {
   set_monday(monday_times);
   set_tuesday(tuesday_times);
   set_wednesday(wednesday_times);
   set_thursday(thursday_times);
   set_friday(friday_times);
   set_saturday(saturday_times);
   set_sunday(sunday_times);
  }
//+------------------------------------------------------------------+
//|   RETURNS TRUE IF A NEW DAY STARTS                               |
//+------------------------------------------------------------------+
bool time_filter::is_new_day()
  {
   update_time();
   if(current_weekday!=previous_trading_day)
     {
      previous_trading_day=current_weekday;
      if(disabled_for_the_day)
         trading_week[previous_trading_day].times_allowed_to_trade=previous_trading_day_time;
      return true;
     }
   return false;
  }
//+------------------------------------------------------------------+
//|               UPDATE TIME                                        |
//+------------------------------------------------------------------+
void time_filter::update_time()
  {
   datetime currentTime = TimeCurrent();
   MqlDateTime currentDateTime;
   TimeToStruct(currentTime, currentDateTime);
   current_sec = currentDateTime.sec;
   current_min= currentDateTime.min;
   current_hour= currentDateTime.hour;
   current_weekday =currentDateTime.day_of_week;
  }
//+------------------------------------------------------------------+
//|               SET SUNDAY TIMES                                   |
//+------------------------------------------------------------------+
void time_filter::set_sunday(string trading_times_allowed="00:00-23:59",color sunday_colour=clrRed)
  {
   set_weekday(SUNDAY,trading_times_allowed,sunday_colour);
  }
//+------------------------------------------------------------------+
//|               SET MONDAY TIMES                                   |
//+------------------------------------------------------------------+
void time_filter::set_monday(string trading_times_allowed="00:00-23:59",color monday_colour=clrRed)
  {
   set_weekday(MONDAY,trading_times_allowed,monday_colour);
  }
//+------------------------------------------------------------------+
//|               SET TUESDAY TIMES                                  |
//+------------------------------------------------------------------+
void time_filter::set_tuesday(string trading_times_allowed="00:00-23:59",color tuesday_colour=clrRed)
  {
   set_weekday(TUESDAY,trading_times_allowed,tuesday_colour);
  }
//+------------------------------------------------------------------+
//|               SET WEDNESDAY TIMES                                |
//+------------------------------------------------------------------+
void time_filter::set_wednesday(string trading_times_allowed="00:00-23:59",color tuesday_colour=clrRed)
  {
   set_weekday(WEDNESDAY,trading_times_allowed,tuesday_colour);
  }
//+------------------------------------------------------------------+
//|               SET THURSDAY TIMES                                 |
//+------------------------------------------------------------------+
void time_filter::set_thursday(string trading_times_allowed="00:00-23:59",color tuesday_colour=clrRed)
  {
   set_weekday(THURSDAY,trading_times_allowed,tuesday_colour);
  }
//+------------------------------------------------------------------+
//|               SET FRIDAY TIMES                                   |
//+------------------------------------------------------------------+
void time_filter::set_friday(string trading_times_allowed="00:00-23:59",color tuesday_colour=clrRed)
  {
   set_weekday(FRIDAY,trading_times_allowed,tuesday_colour);
  }
//+------------------------------------------------------------------+
//|               SET SATURDAY TIMES                                 |
//+------------------------------------------------------------------+
void time_filter::set_saturday(string trading_times_allowed="00:00-23:59",color tuesday_colour=clrRed)
  {
   set_weekday(SATURDAY,trading_times_allowed,tuesday_colour);
  }
//+------------------------------------------------------------------+
//|     DISABLE TRADING FOR CURRENT DAY                              |
//+------------------------------------------------------------------+
bool time_filter::disable_trading_for_current_day()
  {
   previous_trading_day = current_weekday;
   previous_trading_day_time = trading_week[current_weekday].times_allowed_to_trade;
   trading_week[current_weekday].times_allowed_to_trade="0";
   disabled_for_the_day=true;
   return true;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void string_to_array(string &Return[], string value, int &Size, string separ = ",")
  {
   string ls_24;
   if(StringSubstr(value, StringLen(value) - 1, 1) != separ)
      StringConcatenate(value, value, separ);
   int li_16 = 0;
   for(int i = StringFind(value, separ, li_16); i > 0; i = StringFind(value, separ, li_16))
     {
      ls_24 = StringSubstr(value, li_16, i - li_16);
      ArrayResize(Return, ArraySize(Return) + 1);
      Return[ArraySize(Return) - 1] = ls_24;
      li_16 = i + 1;
     }
   Size = ArraySize(Return);
  }


//+------------------------------------------------------------------+
//|       RETURN THE CURRENT HOUR                                    |
//+------------------------------------------------------------------+
int current_hour()
  {
   datetime currentTime = TimeCurrent();
   MqlDateTime currentDateTime;
   TimeToStruct(currentTime, currentDateTime);
   return currentDateTime.hour;
  }

//+------------------------------------------------------------------+
//|       RETURN THE CURRENT MINUTES                                 |
//+------------------------------------------------------------------+
int current_minutes()
  {
   datetime currentTime = TimeCurrent();
   MqlDateTime currentDateTime;
   TimeToStruct(currentTime, currentDateTime);
   return currentDateTime.min;
  }
//+------------------------------------------------------------------+
//|      RETURNS TRUE IF WE ARE IN A TRADING SESSION                 |
//+------------------------------------------------------------------+
bool between_trade_times(int start_hour,int start_min,int end_hour,int end_min)
  {
   int hour = current_hour();
   int min = current_minutes();

   if(start_hour < end_hour)    // this means it's during the day
     {
      if(hour == start_hour && min >= start_min)
         return true;

      if(hour > start_hour && hour < end_hour)
         return true;

      if(hour == end_hour && min < end_min)
         return true;
     }

   if(start_hour > end_hour)    // this means it goes overnight
     {
      if(hour == start_hour && min >= start_min)
         return true;

      if(hour > start_hour || hour < end_hour)
         return true;

      if(hour == end_hour && min < end_min)
         return true;
     }


   return false;
  }
//+------------------------------------------------------------------+
//|    RETURN TRUE IF WE NEED TO CLOSE ALL TRADES                    |
//+------------------------------------------------------------------+
bool time_filter::do_we_close_all()
  {
   update_time();
   if(!able_to_open)
      return false;
   if(trading_week[current_weekday].times_allowed_to_trade=="0")
     {
      able_to_open = false;
      return true;

     }

   string time_string_array[];
   int size_of_array;
   string_to_array(time_string_array,trading_week[current_weekday].times_allowed_to_trade,size_of_array,",");
   if(size_of_array>0)
     {
      for(int i=0; i<size_of_array; i++)
        {
         string time_array[];
         int time_size=0;
         string_to_array(time_array,time_string_array[i],time_size,"-");
         if(time_size==2)
           {
            datetime start_time = StringToTime(TimeToString(TimeCurrent(),TIME_DATE)+" "+time_array[0]);
            datetime end_time = StringToTime(TimeToString(TimeCurrent(),TIME_DATE)+" "+time_array[1]);
            if(TimeCurrent()>=start_time && TimeCurrent() < end_time)
               continue;
            else
              {
               able_to_open=false;
               return false;
              }
           }
        }
     }

   return false;
  }


//+------------------------------------------------------------------+
//|       SET TRADING SETTINGS FOR A WEEK                            |
//+------------------------------------------------------------------+
void time_filter::set_weekday(int weekday_number,string trading_times_allowed="00:00-23:59",color weekday_color=clrBlue)
  {
   trading_week[weekday_number].weekday_number=weekday_number;
   trading_week[weekday_number].times_allowed_to_trade=trading_times_allowed;

   trading_week[weekday_number].chart_color=weekday_color;

  }


//+------------------------------------------------------------------+
//|    RETURN TRUE IS A TRADING SESSION JUST OPENED                  |
//+------------------------------------------------------------------+
bool time_filter::has_session_opened()
  {

   bool is_trading_allowed = trading_allowed();
   if(is_trading_allowed!=previous_session_state && previous_session_state==false)
     {
      previous_session_state = is_trading_allowed;
      visualise_trading_session(visualise_sessions);
      return true;
     }
   return false;
  }


//+------------------------------------------------------------------+
//|     RETURN TRUE IF A TRADING SESSION JUST CLOSED                 |
//+------------------------------------------------------------------+
bool time_filter::has_session_closed()
  {
   bool is_trading_allowed = trading_allowed();
   if(is_trading_allowed!=previous_session_state && previous_session_state==true)
     {
      previous_session_state = is_trading_allowed;
      return true;
     }
   return false;
  }
//+------------------------------------------------------------------+
//|    RETURN TRUE IF A TRADING SESSION JUST OPENED VERSION2(WSHAPES)|
//+------------------------------------------------------------------+
bool time_filter::_has_session_opened()
  {

   bool is_trading_allowed = trading_allowed();
   if(is_trading_allowed!=previous_session_state && previous_session_state==false)
     {
      previous_session_state = is_trading_allowed;
      visualise_trading_session();
      return true;
     }
   return false;
  }


//+------------------------------------------------------------------+
//|      DRAW A RECTANGLE                                            |
//+------------------------------------------------------------------+
void time_filter::visualise_trading_session(bool shapes_allowed=true)
  {

   if(!shapes_allowed)
      return;
   block_name = block_name + IntegerToString(trading_signal);
   trading_signal++;
   create_block(block_name, trading_week[current_weekday].chart_color, TimeCurrent(), next_end_time);
  }
//+------------------------------------------------------------------+
