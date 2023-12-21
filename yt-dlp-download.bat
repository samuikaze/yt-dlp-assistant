@echo off
rem yt-dlp Youtube Download Assistant
rem
rem !!! Warning !!!
rem Do not modify this file or it won't work as expected.
rem
rem MIT License, See `LICENSE` file to get more informations.
rem Copyright (C) 2023 SamuiKaze

chcp 65001 >nul 2>&1

set "re_setting_config=false"

call :readConfigs
call :cleanScreen
call :showLicenseInfo

if "%re_setting_config%" equ "false" (
    set /p "re_setting_config=%lang_reconfig_question% "
)

goto configureTool

:readConfigs
    rem Load configurations from file if it exists, skip else.
    if exist .\configs.ini (
        echo Loading configurations from file, please wait ...
        for /f "delims== tokens=1,2" %%G in (configs.ini) do set %%G=%%H
    ) else (
        set "re_setting_config=y"
        echo Configuration file not found, skipping.
    )

    rem Loading language file after configurations are loaded.
    rem If configurations file not found, using en-us as fallback language.
    echo Loading language file, please wait ...
    if "%lang%" equ "" (
        set "lang=en-us"
    )

    set "lang_file=.\i18n\%lang%.lang"

    if exist %lang_file% (
        for /f "delims== tokens=1,2" %%M in (%lang_file%) do set %%M=%%N
    ) else (
        echo Due to lannguage configuration is empty, using en-us as default language.
        for /f "delims== tokens=1,2" %%M in (.\i18n\en-us.lang) do set %%M=%%N
    )

    echo Configurations are loaded.

    goto :eof

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
    echo ^| Version 1.2.1                                                       ^|
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
        echo %lang_updating%
        echo %lang_update_warning%
        .\yt-dlp.exe -U
    ) else if "%update_option%" equ "true" (
        echo %lang_updating%
        echo %lang_update_warning%
        .\yt-dlp.exe -U
    )  else if "%update_option%" equ "y" (
        echo %lang_updating%
        echo %lang_update_warning%
        .\yt-dlp.exe -U
    )  else if "%update_option%" equ "t" (
        echo %lang_updating%
        echo %lang_update_warning%
        .\yt-dlp.exe -U
    ) else if "%update_option%" equ "YES" (
        echo %lang_updating%
        echo %lang_update_warning%
        .\yt-dlp.exe -U
    ) else if "%update_option%" equ "TRUE" (
        echo %lang_updating%
        echo %lang_update_warning%
        .\yt-dlp.exe -U
    ) else if "%update_option%" equ "Y" (
        echo %lang_updating%
        echo %lang_update_warning%
        .\yt-dlp.exe -U
    ) else if "%update_option%" equ "T" (
        echo %lang_updating%
        echo %lang_update_warning%
        .\yt-dlp.exe -U
    )

    goto :eof

:showMessage
    echo ^|^| %lang_dependency_check_title%
    echo +----------------------------------------------------------------------
    if "%ytdlp_exists%" equ "true" (
        if "%ffmpeg_exists%" equ "true" (
            echo ^| %lang_dependency_check_green%
        )

        if "%ffmpeg_exists%" equ "false" (
            echo ^| %lang_dependency_check_yellow%
        )
    )
    echo ^|
    if "%ffmpeg_exists%" equ "false" (
        echo ^| ^|^| ? %lang_ffmpeg_missing_warning_title%
        echo ^| ^|^|-------------------------------------------------------------------
        echo ^| ^|^| %lang_ffmpeg_missing_warning_message_l1%
        echo ^| ^|^| %lang_ffmpeg_missing_warning_message_l2%
        echo ^| ^|^| %lang_ffmpeg_missing_warning_message_l3%
        echo ^|
    )

    if "%ytdlp_exists%" equ "false" (
        echo ^| ^|^| ! %lang_yt_dlp_missing_error_title%
        echo ^| ^|^| ------------------------------------------------------------------
        echo ^| ^|^| %lang_yt_dlp_missing_error_message_l1%
        echo ^| ^|^| %lang_yt_dlp_missing_error_message_l2%
        echo ^| ^|^| %lang_yt_dlp_missing_error_message_l3%
        echo ^| ^|^|
        echo ^| ^|^| %lang_yt_dlp_missing_error_message_lend%
        echo +----------------------------------------------------------------------

        goto exitTool
    )

    if "%ffmpeg_exists%" equ "false" (
        echo ^| %lang_dependency_check_yellow_ignore_tip%
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

        echo ! %lang_video_uri_check_error_title%
        echo -----------------------------------------------------------------------
        echo %lang_video_uri_check_error_message_l1%
        echo %lang_video_uri_check_error_message_l2%
        echo.
        echo %lang_video_uri_check_error_message_lend%
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

    if "%re_setting_config%" equ "y" (
        rem Set default value first
        set "store_path=%userprofile%\Downloads"
        set "update_option=y"
        set "video_resolution=4320"
        rem Setting display language
        echo %lang_setting_language_help_l1%
        echo %lang_setting_language_help_l2%
        echo %lang_setting_language_help_l3%
        echo ^> https://en.wikipedia.org/wiki/List_of_ISO_639_language_codes
        echo ^> https://zh.wikipedia.org/wiki/ISO_3166-1
        echo %lang_setting_language_help_l4%
        set /p "lang=%lang_setting_language_tip% "
        echo.
        rem Specify download folder and video URI
        rem Download folder default point to user's download folder if user is not specify a path.
        echo %lang_setting_download_folder_help_l1%
        echo %lang_setting_download_folder_help_l2%
        echo %lang_setting_download_folder_help_l3%
        set /p "store_path=%lang_setting_download_folder_tip% "
        echo "%store_path%"
        echo.
        rem Setting video resolution
        echo %lang_setting_video_resolution_help_l1%
        echo %lang_setting_video_resolution_help_l2%
        echo %lang_setting_video_resolution_help_l3%
        set /p "video_resolution=%lang_setting_video_resolution_tip% "
        echo.
        rem Setting custom format options
        echo %lang_setting_custom_format_options_help_l1%
        echo %lang_setting_custom_format_options_help_l2%
        echo %lang_setting_custom_format_options_help_l3%
        echo %lang_setting_custom_format_options_help_l4%
        set /p "format_options=%lang_setting_custom_format_options_tip% "
        echo "%format_options%"
        echo.
        rem Setting update option
        echo %lang_setting_update_option_help_l1%
        echo %lang_setting_update_option_help_l2%
        echo %lang_setting_update_option_help_l3%
        set /p "update_option=%lang_setting_update_option_tip% "
        echo.
    )

    echo %lang_setting_target_uri_help_l1%
    echo %lang_setting_target_uri_help_l2%
    set /p "target_uri=%lang_setting_target_uri_tip% "

    call :checkVideoURIEmpty

    if "%re_setting_config%" equ "y" (
        call :exportSettings
        set "re_setting_config=false"
    )

    goto confirmSettings

:exportSettings
    call :cleanScreen
    call :showLicenseInfo
    call :showMessage

    echo %lang_exporting_settings_tip%

    if "%format_options%" equ "" (
        set "format_options=bestvideo[height^<^=%video_resolution%][ext^=mp4]+bestaudio[ext^=m4a]/best[ext^=mp4]/best"
    )

    (
        echo lang=%lang%
        echo store_path=%store_path%
        echo video_resolution=%video_resolution%
        echo update_option=%update_option%
        echo %lang_exporting_settings_file_comment_custom_format_option%
        echo ^; _format_options=
    ) > configs.ini

    echo %lang_apply_config_now_l1%
    echo %lang_apply_config_now_l2%
    call :readConfigs
    goto :eof

:confirmSettings
    call :cleanScreen
    call :showLicenseInfo
    call :showMessage

    if "%format_options%" equ "" (
        set "format_options=bestvideo[height^<^=%video_resolution%][ext^=mp4]+bestaudio[ext^=m4a]/best[ext^=mp4]/best"
    )

    echo ^|^| %lang_confirm_setting_title%
    echo +----------------------------------------------------------------------
    echo ^| %lang_confirm_setting_download_folder%: %store_path%
    echo ^| %lang_confirm_setting_from_uri%: %target_uri%
    echo ^| %lang_confirm_setting_format_options%: %format_options%
    echo ^| %lang_confirm_setting_update_option%: %update_option%
    echo +----------------------------------------------------------------------
    echo.
    echo %lang_confirm_setting_export_warning_l1%
    echo %lang_confirm_setting_export_warning_l2%
    echo %lang_confirm_setting_export_warning_l3%
    echo.
    set "confirm_settings=Y"
    set /p "confirm_settings=%lang_confirm_setting_tip% "
    if "%confirm_settings%" equ "Y" (
        call :updateYTDLP
        goto mainDownloadProcess
    ) else if "%confirm_settings%" equ "y" (
        call :updateYTDLP
        goto mainDownloadProcess
    ) else if "%confirm_settings%" equ "yes" (
        call :updateYTDLP
        goto mainDownloadProcess
    ) else if "%confirm_settings%" equ "YES" (
        call :updateYTDLP
        goto mainDownloadProcess
    ) else (
        set /p "re_setting_config=%lang_reconfig_question% "
        goto configureTool
    )

:mainDownloadProcess
    call :cleanScreen
    call :showLicenseInfo
    call :showMessage

    echo ^|^| %lang_download_process_config_title%
    echo +----------------------------------------------------------------------
    echo ^| %lang_download_process_config_download_folder%: %store_path%
    echo ^| %lang_download_process_config_from_uri%: %target_uri%
    echo ^| %lang_download_process_config_format_options%: %format_options%
    echo +----------------------------------------------------------------------
    echo.
    echo %lang_download_process_tip_l1%
    echo %lang_download_process_tip_l2%
    echo.
    echo %lang_download_process_tip_lend%
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
