#ifdef QT_QML_DEBUG
#include <QtQuick>
#endif

#include <sailfishapp.h>
#include <sys/types.h>
#include <unistd.h>
#include <QDebug>
#include <QObject>
#include <QString>
#include <QQuickView>
#include <QQmlContext>
#include <QGuiApplication>
#include <QFileSystemWatcher>
#include "eyed3.h"
#include "misc.h"
#include "ogg.h"

int main(int argc, char *argv[]) {
    qDebug() << setuid(0);
    EyeD3 eyed3;
    Misc misc;
    Ogg ogg;
    QGuiApplication *app = SailfishApp::application(argc,argv);
    QQuickView *view = SailfishApp::createView();
    QString qml = QString("qml/harbour-id3-editor.qml");
    view->rootContext()->setContextProperty("eyed3",&eyed3);
    view->rootContext()->setContextProperty("fce",&misc);
    view->rootContext()->setContextProperty("ogg",&ogg);
    view->setSource(SailfishApp::pathTo(qml));
    view->show();
    return app->exec();
    return SailfishApp::main(argc, argv);
}

std::string exec(const char* cmd) {
    FILE* pipe = popen(cmd, "r");
    if (!pipe) return "ERROR";
    char buffer[128];
    std::string result = "";
    while(!feof(pipe)) {
        if(fgets(buffer, 128, pipe) != NULL)
            result += buffer;
    }
    pclose(pipe);
    return result;
}

