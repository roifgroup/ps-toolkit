function clone-vm {

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
        Import-VM -Path $file.FullName -Copy -GenerateNewId -VirtualMachinePath "C:\HyperV\$VMN" -VhdDestinationPath "C:\HyperV\$VMN"
        $vm = Get-VM | Where-Object {$_.Path.StartsWith("$HyperVF\$VMN")}
        Rename-VM -VM $vm -NewName $VMN

        $more = Read-Host "More? [Y/N]"
    }

    Remove-Item -Recurse "$TEMPF\$VMO"

}