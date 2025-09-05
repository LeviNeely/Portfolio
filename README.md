# Portfolio
This portfolio contains all my coding projects to date!

Below, I have listed all of the directories found inside my portfolio and a short description of what can be found within. Please contact me with any inquiries at levijneely@gmail.com.

**IF YOU ARE HERE FROM THE DAVIS TECHNICAL COLLEGE SOFTWARE DEVELOPMENT PROGRAM, PLEASE LOOK IN THE PROJECT THAT HAS A 100X SPEED UP FOR A README FILE**

## #Influence

A video game developed in the Godot 4 engine using gdscript. Building on an idea around ethical social media consumption, this game implements persistent data, save/load functionality, multiple endings (dependent upon player input), and various shaders developed for screen and object modification. The game can be played [here](https://levineely.itch.io/influence).

## Asteroids

A video game developed using SFML in C++. Utilizes collision detection, randomized enemies, health tracking, and increasing difficulty levels. Navigate to the directory named "build", ensure that you have all the libraries needed, then use the make command to build the asteroids executable. Finally, run `./asteroids` to play the game.

## Bee Web Game

A simple JavaScript web game where randomly-generated bees follow the mouse cursor and the user avoids collision. Simply open the "NotTheBees.html" file and make sure that the corresponding .js file is in the same directory to play this simple game on your browser.

## Binary Search Tree

A Java implementation of a binary search tree with helper functions. There is a .zip file that contains all the source code. Compile and run this application to see a binary search tree implemented to make a simple spell-checker.

## Block Cipher

A short C++ program that takes in a message from the user, encrypts it using a BlockCipher with shuffle tables, and decrypts it again for proof of concept. Compile this by running make in the directory with the source files. Then run it using the `./blockcipher` command.

## Compute Shader Practice

This project dives into using compute shaders to speed up calculating 4D Open Simplex Noise. This stems from the Procedurally Generated Video Game. That uses Godot's built in computational pipeline to calculate the noise values. This is very expensive and causes the game to lag. Once I utilized GLSL to create a computational shader, I was able to speed up the calculation 100x. In order to run this, clone the repo and run the project using Godot.

## Currency Converter

A simple program that utilizes a Firestore database to convert currencies using an exchange rate. The program automatically updates the database using exchange rates retrieved from an API to keep the exchange rates current. To run, simply run `node ./main.js` in your terminal, ensuring that all the necessary files are in the same directory.

## Diabetes Calculator

A simple calculator coded in Java that takes in information about the user, information about the meal being consumed, then calculates the appropriate dose of insulin along with 
the best dosing strategy using the Warsaw method.

## Diy Vector

A basic C++ implementation of a templatized vector with methods similar to the builtin vector. Simply run make, then `./diyvector` to run the program.

## DNS Resolver

A simplified Java implementation of the DNS protocol that parses requests received from the dig command line tool, checks an implemented local cache for unexpired responses, forwards 
the request if not present in the cache, then provides a response to the request.

## Fractions

Basic Java implementation of fractions to add, subtract, multiply, divide, etc. fractions input by the user.

## Interactive Times Table

A JavaScript web-based interactive times table, showing what the product of two numbers are using color-changing and cursor-oriented user interaction. Simply open the .html file to run the code.

## Learning Management System

This project that aimed to be similar in functionality to Canvas can be found by visiting team3.dbproject.eng.utah.edu in your browser. This project utilizes mySQL, .NET/C#, and LINQ to manage the system as a whole. This project can register a new user as an  administrator, professor, or student. Each role has different functionality and can see/interact with different aspects of the program.

## Malloc Implementation

A self-implemented `malloc()` and `free()` replacement coded in C++. Tested and shown to be only ~30x slower than the builtin `malloc()` and `free()`. Run the `make` command to compile the executable `msdmalloc`, but feel free to also run `make test` to run tests on the program and `make benchmark` to run a benchmark test on the program.

## Mathematical Scripting App

This is an app developed with Qt and written in C++. It has the possibility to parse input text, interpret that text, or print it in a more visually pleasing way. Download the .zip file and run the program from there to utilize it's functionality.

## Neural Network using Pytorch

A pytorch neural network trained on fonts to detect letters. Simply open the .ipynb file and run using your preferred kernal.

## PacMan Path Finder

A graph-based pathfinding Java program that takes in a maze and finds the shortest path to the destination.

## Procedurally Developed Video Game

A video game developed in the Godot 4 engine written in GDScript. This game employs various techniques (including four-dimensional open simplex noise, A* pathfinding, and a chunk-loading management system) to procedurally generate content for the game. Peruse the code here or play the game [here](https://levineely.itch.io/proc-gen).

## Quick Sort and Merge Sort

QuickSort and MergeSort implementation in Java that compares and contrasts the two implementations.

## Simple Web Chat

A Java implementation of a web chat that allows for users to join a chat room, send and receive messages from others in the chat room, and leave the chat room. First run the RoomChatServer.jar file before opening the chat.html file to see the program in execution.

## Synthesizer

A Java-implemented synthesizer that allows the user to select frequencies and modify resulting tones produced by the synthesizer.

## Unix Shell

A Unix Shell crafted in C++ that contains the capability to run commands, utilize I/O redirection, and execute tab completion. Utilizes syscalls, pipes, and methodical error handling. Simply run the `make` command to create the executable, then run the `./shell` command to run the UnixShell.

