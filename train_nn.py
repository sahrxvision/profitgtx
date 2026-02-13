#!/usr/bin/env python3
"""Minimal NN training stub for the MT5 project."""

from pathlib import Path


def main() -> None:
    data_dir = Path("data")
    models_dir = Path("models")
    models_dir.mkdir(exist_ok=True)

    print("train_nn.py scaffold")
    print(f"data dir exists: {data_dir.exists()}")
    print(f"models dir: {models_dir.resolve()}")
    print("Next: plug in your feature pipeline and model trainer.")


if __name__ == "__main__":
    main()
