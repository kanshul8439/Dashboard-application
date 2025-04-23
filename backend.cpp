#include "backend.h"
#include<QDebug>
#include<QBuffer>

Backend::Backend(QObject *parent):QObject(parent)
{
    socket=new QTcpSocket(this);
    m_connected=false;
    timer=new QTimer(this);
    connect(socket, &QTcpSocket::connected, this, &Backend::onConnected);
    connect(socket, &QTcpSocket::disconnected, this, &Backend::onDisconnected);
    connect(socket, &QTcpSocket::errorOccurred, this, &Backend::onError);
    connect(socket, &QTcpSocket::readyRead, this, &Backend::onDataRecieved);

    // // Correct connection for the timer
    connect(timer, &QTimer::timeout, this, &Backend::checkConnection);


    timer->start(5000);

}

void Backend::connecttoserver()
{
    if(!m_connected)
    {
        qDebug()<<"Trying to connect to server";
        socket->connectToHost("127.0.0.1",1234);
    }
}

void Backend::disconnectfromserver()
{
    if(m_connected)
    {
        qDebug()<<"Disconnect from server";
        socket->disconnectFromHost();
    }
}

void Backend::onConnected()
{
    m_connected=true;
    qDebug()<<"Connected to the server and request a file";
    emit connectionStateChange();
    socket->write("GET_FILE");
}

void Backend::onDisconnected()
{
    m_connected=false;
    qDebug()<<"Disconnected from the server";
    emit connectionStateChange();

}

void Backend::onDataRecieved()
{
    QByteArray data=socket->readAll();
    QJsonDocument doc=QJsonDocument::fromJson(data);
    QJsonObject obj=doc.object();
    qDebug()<<obj;
    // QString filecontent=QString::fromUtf8(data).trimmed();
    // qDebug()<<filecontent;
    // if(filecontent.startsWith("ERROR")){
    //     qDebug()<<"FIle error found ";
    //     return ;
    // }
    emit updateParameter(obj);
}

void Backend::onError(QAbstractSocket::SocketError e)
{
    m_connected=false;
    qDebug()<<"socket error "<<e;
    emit connectionStateChange();
}

void Backend::checkConnection()
{
    if(socket->state()==QAbstractSocket::ConnectedState)
    {
        qInfo()<<"timer function called every 5000 milliseconds";
        onConnected();
        onDataRecieved();
    }
}

bool Backend::isConnected() const{
    return m_connected;
}


