Execute-MSI -Action 'Install' -Path 'Adobe_FlashPlayer_11.2.202.233_x64_EN.msi'
Execute-MSI -Action 'Install' -Path 'Adobe_FlashPlayer_11.2.202.233_x64_EN.msi' -Transform 'Adobe_FlashPlayer_11.2.202.233_x64_EN_01.mst' -Parameters '/QN'
Execute-MSI -Action 'Uninstall' -Path '{26923b43-4d38-484f-9b9e-de460746276c}'
Execute-MSI -Action 'Patch' -Path 'Adobe_Reader_11.0.3_EN.msp'
Execute-MSI -Action 'Patch' -Path 'Adobe_Reader_11.0.3_EN.msp'
Execute-MSI -Action Install -Path $AppMSIName -SkipMSIAlreadyInstalledCheck -ContinueOnError $False -LogName "${AppMSIName}_MSI"

Execute process:
Execute-Process -Path 'uninstall_flash_player_64bit.exe' -Parameters '/uninstall' -WindowStyle 'Hidden'
Execute-Process -Path "$dirFiles\Bin\setup.exe" -Parameters '/S' -WindowStyle 'Hidden'
Execute-Process -Path 'setup.exe' -Parameters '/S' -IgnoreExitCodes '1,2'
Execute-Process -Path 'setup.exe' -Parameters "-s -f2`"$configToolkitLogDir\$installName.log`""
Execute-Process -Path 'setup.exe' -Parameters "/s /v`"ALLUSERS=1 /qn /L* `"$configToolkitLogDir\$installName.log`"`""

ExecuteMSP:
Execute-MSP -Path 'Adobe_Reader_11.0.3_EN.msp'
Execute-MSP -Path 'AcroRdr2017Upd1701130143_MUI.msp' -AddParameters 'ALLUSERS=1'


copyPath:
Copy-File -Path "$dirSupportFiles\*.*" -Destination "$envTemp\tempfiles"
Copy-File -Path "$dirSupportFiles\MyApp.ini" -Destination "$envWinDir\MyApp.ini"



Execute -Msp
Execute-MSP -Path 'Adobe_Reader_11.0.3_EN.msp'

Install-Msupdate
Install-MSUpdates -Directory "$dirFiles\MSUpdates"


Create a Set-ActiveSetup
Set-ActiveSetup -StubExePath 'C:\Users\Public\Company\ProgramUserConfig.vbs' -Arguments '/Silent' -Description 'Program User Config' -Key 'ProgramUserConfig' -Locale 'en'

Set-ActiveSetup -StubExePath "$envWinDir\regedit.exe" -Arguments "/S `"%SystemDrive%\Program Files (x86)\PS App Deploy\PSAppDeployHKCUSettings.reg`"" -Description 'PS App Deploy Config' -Key 'PS_App_Deploy_Config' -ContinueOnError $true
