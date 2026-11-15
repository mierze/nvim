if ($args.Count -eq 0) { $args = @("install") }
$script = Join-Path $PSScriptRoot "setup.py"
if (Get-Command py -ErrorAction SilentlyContinue) {
    & py -3 $script @args
} else {
    & python $script @args
}
exit $LASTEXITCODE
