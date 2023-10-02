/***
 * @author mozcelikors
 **/

#include "helper.h"
#include <QDebug>
#include <QFile>
#include <QJsonDocument>
#include <QJsonObject>
#include "vdf_parser.hpp"
#include <iostream>
#include <string>
#include <unordered_map>

using namespace std;
using namespace tyti::vdf;

Helper::Helper(QObject *parent)
    : QObject{parent}
{

}

void Helper::removeFile(QString gameId, QString filePath)
{
    QString ssListPath = qgetenv("BETTERGALLERYDIR")+"/out/bettergallery_gamedata/"+gameId+".txt";

    qDebug() << "Removing: " << filePath;
    QFile file (filePath);
    file.remove();

    qDebug() << "Removing entry from file list data";
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
    /*
    // Following is some groundwork for the future.
    // We are able to delete entry from screenshots.vdf file but that does not seem to work syncing SteamOS Media section
    // We need to find someway to reflect this deletion to also Steam OS Media section in the future.
    std::ifstream file3("/home/deck/.local/share/Steam/userdata/"+qgetenv("STEAMUSERID")+"/760/screenshots.vdf");
    auto root = tyti::vdf::read(file3);
    file3.close();

    assert(root.name == "screenshots");
    const char * gameId_Text = gameId.toStdString().c_str();
    std::shared_ptr<tyti::vdf::object> child = root.childs[gameId_Text];
    const std::shared_ptr<tyti::vdf::object> child2 = child->childs["0"];
    //child->childs.erase("0");

    if (child != nullptr)
    {
        auto m = child->childs;
        for (auto i = m.begin(); i != m.end(); i++)
        {
            if (i != nullptr)
            {
                auto filename = i->second->attribs["filename"];

                //Debug
                cout << i->first << "   " << i->second << endl;
                //cout << "Filename : " << filename << endl;
                //qDebug() << "Filepath : " << filePath;

                if (filePath.contains(QString::fromStdString(filename)))
                {
                    qDebug() << "Match. Deleting screenshot " << QString::fromStdString(filename) << " from game #" <<  gameId;
                    child->childs.erase(i->first);
                }
            }
        }
    }

    // Write to file modified version
    std::ofstream ofs("/home/deck/.local/share/Steam/userdata/"+qgetenv("STEAMUSERID")+"/760/screenshots.vdf", std::ofstream::out);
    tyti::vdf::write(ofs, root);
    ofs.close();*/
}
