---
title: "CMake stuff"
date: 2021-02-28T20:30:03+00:00
author: "Me"
tags: ["cpp"]
showToc: true
TocOpen: false
draft: false
hidemeta: false
comments: true
description: "You should use CMake people said. It's great people said"
disableHLJS: false # to disable highlightjs
disableShare: true
searchHidden: true
cover:
    image: "<image path/url>" # image path/url
    alt: "<alt text>" # alt text
    caption: "<text>" # display caption under cover
    relative: false # when using page bundles set this to true
    hidden: true # only hide on current single page

---
I just copy random things into CMakeLists.txt to make it work.
I will write it up here so next time i won't have to struggle with it again.
I am very nooby in the C++ world and i don't really understand CMake so
please don't judge me. The main reason I use it because i need
to generate compile-commands.json for clangd, so I can have working
autocomplettion in neovim using coc.nvim and coc-clangd.

CMake's configuration file you need to make in your project is
`CMakeLists.txt`

## Compilation

0. `mkdir build && cd build`
1. `cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=1 ..`
2. `make`

Now make link to the compile-commands.json

1. `cd ..`
2. `ln -s build/compile_commands.json ./`

## Library examples

### OpenCV4

CMakeLists.txt

```cmake
cmake_minimum_required(VERSION 3.19)

project(example)

find_package(OpenCV REQUIRED
    COMPONENTS
        core
        imgproc
        highgui # For cv::imwrite
)

add_executable(${PROJECT_NAME} main.cpp)
target_include_directories(${PROJECT_NAME} PRIVATE ${OpenCV_INCLUDE_DIRS})
target_link_libraries(${PROJECT_NAME} ${OpenCV_LIBS})
```

main.cpp - Should draw a circle and show it

```cpp
#include "opencv2/opencv.hpp"

using namespace cv;

int main() {
        Mat img(500,500, CV_8UC3, Scalar(0,0,0));
        circle(img, Point2d(250, 250), 100, Scalar(0, 0, 255));
        imshow("Circle", img);
        waitKey( 0 );

    return 0;
}
```

### SDL2

If not using git

1. `git clone https://gitlab.com/aminosbh/sdl2-cmake-modules.git cmake/sdl2`
2. `rm -rf cmake/sdl2/.git`

If using git

1. `git submodule add https://gitlab.com/aminosbh/sdl2-cmake-modules.git cmake/sdl2`
2. `git commit -m "Add SDL2 CMake modules"`

CMakeLists.txt

```cmake
cmake_minimum_required(VERSION 3.13)  # CMake version check
project(simple_example)               # Create project "simple_example"
set(CMAKE_CXX_STANDARD 14)            # Enable c++14 standard

# Add main.cpp file of project root directory as source file
set(SOURCE_FILES main.cpp)

list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake/sdl2)

find_package(SDL2 REQUIRED)

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -O1 -march=native")
add_executable(${PROJECT_NAME} ${sources})

target_link_libraries(${PROJECT_NAME} SDL2::Main)
```

main.cpp - Makes a resizable, closable window, thats just one color

```cpp
#include <SDL2/SDL.h>
#include <SDL2/SDL_render.h>
#include <SDL2/SDL_stdinc.h>
#include <SDL2/SDL_events.h>
#include <iostream>


int main(int argc, char *argv[]) {
    int windowHeight = 600;
    int windowWidth = 800;
    if (SDL_Init(SDL_INIT_VIDEO) < 0) {
        return 1;
        cout << "Initialization failed" << endl;
    }

    SDL_Window *window = SDL_CreateWindow("Awesome satisfying drawing",
            SDL_WINDOWPOS_UNDEFINED, SDL_WINDOWPOS_UNDEFINED, windowWidth,
            windowHeight, SDL_WINDOW_SHOWN | SDL_WINDOW_RESIZABLE);

    if (window == NULL) {
        SDL_Quit();
        return 2;
    }

    // We create a renderer with hardware acceleration, we also present according with the vertical sync refresh.
    SDL_Renderer *s = SDL_CreateRenderer(window, 0, SDL_RENDERER_ACCELERATED | SDL_RENDERER_PRESENTVSYNC) ;
	while (!quit) {
		while (SDL_PollEvent(&event)) {
            if (event.type == SDL_QUIT) {
                quit = true;
            }
			if (event.window.event == SDL_WINDOWEVENT_RESIZED) {
				windowWidth = event.window.data1;
				windowHeight = event.window.data2;
			}
        }
		SDL_SetRenderDrawColor(s, 41, 0, 0, 255);
        // We clear what we draw before
        SDL_RenderClear(s);

        // And now we present everything we draw after the clear.
        SDL_RenderPresent(s);
	}
	SDL_DestroyWindow(window);
    // We have to destroy the renderer, same as with the window.
    SDL_DestroyRenderer(s);
    SDL_Quit();
}
```
