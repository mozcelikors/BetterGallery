/**
* @author mozcelikors
**/

#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QCommandLineParser>
#include <QDir>
#include <QQmlContext>

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QCoreApplication::setApplicationName("MediaPlayer Example");
    QCoreApplication::setOrganizationName("QtProject");
    QCoreApplication::setApplicationVersion(QT_VERSION_STR);
    QCommandLineParser parser;
    parser.setApplicationDescription("Qt Quick MediaPlayer Example");
    parser.addHelpOption();
    parser.addVersionOption();
    parser.addPositionalArgument("url", "The URL(s) to open.");
    parser.process(app);

    QQmlApplicationEngine engine;
    const QUrl url(QStringLiteral("qrc:/main.qml"));

    if (!parser.positionalArguments().isEmpty()) {
        QUrl source = QUrl::fromUserInput(parser.positionalArguments().at(0), QDir::currentPath());
        QObject::connect(&engine, &QQmlApplicationEngine::objectCreated, [source](QObject *object, const QUrl &){
            qDebug() << "setting source";
            object->setProperty("source", source);
        });
    }
    engine.rootContext()->setContextProperty("applicationDirPath", QGuiApplication::applicationDirPath());
    engine.rootContext()->setContextProperty("STEAMUSERID", qgetenv("STEAMUSERID"));
    engine.rootContext()->setContextProperty("BETTERGALLERYDIR", qgetenv("BETTERGALLERYDIR"));
    qputenv("QML_XHR_ALLOW_FILE_READ", QByteArray("1"));
    qputenv("QML_XHR_ALLOW_FILE_WRITE", QByteArray("1"));
    engine.load(url);

    return app.exec();
}
