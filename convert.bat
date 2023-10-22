@echo off
setlocal enabledelayedexpansion

:: used for converting results from the clip-submission form to a format that can be used by
:: Lossless cut to create clips.

:: takes a CSV file that contains "start time" and "end time" SPECIFICALLY IN the 3rd and 4th columns, 
:: converts them from hh:mm:ss format to time-in-seconds, and writing the result to a new CSV 
:: with 3 columns - start time, end time, and label.

:: Open a file dialog to select a CSV file
echo Select a CSV file:
set "csvFile="
for /f %%A in ('powershell -noprofile "Add-Type -AssemblyName System.Windows.Forms; $fd = New-Object System.Windows.Forms.OpenFileDialog; $fd.Filter = 'CSV Files (*.csv)|*.csv'; $fd.ShowDialog() | Out-Null; $fd.FileName"') do (
    set "csvFile=%%A"
)

if not exist "%csvFile%" (
    echo No CSV file selected or file does not exist.
    pause
    exit /b 1
)

:: Extract the file name without extension
for %%F in ("%csvFile%") do (
    set "fileName=%%~nF"
)

:: Create a new CSV file with data only, skipping the first row
set "outputFile=%fileName% converted.csv"

(set "skipFirstRow=true" && for /f "usebackq tokens=1-5 delims=," %%a in ("%csvFile%") do (
    if defined skipFirstRow (
        set "skipFirstRow="
    ) else (
        for /f "tokens=1-3 delims=:" %%x in ("%%c") do (
            set /a "start=%%x*3600+%%y*60+%%z"
        )

        for /f "tokens=1-3 delims=:" %%x in ("%%d") do (
            set /a "end=%%x*3600+%%y*60+%%z"
        )

        set /a "label+=1"
        echo !start!,!end!,point !label!
    )
)) > "%outputFile%"

echo New CSV file created: %outputFile%
pause