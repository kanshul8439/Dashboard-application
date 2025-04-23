// #include <QGuiApplication>
#include<QApplication>
#include <QQmlApplicationEngine>
#include "backend.h"
#include <QQmlContext>

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);



    Backend backend;
    // qmlRegisterType<Backend>("com.mycompany", 1, 0, "Backend");
    // backend
    QQmlApplicationEngine engine;

    engine.rootContext()->setContextProperty("backend",&backend);
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("Samriddhi-Dashboard", "Main");

    return app.exec();
}
