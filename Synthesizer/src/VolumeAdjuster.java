package com.example.synthesizer;

public class VolumeAdjuster implements AudioComponent{
    static double volume;
    static AudioComponent input;
    public VolumeAdjuster(double volumeModifier) throws ArithmeticException {
        if (volumeModifier < 0){
            throw new ArithmeticException("Cannot set volume to a negative number");
        }
        try {
            volume = volumeModifier;
        }
        catch (ArithmeticException e){
            System.out.println("Cannot set volume to a negative number, please input a positive number");
        }
    }
    public AudioClip getClip(){
        AudioClip original = input.getClip();
        AudioClip sample = new AudioClip();
        for (int i = 0; i < 88200; i++){
//          Utilizes the volume variable to change the amplitude of the
//          sine way, making it louder or softer depending on the value of volume.
            double value = volume* original.getSample(i);
            sample.setSample(i, (int)value);
        }
        return sample;
    }

    @Override
    public boolean hasInput() {
        return this.input != null;
    }

    @Override
    public void connectInput(AudioComponent input) {
        this.input = input;
    }
}
