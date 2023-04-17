//
//  Bullet.cpp
//  Asteroids
//
//  Created by Levi Neely on 9/20/22.
//

#include "Bullet.hpp"
#include "SFML/Graphics.hpp"
#include "SFML/Window.hpp"
#include <iostream>
#include <vector>

using namespace std;

// Constructors:

// Constructed using a position. But the circle_ is defined in the actual Class definition so that the radius and color are constant.
Bullet::Bullet (const sf::Vector2f& position){
    position_ = position;
    circle_.setPosition(position);
    circle_.setRadius(radius_);
    circle_.setFillColor(color_);
}
Bullet::Bullet (const Bullet& copy){
    circle_ = copy.circle_;
    position_ = copy.position_;
}
// Functions:

// Moves the bullet with a constant speed only in the y direction.
void Bullet::move (){
    circle_.move(0, -15);
    position_.y = circle_.getPosition().y-15;
}

// Draws the bullet to the screen.
void Bullet::draw (sf::RenderWindow& window) {
    window.draw(circle_);
}

// This is a collision detector to use inside it's own deletion section of the main world loop. Without this, it would only delete when it went outside of the screen.
bool Bullet::collides (vector<Asteroid>& asteroids){
    for(Asteroid asteroid: asteroids){
        auto xform = circle_.getTransform();
        for(auto i = 0; i < circle_.getPointCount(); i++){
            auto vec = xform*circle_.getPoint(i) - asteroid.getPosition();
            if(vec.x*vec.x + vec.y*vec.y < asteroid.getRadius()*asteroid.getRadius()){
                    return true;
            }
        }
    }
    return false;
}

// This just returns the position of the bullet.
sf::Vector2f Bullet::getPosition(){
    return position_;
}

// This function determines whether or not the bullet is outside of the screen, so that it can be deleted.
bool Bullet::canEraseBullet (sf::RenderWindow& window){
    auto position = circle_.getPosition();
    return (position.y < 0);
}

// Allows us to return the radius of the bullet.
float Bullet::getRadius (){
    return radius_;
}

// Allows us to return the circle_ variable of the bullet object and that in turn allows us to utilize functions of the sf::CircleShape class.
sf::CircleShape Bullet::getCircle (){
    return circle_;
}
