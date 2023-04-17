package com.example.synthesizer;

import javafx.geometry.Bounds;
import javafx.scene.input.MouseEvent;
import javafx.scene.layout.AnchorPane;
import javafx.scene.shape.Circle;
import javafx.scene.shape.Line;

public class SquareWaveWidget extends AudioComponentWidget {
    public SquareWaveWidget(AudioComponent ac, AnchorPane parent, String name) {
        super(ac, parent, name);
        inputCircle = new Circle(50, 50, 10);
        outputCircle = new Circle(50, 50, 10);
        left.getChildren().add(inputCircle);
        right.getChildren().addAll(close, outputCircle);
        outputCircle.setOnMousePressed(e -> startConnection(e));
        outputCircle.setOnMouseDragged(e -> moveConnection(e));
        outputCircle.setOnMouseReleased(e -> endConnection(e));
        close.setOnMouseClicked(e -> handleCloseClick(e));
    }

    private void endConnection(MouseEvent e) {
//      Checking all widgets on the screen to see if the line is within the bounds
        for (AudioComponentWidget ac : SynthesizerApplication.allWidgets) {
            try {
                Circle circle = ac.getInputCircle();
                Bounds circleBounds = circle.localToScene(circle.getBoundsInLocal());
                double distance = Math.sqrt(Math.pow(circleBounds.getCenterX() - e.getSceneX(), 2.0) + Math.pow(circleBounds.getCenterY() - e.getSceneY(), 2.0));
//              For when a widget that has a line connected to something else and the widget does not have any other connections to it
                if (distance < 10 && lineExists == true && ac.hasConnection == false) {
                    Bounds parentBounds = ac.getParent_().getBoundsInParent();
                    line_.setEndX(circleBounds.getCenterX() - parentBounds.getMinX());
                    line_.setEndY(circleBounds.getCenterY() - parentBounds.getMinY());
//                  Updating method variable data to assist in other functions
                    ac.hasConnection = true;
                    String type = new String();
                    type = "Mixer";
//                  Mixers have to be treated specially since they take multiple inputs
                    if (ac.whatTypeAmI_.equals(type)) {
                        ac.hasConnection = false;
                        ac.allConnectedToMe_.add(this);
                    }
                    ac.audioComponent_.connectInput(this.audioComponent_);
                    ac.whoIsConnectedToMe_ = this;
                    whoAmIConnectedTo_ = ac;
                    return;
                }
//              For when a widget that does not have a line connected to something and doesn't have anything connected to another one
                else if (distance < 10 && lineExists == false && ac.hasConnection == false) {
                    Bounds parentBounds = ac.getParent_().getBoundsInParent();
                    line_.setEndX(circleBounds.getCenterX() - parentBounds.getMinX());
                    line_.setEndY(circleBounds.getCenterY() - parentBounds.getMinY());
                    parent_.getChildren().add(line_);
                    lineExists = true;
                    ac.hasConnection = true;
                    String type = new String();
                    type = "Mixer";
                    if (ac.whatTypeAmI_.equals(type)) {
                        ac.hasConnection = false;
                        ac.allConnectedToMe_.add(this);
                    }
                    ac.audioComponent_.connectInput(this.audioComponent_);
                    ac.whoIsConnectedToMe_ = this;
                    whoAmIConnectedTo_ = ac;
                    return;
                } else {
                    parent_.getChildren().remove(line_);
                    lineExists = false;
                }
            } catch (Exception ex) {
                System.out.println("Error" + ex.getMessage());
                continue;
            }
        }
    }

    private void moveConnection(MouseEvent e) {
        Bounds parentBounds = parent_.getBoundsInParent();
        line_.setEndX(e.getSceneX() - parentBounds.getMinX());
        line_.setEndY(e.getSceneY() - parentBounds.getMinY());
    }

    private void startConnection(MouseEvent e) {
        if (line_ != null) {
            parent_.getChildren().remove(line_);
            lineExists = false;
        }
        Bounds parentBounds = parent_.getBoundsInParent();
        Bounds bounds = outputCircle.localToScene(outputCircle.getBoundsInLocal());
        line_ = new Line();
        line_.setStrokeWidth(4);
        line_.setStartX(bounds.getCenterX() - parentBounds.getMinX());
        line_.setStartY(bounds.getCenterY() - parentBounds.getMinY());
        line_.setEndX(e.getSceneX() - parentBounds.getMinX());
        line_.setEndY(e.getSceneY() - parentBounds.getMinY());
        parent_.getChildren().add(line_);
        lineExists = true;
    }

    private void handleCloseClick(MouseEvent e) {
//      Ensuring that the widget, it's line, and all lines connected to it are removed from the screen
        parent_.getChildren().removeAll(this, line_, whoIsConnectedToMe_.line_);
//      Member variables regarding state are updated
        whoIsConnectedToMe_.whoAmIConnectedTo_ = null;
        whoAmIConnectedTo_ = null;
        whoIsConnectedToMe_.lineExists = false;
        SynthesizerApplication.allWidgets.remove(this);
    }
}
