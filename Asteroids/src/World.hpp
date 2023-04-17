//
//  World.hpp
//  Asteroids
//
//  Created by Levi Neely on 9/20/22.
//

#pragma once

#include "Asteroids.hpp"
#include "Triangle.hpp"
#include "Bullet.hpp"
#include <SFML/Window.hpp>
#include <SFML/Graphics.hpp>
#include <vector>

class World{
public:
    World()
    : window(sf::VideoMode(720, 1280), "My Window")
    {
//        reset();
    }
    void loop ();
    void spawnBullet ();
    bool singleBulletCollisionOccurred (Bullet& bullet, Asteroid& asteroid);
private:
    sf::RenderWindow window;
    Triangle ship;
    std::vector<Asteroid> asteroids;
    std::vector<Bullet> bullets;
    sf::Time timeToShoot;
    sf::Clock shotClock;
};

/* World_hpp */
