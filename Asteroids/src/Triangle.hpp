//
//  Triangle.hpp
//  Asteroids
//
//  Created by Levi Neely on 9/20/22.
//

#pragma once
#define Triangle_hpp

#include <SFML/Graphics.hpp>
#include <iostream>
#include "Bullet.hpp"
#include "Asteroids.hpp"

class Triangle {
private:
    sf::CircleShape triangle_;
    float size_;
    int sides_;
    sf::Vector2f position_;
public:
// Constructors:
    Triangle ();
    Triangle (const Triangle& copy);
// Functions:
    void draw (sf::RenderWindow& window) const;
    void setPosition (sf::Vector2f newPosition);
    void move (sf::RenderWindow& window);
    void redraw (sf::Vector2f& position);
    bool collides (const std::vector<Asteroid>& asteroids);
    sf::Vector2f getPosition();
};


 /* Triangle_h */
