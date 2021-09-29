cmake_minimum_required(VERSION 3.16)
project(BUILDABOT_PROJECT_NAME)

message(FATAL_ERROR "Please run buildabot.sh")

set(CMAKE_CXX_STANDARD 17)

#BUILDABOT_SUBDIR

list(JOIN ALL_DISCORDPP_PLUGINS , ALL_DISCORDPP_PLUGINS_JOINED)
add_compile_definitions(ALL_DISCORDPP_PLUGINS=${ALL_DISCORDPP_PLUGINS_JOINED})

set(SOURCE_FILES main.cc extern.cc)
add_executable(${PROJECT_NAME} ${SOURCE_FILES})
target_precompile_headers(${PROJECT_NAME} PUBLIC ${PROJECT_SOURCE_DIR}/include.hh)

set(THREADS_PREFER_PTHREAD_FLAG ON)

find_package(Boost 1.71.0 REQUIRED system date_time)
find_package(Threads REQUIRED)
find_package(OpenSSL REQUIRED)

if (WIN32)
    add_definitions(-D_WIN32_WINNT=0x0601) # Windows 7
endif ()

if (MSVC)
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /bigobj /wd4250 /wd4244")
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} /bigobj")
    add_definitions(-D_CRT_SECURE_NO_WARNINGS)
endif ()

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -pedantic")
#set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -g -fsanitize=address -fno-omit-frame-pointer")

TARGET_LINK_LIBRARIES(
        ${PROJECT_NAME}
        ${Boost_LIBRARIES}
        Threads::Threads
        ${OPENSSL_LIBRARIES}
        ${ALL_DISCORDPP_LIBRARIES}
)

if (EXISTS ${CMAKE_SOURCE_DIR}/token.dat)
    configure_file(token.dat ${CMAKE_CURRENT_BINARY_DIR} COPYONLY)
elseif (EXISTS ${CMAKE_CURRENT_BINARY_DIR}/token.dat)
    file(REMOVE ${CMAKE_CURRENT_BINARY_DIR}/token.dat)
endif ()
