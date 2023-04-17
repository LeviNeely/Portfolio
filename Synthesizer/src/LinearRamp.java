package com.example.synthesizer;

public class LinearRamp implements AudioComponent{
    static float start_;
    static float stop_;
    public LinearRamp (float start, float stop) throws ArithmeticException {
//      Handle invalid inputs for the start and stop variables.
        if (start < 0 || stop < 0){
            throw new ArithmeticException("Cannot have a value less than 0");
        }
        if (stop < start){
            throw new ArithmeticException("Stop value must be larger than start");
        }
        try {
            start_ = start;
            stop_ = stop;
        }
        catch (ArithmeticException e){
            System.out.println("Invalid input(s)");
        }

    }
    @Override
    public AudioClip getClip() {
        AudioClip sample = new AudioClip();
        for (int i = 0; i < sample.TOTAL_SAMPLES; i++){
//          Assigns the ramped sample to an audioclip to output.
            float rampedSample = ((start_*(float)(sample.TOTAL_SAMPLES-i)+(stop_*i))/(float)(sample.TOTAL_SAMPLES));
            sample.setSample(i, (int) rampedSample);
        }
        return sample;
    }

    @Override
    public boolean hasInput() {
        return false;
    }

    @Override
    public void connectInput(AudioComponent input) {
    }
}
