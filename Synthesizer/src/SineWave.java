package com.example.synthesizer;
import java.lang.Math;
import java.security.InvalidParameterException;

public class SineWave implements AudioComponent {
    public static int frequency;
    //static short volume;

    public SineWave (int frequencyInput) throws ArithmeticException {
        if (frequencyInput <= 0){
            throw new ArithmeticException("Cannot utilize a frequency of 0 or less");
        }
        try {
            frequency = frequencyInput;
        }
//      Catching negative or 0 value inputs.
        catch (ArithmeticException e){
            System.out.println("Invalid frequency input");
        }
    }
    public AudioClip getClip() {
//      Setting the volume as the maximum in the creation of a clip from the sine wave
        double volume = 32767;
        AudioClip sample = new AudioClip();
        for (int i = 0; i < AudioClip.TOTAL_SAMPLES; i++){
            double value = volume * Math.sin(2*Math.PI*frequency*i/ AudioClip.sampleRate);
            sample.setSample(i, (int)value);
        }
        return sample;
    }
    public int getFrequency(){
        return frequency;
    }
    public boolean hasInput() {
        return false;
    }
    public void connectInput(AudioComponent input) {

    }
}
