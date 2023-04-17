package com.example.synthesizer;
import java.lang.Math;

public class VFWaveGenerator implements AudioComponent{
    static AudioComponent input_;
    @Override
    public AudioClip getClip() {
//      Create the audioclip we are taking from and the audioclip that we are outputting.
        AudioClip original = input_.getClip();
        AudioClip output = new AudioClip();
        double phase = 0;
        for (int i = 0; i < original.TOTAL_SAMPLES; i++){
//          Defining the phase by utilizing each single sample from the ramped auidoclip
            phase += (2*Math.PI*(double)original.getSample(i))/(double)original.TOTAL_SAMPLES;
            double outputValue = Short.MAX_VALUE*Math.sin(phase);
            output.setSample(i, (int) outputValue);
        }
        return output;
    }

    @Override
    public boolean hasInput() {
        return false;
    }

    @Override
    public void connectInput(AudioComponent input) {
        input_ = input;
    }
}
