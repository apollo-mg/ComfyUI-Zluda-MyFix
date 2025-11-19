@echo off

echo "Installing transformers..."
py -3.10 -m pip install transformers==4.42.4

echo "Installing faster-whisper and compatible tokenizers..."
py -3.10 -m pip install tokenizers==0.15.2
py -3.10 -m pip install faster-whisper==1.0.1

echo "Installing remaining dependencies..."
py -3.10 -m pip install -r requirements.txt

echo "Installing PyTorch..."
py -3.10 -m pip install torch==2.1.1+cu118 torchaudio==2.1.1+cu118 --index-url https://download.pytorch.org/whl/cu118

echo "Running model downloader..."
py -3.10 scripts/modeldownloader.py

echo "Installation complete."
pause