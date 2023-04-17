package com.example.synthesizer;

import java.util.ArrayList;

public class Mixer implements AudioComponent {
    static ArrayList<AudioComponent> input = new ArrayList<AudioComponent>();
    @Override
    public AudioClip getClip() {
        AudioClip sample = new AudioClip();
        for (int i = 0; i < input.size(); i++){
//          Access the audioclip in the arraylist
            AudioClip original = input.get(i).getClip();
            for (int j = 0; j < original.TOTAL_SAMPLES; j++){
//              Utilize this second for loop to then assign the sample by adding the
//              values together from all samples of the audio components in the arraylist.
                double value = original.getSample(j);
                sample.setSample(j, (int)(value + sample.getSample(j)));
            }
        }
        for (int i = 0; i < 88200; i++){
            System.out.println(sample.getSample(i));
        }
        return sample;
    }

    @Override
    public boolean hasInput() {
        return this.input != null;
    }

    @Override
    public void connectInput(AudioComponent input) {
        this.input.add(input);
    }
}
