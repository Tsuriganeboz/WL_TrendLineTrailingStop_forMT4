//+------------------------------------------------------------------+
//|                            WL_TrendLineTrailingStop_Strategy.mqh |
//|                                     Copyright 2016, Tsuriganeboz |
//|                                  https://github.com/Tsuriganeboz |
//+------------------------------------------------------------------+
#include <WL/WL_StopLevelAdjustUtil.mqh>

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
void WL_TrailingStopOrderSymbolMatch()
{
   for (int i = (OrdersTotal() - 1); i >= 0; i--)
   {
      if (WL_OrderSelectByPos(i) 
         && WL_IsOrderSymbolMatch()
         && !WL_IsWaitingOrder()
         )
      {
         bool needExecute = false;
         double takeProfitPrice = OrderTakeProfit();
         double stopLossPrice = OrderStopLoss();
                     
         if (WL_IsOrderTypeBuy())
         {
            needExecute = needExecute || WL_TrailingStopUseTrendLineForBuy(stopLossPrice, 
                                                                           TrendLineStopLossName,
                                                                           TimeCurrent(),
                                                                           ShiftStopLossPips);
                                                               
            needExecute = WL_AdjustStopLossForBuy(needExecute, stopLossPrice);
                                                                                                                                                                              
            WL_ExecuteModifyOrderForBuy(needExecute, 
                                       stopLossPrice, takeProfitPrice);
         }
         else
         {         
            needExecute = needExecute || WL_TrailingStopUseTrendLineForSell(stopLossPrice,
                                                                           TrendLineStopLossName,
                                                                           TimeCurrent(),
                                                                           ShiftStopLossPips);

            needExecute = WL_AdjustStopLossForSell(needExecute, stopLossPrice);
                                                                                       
            WL_ExecuteModifyOrderForSell(needExecute, 
                                          stopLossPrice, takeProfitPrice);                                    
         }
         
      }
      else {}
   }
}
