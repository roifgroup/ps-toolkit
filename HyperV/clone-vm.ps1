function clone-vm {

    # This requires administrator level privileges to complete 
    # This tool is designed to clone VMs in HyperV windows home versions as Virtualbox is not supported under Windows 11
    

    $VMS = Get-VM | Select -ExpandProperty name
    Write-Host "Existing VMs: $VMS"

    $TEMPF = "C:\Temp"
    $HyperVF = "C:\HyperV"

    $VMO = Read-Host "VM to Clone"


    $more = "y"

    Export-VM -Name $VMO -Path $TEMPF
    $file = Get-ChildItem -Recurse "$TEMPF\$VMO\Virtual Machines" | where name -like "*.vmcx"

    while($more -contains "y" -or $more -contains "Y")
    {
        $VMN = Read-Host "New VM Name"
        New-Item -ItemType Directory -Path "$HyperVF\$VMN"
        Import-VM -Path $file.FullName -Copy -GenerateNewId -VirtualMachinePath "$HyperVF\$VMN" -VhdDestinationPath "$HyperVF\$VMN"
        $vm = Get-VM | Where-Object {$_.Path.StartsWith("$HyperVF\$VMN")}
        Rename-VM -VM $vm -NewName $VMN

        $more = Read-Host "More? [Y/N]"
    }

    Remove-Item -Recurse "$TEMPF\$VMO"

}
