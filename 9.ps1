### 9. Выводить сообщение при каждом запуске приложения MS Word.

try {
    Get-EventSubscriber -SourceIdentifier "MSWordRun"  # If MSWordRun event exist, then event delete and register new.
    Unregister-Event -SourceIdentifier "MSWordRun"
    # The event when MS WORD will start. 
    Register-WmiEvent -Query "Select * From __instancecreationevent within 5 where targetinstance isa 'Win32_Process' and targetinstance.name='WINWORD.EXE'" `
    -sourceIdentifier "MSWordRun" -Action { Write-Host "Microsoft Word has been started." }
    Write-Output ("MSWordRun event existed")
}
catch {
    # The event when MS WORD will start.
    Register-WmiEvent -Query "Select * From __instancecreationevent within 5 where targetinstance isa 'Win32_Process' and targetinstance.name='WINWORD.EXE'" `
    -sourceIdentifier "MSWordRun" -Action { Write-Host "Microsoft Word has been started." }
    Write-Output ("MSWordRun event no existed")
}

# Unregister-Event -SourceIdentifier "MSWordRun"                # Delete "MSWordRun" event