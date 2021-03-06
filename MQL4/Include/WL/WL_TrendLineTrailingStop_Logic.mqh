//+------------------------------------------------------------------+
//|                               WL_TrendLineTrailingStop_Logic.mqh |
//|                                     Copyright 2016, Tsuriganeboz |
//|                                  https://github.com/Tsuriganeboz |
//+------------------------------------------------------------------+
#include <WL/WL_TrendLinePriceUtil.mqh>
#include <WL/WL_OrderUtil.mqh>

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
bool WL_TrailingStopUseTrendLineForBuy(double& refStopLossPrice,
                                          string trendLineName,
                                          datetime timeCurrent,
                                          double shiftStopLossPips)
{   
   double unit = WL_CurrencyUnitPerPips(Symbol());
                                                                                      
   double stopLossPrice = WL_GetTrendLinePriceByTime(trendLineName, timeCurrent);        
   
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
bool WL_TrailingStopUseTrendLineForSell(double& refStopLossPrice, 
                                          string trendLineName,
                                          datetime timeCurrent,
                                          double shiftStopLossPips)
{   
   double unit = WL_CurrencyUnitPerPips(Symbol());
                                                                                     
   double stopLossPrice = WL_GetTrendLinePriceByTime(trendLineName, timeCurrent);        

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
