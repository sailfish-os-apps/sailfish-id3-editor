#ifndef MISC
#define MISC

#include <QObject>
#include <QDebug>
#include <sys/types.h>
#include <unistd.h>
#include "exec.h"
#include <QFileInfo>

class Misc : public QObject {
    Q_OBJECT
public:
    Q_INVOKABLE QString songs() const {
        setuid(0);
        QString list;
        list += QString::fromStdString(exec("find /home/nemo -name '*.mp3'"));
        list += QString::fromStdString(exec("find /media/sdcard -name '*.mp3'"));
        list += QString::fromStdString(exec("find /home/nemo -name '*.ogg'"));
        list += QString::fromStdString(exec("find /media/sdcard -name '*.ogg'"));
        return list;
    }
};

#endif // MISC

