cmake_minimum_required(VERSION 2.8)
set(PROJECT_NAME bgfxtest)
project(${PROJECT_NAME})

set(CMAKE_BUILD_TYPE "RELEASE")

set(CMAKE_CXX_FLAGS "-Wall -std=c++11")

if(DEBUG)
	set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -g")
	set(LEAK true)
endif()
if(LEAK)
	set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fsanitize=address")
endif()

set(CMAKE_CXX_COMPILER /usr/bin/clang++)

set(LIB_DIR "${PROJECT_SOURCE_DIR}/lib")

# BGFX
set(BGFX_SRC_DIR "${LIB_DIR}/bgfx")
set(BGFX_SOURCES
	lib/bgfx/src/amalgamated.cpp
	)

include_directories(lib/bx/include)
include_directories(lib/bgfx/include)
include_directories(lib/bgfx/examples/common)
include_directories(lib/bgfx/3rdparty/khronos)
include_directories(lib/bgfx/3rdparty)

# BGFX example-common
file (GLOB_RECURSE BGFX_EXAMPLE_COMMON_SOURCES
	"${BGFX_SRC_DIR}/3rdparty/ib-compress/**.cpp"
	"${BGFX_SRC_DIR}/3rdparty/ib-compress/**.h"
	"${BGFX_SRC_DIR}/3rdparty/ocornut-imgui/**.cpp"
	"${BGFX_SRC_DIR}/3rdparty/ocornut-imgui/**.h"
	"${BGFX_SRC_DIR}/examples/common/**.cpp"
	"${BGFX_SRC_DIR}/examples/common/**.h"
	)

# Bullet3
set(BULLET3_SRC_DIR "${LIB_DIR}/bullet3/src/")
file (GLOB_RECURSE BULLET3_SOURCES
	"${BULLET3_SRC_DIR}/BulletCollision/*.cpp"
	"${BULLET3_SRC_DIR}/BulletDynamics/*.cpp"
	"${BULLET3_SRC_DIR}/BulletMultiThreaded/*.cpp"
	"${BULLET3_SRC_DIR}/LinearMath/*.cpp"
	)
include_directories(${BULLET3_SRC_DIR})

set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_SOURCE_DIR}/cmake")

#find_package(OpenGL REQUIRED)
#find_package(GLX REQUIRED)
find_package(X11 REQUIRED)
#find_package(SDL2 REQUIRED)
#find_package(GLFW REQUIRED)

list(APPEND main_src
	src/main.cpp
	)

add_library(bgfx STATIC
	${BGFX_SOURCES}
	)

add_library(bgfx-common STATIC
	${BGFX_EXAMPLE_COMMON_SOURCES}
	)

set(MAIN_BINARY ${PROJECT_NAME})

add_executable(${MAIN_BINARY} ${main_src})
set_target_properties(${MAIN_BINARY}
	PROPERTIES
	RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/bin"
	LIBRARY_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/lib"
	ARCHIVE_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/lib"
	)

include_directories(
	#${OpenGL_INCLUDE_DIR}
	#${GLX_INCLUDE_DIR}
	${X11_INCLUDE_DIR}
	#${SDL2_INCLUDE_DIR}
	)

target_link_libraries(${MAIN_BINARY} LINK_PUBLIC
	#${OpenGL_LIBRARIES}
	${X11_LIBRARIES}
	GLX
	bgfx bgfx-common
	dl pthread)
