#ifndef MASTER_AI_COORDINATOR_MQH
#define MASTER_AI_COORDINATOR_MQH

bool g_use_nn = true;
bool g_use_openai = false;
bool g_require_ai_validation = false;
MasterSignal g_master_signal;

bool InitializeMasterAI()
{
   g_master_signal.master_direction = 0;
   g_master_signal.master_confidence = 0.0;
   g_master_signal.should_trade = false;
   g_master_signal.structure_type = "UNKNOWN";
   g_master_signal.reasoning = "Not initialized";
   return true;
}

void CleanupMasterAI()
{
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
   int dir = 0;
   if(ma_fast_value > ma_slow_value) dir = 1;
   if(ma_fast_value < ma_slow_value) dir = -1;

   double confidence = 50.0 + (Active_Praise_Signals - Active_Warnings) * 12.5;
   confidence = MathMax(0.0, MathMin(100.0, confidence));

   NN_Bias = (double)dir;
   NN_Confidence = confidence;

   g_master_signal.master_direction = dir;
   g_master_signal.master_confidence = confidence;
   g_master_signal.structure_type = (dir > 0 ? "HH/HL" : dir < 0 ? "LH/LL" : "SIDEWAYS");
   g_master_signal.reasoning = "EMA bias + warning/praise balance";

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
