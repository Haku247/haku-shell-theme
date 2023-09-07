function Get-GitInfo {
    $gitBranch = & git rev-parse --abbrev-ref HEAD 2>$null
    $gitHash = & git rev-parse --short=8 HEAD 2>$null

    if ($gitBranch -and $gitHash) {
        return "$gitBranch($gitHash)"
    } elseif ($gitBranch) {
        return $gitBranch
    } else {
        return $null
    }
}

function Prompt {
    # Set default colors
    $host.UI.RawUI.ForegroundColor = "White"
    $host.UI.RawUI.BackgroundColor = "Black"

    # Conda Environment Name
    $condaEnv = $env:CONDA_DEFAULT_ENV
    if ($condaEnv) {
        Write-Host "($condaEnv) " -NoNewline -ForegroundColor DarkCyan
    }

    # User@host
    Write-Host "$(whoami)" -NoNewline -ForegroundColor Green

    # Working Directory
    Write-Host " $PWD " -NoNewline -ForegroundColor Cyan

    # UTC+8 Time
    $time = (Get-Date).ToUniversalTime().AddHours(8).ToString("HH:mm:ss")
    Write-Host "[UTC+8 $time]" -NoNewline -ForegroundColor Magenta

    # History Number
    $historyNumber = (Get-History | Measure-Object).Count + 1
    Write-Host " -$historyNumber- " -NoNewline -ForegroundColor Blue

    Write-Host "" # New line for the command status and git info

    # Command Status
    $status = if ($?) {
        Write-Host "■ " -NoNewline -ForegroundColor Green
        " "
    } else {
        Write-Host "■ " -NoNewline -ForegroundColor Red
        " "
    }

    # Git Info
    $gitInfo = Get-GitInfo
    if ($gitInfo) {
        Write-Host "$gitInfo " -NoNewline -ForegroundColor Yellow
    }

    Write-Host "> " -NoNewline -ForegroundColor BrightGreen
    return "> "

}

$function:prompt = ${function:Prompt}
