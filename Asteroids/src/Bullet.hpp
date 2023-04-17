//
//  Bullet.hpp
//  Asteroids
//
//  Created by Levi Neely on 9/20/22.
//

#pragma once

#include <stdio.h>
#include "SFML/Window.hpp"
#include "SFML/Graphics.hpp"
#include <vector>
#include "Asteroids.hpp"

class Bullet {
private:
    sf::Vector2f position_;
    sf::CircleShape circle_;
    float speed_ = 3.f;
    float radius_ = 10.f;
    sf::Color color_ = sf::Color::Blue;
public:
// Constructors:
    Bullet () {}
    Bullet (const sf::Vector2f& position);
    Bullet (const Bullet& copy);
// Functions:
    void move ();
    void draw (sf::RenderWindow& window);
    sf::Vector2f getPosition();
    bool canEraseBullet (sf::RenderWindow& window);
    float getRadius ();
    sf::CircleShape getCircle ();
    bool collides (std::vector<Asteroid>& asteroids);
};

/* Bullet_hpp */
