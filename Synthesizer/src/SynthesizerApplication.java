package com.example.synthesizer;

import javafx.application.Application;
import javafx.geometry.Insets;
import javafx.geometry.Pos;
import javafx.scene.Scene;
import javafx.scene.control.Button;
import javafx.scene.control.Label;
import javafx.scene.input.MouseEvent;
import javafx.scene.layout.*;
import javafx.stage.Stage;

import javax.sound.sampled.AudioFormat;
import javax.sound.sampled.Clip;
import javax.sound.sampled.LineUnavailableException;
import java.io.IOException;
import java.util.ArrayList;

import static javax.sound.sampled.AudioSystem.getClip;

public class SynthesizerApplication extends Application {
//  Member variables that control the window of the application
    public static HBox top;
    public static HBox bottom;
    public static VBox right;
    public static AnchorPane center;
//  The speaker is a constant in the app, so it is a member variable for the application
    public static SpeakerWidget speaker;
//  This is an ArrayList of all the widgets at any given time
    public static ArrayList<AudioComponentWidget> allWidgets = new ArrayList<AudioComponentWidget>();
    @Override
    public void start(Stage stage) throws IOException {
//      Create the root and the scene
        BorderPane root = new BorderPane();
        Scene scene = new Scene(root, 1280, 720);
//      Creating all the border pane areas
        top = new HBox();
        bottom = new HBox();
        right = new VBox();
        center = new AnchorPane();
        root.setTop(top);
        root.setBottom(bottom);
        root.setRight(right);
        root.setCenter(center);
//      Formatting all the areas
        top.setStyle("-fx-border-color: black");
        bottom.setStyle("-fx-border-color: black");
        right.setStyle("-fx-border-color: black");
        center.setStyle("-fx-border-color: black");
        right.setStyle("-fx-background-color: grey");
        top.setAlignment(Pos.TOP_CENTER);
        bottom.setAlignment(Pos.TOP_CENTER);
        right.setAlignment(Pos.TOP_CENTER);
        top.setPadding(new Insets(15, 12, 15, 12));
        bottom.setPadding(new Insets(15, 12, 15, 12));
        right.setPadding(new Insets(15, 12, 15, 12));
        right.setSpacing(50);
        Label title = new Label("Synthesizer");
//      Creating the speaker
        AudioComponent spkr = new Speaker();
        speaker = new SpeakerWidget(spkr, center, "Speaker");
        speaker.relocate(1010, 560);
        allWidgets.add(speaker);
//      Creating all buttons
        Button playButton = new Button("Play");
        Button sineWaveButton = new Button("Sine Wave");
        Button volumeAdjusterButton = new Button("Volume");
        Button mixerButton = new Button("Mixer");
        Button squareWaveButton = new Button("Square Wave");
        Button linearRampButton = new Button("Linear Ramp");
        Button vfWaveGeneratorButton = new Button("VF Wave Generator");
//      Handling clicking events on the buttons
        playButton.setOnMouseClicked(e -> handleMouseClicked(e, speaker));
        sineWaveButton.setOnMouseClicked(e -> handleSineWaveClick(e));
        volumeAdjusterButton.setOnMouseClicked(e -> handleVolumeAdjusterClick(e));
        mixerButton.setOnMouseClicked(e -> handleMixerClick(e));
        squareWaveButton.setOnMouseClicked(e -> handleSquareWaveClick(e));
        linearRampButton.setOnMouseClicked(e -> handleLinearRampClick(e));
        vfWaveGeneratorButton.setOnMouseClicked(e -> handleVFWaveGeneratorClick(e));
//      Putting it all together
        top.getChildren().add(title);
        bottom.getChildren().addAll(playButton);
        right.getChildren().addAll(sineWaveButton, volumeAdjusterButton, squareWaveButton, linearRampButton, vfWaveGeneratorButton, mixerButton);
//      Setting the stage
        stage.setScene(scene);
        stage.setTitle("Synthesizer");
        stage.show();
    }

    private void handleVFWaveGeneratorClick(MouseEvent e) {
        AudioComponent vfWaveGenerator = new VFWaveGenerator();
        VFWaveGeneratorWidget vfwgw = new VFWaveGeneratorWidget(vfWaveGenerator, center, "VF Wave Generator Widget");
        allWidgets.add(vfwgw);
        if (allWidgets.size() > 1){
            vfwgw.relocate(0, (allWidgets.size()*60));
        }
    }

    private void handleLinearRampClick(MouseEvent e) {
        AudioComponent linearRamp = new LinearRamp(50, 500);
        LinearRampWidget lrw = new LinearRampWidget(linearRamp, center, "Linear Ramp (Start: 50, Stop: 500)");
        allWidgets.add(lrw);
        if (allWidgets.size() > 1){
            lrw.relocate(0, (allWidgets.size()*50));
        }
    }

    private void handleSquareWaveClick(MouseEvent e) {
        AudioComponent squareWave = new SquareWave();
        SquareWaveWidget sww = new SquareWaveWidget(squareWave, center, "Square Wave");
        allWidgets.add(sww);
        if (allWidgets.size() > 1){
            sww.relocate(0, (allWidgets.size()*43));
        }
    }

    private void handleMixerClick(MouseEvent e) {
        AudioComponent mixer = new Mixer();
        MixerWidget mw = new MixerWidget(mixer, center, "Mixer");
        allWidgets.add(mw);
        if (allWidgets.size() > 1){
            mw.relocate(0, (allWidgets.size()*70));
        }
    }

    private void handleVolumeAdjusterClick(MouseEvent e) {
        AudioComponent volumeAdjuster = new VolumeAdjuster(1);
        VolumeAdjusterWidget vaw = new VolumeAdjusterWidget(volumeAdjuster, center, "Volume: 1");
        allWidgets.add(vaw);
        if (allWidgets.size() > 1){
            vaw.relocate(0, (allWidgets.size()*32));
        }
    }

    private void handleSineWaveClick(MouseEvent e) {
        AudioComponent sineWave = new SineWave(440);
        sineWaveWidget sw = new sineWaveWidget(sineWave, center, "Sine Wave (440 Hz)");
        allWidgets.add(sw);
        if (allWidgets.size() > 1) {
            sw.relocate(0, (allWidgets.size() * 50));
        }
    }

    private void handleMouseClicked(MouseEvent e, SpeakerWidget speaker) {
//      Initializing the clip to be played
        Clip c = null;
        try {
            c = getClip();
        } catch (LineUnavailableException ex) {
            throw new RuntimeException(ex);
        }
        AudioFormat format16 = new AudioFormat( 44100, 16, 1, true, false );
//      Verifying that the speaker has a connection in the first place
        if (speaker.hasConnection){
            AudioClip clip = speaker.audioComponent_.getClip();
            try {
                c.open( format16, clip.getData(), 0, clip.getData().length);
            } catch (LineUnavailableException ex) {
                throw new RuntimeException(ex);
            }
            c.start();
            while (c.getFramePosition() < AudioClip.TOTAL_SAMPLES || c.isActive() || c.isRunning()){
            }
        }
    }

    public static void main(String[] args) {
        launch();
        SynthesizerApplication sa = new SynthesizerApplication();
        Stage stage = new Stage();
        try {
            sa.start(stage);
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
    }
}