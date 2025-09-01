#!/bin/bash

# Color functions using ANSI escape codes
red() { echo -e "\033[31m$1\033[0m"; }
green() { echo -e "\033[32m$1\033[0m"; }
yellow() { echo -e "\033[33m$1\033[0m"; }
blue() { echo -e "\033[34m$1\033[0m"; }
magenta() { echo -e "\033[35m$1\033[0m"; }
cyan() { echo -e "\033[36m$1\033[0m"; }
white() { echo -e "\033[37m$1\033[0m"; }
bold() { echo -e "\033[1m$1\033[0m"; }
dim() { echo -e "\033[2m$1\033[0m"; }