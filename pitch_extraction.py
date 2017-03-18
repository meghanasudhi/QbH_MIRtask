#this extracts pitch vectors for IOACAS QBSH dataset
#author : MEGHANA SUDHINDRA
#SMC MASTERS
#MIR TASK - 2017




import essentia.standard as ess
import vamp
import numpy as np
import os
import matplotlib.pyplot as plt

path = '/Users/meghanasudhindra/Desktop/wavfile'
path_out = '/Users/meghanasudhindra/Desktop/output'
def hz2cents(pitchInHz, tonic=261.626):
    """def hz2cents(pitchInHz, tonic=261.626)/
    convert hz to cents
    input: an array in hz
    """
    cents = 1200*np.log2(1.0*pitchInHz/tonic)
    return cents

for file in os.listdir(path):
	current_file = os.path.join(path, file)
	if current_file!="/Users/meghanasudhindra/Desktop/test_wav/.DS_Store":
		sr = 8000
		# essentia load audio
		loader = ess.MonoLoader(filename = current_file, downmix = 'left', sampleRate = sr)
		audio = loader()
		# extract pitch contour, by a fixed sample rate "sr"
		# hopsize = 1024 frames
		# framesize = 2048 frames
		data = vamp.collect(audio, sr, "pyin:pyin", output='smoothedpitchtrack')
		pitch = data['vector'][1]
		dur = (audio.size/8000.0)
		timestamps = np.linspace(0.0, dur, num = pitch.size)
		#print timestamps
		#pv = np.vstack((timestamps, pitch))
		#print pv.shape
		outfile_name = os.path.basename(file).split(".")[0] + ".pv"
		outfile = os.path.join(path_out, outfile_name)
		fileid = open(outfile, 'w')

		#np.savetxt(outfile, pv)
		for i in range(0,timestamps.size):
			fileid.write(str(timestamps[i]) + "  " + str(pitch[i]) +"\n")


		fileid.close()


		#print pitch
		# convert Hz to cents
		#pitchInCents = hz2cents(pitch)
		
		#plt.figure()
		#plt.plot(pitchInCents)
		#plt.show()

