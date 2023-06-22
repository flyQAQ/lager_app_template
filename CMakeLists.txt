cmake_minimum_required(VERSION 3.8)
cmake_policy(SET CMP0056 NEW) # honor link flags in try_compile()
list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_LIST_DIR}/cmake")

project(app)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall")

set(CMAKE_EXPORT_COMPILE_COMMANDS on)
set(CMAKE_CXX_EXTENSIONS off)
if ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "Clang")
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Qunused-arguments")
endif()

find_package(SDL2 REQUIRED)
find_package(Boost REQUIRED system)
find_package(Immer)
find_package(Lager)

set(imgui_source_dir "$ENV{IMGUI_SOURCE_DIR}")

set(imgui_sources
  "${imgui_source_dir}/imgui.cpp"
  "${imgui_source_dir}/imgui_draw.cpp"
  "${imgui_source_dir}/imgui_tables.cpp"
  "${imgui_source_dir}/imgui_widgets.cpp"
  "${imgui_source_dir}/imgui_impl_sdl2.cpp"
  "${imgui_source_dir}/imgui_impl_sdlrenderer.cpp")

if (SDL2_FOUND AND EXISTS "${imgui_source_dir}/imgui.h")
  add_executable(app 
    ${imgui_sources}
    ${CMAKE_CURRENT_SOURCE_DIR}/src/main.cpp)
  target_compile_definitions(app PUBLIC DEBUGGER)
  target_include_directories(app PRIVATE 
    ${CMAKE_SOURCE_DIR} 
    ${imgui_source_dir}
    ${SDL2_INCLUDE_DIR}
    ${Boost_INCLUDE_DIR})
  target_link_libraries(app PRIVATE
    lager-debugger-example
    immer
    ${SDL2_LIBRARY}
    ${Boost_LIBRARIES})
endif()

