git pull origin
npm install


function Start-TavernExtras {
    Write-Host "Starting Tavern Extras..." -ForegroundColor Blue
    Push-Location "C:\Applications\AI\Text\Chat\SillyTavern-extras"
    git pull origin
    & .\venv\Scripts\Activate.ps1
    Start-Process python "server.py --enable-modules=caption,summarize,classify,sd,chromadb --cuda"
    Pop-Location
}

$timeout = 50  # Timeout in milliseconds
$ip = '127.0.0.1'

function CheckPort {
    param($ip, $port, $StartFunc)
    $tcpclient = New-Object System.Net.Sockets.TcpClient
    $asyncresult = $tcpclient.BeginConnect($ip, $port, $null, $null)

    if ($asyncresult.AsyncWaitHandle.WaitOne($timeout, $true)) {
        try {
            $tcpclient.EndConnect($asyncresult)
            $tcpclient.Close()
            Write-Output "Process running on localhost\:$port"
        } catch {
            Write-Output "Unable to connect to the process on localhost\:$port"
        }
    } else {
        & $StartFunc
    }
}

CheckPort -ip $ip -port 5100 -StartFunc Start-TavernExtras

Start-Process node -ArgumentList "server.js" -NoNewWindow -Wait
Write-Host "Press Enter to exit"
$null = [System.Console]::ReadLine()