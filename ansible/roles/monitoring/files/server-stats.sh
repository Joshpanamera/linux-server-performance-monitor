#!/bin/bash

##############################################
# Colors
##############################################

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m'

##############################################
# Linux Server Performance Dashboard
# Author: Joshua Kpejoh Tam
# Description:
# Displays server information including CPU,
# memory, disk usage, uptime, logged-in users,
# and top resource-consuming processes.
##############################################

##############################################
# Collect System Information
##############################################

hostname=$(hostname)
today=$(date)

##############################################
# CPU Information
##############################################

idle=$(top -bn1 | grep "Cpu(s)" | awk '{print $8}')
usage=$(awk "BEGIN {printf \"%.1f\", 100 - $idle}")

##############################################
# Memory Information
##############################################

memory=$(free -h | grep "Mem:")
total_memory=$(echo "$memory" | awk '{print $2}')
used_memory=$(echo "$memory" | awk '{print $3}')
free_memory=$(echo "$memory" | awk '{print $4}')

##############################################
# Disk Information
##############################################

disk=$(df -h / | tail -1)

total_disk=$(echo "$disk" | awk '{print $2}')
used_disk=$(echo "$disk" | awk '{print $3}')
available_disk=$(echo "$disk" | awk '{print $4}')
disk_usage=$(echo "$disk" | awk '{print $5}')

##############################################
# Server Uptime
##############################################

uptime_info=$(uptime -p)

##############################################
# Logged-in Users
##############################################

logged_users=$(who)

##############################################
# Dashboard Header
##############################################

echo -e "${CYAN}========================================${NC}"
echo -e "${WHITE} Linux Server Performance Dashboard${NC}"
echo -e "${CYAN}========================================${NC}"

echo
echo -e "${WHITE}Hostname :${NC} ${WHITE}$hostname${NC}"
echo -e "${WHITE}Date     :${NC} ${WHITE}$today${NC}"

##############################################
# CPU Usage
##############################################

echo
echo -e "${GREEN}CPU Usage${NC}"
echo "---------"
echo -e "Total CPU Usage : ${WHITE}$usage%${NC}"

##############################################
# Memory Usage
##############################################

echo
echo -e "${BLUE}Memory Usage${NC}"
echo "------------"
echo -e "Total Memory : ${WHITE}$total_memory${NC}"
echo -e "Used Memory  : ${WHITE}$used_memory${NC}"
echo -e "Free Memory  : ${WHITE}$free_memory${NC}"

##############################################
# Disk Usage
##############################################

echo
echo -e "${YELLOW}Disk Usage${NC}"
echo "----------"
echo -e "Total Disk     : ${WHITE}$total_disk${NC}"
echo -e "Used Disk      : ${WHITE}$used_disk${NC}"
echo -e "Available Disk : ${WHITE}$available_disk${NC}"
echo -e "Disk Usage     : ${WHITE}$disk_usage${NC}"

##############################################
# Server Uptime
##############################################

echo
echo -e "${CYAN}Server Uptime${NC}"
echo "-------------"
echo -e "${WHITE}$uptime_info${NC}"

##############################################
# Top 5 Processes by CPU
##############################################

echo
echo -e "${RED}Top 5 Processes by CPU${NC}"
echo "----------------------"
ps aux --sort=-%cpu | head -5

##############################################
# Top 5 Processes by Memory
##############################################

echo
echo -e "${RED}Top 5 Processes by Memory${NC}"
echo "-------------------------"
ps aux --sort=-%mem | head -5

##############################################
# Logged-in Users
##############################################

echo
echo -e "${CYAN}Logged-in Users${NC}"
echo "---------------"
echo -e "${WHITE}$logged_users${NC}"
##############################################
# Export Metrics as JSON
##############################################

cat > /opt/server-monitor/metrics.json <<EOF
{
  "hostname": "$hostname",
  "date": "$today",
  "cpu_usage": "$usage",
  "memory": {
    "total": "$total_memory",
    "used": "$used_memory",
    "free": "$free_memory"
  },
  "disk": {
    "total": "$total_disk",
    "used": "$used_disk",
    "available": "$available_disk",
    "usage": "$disk_usage"
  },
  "uptime": "$uptime_info"
}
EOF