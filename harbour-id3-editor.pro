TARGET = harbour-id3-editor

MY_FILES = \
other/eyeD3.tar.gz

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

DISTFILES += \
    qml/pages/MainPage.qml \
    qml/js/api_key.js

