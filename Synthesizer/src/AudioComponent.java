package com.example.synthesizer;

interface AudioComponent {
    public AudioClip getClip();
    public boolean hasInput();
    public void connectInput(AudioComponent input);
}
