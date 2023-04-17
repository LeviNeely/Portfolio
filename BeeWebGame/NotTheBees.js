// Levi Neely
// Not The Bees HW 6
// 10/26/22

"use strict";

// Getting the canvas object
let canvases = document.getElementsByTagName("canvas");
let canvas = canvases[0];

// Getting the context of the canvas
let ctx = canvas.getContext('2d');

// Getting other variables needed for drawing
let canvasWidth = canvas.width;
let canvasHeight = canvas.height;

// Creating the Pot object
let myPot = {};
myPot.img = new Image();
myPot.img.src = "beeLady.jpg";
myPot.xPos = 0;
myPot.yPos = 0;

function main() {
    // Calling the listener function
    document.addEventListener("mousemove", handleMouseMoveForPot);
    let myInterval = setInterval(spawnBees, 2000);
}

window.onload = main;

let beeArray = [];

// Clear the screen
function erase(){
    ctx.fillStyle = "#FFFFFF";
    ctx.fillRect(0, 0, canvasWidth, canvasHeight);
}

// Handle mouse movement
function handleMouseMoveForPot(e){
    erase();
    myPot.xPos = e.x;
    myPot.yPos = e.y;
    ctx.drawImage(myPot.img, myPot.xPos, myPot.yPos, 45, 54);
    ctx.lineWidth = 5;
    ctx.strokeRect(myPot.xPos, myPot.yPos, 45, 54);
    animate(myPot.xPos, myPot.yPos);
}

// Animate the bees
function animate(x, y){
    for (let i = 0; i < beeArray.length; i++){
        ctx.drawImage(beeArray[i].img, beeArray[i].xPos, beeArray[i].yPos, 92, 69);
        ctx.lineWidth = 5;
        ctx.strokeRect(beeArray[i].xPos, beeArray[i].yPos, 92, 69);
        if (x - beeArray[i].xPos < 0){
            beeArray[i].xPos -= 2;
        }
        else if (x - beeArray[i].xPos > 0){
            beeArray[i].xPos += 2;
        }
        if (y - beeArray[i].yPos < 0){
            beeArray[i].yPos -= 2;
        }
        else if (y - beeArray[i].yPos > 0){
            beeArray[i].yPos += 2;
        }
        endGame(beeArray[i].xPos, beeArray[i].yPos, myPot.xPos, myPot.yPos);
    }
}

// Spawning the bees
function spawnBees(){
    erase()
    let myBee = {};
    myBee.xPos = randomNumberGenerator(0, canvasWidth);
    myBee.yPos = randomNumberGenerator(0, canvasHeight);
    myBee.img = new Image();
    myBee.img.src = "bee.jpg";
    beeArray.push(myBee);
}

// Random number generator
function randomNumberGenerator(min, max){
    return Math.floor(Math.random()*(max-min+1)+min);
}

// Handling the end game
function endGame(x, y, x2, y2){
    if (Math.abs(x-x2) < 3 && Math.abs(y-y2) < 3){
        document.removeEventListener("mousemove", handleMouseMoveForPot);
    }
}