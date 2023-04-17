//
//  World.cpp
//  Asteroids
//
//  Created by Levi Neely on 9/20/22.
//

#include "World.hpp"
#include <random>
#include <iostream>
#include "SFML/Graphics.hpp"
#include "SFML/Window.hpp"
#include "Asteroids.hpp"
#include "Bullet.hpp"
#include <iostream>
#include <cassert>

using namespace std;

void World::loop (){
    //The constructor takes care of creating the actual window, we just set parameters here like the frame rate limit.
    window.setFramerateLimit(60);
    //Loading in the text font
    sf::Font font;
    if (!font.loadFromFile("Nasa21-l23X.ttf")) {
        perror("Could not find font file");
    }
    //Setting the score text and its settings
    sf::Text scoreText;
    scoreText.setFont(font);
    scoreText.setCharacterSize(50);
    scoreText.setFillColor(sf::Color::Yellow);
    scoreText.setPosition(0, 0);
    //Setting the high score text and its settings
    sf::Text highScoreText;
    highScoreText.setFont(font);
    highScoreText.setCharacterSize(50);
    highScoreText.setFillColor(sf::Color::Yellow);
    highScoreText.setPosition(0, 55);
    //These are the values that keep track of the score and high score and will be updated
    int score = 0;
    int highScore = 0;
    // We wanted a way to track time in order to make difficulty increase as time went on:
    sf::Clock clock;
    //This variable is used in how frequently an asteroid will spawn in a later part of the code.
    float asteroidSpawnSpeed = 1.0;
    //This variable is used in how many asteroids are allowed on the screen at one time.
    int asteroidMax = 10;
    while (window.isOpen()){
        // This lets the values increase every time 10 seconds has elapsed in the game.
        sf::Time elapsed = clock.getElapsedTime();
        if (elapsed.asMilliseconds()%10000 == 0){
            asteroidSpawnSpeed += 0.1;
            asteroidMax += 5;
        }
        sf::Event event;
        while (window.pollEvent(event)){
            // Ensures that the window will close and the game will end if the close button is pushed.
            if (event.type == sf::Event::Closed){
                window.close();
            }
            // This tracks how many times that the space bar is pressed and spawns a bullet everytime that it happens.
            if (event.type == sf::Event::KeyPressed){
                if (event.key.code == sf::Keyboard::Space){
                    spawnBullet();
                }
            }
        }
        
        
        // Rendering section
        window.clear(sf::Color::Black);
        // This defines the "origin" of the screen as far as the spaceship is concerned.
        sf::Vector2f origin = {300.f, 1200.f};
        ship.draw(window);
        ship.move(window);
        // This if statement moves the spaceship back to the origin if it is hit with an asteroid.
        if (ship.collides(asteroids)){
            ship.redraw(origin);
            ship.setPosition(origin);
            score = 0;
            asteroidSpawnSpeed = 1.0;
            asteroidMax = 10;
        }
        // This for loop keeps track of all the bullet objects on the screen and draws each of them.
        for (int i = 0; i < bullets.size(); i++){
            bullets[i].move();
            bullets[i].draw(window);
        }
        // This for loop keeps track of all the asteroid objects on the screen.
        int oldAsteroidsSize = asteroids.size();
        for (int i = 0; i < asteroids.size(); i++){
            if (asteroids[i].getPosition().y > 1280 && score != 0) {
            	score -= 1;
            }
            asteroids[i].move();
            // This for loop compares each bullet to each asteroid, checking to see if any collided
            for (int j = 0; j < bullets.size(); j++){
                if (singleBulletCollisionOccurred(bullets[j], asteroids[i])){
                    // If a bullet did collide with an asteroid, or if it goes off-screen, it deletes itself.
                    bullets.erase(remove_if(bullets.begin(), bullets.end(), [this] (Bullet& b){
                    return (b.canEraseBullet(window) || b.collides(asteroids));
                    }), bullets.end());
                    // If an asteroid was hit by a bullet, then it shrinks its radius by 20l
                    asteroids[i].shrink(20.f);
                    // If the asteroid has a radius smaller than 20, it cannot shrink, so it removes itself.
                    asteroids.erase(remove_if(asteroids.begin(), asteroids.end(), [this] (Asteroid& a){
                    return (!a.canShrink());
                    }), asteroids.end());
                }
            }
            asteroids[i].draw(window);
        }
        //Here we calculate if the score and high score increased
        int newAsteroidsSize = asteroids.size();
        score += oldAsteroidsSize - newAsteroidsSize;
        if (score > highScore) {
        	highScore = score;
        }
        //Now, we draw the score and high score to the screen
        string scoreString = "SCORE " + to_string(score);
        string highScoreString = "HIGH SCORE " + to_string(highScore);
        scoreText.setString(scoreString);
        highScoreText.setString(highScoreString);
        window.draw(scoreText);
        window.draw(highScoreText);
        if (asteroids.size() < asteroidMax) {
            // This piece of code used to be a function, but because we wanted to make passing time increase difficult, we moved the function into the loop so that the appropriate variables could be utilized.
            random_device rd;
            mt19937 gen(rd());
            // Generates a random number between 0 and 100.
            uniform_int_distribution<> randomRoll(0, 100);
            // If the number is smaller than the variable that increases with time (starts at 0.5 and increases by 0.1 each time)
            if (randomRoll(gen) < asteroidSpawnSpeed) {
                // Then it spawns an asteroid with a random x position (inside the visible screen), random radius (between 20 and 80), and is added to the vector of asteroids.
                uniform_int_distribution<> xPosition(0, 570);
                uniform_int_distribution<> randomRadius(20, 80);
                sf::Vector2f pos(xPosition(gen), 0);
                float radius = randomRadius(gen);
                asteroids.push_back(Asteroid(radius, pos));
            }
        }
        window.display();
    }
}

// This function detects a collision between a single bullet and a single asteroid.
bool World::singleBulletCollisionOccurred (Bullet& bullet, Asteroid& asteroid){
    auto xform = bullet.getCircle().getTransform();
    for(auto i = 0; i < bullet.getCircle().getPointCount(); i++){
        auto vec = xform*bullet.getCircle().getPoint(i) - asteroid.getCircle().getPosition();
        if(vec.x*vec.x + vec.y*vec.y < asteroid.getCircle().getRadius()*asteroid.getCircle().getRadius()){
            return true;
        }
    }
    return false;
}

// This function spawns a bullet with the same position as the ship and adds it to the bullets vector.
void World::spawnBullet (){
    sf::Vector2f pos = {(ship.getPosition().x+15), (ship.getPosition().y)};
    bullets.push_back(Bullet(pos));
}
