#include "mainwidget.h"
#include <QLabel>
#include <QLineEdit>
#include <QSpinBox>
#include <QRadioButton>
#include <QPushButton>
#include <QTextEdit>
#include <QVBoxLayout>
#include <QGridLayout>
#include <QGroupBox>
#include <QSpacerItem>
#include <string>
#include <QString>
#include "pointer.h"
#include "Expr.h"
#include "Env.h"
#include "Value.h"
#include "Parse.h"
#include <QErrorMessage>

using namespace std;

mainWidget::mainWidget(QWidget *parent)
    : QWidget{parent}
{
    this->vertical1 = new QVBoxLayout();
    this->horizontal1 = new QHBoxLayout();
    this->expression = new QLabel("Expression:    ");
    this->vertical2 = new QVBoxLayout();
    this->input = new QTextEdit();
    this->groupBox = new QGroupBox();
    this->grid = new QGridLayout();
    this->interpButton = new QRadioButton();
    this->prettyPrintButton = new QRadioButton();
    this->interp = new QLabel("Interp");
    this->prettyPrint = new QLabel("Pretty Print");
    this->submit = new QPushButton("Submit");
    this->horizontal2 = new QHBoxLayout();
    this->result = new QLabel("Result:            ");
    this->vertical3 = new QVBoxLayout();
    this->output = new QTextEdit();
    this->reset = new QPushButton("Reset");

    this->vertical3->addWidget(this->output);
    this->vertical3->addWidget(this->reset);
    this->horizontal2->addWidget(this->result);
    this->horizontal2->addItem(this->vertical3);
    this->grid->addWidget(this->interpButton, 0, 0);
    this->grid->addWidget(this->interp, 0, 1);
    this->grid->addWidget(this->prettyPrintButton, 1, 0);
    this->grid->addWidget(this->prettyPrint, 1, 1);
    this->grid->addItem(new QSpacerItem(500, 10), 0, 2);
    this->grid->addItem(new QSpacerItem(500, 10), 1, 2);
    this->groupBox->setLayout(this->grid);
    this->vertical2->addWidget(this->input);
    this->vertical2->addWidget(this->groupBox);
    this->vertical2->addWidget(this->submit);
    this->horizontal1->addWidget(this->expression);
    this->horizontal1->addItem(this->vertical2);
    this->vertical1->addItem(this->horizontal1);
    this->vertical1->addItem(this->horizontal2);

    connect(submit, &QPushButton::clicked, this, &mainWidget::submitPush);
    connect(reset, &QPushButton::clicked, this, &mainWidget::resetPush);
}

void mainWidget::submitPush() {
    try {
        QString inputString = this->input->toPlainText();
        string input = inputString.toUtf8().constData();
        string output = "";
        QString outputString = "";
        if (this->interpButton->isChecked()) {
            PTR(Expr) e = parse_string(input);
            output = e->interp(Env::empty)->to_string();
            outputString = QString::fromStdString(output);
            this->output->setText(outputString);
        }
        else if (this->prettyPrintButton->isChecked()) {
            PTR(Expr) e = parse_string(input);
            output = e->pretty_print_to_string();
            outputString = QString::fromStdString(output);
            this->output->setText(outputString);
        }
    }
    catch (...) {
        QErrorMessage *error = new QErrorMessage();
        error->showMessage("Error, input valid text");
    }
}

void mainWidget::resetPush() {
    try {
        this->input->setText("");
        this->output->setText("");
        if (this->interpButton->isChecked()) {
            this->interpButton->setAutoExclusive(false);
            this->interpButton->setChecked(false);
            this->interpButton->setAutoExclusive(true);
        }
        else if (this->prettyPrintButton->isChecked()) {
            this->prettyPrintButton->setAutoExclusive(false);
            this->prettyPrintButton->setChecked(false);
            this->prettyPrintButton->setAutoExclusive(true);
        }
    }
    catch (...) {
        QErrorMessage *error = new QErrorMessage();
        error->showMessage("Error");
    }
}
