TARGET = harbour-id3-editor

MY_FILES = \
other/eyeD3.tar.gz \
other/bin

OTHER_SOURCES += $$MY_FILES

my_resources.path = $$PREFIX/share/$$TARGET
my_resources.files = $$MY_FILES

INSTALLS += my_resources


CONFIG += sailfishapp

SOURCES += src/harbour-id3-editor.cpp

OTHER_FILES += qml/harbour-id3-editor.qml \
    qml/cover/CoverPage.qml \
    rpm/harbour-id3-editor.changes.in \
    rpm/harbour-id3-editor.spec \
    rpm/harbour-id3-editor.yaml \
    translations/*.ts \
    harbour-id3-editor.desktop \
    qml/js/*.js

SAILFISHAPP_ICONS = 86x86 108x108 128x128 256x256

CONFIG += sailfishapp_i18n

TRANSLATIONS += translations/harbour-id3-editor-cs_CZ.ts
TRANSLATIONS += translations/harbour-id3-editor-sv.ts
TRANSLATIONS += translations/harbour-id3-editor-es.ts
TRANSLATIONS += translations/harbour-id3-editor-de.ts
TRANSLATIONS += translations/harbour-id3-editor-ru.ts

DISTFILES += \
    qml/pages/MainPage.qml \
    qml/js/api_key.js \
    qml/js/DB.js \
    qml/js/functions.js \
    qml/js/eyeD3.js \
    qml/js/php.js \
    qml/pages/components/Button.qml \
    qml/pages/SongDetail.qml \
    qml/pages/BanPath.qml \
    qml/js/workerscript.js

HEADERS += \
    exec.h \
    eyed3.h \
    misc.h \
    ogg.h

