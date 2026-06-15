# Project 1 - Terraform VMSS Autoscaling Web Application

## Objective

Deploy a highly available web application on Azure using:

- Terraform
- Virtual Machine Scale Sets (VMSS)
- Azure Load Balancer
- Azure NAT Gateway
- Network Security Groups
- Autoscaling

## Architecture

(Architecture image in the Architecture Folder)

## Current Status

- [x] Resource Group
- [x] Virtual Network
- [x] Subnet
- [x] NSG
- [x] NAT Gateway
- [x] Load Balancer
- [x] VMSS
- [x] Cloud-init
- [x] Web Application Deployment
- [x] Autoscaling Validation
- [x] Azure Monitor
    - [x] Create Log Analytics Workspace
    - [x] Add AMA extension in VMSS
    - [x] DCR Rules
    - [x] Workspaces
    - [x] Setup action group and alerts
        - [x] CPU 80 & 95% alerts
        - [ ] Memory Alerts (Beta)
        - [x] HeartBeat Alert (Beta)
        - [ ] Scale event alerts (Up and Down)
- [ ] Grafana / Azure Workbook dashboard