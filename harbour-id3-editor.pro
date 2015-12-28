TARGET = harbour-id3-editor

CONFIG += sailfishapp

SOURCES += src/harbour-id3-editor.cpp

OTHER_FILES += qml/harbour-id3-editor.qml \
    qml/cover/CoverPage.qml \
    qml/pages/FirstPage.qml \
    qml/pages/SecondPage.qml \
    rpm/harbour-id3-editor.changes.in \
    rpm/harbour-id3-editor.spec \
    rpm/harbour-id3-editor.yaml \
    translations/*.ts \
    harbour-id3-editor.desktop

SAILFISHAPP_ICONS = 86x86 108x108 128x128 256x256

CONFIG += sailfishapp_i18n

TRANSLATIONS += translations/harbour-id3-editor-cs_CZ.ts

