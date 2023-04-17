//
//  main.cpp
//  Asteroids
//
//  Created by Levi Neely on 9/20/22.
//
//
//  Team Project by Levi Neely and Jason White
//

#include <iostream>
#include <SFML/Window.hpp>
#include <SFML/Graphics.hpp>
#include "Asteroids.hpp"
#include "Triangle.hpp"
#include "Bullet.hpp"
#include "World.hpp"
#include <random>
#include <vector>

using namespace std;

int main(int argc, const char * argv[]) {
    
    // Construct the world object:
    World world;
    
    // Run the loop member function:
    world.loop();
    
    return 0;
}
