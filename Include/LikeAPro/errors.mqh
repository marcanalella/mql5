//+------------------------------------------------+
//|                                                |
//+------------------------------------------------+
//███████╗██████╗ ██████╗  ██████╗ ██████╗ ███████╗
//██╔════╝██╔══██╗██╔══██╗██╔═══██╗██╔══██╗██╔════╝
//█████╗  ██████╔╝██████╔╝██║   ██║██████╔╝███████╗
//██╔══╝  ██╔══██╗██╔══██╗██║   ██║██╔══██╗╚════██║
//███████╗██║  ██║██║  ██║╚██████╔╝██║  ██║███████║
//╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═╝╚══════
//+------------------------------------------------+
//|                                                |
//+------------------------------------------------+
string get_error(int code)
  {

   if(code == 10004)
     {
      return "Requote";
     }

   if(code == 10006)
     {
      return "Request rejected";
     }

   if(code == 10007)
     {
      return "Request canceled by trader";
     }

   if(code == 10008)
     {
      return "Order placed";
     }

   if(code == 10009)
     {
      return "Request completed";
     }

   if(code == 10010)
     {
      return "Only part of the request was completed";
     }

   if(code == 10011)
     {
      return "Request processing error";
     }

   if(code == 10012)
     {
      return "Request canceled by timeout";
     }

   if(code == 10013)
     {
      return "Invalid request";
     }

   if(code == 10014)
     {
      return "Invalid volume in the request";
     }

   if(code == 10015)
     {
      return "Invalid price in the request";
     }

   if(code == 10016)
     {
      return "Invalid stops in the request";
     }

   if(code == 10017)
     {
      return "Trade is disabled";
     }

   if(code == 10018)
     {
      return "Market is closed";
     }

   if(code == 10019)
     {
      return "There is not enough money to complete the request";
     }

   if(code == 10020)
     {
      return "Prices changed";
     }

   if(code == 10021)
     {
      return "There are no quotes to process the request";
     }

   if(code == 10022)
     {
      return "Invalid order expiration date in the request";
     }

   if(code == 10023)
     {
      return "Order state changed";
     }

   if(code == 10024)
     {
      return "Too frequent requests";
     }

   if(code == 10025)
     {
      return "No changes in request";
     }

   if(code == 10026)
     {
      return "Autotrading disabled by server";
     }

   if(code == 10027)
     {
      return "Autotrading disabled by client terminal";
     }

   if(code == 10028)
     {
      return "Request locked for processing";
     }

   if(code == 10029)
     {
      return "Order or position frozen";
     }

   if(code == 10030)
     {
      return "Invalid order filling type";
     }

   if(code == 10031)
     {
      return "No connection with the trade server";
     }

   if(code == 10032)
     {
      return "Operation is allowed only for live accounts";
     }

   if(code == 10033)
     {
      return "The number of pending orders has reached the limit";
     }

   if(code == 10034)
     {
      return "The volume of orders and positions for the symbol has reached the limit";
     }

   if(code == 10035)
     {
      return "Incorrect or prohibited order type";
     }

   if(code == 10036)
     {
      return "Position with the specified POSITION_IDENTIFIER has already been closed";
     }

   if(code == 10038)
     {
      return "A close volume exceeds the current position volume";
     }

   if(code == 10039)
     {
      return "A close order already exists for a specified position. This may happen when working in the hedging system: - when attempting to close a position with an opposite one, while close orders for the position already exist - when attempting to fully or partially close a position if the total volume of the already present close orders and the newly placed one exceeds the current position volume";
     }

   if(code == 10040)
     {
      return "The number of open positions simultaneously present on an account can be limited by the server settings. After a limit is reached, the server returns the TRADE_RETCODE_LIMIT_POSITIONS error when attempting to place an order. The limitation operates differently depending on the position accounting type: - Netting — number of open positions is considered. When a limit is reached, the platform does not let placing new orders whose execution may increase the number of open positions. In fact, the platform allows placing orders only for the symbols that already have open positions. The current pending orders are not considered since their execution may lead to changes in the current positions but it cannot increase their number. - Hedging — pending orders are considered together with open positions, since a pending order activation always leads to opening a new position. When a limit is reached, the platform does not allow placing both new market orders for opening positions and pending orders.";
     }

   if(code == 10041)
     {
      return "The pending order activation request is rejected, the order is canceled";
     }

   if(code == 10042)
     {
      return "The request is rejected, because the 'Only long positions are allowed' rule is set for the symbol (POSITION_TYPE_BUY)";
     }

   if(code == 10043)
     {
      return "The request is rejected, because the 'Only short positions are allowed' rule is set for the symbol (POSITION_TYPE_SELL)";
     }

   if(code == 10044)
     {
      return "The request is rejected, because the 'Only position closing is allowed' rule is set for the symbol ";
     }

   if(code == 10045)
     {
      return "The request is rejected, because 'Position closing is allowed only by FIFO rule' flag is set for the trading account (ACCOUNT_FIFO_CLOSE=true)";
     }

   if(code == 10046)
     {
      return "The request is rejected, because the 'Opposite positions on a single symbol are disabled' rule is set for the trading account. For example, if the account has a Buy position, then a user cannot open a Sell position or place a pending sell order. The rule is only applied to accounts with hedging accounting system (ACCOUNT_MARGIN_MODE=ACCOUNT_MARGIN_MODE_RETAIL_HEDGING).";
     }

   if(code == 0)
     {
      return "The operation completed successfully";
     }

   if(code == 4001)
     {
      return "Unexpected internal error";
     }

   if(code == 4002)
     {
      return "Wrong parameter in the inner call of the client terminal function";
     }

   if(code == 4003)
     {
      return "Wrong parameter when calling the system function";
     }

   if(code == 4004)
     {
      return "Not enough memory to perform the system function";
     }

   if(code == 4005)
     {
      return "The structure contains objects of strings and/or dynamic arrays and/or structure of such objects and/or classes";
     }

   if(code == 4006)
     {
      return "Array of a wrong type, wrong size, or a damaged object of a dynamic array";
     }

   if(code == 4007)
     {
      return "Not enough memory for the relocation of an array, or an attempt to change the size of a static array";
     }

   if(code == 4008)
     {
      return "Not enough memory for the relocation of string";
     }

   if(code == 4009)
     {
      return "Not initialized string";
     }

   if(code == 4010)
     {
      return "Invalid date and/or time";
     }

   if(code == 4011)
     {
      return "Total amount of elements in the array cannot exceed 2147483647";
     }

   if(code == 4012)
     {
      return "Wrong pointer";
     }

   if(code == 4013)
     {
      return "Wrong type of pointer";
     }

   if(code == 4014)
     {
      return "Function is not allowed for call";
     }

   if(code == 4015)
     {
      return "The names of the dynamic and the static resource match";
     }

   if(code == 4016)
     {
      return "Resource with this name has not been found in EX5";
     }

   if(code == 4017)
     {
      return "Unsupported resource type or its size exceeds 16 Mb";
     }

   if(code == 4018)
     {
      return "The resource name exceeds 63 characters";
     }

   if(code == 4019)
     {
      return "Overflow occurred when calculating math function";
     }

   if(code == 4020)
     {
      return "Out of test end date after calling Sleep()";
     }

   if(code == 4022)
     {
      return "Test forcibly stopped from the outside. For example, optimization interrupted, visual testing window closed or testing agent stopped";
     }

   if(code == 4023)
     {
      return "Invalid type";
     }

   if(code == 4024)
     {
      return "Invalid handle";
     }

   if(code == 4025)
     {
      return "Object pool filled out";
     }

   if(code == 4101)
     {
      return "Wrong chart ID";
     }

   if(code == 4102)
     {
      return "Chart does not respond";
     }

   if(code == 4103)
     {
      return "Chart not found";
     }

   if(code == 4104)
     {
      return "No Expert Advisor in the chart that could handle the event";
     }

   if(code == 4105)
     {
      return "Chart opening error";
     }

   if(code == 4106)
     {
      return "Failed to change chart symbol and period";
     }

   if(code == 4107)
     {
      return "Error value of the parameter for the function of working with charts";
     }

   if(code == 4108)
     {
      return "Failed to create timer";
     }

   if(code == 4109)
     {
      return "Wrong chart property ID";
     }

   if(code == 4110)
     {
      return "Error creating screenshots";
     }

   if(code == 4111)
     {
      return "Error navigating through chart";
     }

   if(code == 4112)
     {
      return "Error applying template";
     }

   if(code == 4113)
     {
      return "Subwindow containing the indicator was not found";
     }

   if(code == 4114)
     {
      return "Error adding an indicator to chart";
     }

   if(code == 4115)
     {
      return "Error deleting an indicator from the chart";
     }

   if(code == 4116)
     {
      return "Indicator not found on the specified chart";
     }

   if(code == 4201)
     {
      return "Error working with a graphical object";
     }

   if(code == 4202)
     {
      return "Graphical object was not found";
     }

   if(code == 4203)
     {
      return "Wrong ID of a graphical object property";
     }

   if(code == 4204)
     {
      return "Unable to get date corresponding to the value";
     }

   if(code == 4205)
     {
      return "Unable to get value corresponding to the date";
     }

   if(code == 4301)
     {
      return "Unknown symbol";
     }

   if(code == 4302)
     {
      return "Symbol is not selected in MarketWatch";
     }

   if(code == 4303)
     {
      return "Wrong identifier of a symbol property";
     }

   if(code == 4304)
     {
      return "Time of the last tick is not known (no ticks)";
     }

   if(code == 4305)
     {
      return "Error adding or deleting a symbol in MarketWatch";
     }

   if(code == 4401)
     {
      return "Requested history not found";
     }

   if(code == 4402)
     {
      return "Wrong ID of the history property";
     }

   if(code == 4403)
     {
      return "Exceeded history request timeout";
     }

   if(code == 4404)
     {
      return "Number of requested bars limited by terminal settings";
     }

   if(code == 4405)
     {
      return "Multiple errors when loading history";
     }

   if(code == 4407)
     {
      return "Receiving array is too small to store all requested data";
     }

   if(code == 4501)
     {
      return "Global variable of the client terminal is not found";
     }

   if(code == 4502)
     {
      return "Global variable of the client terminal with the same name already exists";
     }

   if(code == 4503)
     {
      return "Global variables were not modified";
     }

   if(code == 4504)
     {
      return "Cannot read file with global variable values";
     }

   if(code == 4505)
     {
      return "Cannot write file with global variable values";
     }

   if(code == 4510)
     {
      return "Email sending failed";
     }

   if(code == 4511)
     {
      return "Sound playing failed";
     }

   if(code == 4512)
     {
      return "Wrong identifier of the program property";
     }

   if(code == 4513)
     {
      return "Wrong identifier of the terminal property";
     }

   if(code == 4514)
     {
      return "File sending via ftp failed";
     }

   if(code == 4515)
     {
      return "Failed to send a notification";
     }

   if(code == 4516)
     {
      return "Invalid parameter for sending a notification – an empty string or NULL has been passed to the SendNotification() function";
     }

   if(code == 4517)
     {
      return "Wrong settings of notifications in the terminal (ID is not specified or permission is not set)";
     }

   if(code == 4518)
     {
      return "Too frequent sending of notifications";
     }

   if(code == 4519)
     {
      return "FTP server is not specified";
     }

   if(code == 4520)
     {
      return "FTP login is not specified";
     }

   if(code == 4521)
     {
      return "File not found in the MQL5 Files directory to send on FTP server";
     }

   if(code == 4522)
     {
      return "FTP connection failed";
     }

   if(code == 4523)
     {
      return "FTP path not found on server";
     }

   if(code == 4601)
     {
      return "Not enough memory for the distribution of indicator buffers";
     }

   if(code == 4602)
     {
      return "Wrong indicator buffer index";
     }

   if(code == 4603)
     {
      return "Wrong ID of the custom indicator property";
     }

   if(code == 4701)
     {
      return "Wrong account property ID";
     }

   if(code == 4751)
     {
      return "Wrong trade property ID";
     }

   if(code == 4752)
     {
      return "Trading by Expert Advisors prohibited";
     }

   if(code == 4753)
     {
      return "Position not found";
     }

   if(code == 4754)
     {
      return "Order not found";
     }

   if(code == 4755)
     {
      return "Deal not found";
     }

   if(code == 4756)
     {
      return "Trade request sending failed";
     }

   if(code == 4758)
     {
      return "Failed to calculate profit or margin";
     }

   if(code == 4801)
     {
      return "Unknown symbol";
     }

   if(code == 4802)
     {
      return "Indicator cannot be created";
     }

   if(code == 4803)
     {
      return "Not enough memory to add the indicator";
     }

   if(code == 4804)
     {
      return "The indicator cannot be applied to another indicator";
     }

   if(code == 4805)
     {
      return "Error applying an indicator to chart";
     }


   if(code == 4806)
     {
      return "Requested data not found";
     }

   if(code == 4807)
     {
      return "Wrong indicator handle";
     }

   if(code == 4808)
     {
      return "Wrong number of parameters when creating an indicator";
     }

   if(code == 4809)
     {
      return "No parameters when creating an indicator";
     }

   if(code == 4810)
     {
      return "The first parameter in the array must be the name of the custom indicator";
     }

   if(code == 4811)
     {
      return "Invalid parameter type in the array when creating an indicator";
     }

   if(code == 4812)
     {
      return "Wrong index of the requested indicator buffer";
     }

   if(code == 4901)
     {
      return "Depth Of Market can not be added";
     }

   if(code == 4902)
     {
      return "Depth Of Market can not be removed";
     }

   if(code == 4903)
     {
      return "The data from Depth Of Market can not be obtained";
     }

   if(code == 4904)
     {
      return "Error in subscribing to receive new data from Depth Of Market";
     }

   if(code == 5001)
     {
      return "More than 64 files cannot be opened at the same time";
     }

   if(code == 5002)
     {
      return "Invalid file name";
     }

   if(code == 5003)
     {
      return "Too long file name";
     }

   if(code == 5004)
     {
      return "File opening error";
     }

   if(code == 5005)
     {
      return "Not enough memory for cache to read";
     }

   if(code == 5006)
     {
      return "File deleting error";
     }

   if(code == 5007)
     {
      return "A file with this handle was closed, or was not opening at all";
     }

   if(code == 5008)
     {
      return "Wrong file handle";
     }

   if(code == 5009)
     {
      return "The file must be opened for writing";
     }

   if(code == 5010)
     {
      return "The file must be opened for reading";
     }

   if(code == 5011)
     {
      return "The file must be opened as a binary one";
     }

   if(code == 5012)
     {
      return "The file must be opened as a text";
     }

   if(code == 5013)
     {
      return "The file must be opened as a text or CSV";
     }

   if(code == 5014)
     {
      return "The file must be opened as CSV";
     }

   if(code == 5015)
     {
      return "File reading error";
     }

   if(code == 5016)
     {
      return "String size must be specified, because the file is opened as binary";
     }

   if(code == 5017)
     {
      return "A text file must be for string arrays, for other arrays - binary";
     }

   if(code == 5018)
     {
      return "This is not a file, this is a directory";
     }

   if(code == 5019)
     {
      return "File does not exist";
     }

   if(code == 5020)
     {
      return "File can not be rewritten";
     }

   if(code == 5021)
     {
      return "Wrong directory name";
     }

   if(code == 5022)
     {
      return "Directory does not exist";
     }

   if(code == 5023)
     {
      return "This is a file, not a directory";
     }

   if(code == 5024)
     {
      return "The directory cannot be removed";
     }

   if(code == 5025)
     {
      return "Failed to clear the directory (probably one or more files are blocked and removal operation failed)";
     }

   if(code == 5026)
     {
      return "Failed to write a resource to a file";
     }

   if(code == 5027)
     {
      return "Unable to read the next piece of data from a CSV file (FileReadString, FileReadNumber, FileReadDatetime, FileReadBool), since the end of file is reached";
     }

   if(code == 5030)
     {
      return "No date in the string";
     }

   if(code == 5031)
     {
      return "Wrong date in the string";
     }

   if(code == 5032)
     {
      return "Wrong time in the string";
     }

   if(code == 5033)
     {
      return "Error converting string to date";
     }

   if(code == 5034)
     {
      return "Not enough memory for the string";
     }

   if(code == 5035)
     {
      return "The string length is less than expected";
     }

   if(code == 5036)
     {
      return "Too large number, more than ULONG_MAX";
     }

   if(code == 5037)
     {
      return "Invalid format string";
     }

   if(code == 5038)
     {
      return "Amount of format specifiers more than the parameters";
     }

   if(code == 5039)
     {
      return "Amount of parameters more than the format specifiers";
     }

   if(code == 5040)
     {
      return "Damaged parameter of string type";
     }

   if(code == 5041)
     {
      return "Position outside the string";
     }

   if(code == 5042)
     {
      return "0 added to the string end, a useless operation";
     }

   if(code == 5043)
     {
      return "Unknown data type when converting to a string";
     }

   if(code == 5044)
     {
      return "Damaged string object";
     }

   if(code == 5050)
     {
      return "Copying incompatible arrays. String array can be copied only to a string array, and a numeric array - in numeric array only";
     }

   if(code == 5051)
     {
      return "The receiving array is declared as AS_SERIES, and it is of insufficient size";
     }

   if(code == 5052)
     {
      return "Too small array, the starting position is outside the array";
     }

   if(code == 5053)
     {
      return "An array of zero length";
     }

   if(code == 5054)
     {
      return "Must be a numeric array";
     }

   if(code == 5055)
     {
      return "Must be a one-dimensional array";
     }

   if(code == 5056)
     {
      return "Timeseries cannot be used";
     }

   if(code == 5057)
     {
      return "Must be an array of type double";
     }

   if(code == 5058)
     {
      return "Must be an array of type float";
     }

   if(code == 5059)
     {
      return "Must be an array of type long";
     }

   if(code == 5060)
     {
      return "Must be an array of type int";
     }

   if(code == 5061)
     {
      return "Must be an array of type short";
     }

   if(code == 5062)
     {
      return "Must be an array of type char";
     }

   if(code == 5063)
     {
      return "String array only";
     }

   if(code == 5100)
     {
      return "OpenCL functions are not supported on this computer";
     }

   if(code == 5101)
     {
      return "Internal error occurred when running OpenCL";
     }

   if(code == 5102)
     {
      return "Invalid OpenCL handle";
     }

   if(code == 5103)
     {
      return "Error creating the OpenCL context";
     }

   if(code == 5104)
     {
      return "Failed to create a run queue in OpenCL";
     }

   if(code == 5105)
     {
      return "Error occurred when compiling an OpenCL program";
     }

   if(code == 5106)
     {
      return "Too long kernel name (OpenCL kernel)";
     }

   if(code == 5107)
     {
      return "Error creating an OpenCL kernel";
     }

   if(code == 5108)
     {
      return "Error occurred when setting parameters for the OpenCL kernel";
     }

   if(code == 5109)
     {
      return "OpenCL program runtime error";
     }

   if(code == 5110)
     {
      return "Invalid size of the OpenCL buffer";
     }

   if(code == 5111)
     {
      return "Invalid offset in the OpenCL buffer";
     }

   if(code == 5112)
     {
      return "Failed to create an OpenCL buffer";
     }

   if(code == 5113)
     {
      return "Too many OpenCL objects";
     }

   if(code == 5114)
     {
      return "OpenCL device selection error";
     }

   if(code == 5120)
     {
      return "Internal database error";
     }

   if(code == 5121)
     {
      return "Invalid database handle";
     }

   if(code == 5122)
     {
      return "Exceeded the maximum acceptable number of Database objects";
     }

   if(code == 5123)
     {
      return "Database connection error";
     }

   if(code == 5124)
     {
      return "Request execution error";
     }

   if(code == 5125)
     {
      return "Request generation error";
     }

   if(code == 5126)
     {
      return "No more data to read";
     }

   if(code == 5127)
     {
      return "Failed to move to the next request entry";
     }

   if(code == 5128)
     {
      return "Data for reading request results are not ready yet";
     }

   if(code == 5129)
     {
      return "Failed to auto substitute parameters to an SQL request";
     }

   if(code == 5200)
     {
      return "Invalid URL";
     }

   if(code == 5201)
     {
      return "Failed to connect to specified URL";
     }

   if(code == 5202)
     {
      return "Timeout exceeded";
     }

   if(code == 5203)
     {
      return "HTTP request failed";
     }

   if(code == 5270)
     {
      return "Invalid socket handle passed to function";
     }

   if(code == 5271)
     {
      return "Too many open sockets (max 128)";
     }

   if(code == 5272)
     {
      return "Failed to connect to remote host";
     }

   if(code == 5273)
     {
      return "Failed to send/receive data from socket";
     }

   if(code == 5274)
     {
      return "Failed to establish secure connection (TLS Handshake)";
     }

   if(code == 5275)
     {
      return "No data on certificate protecting the connection";
     }

   if(code == 5300)
     {
      return "A custom symbol must be specified";
     }

   if(code == 5301)
     {
      return "The name of the custom symbol is invalid. The symbol name can only contain Latin letters without punctuation, spaces or special characters (may only contain '.', '_', '&' and '#'). It is not recommended to use characters <, >, :, ', / , |, ?, *.";
     }

   if(code == 5302)
     {
      return "The name of the custom symbol is too long. The length of the symbol name must not exceed 32 characters including the ending 0 character";
     }

   if(code == 5303)
     {
      return "The path of the custom symbol is too long. The path length should not exceed 128 characters including 'Custom\\', the symbol name, group separators and the ending 0";
     }

   if(code == 5304)
     {
      return "A custom symbol with the same name already exists";
     }

   if(code == 5305)
     {
      return "Error occurred while creating, deleting or changing the custom symbol";
     }

   if(code == 5306)
     {
      return "You are trying to delete a custom symbol selected in Market Watch";
     }

   if(code == 5307)
     {
      return "An invalid custom symbol property";
     }

   if(code == 5308)
     {
      return "A wrong parameter while setting the property of a custom symbol";
     }

   if(code == 5309)
     {
      return "A too long string parameter while setting the property of a custom symbol";
     }

   if(code == 5310)
     {
      return "Ticks in the array are not arranged in the order of time";
     }

   if(code == 5400)
     {
      return "Array size is insufficient for receiving descriptions of all values";
     }

   if(code == 5401)
     {
      return "Request time limit exceeded";
     }

   if(code == 5402)
     {
      return "Country is not found";
     }

   if(code == 5601)
     {
      return "Generic error";
     }

   if(code == 5602)
     {
      return "SQLite internal logic error";
     }

   if(code == 5603)
     {
      return "Access denied";
     }

   if(code == 5604)
     {
      return "Callback routine requested abort";
     }

   if(code == 5605)
     {
      return "Database file locked";
     }

   if(code == 5606)
     {
      return "Database table locked";
     }

   if(code == 5607)
     {
      return "Insufficient memory for completing operation";
     }

   if(code == 5608)
     {
      return "Attempt to write to readonly database";
     }

   if(code == 5609)
     {
      return "Operation terminated by sqlite3_interrupt()";
     }

   if(code == 5610)
     {
      return "Disk I/O error";
     }

   if(code == 5611)
     {
      return "Database disk image corrupted";
     }

   if(code == 5612)
     {
      return "Unknown operation code in sqlite3_file_control()";
     }

   if(code == 5613)
     {
      return "Insertion failed because database is full";
     }

   if(code == 5614)
     {
      return "Unable to open the database file";
     }

   if(code == 5615)
     {
      return "Database lock protocol error";
     }

   if(code == 5616)
     {
      return "Internal use only";
     }

   if(code == 5617)
     {
      return "Database schema changed";
     }

   if(code == 5618)
     {
      return "String or BLOB exceeds size limit";
     }

   if(code == 5619)
     {
      return "Abort due to constraint violation";
     }

   if(code == 5620)
     {
      return "Data type mismatch";
     }

   if(code == 5621)
     {
      return "Library used incorrectly";
     }

   if(code == 5622)
     {
      return "Uses OS features not supported on host";
     }

   if(code == 5623)
     {
      return "Authorization denied";
     }

   if(code == 5624)
     {
      return "Not used ";
     }

   if(code == 5625)
     {
      return "Bind parameter error, incorrect index";
     }

   if(code == 5626)
     {
      return "File opened that is not database file";
     }

   if(code == 5700)
     {
      return "Internal error of the matrix/vector executing subsystem";
     }

   if(code == 5701)
     {
      return "Matrix/vector not initialized";
     }

   if(code == 5702)
     {
      return "Inconsistent size of matrices/vectors in operation";
     }

   if(code == 5703)
     {
      return "Invalid matrix/vector size";
     }

   if(code == 5704)
     {
      return "Invalid matrix/vector type";
     }

   if(code == 5705)
     {
      return "Function not available for this matrix/vector";
     }

   if(code == 5706)
     {
      return "Matrix/vector contains non-numbers (Nan/Inf)";
     }

   if(code == 5800)
     {
      return "ONNX internal error";
     }

   if(code == 5801)
     {
      return "ONNX Runtime API initialization error";
     }

   if(code == 5802)
     {
      return "Property or value not supported by MQL5";
     }

   if(code == 5803)
     {
      return "ONNX runtime API run error";
     }

   if(code == 5804)
     {
      return "Invalid number of parameters passed to OnnxRun";
     }

   if(code == 5805)
     {
      return "Invalid parameter value";
     }

   if(code == 5806)
     {
      return "Invalid parameter type";
     }

   if(code == 5807)
     {
      return "Invalid parameter size";
     }

   if(code == 5808)
     {
      return "Tensor dimension not set or invalid";
     }

   if(code == 65536)
     {
      return "User defined errors start with this code";
     }

   if(code == 100)
     {
      return "File reading error";
     }

   if(code == 101)
     {
      return "Error of opening an *.EX5 for writing";
     }

   if(code == 103)
     {
      return "Not enough free memory to complete compilation";
     }

   if(code == 104)
     {
      return "Empty syntactic unit unrecognized by compiler";
     }

   if(code == 105)
     {
      return "Incorrect file name in #include";
     }

   if(code == 106)
     {
      return "Error accessing a file in #include (probably the file does not exist)";
     }

   if(code == 108)
     {
      return "Inappropriate name for #define";
     }

   if(code == 109)
     {
      return "Unknown command of preprocessor (valid #include, #define, #property, #import)";
     }

   if(code == 110)
     {
      return "Symbol unknown to compiler";
     }

   if(code == 111)
     {
      return "Function not implemented (description is present, but no body)";
     }

   if(code == 112)
     {
      return "Double quote (\") omitted";
     }

   if(code == 113)
     {
      return "Opening angle bracket (<) or double quote (\") omitted";
     }

   if(code == 114)
     {
      return "Single quote (') omitted";
     }

   if(code == 115)
     {
      return "Closing angle bracket > omitted";
     }

   if(code == 116)
     {
      return "Type not specified in declaration";
     }

   if(code == 117)
     {
      return "No return operator or return is found not in all branches of the implementation";
     }

   if(code == 118)
     {
      return "Opening bracket of call parameters was expected";
     }

   if(code == 119)
     {
      return "Error writing EX5";
     }

   if(code == 120)
     {
      return "Invalid access to an array";
     }

   if(code == 121)
     {
      return "The function is not of void type and the return operator must return a value";
     }

   if(code == 122)
     {
      return "Incorrect declaration of the destructor";
     }

   if(code == 123)
     {
      return "Colon ':' is missing";
     }

   if(code == 124)
     {
      return "Variable is already declared";
     }

   if(code == 125)
     {
      return "Variable with such identifier already declared";
     }

   if(code == 126)
     {
      return "Variable name is too long (> 250 characters)";
     }

   if(code == 127)
     {
      return "Structure with such identifier already defined";
     }

   if(code == 128)
     {
      return "Structure is not defined";
     }

   if(code == 129)
     {
      return "Structure member with the same name already defined";
     }

   if(code == 130)
     {
      return "No such structure member";
     }

   if(code == 131)
     {
      return "Breached pairing of brackets";
     }

   if(code == 132)
     {
      return "Opening parenthesis \"(\" expected";
     }

   if(code == 133)
     {
      return "Unbalanced braces (no \"}\")";
     }

   if(code == 134)
     {
      return "Difficult to compile (too much branching, internal stack levels are overfilled)";
     }

   if(code == 135)
     {
      return "Error of file opening for reading";
     }

   if(code == 136)
     {
      return "Not enough memory to download the source file into memory";
     }

   if(code == 137)
     {
      return "Variable is expected";
     }

   if(code == 138)
     {
      return "Reference cannot be initialized";
     }

   if(code == 140)
     {
      return "Assignment expected (appears at declaration)";
     }

   if(code == 141)
     {
      return "Opening brace '{' expected";
     }

   if(code == 142)
     {
      return "Parameter can be a dynamic array only";
     }

   if(code == 143)
     {
      return "Use of \"void\" type is unacceptable";
     }

   if(code == 144)
     {
      return "No pair for \")\" or \"]\", i.e. \"(or\" [ \" is absent";
     }

   if(code == 145)
     {
      return "No pair for \"(or\" [ \", i.e. \") \"or\"] \" is absent";
     }

   if(code == 146)
     {
      return "Incorrect array size";
     }

   if(code == 147)
     {
      return "Too many parameters (> 64)";
     }

   if(code == 149)
     {
      return "This token is not expected here";
     }

   if(code == 150)
     {
      return "Invalid use of operation (invalid operands)";
     }

   if(code == 151)
     {
      return "Expression of void type not allowed";
     }

   if(code == 152)
     {
      return "Operator is expected";
     }

   if(code == 153)
     {
      return "Misuse of break";
     }

   if(code == 154)
     {
      return "Semicolon \";\" expected";
     }

   if(code == 155)
     {
      return "Comma \",\" expected";
     }

   if(code == 156)
     {
      return "Must be a class type, not struct";
     }

   if(code == 157)
     {
      return "Expression is expected";
     }

   if(code == 158)
     {
      return "\"non HEX character\" found in HEX or too long number (number of digits> 511)";
     }

   if(code == 159)
     {
      return "String-constant has more than 65534 characters";
     }

   if(code == 160)
     {
      return "Function definition is unacceptable here";
     }

   if(code == 161)
     {
      return "Unexpected end of program";
     }

   if(code == 162)
     {
      return "Forward declaration is prohibited for structures";
     }

   if(code == 163)
     {
      return "Function with this name is already defined and has another return type";
     }

   if(code == 164)
     {
      return "Function with this name is already defined and has a different set of parameters";
     }

   if(code == 165)
     {
      return "Function with this name is already defined and implemented";
     }

   if(code == 166)
     {
      return "Function overload for this call was not found";
     }

   if(code == 167)
     {
      return "Function with a return value of void type cannot return a value";
     }

   if(code == 168)
     {
      return "Function is not defined";
     }

   if(code == 170)
     {
      return "Value is expected";
     }

   if(code == 171)
     {
      return "In case expression only integer constants are valid";
     }

   if(code == 172)
     {
      return "The value of case in this switch is already used";
     }

   if(code == 173)
     {
      return "Integer is expected";
     }

   if(code == 174)
     {
      return "In #import expression file name is expected";
     }

   if(code == 175)
     {
      return "Expressions are not allowed on global level";
     }

   if(code == 176)
     {
      return "Omitted parenthesis \")\" before \";\"";
     }

   if(code == 177)
     {
      return "To the left of equality sign a variable is expected";
     }

   if(code == 178)
     {
      return "The result of expression is not used";
     }

   if(code == 179)
     {
      return "Declaring of variables is not allowed in case";
     }

   if(code == 180)
     {
      return "Implicit conversion from a string to a number";
     }

   if(code == 181)
     {
      return "Implicit conversion of a number to a string";
     }

   if(code == 182)
     {
      return "Ambiguous call of an overloaded function (several overloads fit)";
     }

   if(code == 183)
     {
      return "Illegal else without proper if";
     }

   if(code == 184)
     {
      return "Invalid case or default without a switch";
     }

   if(code == 185)
     {
      return "Inappropriate use of ellipsis";
     }

   if(code == 186)
     {
      return "The initializing sequence has more elements than the initialized variable";
     }

   if(code == 187)
     {
      return "A constant for case expected";
     }

   if(code == 188)
     {
      return "A constant expression required";
     }

   if(code == 189)
     {
      return "A constant variable cannot be changed";
     }

   if(code == 190)
     {
      return "Closing bracket or a comma is expected (declaring array member)";
     }

   if(code == 191)
     {
      return "Enumerator identifier already defined";
     }

   if(code == 192)
     {
      return "Enumeration cannot have access modifiers (const, extern, static)";
     }

   if(code == 193)
     {
      return "Enumeration member already declared with a different value";
     }

   if(code == 194)
     {
      return "There is a variable defined with the same name";
     }

   if(code == 195)
     {
      return "There is a structure defined with the same name";
     }

   if(code == 196)
     {
      return "Name of enumeration member expected";
     }

   if(code == 197)
     {
      return "Integer expression expected";
     }

   if(code == 198)
     {
      return "Division by zero in constant expression";
     }

   if(code == 199)
     {
      return "Wrong number of parameters in the function";
     }

   if(code == 200)
     {
      return "Parameter by reference must be a variable";
     }

   if(code == 201)
     {
      return "Variable of the same type to pass by reference expected";
     }

   if(code == 202)
     {
      return "A constant variable cannot be passed by a non-constant reference";
     }

   if(code == 203)
     {
      return "Requires a positive integer constant";
     }

   if(code == 204)
     {
      return "Failed to access protected class member";
     }

   if(code == 205)
     {
      return "Import already defined in another way";
     }

   if(code == 208)
     {
      return "Executable file not created";
     }

   if(code == 209)
     {
      return "'OnCalculate' entry point not found for the indicator";
     }

   if(code == 210)
     {
      return "The continue operation can be used only inside a loop";
     }

   if(code == 211)
     {
      return "Error accessing private (closed) class member";
     }

   if(code == 213)
     {
      return "Method of structure or class is not declared";
     }

   if(code == 214)
     {
      return "Error accessing private (closed) class method";
     }

   if(code == 216)
     {
      return "Copying of structures with objects is not allowed";
     }

   if(code == 218)
     {
      return "Index out of array range";
     }

   if(code == 219)
     {
      return "Array initialization in structure or class declaration not allowed";
     }

   if(code == 220)
     {
      return "Class constructor cannot have parameters";
     }

   if(code == 221)
     {
      return "Class destructor can not have parameters";
     }

   if(code == 222)
     {
      return "Class method or structure with the same name and parameters have already been declared";
     }

   if(code == 223)
     {
      return "Operand expected";
     }

   if(code == 224)
     {
      return "Class method or structure with the same name exists, but with different parameters (declaration!=implementation)";
     }

   if(code == 225)
     {
      return "Imported function is not described";
     }

   if(code == 226)
     {
      return "ZeroMemory() is not allowed for objects with protected members or inheritance";
     }

   if(code == 227)
     {
      return "Ambiguous call of the overloaded function (exact match of parameters for several overloads)";
     }

   if(code == 228)
     {
      return "Variable name expected";
     }

   if(code == 229)
     {
      return "A reference cannot be declared in this place";
     }

   if(code == 230)
     {
      return "Already used as the enumeration name";
     }

   if(code == 232)
     {
      return "Class or structure expected";
     }

   if(code == 235)
     {
      return "Cannot call 'delete' operator to delete the array";
     }

   if(code == 236)
     {
      return "Operator ' while' expected";
     }

   if(code == 237)
     {
      return "Operator 'delete' must have a pointer";
     }

   if(code == 238)
     {
      return "There is 'default' for this 'switch' already";
     }

   if(code == 239)
     {
      return "Syntax error";
     }

   if(code == 240)
     {
      return "Escape-sequence can occur only in strings (starts with '\')";
     }

   if(code == 241)
     {
      return "Array required - square bracket '[' does not apply to an array, or non arrays are passed as array parameters";
     }

   if(code == 242)
     {
      return "Can not be initialized through the initialization sequence";
     }

   if(code == 243)
     {
      return "Import is not defined";
     }

   if(code == 244)
     {
      return "Optimizer error on the syntactic tree";
     }

   if(code == 245)
     {
      return "Declared too many structures (try to simplify the program)";
     }

   if(code == 246)
     {
      return "Conversion of the parameter is not allowed";
     }

   if(code == 247)
     {
      return "Incorrect use of the 'delete' operator";
     }

   if(code == 248)
     {
      return "It's not allowed to declare a pointer to a reference";
     }

   if(code == 249)
     {
      return "It's not allowed to declare a reference to a reference";
     }

   if(code == 250)
     {
      return "It's not allowed to declare a pointer to a pointer";
     }

   if(code == 251)
     {
      return "Structure declaration in the list of parameter is not allowed";
     }

   if(code == 252)
     {
      return "Invalid operation of typecasting";
     }

   if(code == 253)
     {
      return "A pointer can be declared only for a class or structure";
     }

   if(code == 256)
     {
      return "Undeclared identifier";
     }

   if(code == 257)
     {
      return "Executable code optimizer error";
     }

   if(code == 258)
     {
      return "Executable code generation error";
     }

   if(code == 260)
     {
      return "Invalid expression for the 'switch' operator";
     }

   if(code == 261)
     {
      return "Pool of string constants overfilled, simplify program";
     }

   if(code == 262)
     {
      return "Cannot convert to enumeration";
     }

   if(code == 263)
     {
      return "Do not use 'virtual' for data (members of a class or structure)";
     }

   if(code == 264)
     {
      return "Cannot call protected method of class";
     }

   if(code == 265)
     {
      return "Overridden virtual functions return a different type";
     }

   if(code == 266)
     {
      return "Class cannot be inherited from a structure";
     }

   if(code == 267)
     {
      return "Structure cannot be inherited from a class";
     }

   if(code == 268)
     {
      return "Constructor cannot be virtual (virtual specifier is not allowed)";
     }

   if(code == 269)
     {
      return "Method of structure cannot be virtual";
     }

   if(code == 270)
     {
      return "Function must have a body";
     }

   if(code == 271)
     {
      return "Overloading of system functions (terminal functions) is prohibited";
     }

   if(code == 272)
     {
      return "Const specifier is invalid for functions that are not members of a class or structure";
     }

   if(code == 274)
     {
      return "Not allowed to change class members in constant method";
     }

   if(code == 276)
     {
      return "Inappropriate initialization sequence";
     }

   if(code == 277)
     {
      return "Missed default value for the parameter (specific declaration of default parameters)";
     }

   if(code == 278)
     {
      return "Overriding the default parameter (different values in declaration and implementation)";
     }

   if(code == 279)
     {
      return "Not allowed to call non-constant method for a constant object";
     }

   if(code == 280)
     {
      return "An object is necessary for accessing members (a dot for a non class/structure is specified)";
     }

   if(code == 281)
     {
      return "The name of an already declared structure cannot be used in declaration";
     }
     
   if(code == 284)
     {
      return "Unauthorized conversion (at closed inheritance)";
     }

   if(code == 285)
     {
      return "Structures and arrays cannot be used as input variables";
     }

   if(code == 286)
     {
      return "Const specifier is not valid for constructor/destructor";
     }

   if(code == 287)
     {
      return "Incorrect string expression for a datetime";
     }

   if(code == 288)
     {
      return "Unknown property (#property)";
     }
     
   if(code == 289)
     {
      return "Incorrect value of a property";
     }

   if(code == 290)
     {
      return "Invalid index for a property in #property";
     }

   if(code == 291)
     {
      return "Call parameter omitted - <func (x,)>";
     }

   if(code == 293)
     {
      return "Object must be passed by reference";
     }

   if(code == 294)
     {
      return "Array must be passed by reference";
     }

   if(code == 295)
     {
      return "Function was declared as exportable";
     }

   if(code == 296)
     {
      return "Function was not declared as exportable";
     }

   if(code == 297)
     {
      return "It is prohibited to export imported function";
     }

   if(code == 298)
     {
      return "Imported function cannot have this parameter (prohibited to pass a pointer, class or structure containing a dynamic array, pointer, class, etc.)";
     }

   if(code == 299)
     {
      return "Must be a class";
     }

   if(code == 300)
     {
      return "#import was not closed";
     }

   if(code == 302)
     {
      return "Type mismatch";
     }

   if(code == 303)
     {
      return "Extern variable is already initialized";
     }

   if(code == 304)
     {
      return "No exported function or entry point found";
     }

   if(code == 305)
     {
      return "Explicit constructor call is not allowed";
     }

   if(code == 306)
     {
      return "Method was declared as constant";
     }

   if(code == 307)
     {
      return "Method was not declared as constant";
     }

   if(code == 308)
     {
      return "Incorrect size of the resource file ";
     }

   if(code == 309)
     {
      return "Incorrect resource name ";
     }

   if(code == 310)
     {
      return "Resource file opening error ";
     }

   if(code == 311)
     {
      return "Resource file reading error";
     }

   if(code == 312)
     {
      return "Unknown resource type";
     }

   if(code == 313)
     {
      return "Incorrect path to the resource file";
     }

   if(code == 314)
     {
      return "The specified resource name is already used";
     }

   if(code == 315)
     {
      return "Argument expected for the function-like macro";
     }

   if(code == 316)
     {
      return "Unexpected symbol in macro definition";
     }

   if(code == 317)
     {
      return "Error in formal parameters of the macro";
     }

   if(code == 318)
     {
      return "Invalid number of parameters for a macro";
     }

   if(code == 319)
     {
      return "Too many parameters for a macro";
     }

   if(code == 320)
     {
      return "Too complex, simplify the macro";
     }

   if(code == 321)
     {
      return "Parameter for EnumToString() can be only an enumeration ";
     }

   if(code == 322)
     {
      return "The resource name is too long";
     }

   if(code == 323)
     {
      return "Unsupported image format (only BMP with 24 or 32 bit color depth is supported)";
     }

   if(code == 324)
     {
      return "An array cannot be declared in operator";
     }

   if(code == 325)
     {
      return "The function can be declared only in the global scope";
     }

   if(code == 326)
     {
      return "The declaration is not allowed for the current scope";
     }

   if(code == 327)
     {
      return "Initialization of static variables with the values of local variables is not allowed";
     }

   if(code == 328)
     {
      return "Illegal declaration of an array of objects that do not have a default constructor";
     }

   if(code == 329)
     {
      return "Initialization list allowed only for constructors";
     }

   if(code == 330)
     {
      return "No function definition after initialization list";
     }

   if(code == 331)
     {
      return "Initialization list is empty";
     }

   if(code == 332)
     {
      return "Array initialization in a constructor is not allowed";
     }

   if(code == 333)
     {
      return "Initializing members of a parent class in the initialization list is not allowed";
     }

   if(code == 334)
     {
      return "Expression of the integer type expected";
     }

   if(code == 335)
     {
      return "Memory required for the array exceeds the maximum value";
     }

   if(code == 336)
     {
      return "Memory required for the structure exceeds the maximum value";
     }

   if(code == 337)
     {
      return "Memory required for the variables declared on the global level exceeds the maximum value";
     }

   if(code == 338)
     {
      return "Memory required for local variables exceeds the maximum value";
     }

   if(code == 339)
     {
      return "Constructor not defined";
     }

   if(code == 340)
     {
      return "Invalid name of the icon file";
     }

   if(code == 341)
     {
      return "Could not open the icon file at the specified path";
     }
     
   if(code == 342)
     {
      return "The icon file is incorrect and is not of the ICO format";
     }
     
   if(code == 343)
     {
      return "Reinitialization of a member in a class/structure constructor using the initialization list";
     }

   if(code == 344)
     {
      return "Initialization of static members in the constructor initialization list is not allowed";
     }

   if(code == 345)
     {
      return "Initialization of a non-static member of a class/structure on a global level is not allowed";
     }

   if(code == 346)
     {
      return "The name of the class/structure method matches the name of an earlier declared member";
     }
     
   if(code == 347)
     {
      return "The name of the class/structure member matches the name of an earlier declared method";
     }

   if(code == 348)
     {
      return "Virtual function cannot be declared as static";
     }
     
   if(code == 349)
     {
      return "The const modifier is not allowed for static functions";
     }

   if(code == 350)
     {
      return "Constructor or destructor cannot be static";
     }

   if(code == 351)
     {
      return "Non-static member/method of a class or a structure cannot be accessed from a static function";
     }

   if(code == 352)
     {
      return "An overload operation (+,-,[],++,-- etc.) is expected after the operator keyword";
     }

   if(code == 353)
     {
      return "Not all operations can be overloaded in MQL5";
     }

   if(code == 354)
     {
      return "Definition does not match declaration";
     }

   if(code == 355)
     {
      return "An invalid number of parameters is specified for the operator ";
     }

   if(code == 356)
     {
      return "Event handling function not found";
     }

   if(code == 357)
     {
      return "Method cannot be exported";
     }

   if(code == 358)
     {
      return "A pointer to the constant object cannot be normalized by a non-constant object";
     }

   if(code == 359)
     {
      return "Class templates are not supported yet";
     }

   if(code == 360)
     {
      return "Function template overload is not supported yet";
     }

   if(code == 361)
     {
      return "Function template cannot be applied";
     }

   if(code == 362)
     {
      return "Ambiguous parameter in function template (several parameter types can be applied)";
     }

   if(code == 363)
     {
      return "Unable to determine the parameter type, by which the function template argument should be normalized";
     }

   if(code == 364)
     {
      return "Incorrect number of parameters in the function template";
     }

   if(code == 365)
     {
      return "Function template cannot be virtual";
     }

   if(code == 366)
     {
      return "Function templates cannot be exported";
     }

   if(code == 367)
     {
      return "Function templates cannot be imported";
     }

   if(code == 368)
     {
      return "Structures containing the objects are not allowed";
     }

   if(code == 369)
     {
      return "String arrays and structures containing the objects are not allowed";
     }

   if(code == 370)
     {
      return "A static class/structure member must be explicitly initialized";
     }

   if(code == 371)
     {
      return "Compiler limitation: the string cannot contain more than 65 535 characters";
     }

   if(code == 372)
     {
      return "Inconsistent #ifdef/#endif";
     }

   if(code == 373)
     {
      return "Object of class cannot be returned, copy constructor not found";
     }

   if(code == 374)
     {
      return "Non-static members and methods cannot be used";
     }

   if(code == 375)
     {
      return "OnTesterInit() impossible to use without OnTesterDeinit()";
     }

   if(code == 376)
     {
      return "Redefinition of formal parameter '%s'";
     }

   if(code == 377)
     {
      return "Macro __FUNCSIG__ and __FUNCTION__ cannot appear outside of a function body";
     }

   if(code == 378)
     {
      return "Invalid returned type. For example, this error will be produced for functions imported from DLL that return structure or pointer.";
     }

   if(code == 379)
     {
      return "Template usage error";
     }

   if(code == 380)
     {
      return "Not used";
     }

   if(code == 381)
     {
      return "Illegal syntax when declaring pure virtual function, only \"=NULL\" or \"=0\" are allowed";
     }

   if(code == 382)
     {
      return "Only virtual functions can be declared with the pure-specifier (\"=NULL\" or \"=0\")";
     }

   if(code == 383)
     {
      return "Abstract class cannot be instantiated";
     }

   if(code == 384)
     {
      return "A pointer to a user-defined type should be applied as a target type for dynamic casting using the dynamic_cast operator";
     }

   if(code == 385)
     {
      return "\"Pointer to function\" type is expected";
     }

   if(code == 386)
     {
      return "Pointers to methods are not supported";
     }

   if(code == 387)
     {
      return "Error – cannot define the type of a pointer to function";
     }

   if(code == 388)
     {
      return "Type cast is not available due to private inheritance ";
     }

   if(code == 389)
     {
      return "A variable with const modifier should be initialized during declaration";
     }

   if(code == 393)
     {
      return "Only methods with public access can be declared in an interface";
     }

   if(code == 394)
     {
      return "Invalid nesting of an interface inside of another interface";
     }

   if(code == 395)
     {
      return "An interface can only be derived from another interface";
     }

   if(code == 396)
     {
      return "An interface is expected";
     }

   if(code == 397)
     {
      return "Interfaces only support public inheritance";
     }

   if(code == 398)
     {
      return "An interface cannot contain members";
     }

   if(code == 399)
     {
      return "Interface objects cannot be created directly, only use inheritance";
     }

   if(code == 400)
     {
      return "A specifier cannot be used in a forward declaration";
     }

   if(code == 401)
     {
      return "Inheritance from the class is impossible, since it is declared with the final specifier";
     }
     
   if(code == 402)
     {
      return "Cannot redefine a method declared with the final specifier";
     }

   if(code == 403)
     {
      return "The final specifier can be applied only to virtual functions";
     }

   if(code == 404)
     {
      return "The method marked by the override specifier actually does not override any base class function";
     }

   if(code == 405)
     {
      return "A specifier is not allowed in defining a function, but only in declaring";
     }

   if(code == 406)
     {
      return "Cannot cast the type to the specified one";
     }

   if(code == 407)
     {
      return "The type cannot be used for a resource variable";
     }

   if(code == 408)
     {
      return "Error in the project file";
     }

   if(code == 409)
     {
      return "Cannot be used as a union member";
     }

   if(code == 410)
     {
      return "Ambiguous choice for the name, the usage context should be explicitly defined";
     }

   if(code == 411)
     {
      return "The structure cannot be used from DLL";
     }

   if(code == 412)
     {
      return "Cannot call a function marked by the delete specifier";
     }

   if(code == 413)
     {
      return "MQL4 is not supported. To compile this program, use MetaEditor from your MetaTrader 4 installation folder";
     }

   if(code == 21)
     {
      return "Incomplete record of a date in the datetime string";
     }

   if(code == 22)
     {
      return "Wrong number in the datetime string for the date. Requirements: Year 1970 <= X <= 3000, Month 0 <X <= 12, Day 0 <X <= 31/30/28 (29 )....";
     }

   if(code == 23)
     {
      return "Wrong number of datetime string for time. Requirements:    Hour    0 <= X <24,    Minute 0 <= X <60";
     }

   if(code == 24)
     {
      return "Invalid color in RGB format: one of RGB components is less than 0 or greater than 255";
     }

   if(code == 25)
     {
      return "Unknown character of the escape sequences.    Known: \n \r \t \\ \" \' X  x";
     }

   if(code == 26)
     {
      return "Too large volume of local variables (> 512Kb) of the function, reduce the number";
     }

   if(code == 29)
     {
      return "Enumeration already defined (duplication) - members will be added to the first definition";
     }

   if(code == 30)
     {
      return "Overriding macro";
     }

   if(code == 31)
     {
      return "The variable is declared but is not used anywhere";
     }

   if(code == 32)
     {
      return "Constructor must be of void type";
     }

   if(code == 33)
     {
      return "Destructor must be of void type";
     }

   if(code == 34)
     {
      return "Constant does not fit in the range of integers (X> _UI64_MAX | | X <_I64_MIN) and will be converted to the double type";
     }

   if(code == 35)
     {
      return "Too long HEX - more than 16 significant characters (senior nibbles are cut)";
     }

   if(code == 36)
     {
      return "No nibbles in HEX string \"0x\"";
     }

   if(code == 37)
     {
      return "No function - nothing to be performed";
     }

   if(code == 38)
     {
      return "A non-initialized variable is used";
     }

   if(code == 41)
     {
      return "Function has no body, and is not called";
     }

   if(code == 43)
     {
      return "Possible loss of data at typecasting. Example: int x = (double) z;";
     }

   if(code == 44)
     {
      return "Loss of accuracy (of data) when converting a constant. Example: int x = M_PI";
     }

   if(code == 45)
     {
      return "Difference between the signs of operands in the operations of comparison. Example: (char) c1> (uchar) c2";
     }

   if(code == 46)
     {
      return "Problems with function importing - declaration of #import is required or import of functions is closed";
     }
     
   if(code == 47)
     {
      return "Too large description - extra characters will not be included in the executable file";
     }

   if(code == 48)
     {
      return "The number of indicator buffers declared is less than required";
     }

   if(code == 49)
     {
      return "No color to plot a graphical series in the indicator";
     }

   if(code == 50)
     {
      return "No graphical series to draw the indicator";
     }

   if(code == 51)
     {
      return "'OnStart' handler function not found in the script";
     }

   if(code == 52)
     {
      return "'OnStart' handler function is defined with wrong parameters";
     }

   if(code == 53)
     {
      return "'OnStart' function can be defined only in a script";
     }

   if(code == 54)
     {
      return "'OnInit' function is defined with wrong parameters";
     }

   if(code == 55)
     {
      return "'OnInit' function is not used in scripts";
     }
     
   if(code == 56)
     {
      return "'OnDeinit' function is defined with wrong parameters";
     }
     
   if(code == 57)
     {
      return "'OnDeinit' function is not used in scripts";
     }

   if(code == 58)
     {
      return "Two 'OnCalculate' functions are defined. OnCalculate () at one price array will be used";
     }

   if(code == 59)
     {
      return "Overfilling detected when calculating a complex integer constant";
     }

   if(code == 60)
     {
      return "Probably, the variable is not initialized.";
     }

   if(code == 61)
     {
      return "This declaration makes it impossible to refer to the local variable declared on the specified line";
     }

   if(code == 62)
     {
      return "This declaration makes it impossible to refer to the global variable declared on the specified line";
     }

   if(code == 63)
     {
      return "Cannot be used for static allocated array";
     }

   if(code == 64)
     {
      return "This variable declaration hides predefined variable";
     }

   if(code == 65)
     {
      return "The value of the expression is always true/false";
     }

   if(code == 66)
     {
      return "Using a variable or bool type expression in mathematical operations is unsafe";
     }

   if(code == 67)
     {
      return "The result of applying the unary minus operator to an unsigned ulong type is undefined";
     }

   if(code == 68)
     {
      return "The version specified in the #property version property is unacceptable for the Market section; the correct format of #property version id 'XXX.YYY'";
     }

   if(code == 69)
     {
      return "Empty controlled statement found";
     }

   if(code == 70)
     {
      return "Invalid function return type or incorrect parameters during declaration of the event handler function";
     }

   if(code == 71)
     {
      return "An implicit cast of structures to one type is required";
     }

   if(code == 72)
     {
      return "This declaration makes direct access to the member of a class declared in the specified string impossible. Access will be possible only with the scope resolution operation ::";
     }

   if(code == 73)
     {
      return "Binary constant is too big, high-order digits will be truncated";
     }

   if(code == 74)
     {
      return "Parameter in the method of the inherited class has a different const modifier, the derived function has overloaded the parent function";
     }

   if(code == 75)
     {
      return "Negative or too large shift value in shift bitwise operation, execution result is undefined";
     }

   if(code == 76)
     {
      return "Function must return a value";
     }

   if(code == 77)
     {
      return "void function returns a value";
     }

   if(code == 78)
     {
      return "Not all control paths return a value";
     }

   if(code == 79)
     {
      return "Expressions are not allowed on a global scope";
     }
     
   if(code == 80)
     {
      return "Check operator precedence for possible error; use parentheses to clarify precedence";
     }

   if(code == 81)
     {
      return "Two OnCalCulate() are defined. OHLC version will be used";
     }

   if(code == 82)
     {
      return "Struct has no members, size assigned to 1 byte";
     }

   if(code == 83)
     {
      return "Return value of the function should be checked";
     }

   if(code == 84)
     {
      return "Resource indicator is compiled for debugging. That slows down the performance. Please recompile the indicator to increase performance";
     }

   if(code == 85)
     {
      return "Too great character code in the string, must be in the range 0 to 65535";
     }

   if(code == 86)
     {
      return "Unrecognized character in the string";
     }

   if(code == 87)
     {
      return "No indicator window property (setting the display in the main window or a subwindow) is defined. Property #property indicator_chart_window is applied";
     }

   return IntegerToString(code);
  }


//+------------------------------------------------------------------+