#include <iostream>
#include <SFML/Graphics.hpp>
#include "Triangle.hpp"
#include <cassert>

using namespace std;

// Constructors:
Triangle::Triangle (){
    // Since our player is never going to change size, size, color, and constructed position will remain constant.
    triangle_.setRadius(30);
    triangle_.setPointCount(3);
    triangle_.setFillColor(sf::Color::Green);
    position_ = {300, 1200};
    triangle_.setPosition(position_);
}

//Copy constructor
Triangle::Triangle (const Triangle& copy){
    triangle_ = copy.triangle_;
    size_ = copy.size_;
    sides_ = copy.sides_;
    position_ = copy.position_;
}

// Functions:

// Draws the triangle_ shape of the triangle object on the screen.
void Triangle::draw (sf::RenderWindow& window) const{
    window.draw(triangle_);
}

// Moves the triangle object left and right with a constant speed.
void Triangle::move (sf::RenderWindow& window){
    if (sf::Keyboard::isKeyPressed(sf::Keyboard::Left) && position_.x> 0){
        triangle_.move(-5.f, 0.f);
        // After some debugging, we realized that unless we were setting the triangle_'s position manually like this, the position was inadvertently remaining at 0,0.
        position_.x = triangle_.getPosition().x-5;
    }
    if (sf::Keyboard::isKeyPressed(sf::Keyboard::Right) && position_.x < 670){
        if (position_.x > 720){
            position_.x = 0;
        }
        triangle_.move(5.f, 0.f);
        position_.x = triangle_.getPosition().x+5;
    }
}

// This simply sets a new position for the triangle object.
void Triangle::setPosition (sf::Vector2f newPosition){
    position_ = newPosition;
}

// This "redraw"s the triangle. It sets the position of the triangle_ inside the triangle object.
void Triangle::redraw (sf::Vector2f& position){
    return triangle_.setPosition(position);
}

// Tests whether the triangle collides with an asteroid using some geometry.
bool Triangle::collides (const vector<Asteroid>& asteroids){
    for(Asteroid asteroid: asteroids){
        auto xform = triangle_.getTransform();
        for(auto i = 0; i < triangle_.getPointCount(); i++){
            auto vec = xform*triangle_.getPoint(i) - asteroid.getCircle().getPosition();
            if(vec.x*vec.x + vec.y*vec.y <
                asteroid.getCircle().getRadius()*asteroid.getCircle().getRadius()){
                    return true;
            }
        }
    }
    return false;
}

// Returns what the current position is of the triangle. Helpful in tracking movement and helping to spawn bullets.
sf::Vector2f Triangle::getPosition(){
    return position_;
}
