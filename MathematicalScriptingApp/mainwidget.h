#ifndef MAINWIDGET_H
#define MAINWIDGET_H

#include <QWidget>
#include <QLabel>
#include <QLineEdit>
#include <QSpinBox>
#include <QRadioButton>
#include <QPushButton>
#include <QTextEdit>
#include <QVBoxLayout>
#include <QGridLayout>
#include <QHBoxLayout>
#include <QGroupBox>

class mainWidget : public QWidget
{
    Q_OBJECT
public:
    explicit mainWidget(QWidget *parent = nullptr);
    QVBoxLayout *vertical1;
    QHBoxLayout *horizontal1;
    QLabel *expression;
    QVBoxLayout *vertical2;
    QTextEdit *input;
    QGroupBox *groupBox;
    QGridLayout *grid;
    QRadioButton *interpButton;
    QRadioButton *prettyPrintButton;
    QLabel *interp;
    QLabel *prettyPrint;
    QPushButton *submit;
    QHBoxLayout *horizontal2;
    QLabel *result;
    QVBoxLayout *vertical3;
    QTextEdit *output;
    QPushButton *reset;
signals:
public slots:
    void submitPush();
    void resetPush();
};

#endif // MAINWIDGET_H
