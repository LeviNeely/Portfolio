package com.example.synthesizer;

public class Speaker implements AudioComponent{
    public AudioComponent input;
    @Override
    public AudioClip getClip() {
        AudioClip sample = new AudioClip();
        sample = input.getClip();
        return sample;
    }

    @Override
    public boolean hasInput() {
        return false;
    }

    @Override
    public void connectInput(AudioComponent input1) {
        input = input1;
    }
}
