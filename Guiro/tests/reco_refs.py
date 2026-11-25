"""reco_refs.py <texture.wav> <outdir> — cuts the reco-reco texture (15 s of continuous playing: scrapes back to back) into one clip per stroke, onset to the
next onset (at most 600 ms; the last stroke of a run gets the ring-out): RR_<n>_<ms>.wav. Onsets: the 1.5 kHz+ rms envelope (3 ms) rises 9 dB above its minimum over the previous 12 ms and is >= -30 dB
re its peak; two onsets are at least 35 ms apart. Prints onset, clip length and peak per clip."""
import sys, wave, numpy as np
w = wave.open(sys.argv[1]); sr = w.getframerate()
x = np.frombuffer(w.readframes(w.getnframes()), dtype='<i2').astype(float) / 32768
h = np.diff(np.diff(x, prepend=0), prepend=0)
e = np.sqrt(np.convolve(h * h, np.ones(int(0.003 * sr)) / int(0.003 * sr), 'same')); db = 20 * np.log10(e / e.max() + 1e-9)
k = int(0.012 * sr); ons = []
for i in range(k, len(db) - k):
    if db[i] > -30 and db[i] - db[i - k:i].min() > 9 and db[i] >= db[i - 1] and db[i] > db[i + 1] and (not ons or i - ons[-1] > 0.035 * sr):
        j = i
        while j > i - k and db[j - 1] < db[j]: j -= 1   # back to the foot of the rise
        ons.append(j)
for n, a in enumerate(ons):
    b = ons[n + 1] if n + 1 < len(ons) else a + int(0.6 * sr)
    b = min(b, a + int(0.6 * sr)); lo = max(0, a - int(0.003 * sr)); y = (x[lo:b] * 32767).astype('<i2')
    ms = int((b - a) / sr * 1000)
    o = wave.open('%s/RR_%02d_%d.wav' % (sys.argv[2], n, ms), 'wb'); o.setnchannels(1); o.setsampwidth(2); o.setframerate(sr); o.writeframes(y.tobytes()); o.close()
    print('RR_%02d  onset %.3f s  clip %d ms  peak %.2f' % (n, a / sr, ms, np.abs(y / 32768.).max()))
