//+------------------------------------------------------------------+
//|                                                 WolfeWaves.mqh |
//|                                                                  |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023"
#property link      ""

// Timeframe for this module
extern ENUM_TIMEFRAMES WW_Timeframe;

// Import DebugPrint function from main file
#import "GoldTraderEA.mq5"
   void DebugPrint(string message);
#import

//+------------------------------------------------------------------+
//| Detecting Bullish Wolfe Wave Pattern                              |
//+------------------------------------------------------------------+
bool IsBullishWolfeWave(MqlRates &rates[])
{
    int size = ArraySize(rates);
    if(size < 50)
        return false;
    
    int points[5] = {0};
    double values[5] = {0};
    
    for(int i = 49; i > 40; i--) {
        if(rates[i].low < rates[i+1].low && rates[i].low < rates[i-1].low) {
            points[0] = i;
            values[0] = rates[i].low;
            break;
        }
    }
    if(points[0] == 0) return false;
    
    for(int i = points[0] - 1; i > 30; i--) {
        if(rates[i].high > rates[i+1].high && rates[i].high > rates[i-1].high) {
            points[1] = i;
            values[1] = rates[i].high;
            break;
        }
    }
    if(points[1] == 0 || points[1] >= points[0]) return false;
    
    for(int i = points[1] - 1; i > 20; i--) {
        if(rates[i].low < rates[i+1].low && rates[i].low < rates[i-1].low) {
            points[2] = i;
            values[2] = rates[i].low;
            break;
        }
    }
    if(points[2] == 0 || points[2] >= points[1]) return false;
    
    for(int i = points[2] - 1; i > 10; i--) {
        if(rates[i].high > rates[i+1].high && rates[i].high > rates[i-1].high) {
            points[3] = i;
            values[3] = rates[i].high;
            break;
        }
    }
    if(points[3] == 0 || points[3] >= points[2]) return false;
    
    for(int i = points[3] - 1; i >= 0; i--) {
        if(i == 0 || (rates[i].low < rates[i+1].low && i > 0 && rates[i].low < rates[i-1].low)) {
            points[4] = i;
            values[4] = rates[i].low;
            break;
        }
    }
    
    double slope_1_3 = (values[2] - values[0]) / (points[0] - points[2]);
    double expected_point5 = values[0] + slope_1_3 * (points[0] - points[4]);
    double tolerance = MathAbs(values[0] - values[2]) * 0.1;
    if(MathAbs(values[4] - expected_point5) > tolerance) return false;
    
    double slope_2_4 = (values[3] - values[1]) / (points[1] - points[3]);
    if(values[3] >= values[1]) return false;
    if(values[2] <= values[0]) return false;
    
    int time_1_2 = points[0] - points[1];
    int time_2_3 = points[1] - points[2];
    int time_3_4 = points[2] - points[3];
    int time_4_5 = points[3] - points[4];
    if(!(time_1_2 > time_2_3 && time_2_3 > time_3_4 && time_3_4 > time_4_5)) return false;
    
    double target_price = values[0] + slope_1_3 * (points[0] - 0);
    DebugPrint("Bullish Wolfe Wave pattern identified with target price: " + DoubleToString(target_price, 2));
    return true;
}

//+------------------------------------------------------------------+
//| Detecting Bearish Wolfe Wave Pattern                              |
//+------------------------------------------------------------------+
bool IsBearishWolfeWave(MqlRates &rates[])
{
    int size = ArraySize(rates);
    if(size < 50)
        return false;
    
    int points[5] = {0};
    double values[5] = {0};
    
    for(int i = 49; i > 40; i--) {
        if(rates[i].high > rates[i+1].high && rates[i].high > rates[i-1].high) {
            points[0] = i;
            values[0] = rates[i].high;
            break;
        }
    }
    if(points[0] == 0) return false;
    
    for(int i = points[0] - 1; i > 30; i--) {
        if(rates[i].low < rates[i+1].low && rates[i].low < rates[i-1].low) {
            points[1] = i;
            values[1] = rates[i].low;
            break;
        }
    }
    if(points[1] == 0 || points[1] >= points[0]) return false;
    
    for(int i = points[1] - 1; i > 20; i--) {
        if(rates[i].high > rates[i+1].high && rates[i].high > rates[i-1].high) {
            points[2] = i;
            values[2] = rates[i].high;
            break;
        }
    }
    if(points[2] == 0 || points[2] >= points[1]) return false;
    
    for(int i = points[2] - 1; i > 10; i--) {
        if(rates[i].low < rates[i+1].low && rates[i].low < rates[i-1].low) {
            points[3] = i;
            values[3] = rates[i].low;
            break;
        }
    }
    if(points[3] == 0 || points[3] >= points[2]) return false;
    
    for(int i = points[3] - 1; i >= 0; i--) {
        if(i == 0 || (rates[i].high > rates[i+1].high && i > 0 && rates[i].high > rates[i-1].high)) {
            points[4] = i;
            values[4] = rates[i].high;
            break;
        }
    }
    
    double slope_1_3 = (values[2] - values[0]) / (points[0] - points[2]);
    double expected_point5 = values[0] + slope_1_3 * (points[0] - points[4]);
    double tolerance = MathAbs(values[0] - values[2]) * 0.1;
    if(MathAbs(values[4] - expected_point5) > tolerance) return false;
    
    double slope_2_4 = (values[3] - values[1]) / (points[1] - points[3]);
    if(values[3] <= values[1]) return false;
    if(values[2] >= values[0]) return false;
    
    int time_1_2 = points[0] - points[1];
    int time_2_3 = points[1] - points[2];
    int time_3_4 = points[2] - points[3];
    int time_4_5 = points[3] - points[4];
    if(!(time_1_2 > time_2_3 && time_2_3 > time_3_4 && time_3_4 > time_4_5)) return false;
    
    double target_price = values[0] + slope_1_3 * (points[0] - 0);
    DebugPrint("Bearish Wolfe Wave pattern identified with target price: " + DoubleToString(target_price, 2));
    return true;
}

//+------------------------------------------------------------------+
//| Checking Wolfe Waves for Buy Signal                               |
//+------------------------------------------------------------------+
int CheckWolfeWavesBuy(MqlRates &rates[])
{
    DebugPrint("Starting to check Wolfe Wave patterns for buy");
    int confirmations = 0;
    int size = ArraySize(rates);
    if(size < 50) {
        MqlRates local_rates[];
        ArraySetAsSeries(local_rates, true);
        int copied = CopyRates(Symbol(), WW_Timeframe, 0, 100, local_rates);
        if(copied < 50) { DebugPrint("Not enough data to detect bullish Wolfe pattern"); return 0; }
        if(IsBullishWolfeWave(local_rates)) { DebugPrint("Bullish Wolfe Wave pattern found"); confirmations += 3; }
        return confirmations;
    }
    if(IsBullishWolfeWave(rates)) { DebugPrint("Bullish Wolfe Wave pattern found"); confirmations += 3; }
    return confirmations;
}

//+------------------------------------------------------------------+
//| Checking Wolfe Waves for Sell Signal                              |
//+------------------------------------------------------------------+
int CheckWolfeWavesShort(MqlRates &rates[])
{
    DebugPrint("Starting to check Wolfe Wave patterns for sell");
    int confirmations = 0;
    int size = ArraySize(rates);
    if(size < 50) {
        MqlRates local_rates[];
        ArraySetAsSeries(local_rates, true);
        int copied = CopyRates(Symbol(), WW_Timeframe, 0, 100, local_rates);
        if(copied < 50) { DebugPrint("Not enough data to detect bearish Wolfe pattern"); return 0; }
        if(IsBearishWolfeWave(local_rates)) { DebugPrint("Bearish Wolfe Wave pattern found"); confirmations += 3; }
        return confirmations;
    }
    if(IsBearishWolfeWave(rates)) { DebugPrint("Bearish Wolfe Wave pattern found"); confirmations += 3; }
    return confirmations;
}

//+------------------------------------------------------------------+
//| Safe wrapper for buy — guards array size before calling check    |
//+------------------------------------------------------------------+
int SafeCheckWolfeWavesBuy(MqlRates &rates[])
{
    if(ArraySize(rates) < 3)
    {
        DebugPrint("SafeCheckWolfeWavesBuy: rates array too small");
        return 0;
    }
    return CheckWolfeWavesBuy(rates);
}

//+------------------------------------------------------------------+
//| Safe wrapper for sell — guards array size before calling check   |
//+------------------------------------------------------------------+
int SafeCheckWolfeWavesShort(MqlRates &rates[])
{
    if(ArraySize(rates) < 3)
    {
        DebugPrint("SafeCheckWolfeWavesShort: rates array too small");
        return 0;
    }
    return CheckWolfeWavesShort(rates);
}