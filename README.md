# profitgtx

Modular MT5 EA repository for `profitmaxxingt3.1.mq5`.

## Current structure
- `profitmaxxingt3.1.mq5`: Main EA orchestrator.
- `*.mqh`: Module files (config, indicators, warnings, setups, AI coordinator).
- `train_nn.py`: Placeholder NN training entry point.
- `scripts/build_mt5.sh`: Syncs this repo into MT5 Experts path and runs MetaEditor compile.

## Notes
- The previously unreadable module files were zero-byte placeholders; they are now valid UTF-8 text files.
- Linux path compilation with MetaEditor fails include resolution. Use `scripts/build_mt5.sh` to compile from MT5 `MQL5/Experts` path.
- On fully headless servers, Wine GUI dependencies can still block MetaEditor compile log creation. In that case, run build from a desktop session or RDP/X server.

## Build
```bash
./scripts/build_mt5.sh
```
