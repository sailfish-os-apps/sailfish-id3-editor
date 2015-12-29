#ifndef EYED3
#define EYED3

#include <QObject>
#include <QDebug>
#include <sys/types.h>
#include <unistd.h>
#include "exec.h"
#include <QFileInfo>

class EyeD3 : public QObject {
    Q_OBJECT
public:
    Q_INVOKABLE bool untar() const {
        setuid(0);
        system("tar xzvf /usr/share/harbour-id3-editor/eyeD3.tar.gz -C /usr/share/harbour-id3-editor");
        return true;
    }

    Q_INVOKABLE bool install() const {
        setuid(0);
        system("cd /usr/share/harbour-id3-editor/eyeD3-0.7.9 && python setup.py install");
        return true;
    }

    Q_INVOKABLE bool check() const {
        setuid(0);
        QFileInfo file("/usr/bin/eyeD3");
        return file.exists();
    }

    Q_INVOKABLE QString whoami() const {
        return QString::fromStdString(exec("whoami"));
    }

    Q_INVOKABLE bool deleteCompileDir() const {
        setuid(0);
        system("rm -rf /usr/share/harbour-id3-editor/eyeD3-0.7.9");
        return true;
    }
};

#endif // EYED3

