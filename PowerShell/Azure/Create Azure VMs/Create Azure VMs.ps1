# Set the default Azure subscription (Run only once)
# az account set --subscription "{put_subscription_name_here}"

# Start a login session
az login

# Ask for a name prefix and set it as variable
Write-Host "Please write a general name prefix: " -ForegroundColor Yellow
$name_prefix = Read-Host

# Ask for the number of VMs to be created
Write-Host "Please write the number of VMs to be created: " -ForegroundColor Yellow
$vm_count = Read-Host

Try
{
# Set the maximum amount of VMs to possibly be created
$max_vm_count = 4

# Check if the user has requested more VMs than the allowed maximum
If ($vm_count -le $max_vm_count)
{   
    # Check if the amount of requested VMs is odd
    If (0 -ne $vm_count % 2)
    {
        # Create all VMs with two disks
        az vmss create --resource-group test-liran --name $name_prefix --image Win2019Datacenter --authentication-type password --admin-username azureuser --admin-password ChangeThisPassword! --os-disk-size-gb 130 --data-disk-sizes-gb 70 --public-ip-per-vm --instance-count $vm_count
    }
    # In case the amount of requested VMs is even
    Else
    {   
        # Set the variable for half of the requested VMs
        $half_vm_count = @(1..($vm_count / 2))
        $second_half = @(($half_vm_count[-1]+1)..$vm_count)

        # Create half of the VMs with the shutdwon tag and only one disk
        az vmss create --resource-group test-liran --name $name_prefix --image Win2019Datacenter --authentication-type password --admin-username azureuser --admin-password ChangeThisPassword! --tags Shutdown --os-disk-size-gb 130 --public-ip-per-vm --instance-count $half_vm_count.Count

        # Create half of the VMs with two disks
        az vmss create --resource-group test-liran --name $name_prefix --image Win2019Datacenter --authentication-type password --admin-username azureuser --admin-password ChangeThisPassword! --os-disk-size-gb 130 --data-disk-sizes-gb 70 --public-ip-per-vm --instance-count $second_half.Count
    }
}

# Notify the user they requested more than the maximum allowed VMs to be created
else
{Write-Host "Error! The maximum amount of VMs allowed to be created is $max_vm_count, but you have chosen to create $vm_count. Please try again." -ForegroundColor Red}
}

Catch {$_}

Finally {"$(Get-Date)".Trim() | Out-File C:\Logs\Azure_Script_Log.txt -Append ; $Error[0] | Out-File C:\Logs\Azure_Script_Log.txt -Append}
