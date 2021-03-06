//+------------------------------------------------------------------+
//|                                     WL_TrendLineTrailingStop.mq4 |
//|                                     Copyright 2016, Tsuriganeboz |
//|                                  https://github.com/Tsuriganeboz |
//+------------------------------------------------------------------+
#include <WL/WL_TrendLineTrailingStop_Logic.mqh>
#include <WL/WL_TrendLineTrailingStop_Misc.mqh>
#include <WL/WL_TrendLineTrailingStop_Strategy.mqh>

#property copyright "Copyright 2016, Tsuriganeboz"
#property link      "https://github.com/Tsuriganeboz"
#property version   "1.00"
#property strict

//---
sinput string TrendLineStopLossName = "TSL"; // Stop Loss トレンドライン名
sinput double ShiftStopLossPips = 8.0;       // トレール幅マージン pips


//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   
//---
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

   WL_TrailingStopOrderSymbolMatch();   

  }
//+------------------------------------------------------------------+
