# =========================================================
# 天机学堂 一键关闭脚本
# 关闭: 前端 -> 微服务 -> RabbitMQ -> Elasticsearch -> Nacos
# 保留: MySQL / Redis
# 用法:  powershell -ExecutionPolicy Bypass -File stop-all.ps1
# =========================================================

$ErrorActionPreference = "SilentlyContinue"
$MQ_SBIN = "D:\software\rabbitmq\rabbitmq-server-windows-3.12.13\rabbitmq_server-3.12.13\sbin"

# ---------- 1. 停止前端 ----------
Write-Host "[1/5] 停止前端..."
$node = Get-NetTCPConnection -LocalPort 18082 -State Listen
if ($node) {
    Stop-Process -Id $node.OwningProcess -Force
    Write-Host "  已停止: 前端 (端口 18082)"
} else {
    Write-Host "  前端未运行"
}

# ---------- 2. 停止所有 tjxt 微服务 ----------
Write-Host "[2/5] 停止微服务..."
$services = Get-CimInstance Win32_Process -Filter "Name='java.exe'" |
    Where-Object { $_.CommandLine -match "target[\\/]tj-" }
$count = 0
foreach ($s in $services) {
    Stop-Process -Id $s.ProcessId -Force
    $name = if ($s.CommandLine -match "tj-([\w-]+)\.jar") { $Matches[1] } else { $s.ProcessId }
    Write-Host "  已停止: $name"
    $count++
}
Write-Host "  共停止 $count 个微服务进程"

# ---------- 3. 停止 RabbitMQ ----------
Write-Host "[3/5] 停止 RabbitMQ..."
$mqListening = netstat -ano | Select-String ":5672 " | Select-String "LISTENING"
if ($mqListening) {
    & (Join-Path $MQ_SBIN "rabbitmqctl.bat") stop 2>&1 | Out-Null
    Start-Sleep -Seconds 3
    if (netstat -ano | Select-String ":5672 " | Select-String "LISTENING") {
        # rabbitmqctl 未完全停止，强制结束 erl 进程
        Get-CimInstance Win32_Process | Where-Object { $_.Name -match "erl|beam" -and $_.CommandLine -match "rabbit" } |
            ForEach-Object { Stop-Process -Id $_.ProcessId -Force }
    }
    Write-Host "  已停止: RabbitMQ"
} else {
    Write-Host "  RabbitMQ 未运行"
}

# ---------- 4. 停止 Elasticsearch ----------
Write-Host "[4/5] 停止 Elasticsearch..."
$esProc = Get-CimInstance Win32_Process -Filter "Name='java.exe'" |
    Where-Object { $_.CommandLine -match "elasticsearch" }
if ($esProc) {
    $esProc | ForEach-Object { Stop-Process -Id $_.ProcessId -Force }
    Write-Host "  已停止: Elasticsearch ($($esProc.Count) 个进程)"
} else {
    Write-Host "  Elasticsearch 未运行"
}

# ---------- 5. 停止 Nacos ----------
Write-Host "[5/5] 停止 Nacos..."
$nacosProc = Get-CimInstance Win32_Process -Filter "Name='java.exe'" |
    Where-Object { $_.CommandLine -match "nacos" }
if ($nacosProc) {
    $nacosProc | ForEach-Object { Stop-Process -Id $_.ProcessId -Force }
    Write-Host "  已停止: Nacos"
} else {
    Write-Host "  Nacos 未运行"
}

Write-Host "`n完成！(MySQL/Redis 保持运行)"
