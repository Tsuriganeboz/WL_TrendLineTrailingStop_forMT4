//+------------------------------------------------------------------+
//|                                                 WL_OrderUtil.mqh |
//|                                    Copyright 2016, Tsuriganeboz  |
//|                                  https://github.com/Tsuriganeboz |
//+------------------------------------------------------------------+
#include <stdlib.mqh>
#include <WL/WL_Util.mqh>

#property copyright "Copyright 2016, Tsuriganeboz"
#property link      "https://github.com/Tsuriganeboz"
#property strict


//+------------------------------------------------------------------+
//| defines                                                          |
//+------------------------------------------------------------------+
// #define MacrosHello   "Hello, world!"
// #define MacrosYear    2010
//+------------------------------------------------------------------+
//| DLL imports                                                      |
//+------------------------------------------------------------------+
// #import "user32.dll"
//   int      SendMessageA(int hWnd,int Msg,int wParam,int lParam);
// #import "my_expert.dll"
//   int      ExpertRecalculate(int wParam,int lParam);
// #import
//+------------------------------------------------------------------+
//| EX5 imports                                                      |
//+------------------------------------------------------------------+
// #import "stdlib.ex5"
//   string ErrorDescription(int error_code);
// #import
//+------------------------------------------------------------------+


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool WL_OrderSelectByPos(int index)
{
   return OrderSelect(index, SELECT_BY_POS);
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool WL_IsNotBlankStopLoss()
{
   return OrderStopLoss() != 0.0;
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool WL_IsOrderMagicNumberMatch(int magic)
{
   return (OrderMagicNumber() == magic);
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool WL_IsOrderSymbolMatch()
{
   return (OrderSymbol() == Symbol());
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool WL_IsWaitingOrder()
{
   return (OrderType() != OP_BUY && OrderType() != OP_SELL);
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool WL_IsOrderTypeBuy()
{
   return (WL_GetBuyOrSell(OrderType()) == OP_BUY);
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int WL_SymbolMatchOrderCount(string symbol)
{
   int result = 0;

   for (int i = (OrdersTotal() - 1); i >= 0; i--)
   {   
      if (WL_OrderSelectByPos(i) 
         && WL_IsOrderSymbolMatch()
         )
      {
         result++;
      }
      else {}
   }
   
   return result;
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void WL_PrintOrderError(bool orderResult)
{
   if (!orderResult)
   {
      int err = GetLastError();
      string description = ErrorDescription(err);
      string message = "EA error! (" + IntegerToString(err) + ") " + description;
      
      Print(message);
   }
   else {}
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void WL_AlertOrderError(bool orderResult)
{
   if (!orderResult)
   {
      int err = GetLastError();
      string description = ErrorDescription(err);
      string message = "EA error! (" + IntegerToString(err) + ") " + description;
            
      Print("error! (" + IntegerToString(err) + ") " + description);
      
   }
   else {}
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double WL_CurrencyUnitPerPips(string symbol)
{
   if (Digits == 3.0 || Digits == 5.0)
   {
      return (Point * 10.0);
   }
   else
   {
      return Point;
   }
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool WL_IsUpperNewStopLossForBuy(double currentStopLoss, double newStopLoss)
{
	return (currentStopLoss == 0 || currentStopLoss < newStopLoss);
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool WL_IsLowerNewStopLossForSell(double currentStopLoss, double newStopLoss)
{
	return (currentStopLoss == 0 || currentStopLoss > newStopLoss);
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool WL_ExecuteModifyOrderForBuy(bool needExecute, double stopLossPrice, double takeProfitPrice)
{
   bool ret = false;

   if (needExecute)
   {                                                               
      if (OrderStopLoss() != 0 && stopLossPrice < OrderStopLoss())
         stopLossPrice = OrderStopLoss();
   
      ret = OrderModify(OrderTicket(), OrderOpenPrice(), stopLossPrice, takeProfitPrice, 0);
      WL_PrintOrderError(ret);
   }
   else {}
   
   return ret;
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool WL_ExecuteModifyOrderForSell(bool needExecute, double stopLossPrice, double takeProfitPrice)
{
   bool ret = false;

   if (needExecute)
   {  
      if (OrderStopLoss() != 0 && stopLossPrice > OrderStopLoss())
         stopLossPrice = OrderStopLoss();
   
      ret = OrderModify(OrderTicket(), OrderOpenPrice(), stopLossPrice, takeProfitPrice, 0);
      WL_PrintOrderError(ret);
   }
   else {}

   return ret;
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool WL_ModifyOrderFirstStopLossForBuy(double& refStopLossPrice, double shiftStopLossPips)
{
   if (OrderStopLoss() != 0.0)
      return false;
      
	double unit = WL_CurrencyUnitPerPips(Symbol());

	double stopLossPrice = OrderOpenPrice();
	// Buy の場合。
	stopLossPrice -= unit * shiftStopLossPips;
   stopLossPrice = NormalizeDouble(stopLossPrice, Digits);   


	if (WL_IsUpperNewStopLossForBuy(refStopLossPrice, stopLossPrice))
	{
      refStopLossPrice = stopLossPrice;
      return true;
   }
   else 
   {
      return false;
   }
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool WL_ModifyOrderFirstStopLossForSell(double& refStopLossPrice, double shiftStopLossPips)
{
   if (OrderStopLoss() != 0.0)
      return false;

	double unit = WL_CurrencyUnitPerPips(Symbol());

	double stopLossPrice = OrderOpenPrice();
	// Sell の場合。
	stopLossPrice += unit * shiftStopLossPips;
   stopLossPrice = NormalizeDouble(stopLossPrice, Digits);   


	if (WL_IsLowerNewStopLossForSell(refStopLossPrice, stopLossPrice))
	{
      refStopLossPrice = stopLossPrice;
      return true;
   }
   else 
   {
      return false;
   }
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool WL_BreakEvenForBuy(double& refStopLossPrice, bool isBreakEvenEnable, bool isMoveToBreakEven)
{
	if (!isBreakEvenEnable || !isMoveToBreakEven)
		return false;

	double unit = WL_CurrencyUnitPerPips(Symbol());
	double stopLossPrice = OrderOpenPrice();
   stopLossPrice = NormalizeDouble(stopLossPrice, Digits);   


	if (WL_IsUpperNewStopLossForBuy(refStopLossPrice, stopLossPrice))
	{
      refStopLossPrice = stopLossPrice;
      return true;
   }
   else 
   {
      return false;
   }
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool WL_BreakEvenForSell(double& refStopLossPrice, bool isBreakEvenEnable, bool isMoveToBreakEven)
{
	if (!isBreakEvenEnable || !isMoveToBreakEven)
		return false;

	double unit = WL_CurrencyUnitPerPips(Symbol());
	double stopLossPrice = OrderOpenPrice();
   stopLossPrice = NormalizeDouble(stopLossPrice, Digits);   


	if (WL_IsLowerNewStopLossForSell(refStopLossPrice, stopLossPrice))
	{
      refStopLossPrice = stopLossPrice;
      return true;
   }
   else 
   {
      return false;
   }
}
