//
//  AsteroidsFuncs.cpp
//  Asteroids
//
//  Created by Levi Neely on 9/20/22.
//

#include "Asteroids.hpp"
#include <SFML/Graphics.hpp>
#include <iostream>
#include <cassert>

using namespace std;

// Constructors:

// Constructs the asteroid using a radius and position to draw a circle shape.
Asteroid::Asteroid (float radius, sf::Vector2f position){
    radius_ = radius;
    position_ = position;
    circle.setRadius(radius_);
    circle.setPosition(position);
    circle.setFillColor(sf::Color::Red);
}

Asteroid::Asteroid (const Asteroid& copy){
    radius_ = copy.radius_;
    position_ = copy.position_;
    circle = copy.circle;
}
// Functions:

// Gets the radius value.
float Asteroid::getRadius(){
    return radius_;
}

// Gets the position of the asteroid.
sf::Vector2f Asteroid::getPosition(){
    return position_;
}

// Sets the radius to a new value.
void Asteroid::setRadius(float newRadius){
    radius_ = newRadius;
}

// Draws the asteroid to the screen.
void Asteroid::draw (sf::RenderWindow& window) const{
    window.draw(circle);
}

// This returns the circle shape variable of the asteroid object (handy in some other functions).
sf::CircleShape Asteroid::getCircle(){
    return circle;
}

// This "redraw"s the asteroid, making sure that its position is updated everytime there is a change in position.
void Asteroid::redraw(sf::Vector2f position){
    return circle.setPosition(position);
}

// Since the asteroids are falling, movement is only happening in the y direction. Additionally, if the asteroid reaches the bottom of the screen it will go back to the top.
void Asteroid::move(){
    if (position_.y>1280){
        position_.y = 0;
//        assert(position_.y=0);
    }
    position_.y += 3.f;
    redraw(position_);
}

// This function shrinks the asteroid down (used in conjunction to a collision detection).
void Asteroid::shrink (float radius){
    radius_ -= radius;
    circle.setRadius(radius_);
}

// Determines if an asteroid is capable of shrinking further.
bool Asteroid::canShrink() const{
    return circle.getRadius() > 20;
}
// Destructors:
Asteroid::~Asteroid (){
    radius_ = 0;
    //position_ = 0;
    //circle = 0;
}
