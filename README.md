﻿# WL_TrendLineTrailingStop_forMT4
トレンドラインに沿ったトレーリングストップ(EA) 
MetaTrader4 用

## 概要
引いたトレンドラインに沿った、決済逆指値(S/L)の移動を行います。  
本EAではエントリー操作はしません。

## 動作環境
MetaTrader4 


## 注意事項
同一通貨ペアのオープン中ポジション全てに、同じ決済逆指値(S/L)を適用します。  
そのため、両建てには不向きです。

## 使い方
* 決済逆指値(S/L)は注文時に入れておくことを推奨します。

1. 買いならば、価格の下側でサポートになるトレンドラインを引きます。  
売りならば、価格の上側でレジスタンスになるトレンドラインを引きます。

2. トレンドラインの名前を 'TSL' にします。

3. 「自動売買」をONにし、本EAを実行します。


## 決済逆指値(S/L)の掛かり方について
買いならば、トレンドラインの現在時刻での値より、トレール幅マージンpips ぶん下です。  
売りならば、トレンドラインの現在時刻での値より、トレール幅マージンpips ぶん上です。  
トレール幅マージンpips はパラメータであり、変更可能です。  
  
証券会社の設定したストップレベルの幅より、決済逆指値(S/L)を Ask・Bid に近づけることはできません。  
その場合、ストップレベルぎりぎりまで移動させようとする動きをします。


## ビルド
MQL4フォルダ階層に展開し、MetaEditor でコンパイルして下さい。

## その他
ご使用は自己責任でお願いします。
