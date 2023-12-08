@echo off
rem yt-dlp Youtube Download Assistant
rem
rem !!! Warning !!!
rem Do not modify this file or it won't work as expected.
rem
rem MIT License, See `LICENSE` file to get more informations.
rem Copyright (C) 2023 SamuiKaze

call :showLicenseInfo

goto configureTool

:showLicenseInfo
    echo +---------------------------------------------------------------------+
    echo ^|                  yt-dlp Youtube Download Assistant                  ^|
    echo +---------------------------------------------------------------------+
    echo ^|                                                                     ^|
    echo ^| MIT License                                                         ^|
    echo ^| Copyright ^(C^) 2023 SamuiKaze                                        ^|
    echo ^|                                                                     ^|
    echo ^| License detail can be found in `LICENSE` file.                      ^|
    echo ^|                                                                     ^|
    echo +---------------------------------------------------------------------+
    echo ^| Version 1.1.0                                                       ^|
    echo +---------------------------------------------------------------------+
    echo.
    goto :eof

:cleanScreen
    cls
    goto :eof

:updateYTDLP
    call :cleanScreen
    call :showLicenseInfo
    call :showMessage

    if "%update_option%" equ "yes" (
        echo Updating yt-dlp ...
        echo Do not terminate the process or the yt-dlp may be deleted by itself.
        .\yt-dlp.exe -U
    )
    if "%update_option%" equ "true" (
        echo Updating yt-dlp ...
        echo Do not terminate the process or the yt-dlp may be deleted by itself.
        .\yt-dlp.exe -U
    )
    goto :eof

:showMessage
    echo ^|^| Dependencies Check
    echo +----------------------------------------------------------------------
    if "%ytdlp_exists%" equ "true" (
        if "%ffmpeg_exists%" equ "true" (
            echo ^| [Green] Check all passed!
        )

        if "%ffmpeg_exists%" equ "false" (
            echo ^| [Yellow] There are some warnings found!
        )
    )
    echo ^|
    if "%ffmpeg_exists%" equ "false" (
        echo ^| ^|^| ? Warning: ffmpeg.exe not found
        echo ^| ^|^|-------------------------------------------------------------------
        echo ^| ^|^| ffmpeg.exe not found!
        echo ^| ^|^| FFmpeg is required to merge video and audio file.
        echo ^| ^|^| Or you'll need to merge them by yourself.
        echo ^|
    )

    if "%ytdlp_exists%" equ "false" (
        echo ^| ^|^| ! Error: yt-dlp.exe not found
        echo ^| ^|^| ------------------------------------------------------------------
        echo ^| ^|^| yt-dlp.exe not found!
        echo ^| ^|^| yt-dlp is required to download the video.
        echo ^| ^|^| Please put this batch file in the folder where `yt-dlp.exe` is lo-
        echo ^| ^|^| cated.
        echo ^| ^|^|
        echo ^| ^|^| Press any key to exit the tool to fix the errors.
        echo +----------------------------------------------------------------------

        goto exitTool
    )

    if "%ffmpeg_exists%" equ "false" (
        echo ^| You can ignore warnings anyway or terminate the process.
    )

    echo +----------------------------------------------------------------------
    echo.

    goto :eof

:checkDependencies
    rem Check yt-dlp is exists or not first
    set "ytdlp_exists=false"
    set "ffmpeg_exists=false"

    if exist .\yt-dlp.exe (
        set "ytdlp_exists=true"
    )

    if exist .\ffmpeg.exe (
        set "ffmpeg_exists=true"
    )

    goto :eof

:checkVideoURIEmpty
    if "%target_uri%" equ "" (
        call :cleanScreen
        call :showLicenseInfo

        echo !!! Error !!!
        echo -----------------------------------------------------------------------
        echo Video URI can not be empty.
        echo Please specify a video URI to download.
        echo.
        echo Press any key to reconfigure the settings.
        echo.
        echo.

        pause

        call :cleanScreen
        goto configureTool
    ) else (
        goto :eof
    )

:configureTool
    call :cleanScreen
    call :checkDependencies
    call :showLicenseInfo
    call :showMessage

    rem Specify download folder and video URI
    rem Download folder default point to user's download folder if user is not specify a path.
    echo ^> Setting download folder. Default is current user's download folder.
    echo ^> You can use relative path or absolute path to specify where to save the file.
    echo ^> If folder doesn't exist, it will be create automatically.
    set "store_path=%userprofile%\Downloads"
    set "update_option=yes"
    set "video_resolution=4320"
    set /P "store_path=Download folder: (Press Enter to skip) "
    echo.
    echo ^> This tool is designed to support Youtube ONLY even if yt-dlp support more sites.
    echo ^> But you can still give it a try.
    set /P "target_uri=Input video URI: "
    call :checkVideoURIEmpty
    echo.
    echo ^> Select what resolution to download. Default resolution is 4K.
    echo ^> yt-dlp will download less than or equal to what resolution is specified.
    echo ^> Using 4320, 2140, 1080, ..., etc. to specify resolution.
    set /P "video_resolution=Specify video resolution: (Default is 4K, press Enter to skip) "
    echo.
    echo ^> You can use your format options here or just press enter to use default setting.
    echo ^> If change format options here, you need to specify your video resolution yourself here.
    echo ^> See official documents for more informations.
    set "format_options=bestvideo[height^<^=%video_resolution%][ext^=mp4]+bestaudio[ext^=m4a]/best[ext^=mp4]/best"
    set /P "format_options=Input your format options: (Press Enter to skip) "
    echo.
    echo ^> Setting the process to update yt-dlp first or not
    echo ^> Download process will still continue regardless of update process is failed or not
    set /P "update_option=Update yt-dlp first? (using `no` to ignore update process, default is `yes`) "
    goto confirmSettings

:confirmSettings
    call :cleanScreen
    call :showLicenseInfo
    call :showMessage

    echo ^|^| Confirm Configurations
    echo +----------------------------------------------------------------------
    echo ^| Download folder: %store_path%
    echo ^| From URI: %target_uri%
    echo ^| Format Options: %format_options%
    echo ^| Update yt-dlp First: %update_option%
    echo +----------------------------------------------------------------------
    echo.
    set "confirm_settings=yes"
    set /P "confirm_settings=Confirm the configurations (Press Enter or `yes` to confirm, `no` to reconfigure) "
    if "%confirm_settings%" equ "yes" (
        call :updateYTDLP
        goto mainDownloadProcess
    ) else (
        goto configureTool
    )

:mainDownloadProcess
    call :cleanScreen
    call :showLicenseInfo
    call :showMessage

    echo ^|^| Configurations
    echo +----------------------------------------------------------------------
    echo ^| Download folder: %store_path%
    echo ^| From URI: %target_uri%
    echo ^| Format Options: %format_options%
    echo +----------------------------------------------------------------------
    echo.
    echo Begin download process with yt-dlp ...
    echo You can terminate the process by pressing Ctrl + C
    echo.
    echo Please note the download process will be ignored if the video had been downloaded before.
    echo -----------------------------------------------------------------------
    echo.

    .\yt-dlp.exe ^
        --windows-filenames ^
        --no-force-overwrites ^
        --no-cookies ^
        --write-thumbnail ^
        -f %format_options% ^
        --progress ^
        --path %store_path% ^
        %target_uri%

    goto exitTool

:exitTool
    echo.
    echo.
    pause

    exit
