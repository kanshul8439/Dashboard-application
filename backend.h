#ifndef BACKEND_H
#define BACKEND_H

#include <QObject>
#include<QTcpSocket>
#include<QTimer>
#include<QJsonDocument>
#include<QJsonObject>
class Backend : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool value READ isConnected  NOTIFY connectionStateChange)
public:

    explicit Backend(QObject * parent=nullptr);
    Q_INVOKABLE void connecttoserver();
    Q_INVOKABLE void disconnectfromserver();

    // bool connected() const;
    // void setConnected(bool newConnected);

    bool isConnected()const;

signals:
    void updateParameter(QJsonObject data);
    void connectionStateChange();
private slots:
    void onConnected();
    void onDisconnected();
    void onDataRecieved();
    void onError(QAbstractSocket::SocketError e);
    void checkConnection();
private:
    QTcpSocket *socket;
    bool m_connected;
    QTimer *timer;
};

#endif // BACKEND_H
