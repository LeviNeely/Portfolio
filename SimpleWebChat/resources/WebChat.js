"use strict";

// Callback functions
function handleUserNameEnterCB(){
    userName = userNameTA.value;
}

function handleRoomNameEnterCB(){
    roomName = roomNameTA.value;
    for (let i = 0; i<roomName.length; i++){
        if (roomName.charCodeAt(i) < 97 || roomName.charCodeAt(i) > 122){
            alert("Room name must only contain lowercase letters, please try again");
            roomNameTA.value = "<Enter a room name with only lowercase letters>";
            roomNameTA.select();
            return;
        }
    }
    if (isWSOpen){
        ws.send("join "+ userName + " " + roomName);
    }
    else {
        alert("The websocket is not open");
    }
}

function handleMessageEnterCB(e){
    if (e.keyCode == 13){
        message = messageTA.value;
        e.preventDefault();
        if (isWSOpen){
            ws.send(userName + " " + message);
        }
        else {
            alert("The websocket is not open");
        }
        messageTA.value = "";
    }
}

function handleConnectCB(){
    isWSOpen = true;
}

function handleCloseCB(){
    isWSOpen = false;
    alert("The server has disconnected, please close this window, goodbye");
}

function handleErrorCB(){
    alert("An error with the websocket has occurred, please try again");
}

function handleMessageCB(e){
    let messageObject = JSON.parse(e.data);
    if (messageObject.type == "join"){
        let linebreak = document.createElement('br');
        peopleInRoom.appendChild(linebreak);
        let peopleInRoomText = document.createTextNode(messageObject.user + " joined " + messageObject.room + "\n");
        peopleInRoom.appendChild(peopleInRoomText);
        let linebreak2 = document.createElement('br');
        peopleInRoom.appendChild(linebreak2);
    }
    else if (messageObject.type == "leave"){
        let linebreak = document.createElement('br');
        peopleInRoom.appendChild(linebreak);
        let peopleInRoomText2 = document.createTextNode(messageObject.user + " left " + messageObject.room + "\n");
        peopleInRoom.appendChild(peopleInRoomText2);
        let linebreak2 = document.createElement('br');
        peopleInRoom.appendChild(linebreak2);
    }
    else if (messageObject.type == "message"){
        let messagesText = document.createTextNode(messageObject.user + ": " + messageObject.message + "\n");
        messages.appendChild(messagesText);
        let linebreak = document.createElement('br');
        messages.appendChild(linebreak);
        let linebreak2 = document.createElement('br');
        messages.appendChild(linebreak2);
    }
}


// The main workings of the chat room
let isWSOpen = false;
let userName = "";
let roomName = "";
let message = "";

let ws = new WebSocket("ws://localhost:8080/");

let userNameTA = document.getElementById("userNameTA");
let roomNameTA = document.getElementById("roomNameTA");
let messageTA = document.getElementById("messageTA");
let peopleInRoom = document.getElementById("peopleInRoom");
let messages = document.getElementById("messages");

// Creating all the event listeners and handling them
userNameTA.addEventListener("change", handleUserNameEnterCB);
roomNameTA.addEventListener("change", handleRoomNameEnterCB);
messageTA.addEventListener("keypress", handleMessageEnterCB);
ws.onopen = handleConnectCB;
ws.onclose = handleCloseCB;
ws.onerror = handleErrorCB;
ws.onmessage = handleMessageCB;

