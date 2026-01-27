import wave
import math
import struct
import random

def generate_click(filename, duration=0.05, volume=0.5, sample_rate=44100):
    n_samples = int(sample_rate * duration)
    
    with wave.open(filename, 'w') as wav_file:
        wav_file.setnchannels(1)  # Mono
        wav_file.setsampwidth(2)  # 2 bytes per sample
        wav_file.setframerate(sample_rate)
        
        for i in range(n_samples):
            # Generate a burst of noise with a quick decay for a "click" or "flip" sound
            t = float(i) / n_samples
            decay = math.exp(-t * 20) # Fast decay
            
            # White noise * decay
            value = random.uniform(-1, 1) * volume * decay
            
            # Convert to 16-bit integer
            data = struct.pack('<h', int(value * 32767.0))
            wav_file.writeframesraw(data)

if __name__ == "__main__":
    generate_click("assets/flip.wav")
