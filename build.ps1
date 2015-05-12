
$version = "4.5.1"
$BuildConfig = 'Release'
$Target = 'Rebuild'
$year = Get-Date -Format "yyyy"

$SolutionPath = Resolve-path antlr4-csharp\Runtime\CSharp\Antlr4.Runtime\Antlr4.Runtime.vs2013.csproj
$key = Resolve-path antlr4-csharp\Runtime\Antlr4.snk
$out = Join-Path (Resolve-Path .) bin

#region functions

function Invoke-MSBuild() {
param(
        [Parameter(Mandatory=$true)]
        [ValidateSet('v3.5', 'v4.5')]
        [string] $tfv,
        [string] $const = "TRACE"
    )

    
    $vout = $tfv.Replace("v","").Replace(".", "")

    $props = "Configuration=$BuildConfig;SignAssembly=true;AssemblyOriginatorKeyFile=$key;OutputPath=$out\lib\net$vout\"
    $props += ";TargetFrameworkVersion=$tfv;DefineConstants=`"$const`""

    $opts = @('/nologo', '/m', '/nr:false', "/v:m", "/t:$Target", "/p:$props", $SolutionPath);

    & msbuild $opts
}

#endregion

Remove-Item *.nupkg

Invoke-MSBuild -tfv v3.5 -const "TRACE;NET35PLUS"
Invoke-MSBuild -tfv v4.5 -const "TRACE;NET35PLUS;NET40PLUS"

nuget pack VisualOn.Antlr4.Runtime.nuspec -OutputDirectory $out -Version "$version" -Properties "version=$version;year=$year"