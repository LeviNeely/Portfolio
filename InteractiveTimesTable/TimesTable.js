// Creating the table header and title
let myTable = document.createElement("table");
let myTableHeader = document.createElement("h1");
let myTableHeaderText = document.createTextNode("Interactive Multiplication Table");
myTableHeader.appendChild(myTableHeaderText);
myTable.style.textAlign = "center";
myTable.style.width = "100%";
myTable.style.height = "600px";
document.body.appendChild(myTableHeader);
myTable.style.border = "1px solid black";

// Creating the table body
let myTableBody = document.createElement("tbody");
for (let i = 1; i < 11; i++){
    let myTableRow = document.createElement("tr");
    myTableBody.appendChild(myTableRow);
    for (let j = 1; j < 11; j++){
        let myTableCell = document.createElement("td");
        myTableCell.classList.add("plain-cell");
        myTableCell.innerText = (i*j).toString();
        myTableCell.style.border = "1px solid black";
        myTableCell.style.backgroundColor = "white";
        myTableCell.style.color = "black";
        myTableRow.appendChild(myTableCell);
    }
}
myTable.appendChild(myTableBody);
document.body.appendChild(myTable);

// Creating the event listeners and functions
let allTableCells = document.getElementsByClassName("plain-cell");
let allHighlighted = [];
for (i of allTableCells){
    i.addEventListener("mouseover", function(){
        this.style.backgroundColor = "black";
        this.style.color = "white";
    });
}
for (i of allTableCells){
    i.addEventListener("click", function(){
        if (allHighlighted[0] != this){
            allHighlighted[0].style.backgroundColor = "white";
            allHighlighted[0].style.color = "black";
        }
    });
}
for (i of allTableCells){
    i.addEventListener("click", function(){
        this.style.backgroundColor = "green";
        this.style.color = "white";
        allHighlighted[0] = this;
    });
}
for (i of allTableCells){
    i.addEventListener("mouseleave", function(){
        if (allHighlighted[0] != this){
            this.style.backgroundColor = "white";
            this.style.color = "black";
        }
    });
}

// Making my page annoying
let myInterval = setInterval(setBackgroundColor, 2000);
function setBackgroundColor(){
    let x = document.body;
    x.style.backgroundColor = x.style.backgroundColor == "yellow" ? "purple" : "yellow";
}

