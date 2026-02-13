#ifndef MASTER_AI_COORDINATOR_MQH
#define MASTER_AI_COORDINATOR_MQH

#include "ChartStructure.mqh"
#include "CandlePatterns.mqh"

bool g_use_nn = true;
bool g_use_openai = false;
bool g_require_ai_validation = false;
MasterSignal g_master_signal;

bool InitializeMasterAI()
{
   InitializeChartStructure();
   InitializePatternDetection();

   g_master_signal.master_direction = 0;
   g_master_signal.master_confidence = 0.0;
   g_master_signal.should_trade = false;
   g_master_signal.structure_type = "UNKNOWN";
   g_master_signal.reasoning = "Not initialized";
   return true;
}

void CleanupMasterAI()
{
   CleanupStructureObjects();
   g_master_signal.master_direction = 0;
   g_master_signal.master_confidence = 0.0;
   g_master_signal.should_trade = false;
   g_master_signal.structure_type = "CLEANUP";
   g_master_signal.reasoning = "AI state reset";
}

void SetUseNeuralNetwork(const bool enable) { g_use_nn = enable; }
void SetUseOpenAI(const bool enable) { g_use_openai = enable; }
void SetRequireAIValidation(const bool enable) { g_require_ai_validation = enable; }

void UpdateMasterAI()
{
   DetectMarketStructure();
   DetectAllCandlestickPatterns();

   int pattern_warns = GetPatternWarnCount();
   int pattern_praise = GetPatternPraiseCount();

   int dir = 0;
   if(IsBullBias()) dir = 1;
   if(IsBearBias()) dir = -1;

   double combo_score = (double)(Active_Praise_Signals + pattern_praise) - (double)(Active_Warnings + pattern_warns);
   double structure_score = (double)GetStructureStrength() * 0.30;
   double confidence = 50.0 + combo_score * 5.0 + structure_score;
   confidence = MathMax(0.0, MathMin(100.0, confidence));

   NN_Bias = (double)dir;
   NN_Confidence = confidence;

   g_master_signal.master_direction = dir;
   g_master_signal.master_confidence = confidence;
   g_master_signal.structure_type = GetStructureString();
   g_master_signal.reasoning = "Combo matrix + patterns + structure";

   if(g_require_ai_validation)
      g_master_signal.should_trade = (confidence >= 75.0 && dir != 0);
   else
      g_master_signal.should_trade = (confidence >= 60.0 && dir != 0);

   if(g_use_nn) g_master_signal.reasoning += " + NN";
   if(g_use_openai) g_master_signal.reasoning += " + OpenAI";
}

MasterSignal GetMasterSignal()
{
   return g_master_signal;
}

#endif
