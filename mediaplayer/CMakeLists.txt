cmake_minimum_required(VERSION 3.16)

project(mediaplayer LANGUAGES CXX)

set(CMAKE_AUTOMOC ON)

if(NOT DEFINED INSTALL_EXAMPLESDIR)
    set(INSTALL_EXAMPLESDIR "examples")
endif()

set(INSTALL_EXAMPLEDIR "${INSTALL_EXAMPLESDIR}/multimedia/video/mediaplayer")

find_package(Qt6 REQUIRED COMPONENTS Core Quick QuickControls2 Svg)


set(resource_files
    "main.qml"
)


qt_add_executable(mediaplayer
    main.cpp
    helper.cpp
    helper.h
    vdf_parser.hpp
)



qt_add_resources(mediaplayer "mediaplayer"
    PREFIX
        "/"
    FILES
        ${resource_files}
)


target_link_libraries(mediaplayer PRIVATE
    Qt6::Core
    Qt6::Svg
    Qt6::Quick
)

install(TARGETS mediaplayer
    RUNTIME DESTINATION "${INSTALL_EXAMPLEDIR}"
    BUNDLE DESTINATION "${INSTALL_EXAMPLEDIR}"
    LIBRARY DESTINATION "${INSTALL_EXAMPLEDIR}"
)
