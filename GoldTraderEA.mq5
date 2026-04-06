// Forward declarations for functions defined later in this file
bool PrepareHistoricalData();
bool UpdateIndicatorsSafe();
bool CheckTiltFilter(bool isBuy, MqlRates &rates[]);
bool IsBadTradingDay();
bool SafeOpenBuyPosition();
bool SafeOpenSellPosition();
bool GetDebugMode();
void ResetExternalCandleCache();
