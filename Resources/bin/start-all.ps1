# =========================================================
# 天机学堂 一键启动脚本
# 自动启动: Nacos -> Elasticsearch -> RabbitMQ -> 13 个微服务
# 用法:  powershell -ExecutionPolicy Bypass -File start-all.ps1
# =========================================================

$ErrorActionPreference = "Continue"
$PROJECT_DIR = "d:\daima\待学习\tianjixuetang\tjxt"
$LOG_DIR     = "d:\daima\待学习\tianjixuetang\logs"
$NACOS_URL   = "http://127.0.0.1:8848/nacos/v1/console/server/state"
$ES_URL      = "http://127.0.0.1:9200"

# 基础设施路径
$NACOS_CMD   = "D:\software\nacos\bin\startup.cmd"
$ES_BAT      = "D:\software\Elasticsearch\elasticsearch-7.12.1-windows-x86_64\elasticsearch-7.12.1\bin\elasticsearch.bat"
$MQ_SBIN     = "D:\software\rabbitmq\rabbitmq-server-windows-3.12.13\rabbitmq_server-3.12.13\sbin"

New-Item -ItemType Directory -Path $LOG_DIR -Force | Out-Null

# ---------- 1. 启动 Nacos ----------
Write-Host "[1/5] 启动 Nacos..."
try {
    $null = Invoke-RestMethod -Uri $NACOS_URL -TimeoutSec 3
    Write-Host "     Nacos 已运行 (8848)"
} catch {
    Write-Host "     启动 Nacos (standalone)..."
    Start-Process -FilePath "cmd.exe" -ArgumentList "/c", "$NACOS_CMD -m standalone" -WindowStyle Minimized
    $ok = $false
    for ($i = 0; $i -lt 20; $i++) {
        Start-Sleep -Seconds 3
        try { $null = Invoke-RestMethod -Uri $NACOS_URL -TimeoutSec 2; $ok = $true; break } catch {}
    }
    if ($ok) { Write-Host "     Nacos 启动成功" } else { Write-Host "     [警告] Nacos 启动超时，请手动检查" }
}

# ---------- 2. 启动 Elasticsearch ----------
Write-Host "[2/5] 启动 Elasticsearch..."
try {
    $null = Invoke-RestMethod -Uri $ES_URL -TimeoutSec 3
    Write-Host "     ES 已运行 (9200)"
} catch {
    Write-Host "     启动 ES (7.12.1)..."
    Start-Process -FilePath $ES_BAT -WindowStyle Minimized
    $ok = $false
    for ($i = 0; $i -lt 30; $i++) {
        Start-Sleep -Seconds 3
        try { $null = Invoke-RestMethod -Uri $ES_URL -TimeoutSec 2; $ok = $true; break } catch {}
    }
    if ($ok) { Write-Host "     ES 启动成功" } else { Write-Host "     [警告] ES 启动超时，请手动检查" }
}

# ---------- 3. 启动 RabbitMQ ----------
Write-Host "[3/5] 启动 RabbitMQ..."
$mqListening = netstat -ano | Select-String ":5672 " | Select-String "LISTENING"
if ($mqListening) {
    Write-Host "     RabbitMQ 已运行 (5672)"
} else {
    Write-Host "     启动 RabbitMQ (3.12.13)..."
    Start-Process -FilePath (Join-Path $MQ_SBIN "rabbitmq-server.bat") -ArgumentList "-detached" -WindowStyle Minimized
    $ok = $false
    for ($i = 0; $i -lt 20; $i++) {
        Start-Sleep -Seconds 3
        if (netstat -ano | Select-String ":5672 " | Select-String "LISTENING") { $ok = $true; break }
    }
    if ($ok) { Write-Host "     RabbitMQ 启动成功" } else { Write-Host "     [警告] RabbitMQ 启动超时，请手动检查" }
}

# ---------- 4. 启动 13 个微服务 ----------
$services = @(
    @{ Name = "auth-service";     Jar = "tj-auth\tj-auth-service\target\tj-auth-service.jar";     Dir = "tj-auth\tj-auth-service" }
    @{ Name = "user-service";     Jar = "tj-user\target\tj-user.jar";                              Dir = "tj-user" }
    @{ Name = "course-service";   Jar = "tj-course\target\tj-course.jar";                          Dir = "tj-course" }
    @{ Name = "search-service";   Jar = "tj-search\target\tj-search.jar";                          Dir = "tj-search" }
    @{ Name = "learning-service"; Jar = "tj-learning\target\tj-learning.jar";                      Dir = "tj-learning" }
    @{ Name = "trade-service";    Jar = "tj-trade\target\tj-trade.jar";                            Dir = "tj-trade" }
    @{ Name = "pay-service";      Jar = "tj-pay\tj-pay-service\target\tj-pay-service.jar";         Dir = "tj-pay\tj-pay-service" }
    @{ Name = "promotion-service";Jar = "tj-promotion\target\tj-promotion.jar";                    Dir = "tj-promotion" }
    @{ Name = "message-service";  Jar = "tj-message\tj-message-service\target\tj-message-service.jar"; Dir = "tj-message\tj-message-service" }
    @{ Name = "remark-service";   Jar = "tj-remark\target\tj-remark.jar";                          Dir = "tj-remark" }
    @{ Name = "exam-service";     Jar = "tj-exam\target\tj-exam.jar";                              Dir = "tj-exam" }
    @{ Name = "data-service";     Jar = "tj-data\target\tj-data.jar";                              Dir = "tj-data" }
    @{ Name = "gateway-service";  Jar = "tj-gateway\target\tj-gateway.jar";                        Dir = "tj-gateway" }
)

Write-Host "[4/5] 启动微服务（共 $($services.Count) 个，内存限制 -Xmx512m）..."
$i = 0
foreach ($svc in $services) {
    $i++
    $jar  = Join-Path $PROJECT_DIR $svc.Jar
    $work = Join-Path $PROJECT_DIR $svc.Dir
    $outLog = Join-Path $LOG_DIR "$($svc.Name).out.log"
    $errLog = Join-Path $LOG_DIR "$($svc.Name).err.log"

    if (-not (Test-Path $jar)) {
        Write-Host "  [$i/$($services.Count)] $($svc.Name) 跳过: jar 不存在"
        continue
    }
    $running = Get-CimInstance Win32_Process -Filter "Name='java.exe'" |
        Where-Object { $_.CommandLine -match [regex]::Escape($svc.Jar) }
    if ($running) {
        Write-Host "  [$i/$($services.Count)] $($svc.Name) 已在运行，跳过"
        continue
    }
    Write-Host "  [$i/$($services.Count)] 启动 $($svc.Name) ..."
    Start-Process -FilePath "java" `
        -ArgumentList "-Xmx512m","-Xms256m","-jar",$jar,"--spring.profiles.active=local" `
        -WorkingDirectory $work `
        -RedirectStandardOutput $outLog `
        -RedirectStandardError $errLog `
        -WindowStyle Hidden
    Start-Sleep -Seconds 5
}

# ---------- 5. 验证 ----------
Write-Host "[5/5] 等待服务注册（约 30 秒）..."
Start-Sleep -Seconds 30
Write-Host "`n===== Nacos 注册结果 ====="
try {
    $result = Invoke-RestMethod -Uri "http://127.0.0.1:8848/nacos/v1/ns/catalog/services?pageNo=1&pageSize=30&namespaceId=public"
    foreach ($svc in $result.serviceList) {
        Write-Host ("  {0,-20} 健康实例: {1}" -f $svc.name, $svc.healthyInstanceCount)
    }
} catch {
    Write-Host "查询 Nacos 失败: $($_.Exception.Message)"
}
Write-Host "`n日志目录: $LOG_DIR"
Write-Host "完成！前端如需启动: cd tj-portal-src-master ; npm run dev"
