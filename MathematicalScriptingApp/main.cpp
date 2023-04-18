#include<QApplication>
#include "mainwidget.h"

int main(int argc, char **argv) {
    QApplication app(argc, argv);
    mainWidget *mw = new mainWidget();
    mw->setLayout(mw->vertical1);
    mw->show();
    return app.exec();
}
