int account_allowed = 51989678;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {

   only_allow_this_account(account_allowed);



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

  }
//+------------------------------------------------------------------+


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void only_allow_this_account(int acc_number_allowed)
  {
   if(AccountInfoInteger(ACCOUNT_LOGIN) != acc_number_allowed)
     {
      Alert("THIS EA IS NOT ALLOWED ON THIS ACCOUNT!");
      ExpertRemove();
     }
  }
