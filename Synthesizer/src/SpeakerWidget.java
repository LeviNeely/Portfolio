package com.example.synthesizer;

import javafx.scene.layout.AnchorPane;
import javafx.scene.shape.Circle;

public class SpeakerWidget extends AudioComponentWidget {
    public SpeakerWidget(AudioComponent ac, AnchorPane parent, String name) {
        super(ac, parent, name);
        inputCircle = new Circle (10);
        right.getChildren().remove(close);
        left.getChildren().add(inputCircle);
    }
}
