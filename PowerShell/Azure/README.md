Ask the user for a prefix name to be added to all VMs.  
Ask the user for an amount of VMs to create in Azure. 
Maximum number of VMs should be not more than 4.  
Each VM creation should be done in parallel.  
All VMs should have public IP addresses.  
If you provided an even number (2 or 4), half of the machines should be created with "shutdown" tag and contain only one disk (OS Disk).  
If you provided an odd number, created machines should be created with two disks (OS Disk and Data Disk). 
The script should handle exceptions, which should be written to a log file. 
