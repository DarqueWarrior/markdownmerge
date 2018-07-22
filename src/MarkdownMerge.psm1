Set-StrictMode -Version Latest

function Merge-Markdown {
   [CmdletBinding()]
   param(
      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [string] $InPath,

      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [string] $OutPath
   )

   Process {
      # If the in path can't be found throw at the caller.
      if ((Test-Path -Path $InPath) -ne $true) {
         throw [InvalidArgumentException]::new('InPath could not be found.')
      }

      # If the out path can't be found create it.
      if ((Test-Path -Path $OutPath) -ne $true) {
         Write-Verbose "Creating $OutPath"

         # Pipe to Out-Null so the folder creation is not written to the screen.
         New-Item -Path $OutPath -ItemType Directory | Out-Null
      }

      $files = Get-ChildItem -Path $InPath -Filter *.md

      foreach ($file in $files) {
         Write-Verbose "Processing $($file.FullName)"

         $content = _process -file $file.FullName

         $finalFile = Join-Path -Path $OutPath -ChildPath $file.Name

         Write-Verbose "Writing $finalFile"
         Set-Content -Path $finalFile -Value $content -Force
      }
   }
}

function _process {
   [CmdletBinding()]
   param(
      [System.IO.FileInfo] $file
   )

   process {
      $r = [regex]'<!\-\-\s#include\s"([^"]+)"\s\-\->'
      $content = Get-Content -Path $file.FullName -Raw

      $m = $r.Matches($content)

      while ($m.Count) {
         $includedFile = $m.Groups[1]

         # Regardless if it is relative or absolute this will fix the path
         $includedFile = [System.IO.Path]::GetFullPath((Join-Path $file.Directory $includedFile))

         $newContent = _process -file $includedFile

         $content = $content.Replace($m.Groups[0], $newContent)

         $m = $r.Matches($content)
      }

      return $content
   }
}

Export-ModuleMember -Function Merge-Markdown