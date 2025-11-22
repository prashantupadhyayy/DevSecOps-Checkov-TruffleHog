$ip = Invoke-RestMethod -Uri "https://api.ipify.org"
@{ public_ip = $ip } | ConvertTo-Json