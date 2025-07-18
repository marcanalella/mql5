//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//███████╗██╗  ██╗ █████╗ ██████╗ ███████╗███████╗
//██╔════╝██║  ██║██╔══██╗██╔══██╗██╔════╝██╔════╝
//███████╗███████║███████║██████╔╝█████╗  ███████╗
//╚════██║██╔══██║██╔══██║██╔═══╝ ██╔══╝  ╚════██║
//███████║██║  ██║██║  ██║██║     ███████╗███████║
//╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝     ╚══════╝╚══════╝
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string PREFIX; // Reference for all objects related to dashboard

int _X; // X axis
int _Y; // Y axis
int _W; // Width
int _H ; // Height
//+------------------------------------------------------------------+
//|                    CREATE A LABEL IN THE CHART                   |
//+------------------------------------------------------------------+
void label(string name, int x, int y, ENUM_BASE_CORNER corner, string text, int font_size, color clr, string font = "Arial",bool bold=false)
  {
   string use_bold = "";
   if(bold)
      use_bold=" Bold";
   name = PREFIX + name ; //Unique name for the label
   ObjectDelete(0, name); //Delete an object if it already exists this name
   ObjectCreate(0, name, OBJ_LABEL, 0, 0, 0); //Create an object with this name
   ObjectSetInteger(0, name, OBJPROP_XDISTANCE, x);//Set object with this name X axis distance
   ObjectSetInteger(0, name, OBJPROP_YDISTANCE, y);//Set object this name Y axis distance
   ObjectSetInteger(0, name, OBJPROP_CORNER, corner);//Position this object in which corner
   ObjectSetString(0, name, OBJPROP_TEXT, text);//Add the text for the label
   ObjectSetString(0, name, OBJPROP_FONT, font+use_bold);//Set the font of the text for the label
   ObjectSetInteger(0, name, OBJPROP_FONTSIZE, font_size);//Set the font size of the text for the label
   ObjectSetInteger(0, name, OBJPROP_COLOR, clr);//Set the color of the text for the label
   ObjectSetInteger(0, name, OBJPROP_SELECTABLE, true);//Is this object selectable (can you click on it?)
   ObjectSetInteger(0, name, OBJPROP_SELECTED, false);//Is the object already selected (already clicked on?)
   ObjectSetInteger(0, name, OBJPROP_HIDDEN, false);//Is this object hidden from the object
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void rectangle(string name, int x, int y, int width, int height, ENUM_BASE_CORNER corner, ENUM_BORDER_TYPE border, ENUM_LINE_STYLE style, int line_width, color back_clr)
  {
   name = PREFIX + name ; //Unique name for the rectangle
   ObjectDelete(0, name); //Delete an object if it already exists with this name
   ObjectCreate(0, name, OBJ_RECTANGLE_LABEL, 0, 0, 0); //Create an object with this name
   ObjectSetInteger(0, name, OBJPROP_XDISTANCE, x); //Set object with this name X axis distance
   ObjectSetInteger(0, name, OBJPROP_YDISTANCE, y); //Set object with this name Y axis distance
   ObjectSetInteger(0, name, OBJPROP_XSIZE, width); //Set object with this name Width
   ObjectSetInteger(0, name, OBJPROP_YSIZE, height); //Set object with this name Height
   ObjectSetInteger(0, name, OBJPROP_BGCOLOR, back_clr);//Set background color of this object
   ObjectSetInteger(0, name, OBJPROP_CORNER, corner);//Position this object in which corner
   ObjectSetInteger(0, name, OBJPROP_BORDER_TYPE, border);//Set border type
   ObjectSetInteger(0, name, OBJPROP_STYLE, style);//Set border style
   ObjectSetInteger(0, name, OBJPROP_WIDTH, line_width);//Set object line width around the border of the rectangle
   ObjectSetInteger(0, name, OBJPROP_COLOR, clrBlack);//Set object line colour around the border of the rectangle
   ObjectSetInteger(0, name, OBJPROP_SELECTABLE, false);//Is this object selectable (can you click on it?)
   ObjectSetInteger(0, name, OBJPROP_SELECTED, false);//Is the object already selected (already clicked on?)
   ObjectSetInteger(0, name, OBJPROP_HIDDEN, true);//Is this object hidden from the object
  };


//+------------------------------------------------------------------+
//|              CREATE A BUTTON ON THE CHART                        |
//+------------------------------------------------------------------+
void button(string name, int x, int y, int width, int height, ENUM_BASE_CORNER corner, string text, int font_size, color clr, color back_clr, color border_clr)
  {
   name = PREFIX + name ;
   ObjectDelete(0, name);
   ObjectCreate(0, name, OBJ_BUTTON, 0, 0, 0);
   ObjectSetInteger(0, name, OBJPROP_XDISTANCE, x);
   ObjectSetInteger(0, name, OBJPROP_YDISTANCE, y);
   ObjectSetInteger(0, name, OBJPROP_XSIZE, width);
   ObjectSetInteger(0, name, OBJPROP_YSIZE, height);
   ObjectSetInteger(0, name, OBJPROP_CORNER, corner);
   ObjectSetString(0, name, OBJPROP_TEXT, text);
   ObjectSetInteger(0, name, OBJPROP_FONTSIZE, font_size);
   ObjectSetInteger(0, name, OBJPROP_COLOR, clr);
   ObjectSetInteger(0, name, OBJPROP_BGCOLOR, back_clr);
   ObjectSetInteger(0, name, OBJPROP_BORDER_COLOR, border_clr);
   ObjectSetInteger(0, name, OBJPROP_SELECTABLE, false);
   ObjectSetInteger(0, name, OBJPROP_SELECTED, false);
   ObjectSetInteger(0, name, OBJPROP_HIDDEN, true);
  }

//+------------------------------------------------------------------+
//|             CREATE AN EDIT BOX ON THE CHART                      |
//+------------------------------------------------------------------+
void edit_box(
   string name,
   int x,
   int y,
   int w,
   int h,
   string text,
   int font_size,
   color clr = clrBlack,
   ENUM_BASE_CORNER corner=CORNER_RIGHT_UPPER,
   string font = "Arial",
   color background_colour = clrWhite,
   color border_colour=clrGray
)
  {
   name = PREFIX + name ;
   ObjectDelete(0, name);
   ObjectCreate(0, name, OBJ_EDIT, 0, 0, 0);
   ObjectSetInteger(0, name, OBJPROP_XDISTANCE, x);
   ObjectSetInteger(0, name, OBJPROP_YDISTANCE, y);
   ObjectSetInteger(0, name, OBJPROP_XSIZE, w);
   ObjectSetInteger(0, name, OBJPROP_YSIZE, h);
   ObjectSetInteger(0, name, OBJPROP_CORNER, corner);
   ObjectSetString(0, name, OBJPROP_TEXT, text);
   ObjectSetString(0, name, OBJPROP_FONT, font);
   ObjectSetInteger(0, name, OBJPROP_FONTSIZE, font_size);
   ObjectSetInteger(0, name, OBJPROP_COLOR, clr);
   ObjectSetInteger(0, name, OBJPROP_BGCOLOR, background_colour);
   ObjectSetInteger(0, name, OBJPROP_BORDER_COLOR, border_colour);
   ObjectSetInteger(0, name, OBJPROP_SELECTABLE, false);
   ObjectSetInteger(0, name, OBJPROP_SELECTED, false);
   ObjectSetInteger(0, name, OBJPROP_HIDDEN, true);
  }


//+------------------------------------------------------------------+
//|                 DELETE A LINE                                    |
//+------------------------------------------------------------------+
void delete_line(string line_name)
  {
   ObjectDelete(NULL,line_name);
   ObjectDelete(NULL,line_name+"_label");
  }
//+------------------------------------------------------------------+
//|                  DRAW A VERTICAL LINE                            |
//+------------------------------------------------------------------+
void v_line(string line_name="",color line_colour=clrRed,ENUM_LINE_STYLE style=STYLE_SOLID)
  {
   if(line_name=="")
      line_name=TimeToString(TimeCurrent());
   ObjectCreate(0,line_name,OBJ_VLINE,0,TimeCurrent(), 0);

   ObjectSetInteger(0,line_name,OBJPROP_STYLE, style);
   ObjectSetInteger(0,line_name,OBJPROP_COLOR,line_colour);
   ObjectSetInteger(0,line_name,OBJPROP_BACK, true);
  }
//+------------------------------------------------------------------+
//|                DRAW A HORIZONTAL LINE AT LINE PRICE INPUT        |
//+------------------------------------------------------------------+
void h_line(string line_name,color line_colour,double line_price, string label="",color label_color=NULL)
  {
   if(label_color==NULL)
      label_color=line_colour;
   line_name = PREFIX + line_name ;
   ObjectCreate(0, line_name,OBJ_HLINE,0,0,line_price);
   ObjectSetInteger(0, line_name, OBJPROP_COLOR, line_colour);



   string label_name=line_name+"_label";
   datetime tim=iTime(_Symbol,PERIOD_CURRENT,1);
   double price=line_price;
   ObjectCreate(0,label_name,OBJ_TEXT,0,tim,price);
   ObjectSetString(0,label_name,OBJPROP_TEXT,label+ " "+(string)DoubleToString(line_price,_Digits));
   ObjectSetInteger(0, label_name, OBJPROP_COLOR, label_color);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void create_block(string name, color block_color, datetime start_time=0, datetime end_time=0)
  {
   if(start_time == 0)
      start_time = TimeCurrent();
   if(end_time == 0)
      end_time = TimeCurrent();
   ObjectCreate(0, name, OBJ_RECTANGLE, 0, start_time, 0, end_time, 9999);
   ObjectSetInteger(0, name, OBJPROP_COLOR, block_color);
   ObjectSetInteger(0, name, OBJPROP_STYLE, STYLE_SOLID);
   ObjectSetInteger(0, name, OBJPROP_WIDTH, 1);
   ObjectSetInteger(0, name, OBJPROP_BACK, true);
   ObjectSetInteger(0, name, OBJPROP_FILL, true);
   ObjectSetInteger(0, name, OBJPROP_ZORDER, 0);
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void update_block(string name,datetime new_date=0)
  {
   if(new_date == 0)
      new_date = TimeCurrent();

   ObjectMove(0, name, 0, new_date, -1);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void fibo(string name, datetime time1, double price1, datetime time2, double price2, color level_clr=clrLimeGreen, color line_clr=clrGray)
  {
   bool result = true;
   long chart_id = 0;
   ObjectDelete(chart_id, name);
   ObjectCreate(chart_id, name, OBJ_FIBO, 0, time1, price1, time2, price2);
   ObjectSetInteger(chart_id, name, OBJPROP_COLOR, line_clr);
   ObjectSetInteger(chart_id, name, OBJPROP_LEVELCOLOR, 0, level_clr);
  }
//+------------------------------------------------------------------+
//|           DRAW A HORIZONTAL LINE BETWEEN TWO POINTS              |
//+------------------------------------------------------------------+
void line(string line_name, color _line_color, datetime time_1, double price_1, datetime time_2, double price_2)
  {
   ObjectCreate(0, line_name, OBJ_TREND, 0, 0, 0);

   ObjectSetInteger(0, line_name, OBJPROP_COLOR, _line_color);
   ObjectSetInteger(0, line_name, OBJPROP_STYLE, STYLE_SOLID);
   ObjectSetInteger(0, line_name, OBJPROP_WIDTH, 1);
   ObjectSetInteger(0, line_name, OBJPROP_TIME, 0, time_1);
   ObjectSetInteger(0, line_name, OBJPROP_TIME, 1, time_2);
   ObjectSetDouble(0, line_name, OBJPROP_PRICE, 0, price_1);
   ObjectSetDouble(0, line_name, OBJPROP_PRICE, 1, price_2);
   ObjectSetInteger(0,line_name,OBJPROP_BACK, true);
  }
//+------------------------------------------------------------------+
//|            ADD TEXT TO THE CHART                                 |
//+------------------------------------------------------------------+
void text_label(string text, datetime time, double price, color text_colour=clrBlack, string font="Arial",int font_size=8)
  {
   ObjectCreate(0,text+TimeToString(time),OBJ_TEXT,0,time,price);
   ObjectSetInteger(0,text+TimeToString(time),OBJPROP_FONTSIZE,font_size);
   ObjectSetInteger(0,text+TimeToString(time),OBJPROP_COLOR,text_colour);
   ObjectSetString(0,text+TimeToString(time),OBJPROP_TEXT,text);
  }
//+------------------------------------------------------------------+
//|          UPDATE A LINE BY NAME TO A NEW TIME                     |
//+------------------------------------------------------------------+
void update_line(string name, datetime new_date=0)
  {
   if(new_date == 0)
      new_date = TimeCurrent();

   ObjectSetInteger(0, name, OBJPROP_TIME, 1, new_date) ;
  }
//+------------------------------------------------------------------+
//|              HIGHLIGHT A CANDLE                                  |
//+------------------------------------------------------------------+
void highlight_chart(
   string internal_name,
   datetime time1,
   double price1,
   datetime time2,
   double price2,
   color highlight_colour,
   bool fill
)
  {
   if(!ObjectCreate(0,internal_name,OBJ_RECTANGLE,0,time1,price1,time2,price2))
     {
      Print(__FUNCTION__+": failed to create a rectangle! Error code = "+IntegerToString(GetLastError()));
     }

   ObjectSetInteger(0,internal_name,OBJPROP_COLOR,highlight_colour);
   ObjectSetInteger(0,internal_name,OBJPROP_STYLE,STYLE_SOLID);
   ObjectSetInteger(0,internal_name,OBJPROP_WIDTH,2);

   ObjectSetInteger(0,internal_name,OBJPROP_FILL,fill);
   if(!fill)
      ObjectSetInteger(0,internal_name,OBJPROP_BACK,false);
   else
      ObjectSetInteger(0,internal_name,OBJPROP_BACK,true);

   ObjectSetInteger(0,internal_name,OBJPROP_SELECTABLE,false);
   ObjectSetInteger(0,internal_name,OBJPROP_SELECTED,false);
   ObjectSetInteger(0,internal_name,OBJPROP_HIDDEN,false);
   ObjectSetInteger(0,internal_name,OBJPROP_ZORDER,0);

  }
//+------------------------------------------------------------------+

void watermark(string text, string font, int text_size,int x, int y,color watermark_colour)
  {
   uint w,h;
   TextSetFont(font,text_size);
   TextGetSize(text,w,h);
   label(text,x+(w*2),y+(h*2),CORNER_RIGHT_LOWER,text,text_size,watermark_colour,font);

  }