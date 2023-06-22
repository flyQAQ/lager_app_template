//
// lager - library for functional interactive c++ programs
// Copyright (C) 2017 Juan Pedro Bolivar Puente
//
// This file is part of lager.
//
// lager is free software: you can redistribute it and/or modify
// it under the terms of the MIT License, as detailed in the LICENSE
// file located at the root of this source code distribution,
// or here: <https://github.com/arximboldi/lager/blob/master/LICENSE>
//

#include "counter.hpp"

#include <lager/debug/debugger.hpp>
#include <lager/debug/http_server.hpp>
#include <lager/event_loop/sdl.hpp>
#include <lager/store.hpp>
#include <lager/resources_path.hpp>

#include <zug/compose.hpp>

#include <cereal/types/complex.hpp>

#include <imgui.h>
#include <imgui_impl_sdlrenderer.h>
#include <imgui_impl_sdl2.h>

#include <SDL.h>
#include <SDL_opengl.h>

#include <iostream>

constexpr int window_padding = 48;
constexpr int window_width   = 800;
constexpr int window_height  = 600;

void draw(lager::context<counter::action> ctx,
          const counter::model& m)
{
    ImGui::SetNextWindowPos({window_padding, window_padding}, ImGuiCond_Once);
    ImGui::SetNextWindowSize(
        {window_width - 2 * window_padding, window_height - 2 * window_padding},
        ImGuiCond_Once);
    ImGui::Begin("lager app");

    float spacing = ImGui::GetStyle().ItemInnerSpacing.x;
    ImGui::PushButtonRepeat(true);
    if (ImGui::ArrowButton("##left", ImGuiDir_Left)) { ctx.dispatch(counter::decrement_action{}); }
    ImGui::SameLine(0.0f, spacing);
    if (ImGui::ArrowButton("##right", ImGuiDir_Right)) { ctx.dispatch(counter::increment_action{}); }
    ImGui::PopButtonRepeat();
    ImGui::SameLine(0.0f, spacing);
    ImGui::Text("%d", m.value);
    ImGui::SameLine(0.0f, spacing);
    if (ImGui::Button("reset")) { ctx.dispatch(counter::reset_action{}); }

    ImGui::End();
}

int main(int argc, const char *argv[])
{
    if (SDL_Init(SDL_INIT_VIDEO | SDL_INIT_TIMER) != 0) {
        std::cerr << "Error initializing SDL: " << SDL_GetError() << std::endl;
        return -1;
    }

    // Create window with SDL_Renderer graphics context
    SDL_WindowFlags window_flags = (SDL_WindowFlags)(SDL_WINDOW_RESIZABLE | SDL_WINDOW_ALLOW_HIGHDPI);
    SDL_Window* window = SDL_CreateWindow("Todo ImGui", SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED, 1280, 720, window_flags);
    if (!window) {
        std::cerr << "Error creating SDL window: " << SDL_GetError()
                  << std::endl;
        return -1;
    }

    SDL_Renderer* renderer = SDL_CreateRenderer(window, -1, 0);
    if (renderer == nullptr)
    {
        std::cerr << "Error creating SDL renderer: " << SDL_GetError()
                  << std::endl;
        return -1;
    }

    IMGUI_CHECKVERSION();
    ImGui::CreateContext();
    auto& io = ImGui::GetIO();
    io.ConfigFlags |= ImGuiConfigFlags_NavEnableKeyboard;
    io.ConfigFlags |= ImGuiConfigFlags_NavEnableGamepad;

    ImGui::StyleColorsDark();

    ImGui_ImplSDL2_InitForSDLRenderer(window, renderer);
    ImGui_ImplSDLRenderer_Init(renderer);

    auto clear_color = ImVec4(0.45f, 0.55f, 0.60f, 1.00f);

#ifdef DEBUGGER
    auto debugger =
        lager::http_debug_server{argc, argv, 8080, lager::resources_path()};
#endif
    auto loop  = lager::sdl_event_loop{};
    auto store = lager::make_store<counter::action>(
        counter::model{}, lager::with_sdl_event_loop{loop},
        zug::comp(
#ifdef DEBUGGER
            lager::with_debugger(debugger),
#endif
            lager::identity
        )
    );

    loop.run(
        [&](const SDL_Event& ev) {
            ImGui_ImplSDL2_ProcessEvent(&ev);
            return ev.type != SDL_QUIT;
        },
        [&](auto dt) {
            ImGui_ImplSDLRenderer_NewFrame();
            ImGui_ImplSDL2_NewFrame(window);
            ImGui::NewFrame();
            {
                draw(store, store.get());
            }
            ImGui::Render();
            SDL_RenderSetScale(renderer, io.DisplayFramebufferScale.x, io.DisplayFramebufferScale.y);
            SDL_SetRenderDrawColor(renderer, (Uint8)(clear_color.x * 255), (Uint8)(clear_color.y * 255), (Uint8)(clear_color.z * 255), (Uint8)(clear_color.w * 255));
            SDL_RenderClear(renderer);
            ImGui_ImplSDLRenderer_RenderDrawData(ImGui::GetDrawData());
            SDL_RenderPresent(renderer);
        });

    ImGui_ImplSDLRenderer_Shutdown();
    ImGui_ImplSDL2_Shutdown();
    ImGui::DestroyContext();

    SDL_DestroyRenderer(renderer);
    SDL_DestroyWindow(window);
    SDL_Quit();

    return 0;
}
