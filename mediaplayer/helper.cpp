/***
 * @author mozcelikors
 **/

#include "helper.h"
#include <QDebug>
#include <QFile>

Helper::Helper(QObject *parent)
    : QObject{parent}
{

}

void Helper::removeFile(QString gameId, QString filePath)
{
    qDebug() << "Removing: " << filePath;
    QFile file (filePath);
    file.remove();

    qDebug() << "Removing entry from file list data";
    QString ssListPath = qgetenv("BETTERGALLERYDIR")+"/out/bettergallery_gamedata/"+gameId+".txt";
    qDebug() << ssListPath;
    QFile file2(ssListPath);
    if(file2.open(QIODevice::ReadWrite | QIODevice::Text))
    {
        QString s;
        QTextStream t(&file2);
        while(!t.atEnd())
        {
            QString line = t.readLine();
            if(!line.contains(filePath))
                s.append(line + "\n");
        }
        file2.resize(0);
        t << s;
        file2.close();
    }
}
