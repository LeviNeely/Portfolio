//
//  AsteroidsFuncs.hpp
//  Asteroids
//
//  Created by Levi Neely on 9/20/22.
//

#pragma once

#include <stdio.h>
#include <SFML/Graphics.hpp>
#include <iostream>
#include <vector>

class Asteroid {
private:
    float radius_; // Will be randomly generated, tells how large it is.
    sf::Vector2f position_;
    sf::CircleShape circle;
public:
    // Constructors:
    Asteroid() { }
    Asteroid (float radius, sf::Vector2f position);
    Asteroid (const Asteroid& copy);
    // Functions:
    float getRadius();
    sf::Vector2f getPosition();
    void setRadius(float newRadius);
    void draw (sf::RenderWindow& window) const;
    sf::CircleShape getCircle();
    void redraw(sf::Vector2f position);
    void move();
    void shrink (float radius);
    bool canShrink() const;
    // Destructors:
    ~Asteroid ();
};

/* AsteroidsFuncs_hpp */
