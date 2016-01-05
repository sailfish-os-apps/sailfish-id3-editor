#ifndef OGG
#define OGG

#include <QObject>
#include <QDebug>
#include <sys/types.h>
#include <unistd.h>
#include "exec.h"
#include <QFileInfo>

class Ogg : public QObject {
    Q_OBJECT
public:
    Q_INVOKABLE QString songInfo(const QString path) const {
        std::string c_path = path.toStdString();
        std::string command = "/usr/share/harbour-id3-editor/bin \""+c_path+"\"";
        return QString::fromStdString(exec(command.c_str()));
    }
};

#endif // OGG

