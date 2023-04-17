package com.example.synthesizer;

public class SquareWave implements AudioComponent{
    static AudioComponent input;
    @Override
    public AudioClip getClip() {
        AudioClip original = input.getClip();
        AudioClip sample = new AudioClip();
        for (int i = 0; i < 88200; i++){
//          Since the values are going to be between -1 and 1, we can set the values
//          to the min or max value based off of whether or not it is greater than 0.
            if ( (original.getSample(i)) > 0) {
                sample.setSample(i, Short.MAX_VALUE);
            }
            else {
                sample.setSample(i, Short.MIN_VALUE);
            }
        }
        return sample;
    }

    @Override
    public boolean hasInput() {
        return this.input != null;
    }

    @Override
    public void connectInput(AudioComponent input1) {
        input = input1;
    }
}
