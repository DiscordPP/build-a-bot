//
// Created by Aidan on 10/2/2020.
//

#pragma once

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

extern template class BUILDABOT_TEMPLATE_BEGINdiscordpp::BotBUILDABOT_TEMPLATE_END;
using DppBot = BUILDABOT_TEMPLATE_BEGINdiscordpp::BotBUILDABOT_TEMPLATE_END;

#undef DPPBOT_EXTERN

#endif
