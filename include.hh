//
// Created by Aidan on 10/2/2020.
//

#pragma once

#include <discordpp/macros.hh>

#define MY_BOT_DEF BOT_DEF(ALL_DISCORDPP_PLUGINS)

#ifndef DPPBOT_EXTERN

#include <fstream>
#include <iostream>
#include <regex>

#ifdef ASIO_STANDALONE
#include <asio.hpp>
#else
#include <boost/asio.hpp>
#endif

// Put more non-plugin `include`s here

#endif

#include <discordpp.hh>

#ifndef DPPBOT_EXTERN

extern template class MY_BOT_DEF;
using DppBot = MY_BOT_DEF;

#undef DPPBOT_EXTERN

#endif
