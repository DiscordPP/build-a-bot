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

#include <boost/asio.hpp>

// Put more non-plugin `include`s here

#endif

BUILDABOT_INCLUDE

// Put more D++ plugin `include`s here

#ifndef DPPBOT_EXTERN

extern template class MY_BOT_DEF;
using DppBot = MY_BOT_DEF;

#undef DPPBOT_EXTERN

#endif
