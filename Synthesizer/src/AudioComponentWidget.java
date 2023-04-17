package com.example.synthesizer;

import javafx.geometry.Insets;
import javafx.geometry.Pos;
import javafx.scene.control.Button;
import javafx.scene.control.Label;
import javafx.scene.input.MouseEvent;
import javafx.scene.layout.AnchorPane;
import javafx.scene.layout.HBox;
import javafx.scene.layout.Pane;
import javafx.scene.layout.VBox;
import javafx.scene.shape.Circle;
import javafx.scene.shape.Line;

import java.lang.reflect.Array;
import java.util.ArrayList;

public class AudioComponentWidget extends Pane {
//  All the member variables formatting the widgets
    public final Insets padding = new Insets(15,12,15,12);
    public String borderColor = "-fx-border-color: black";
    public Button close;
    public AudioComponent audioComponent_;
    public AnchorPane parent_;
    public String name_;
    public HBox baseLayout;
    public VBox left;
    public VBox right;
    public VBox center_;
    public Label title;
    public Circle inputCircle;
    public Circle outputCircle;
//  All of these member variables allow for keeping track of various connections
    public Boolean hasConnection = false;
    public Boolean lineExists = false;
    public String whatTypeAmI_ = "";
    public Line line_;
    public AudioComponentWidget whoIsConnectedToMe_ = null;
    public AudioComponentWidget whoAmIConnectedTo_ = null;
//  Only used for the Mixer widget
    public ArrayList<AudioComponentWidget> allConnectedToMe_;
//  Variables used to move widgets around the screen
    public double mouseStartDragX_, mouseStartDragY_, widgetStartDragX_, widgetStartDragY_, lineStartDragX_, lineStartDragY_, otherLineStartDragX_, otherLineStartDragY_;
    public ArrayList<Double> allConnectedToMeStartDragX_ = new ArrayList<Double>();
    public ArrayList<Double> allConnectedToMeStartDragY_ = new ArrayList<Double>();
    public AudioComponentWidget(AudioComponent ac, AnchorPane parent, String name){
//      Assigning member variables and formatting all the different boxes and whatnot
        audioComponent_ = ac;
        parent_ = parent;
        name_ = name;
        baseLayout = new HBox();
        baseLayout.setStyle(borderColor);
        baseLayout.setPadding(padding);
        baseLayout.setSpacing(15);
        baseLayout.setAlignment(Pos.CENTER);
        left = new VBox();
        center_ = new VBox();
        right = new VBox();
        center_.setSpacing(15);
        right.setSpacing(15);
        left.setAlignment(Pos.CENTER);
        center_.setAlignment(Pos.CENTER);
        right.setAlignment(Pos.CENTER);
        close = new Button("x");
        title = new Label(name_);
        title.setMouseTransparent(true);
        center_.getChildren().add(title);
        baseLayout.getChildren().addAll(left, center_, right);
//      Handling any mouse events
        center_.setOnMousePressed(e -> startDrag(e));
        center_.setOnMouseDragged(e -> handleDrag(e));
//      Putting it all together and adding it to the parent
        this.getChildren().add(baseLayout);
        this.setLayoutX(0);
        this.setLayoutY(50);
        parent_.getChildren().add(this);
    }

    public Circle getInputCircle(){
        return inputCircle;
    }

    public AnchorPane getParent_(){
        return parent_;
    }

    private void handleDrag(MouseEvent e) {
        double mouseDelX = e.getSceneX() - mouseStartDragX_;
        double mouseDelY = e.getSceneY() - mouseStartDragY_;
//      Since Mixers have multiple connections, an ArrayList needs to be used
        String type = "Mixer";
        if (this.whatTypeAmI_.equals(type)){
            this.relocate(widgetStartDragX_+mouseDelX, widgetStartDragY_+mouseDelY);
            if (this.lineExists){
                this.line_.setStartX(lineStartDragX_+mouseDelX);
                this.line_.setStartY(lineStartDragY_+mouseDelY);
                for (int i = 0; i < allConnectedToMe_.size(); i++){
                    allConnectedToMe_.get(i).line_.setEndX(allConnectedToMeStartDragX_.get(i)+mouseDelX);
                    allConnectedToMe_.get(i).line_.setEndY(allConnectedToMeStartDragY_.get(i)+mouseDelY);
                }
            }
        }
        else{
            this.relocate(widgetStartDragX_+mouseDelX, widgetStartDragY_+mouseDelY);
            if (this.lineExists){
                this.line_.setStartX(lineStartDragX_+mouseDelX);
                this.line_.setStartY(lineStartDragY_+mouseDelY);
            }
            if (this.hasConnection){
                this.whoIsConnectedToMe_.line_.setEndX(otherLineStartDragX_+mouseDelX);
                this.whoIsConnectedToMe_.line_.setEndY(otherLineStartDragY_+mouseDelY);
            }
        }
    }

    private void startDrag(MouseEvent e) {
//      Since Mixers have multiple connections, an ArrayList needs to be used
        String type = "Mixer";
        if (this.whatTypeAmI_.equals(type)){
            mouseStartDragX_ = e.getSceneX();
            mouseStartDragY_ = e.getSceneY();
            widgetStartDragX_ = this.getLayoutX();
            widgetStartDragY_ = this.getLayoutY();
            if (this.lineExists){
                lineStartDragX_ = this.line_.getStartX();
                lineStartDragY_ = this.line_.getStartY();
                for (int i = 0; i < allConnectedToMe_.size(); i++){
                    allConnectedToMeStartDragX_.add(allConnectedToMe_.get(i).line_.getEndX());
                    allConnectedToMeStartDragY_.add(allConnectedToMe_.get(i).line_.getEndY());
                }
            }
        }
        else{
            mouseStartDragX_ = e.getSceneX();
            mouseStartDragY_ = e.getSceneY();
            widgetStartDragX_ = this.getLayoutX();
            widgetStartDragY_ = this.getLayoutY();
            if (this.lineExists){
                lineStartDragX_ = this.line_.getStartX();
                lineStartDragY_ = this.line_.getStartY();
            }
            if (this.hasConnection){
                otherLineStartDragX_ = this.whoIsConnectedToMe_.line_.getEndX();
                otherLineStartDragY_ = this.whoIsConnectedToMe_.line_.getEndY();
            }
        }
    }
}

