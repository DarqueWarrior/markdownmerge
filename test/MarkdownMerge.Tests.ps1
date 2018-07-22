Set-StrictMode -Version Latest

# Remove any loaded version of this module so only the files
# imported below are being tested.
Get-Module MarkdownMerge | Remove-Module -Force

# Load the modules we want to test and any dependencies
Import-Module $PSScriptRoot\..\src\MarkdownMerge.psm1 -Force

# The InModuleScope command allows you to perform white-box unit testing on the
# internal (non-exported) code of a Script Module.
InModuleScope MarkdownMerge {
   # Make sure the parameters are validated correctly
   Describe 'Parameter Validation' -Tag 'parameters', 'unit' {
      Context 'InPath does not exist' {
         Mock Test-Path { return $false } -ParameterFilter { $Path -eq './notRealFolderInPath' } -Verifiable
         Mock Test-Path { throw "Wrong call to Test-Path: $args" }
         Mock Get-ChildItem { }

         It 'Should throw' {
            { Merge-Markdown -InPath './notRealFolderInPath' -OutPath './notRealFolderOutPath' } | Should -Throw -Because 'because inPath folder does not exist'
            Assert-VerifiableMock
         }
      }

      Context 'OutPath does not exist' {
         Mock Test-Path { return $true } -ParameterFilter { $Path -eq '.\realFolderInPath' } -Verifiable
         Mock Test-Path { return $false } -ParameterFilter { $Path -eq '.\missingOutPath' } -Verifiable
         Mock Test-Path { throw "Wrong call to Test-Path: $args" }
         Mock New-Item { return [System.IO.FileInfo]::new('.\missingOutPath') } -ParameterFilter { $Path -eq '.\missingOutPath' -and $ItemType -eq 'Directory' } -Verifiable
         Mock Get-ChildItem { }

         Merge-Markdown -InPath '.\realFolderInPath' -OutPath '.\missingOutPath'

         It 'Should be created' {
            Assert-VerifiableMock
         }
      }

      Context 'OutPath exists' {
         Mock Test-Path { return $true } -ParameterFilter { $Path -eq '.\realFolderInPath' } -Verifiable
         Mock Test-Path { return $true } -ParameterFilter { $Path -eq '.\missingOutPath' } -Verifiable
         Mock New-Item { throw "New-Item should not be called: $args" }
         Mock Get-ChildItem { }

         Merge-Markdown -InPath '.\realFolderInPath' -OutPath '.\missingOutPath'

         It 'Should not be created' {
            Assert-VerifiableMock
         }
      }
   }

   Describe 'Process files' -Tag 'process', 'unit' {
      Context 'Process empty file' {
         Mock Test-Path { return $true } -ParameterFilter { $Path -eq '.\realFolderInPath' } -Verifiable
         Mock Test-Path { return $true } -ParameterFilter { $Path -eq '.\missingOutPath' } -Verifiable
         Mock Test-Path { throw "Wrong call to Test-Path: $args" }
         Mock Get-ChildItem { return @(
               [System.IO.FileInfo]::new('.\realFolderInPath\test.md')
            )
         } -Verifiable
         Mock Get-Content { return '' } -Verifiable
         Mock Set-Content { } -Verifiable

         Merge-Markdown -InPath '.\realFolderInPath' -OutPath '.\missingOutPath'

         It 'Should write empty file' {
            Assert-VerifiableMock
         }
      }

      Context 'Process file' {
         Mock Test-Path { return $true } -ParameterFilter { $Path -eq '.\realFolderInPath' } -Verifiable
         Mock Test-Path { return $true } -ParameterFilter { $Path -eq '.\missingOutPath' } -Verifiable
         Mock Test-Path { throw "Wrong call to Test-Path: $args" }
         Mock Get-ChildItem { return @(
               [System.IO.FileInfo]::new('.\realFolderInPath\test.md')
            )
         } -Verifiable
         Mock Get-Content { return '<!-- #include "./include.md" -->' } -ParameterFilter { $Path -like '*test.md*'} -Verifiable
         Mock Get-Content { return '<!-- #include "./hello.md" -->' } -ParameterFilter { $Path -like '*include.md*'} -Verifiable
         Mock Get-Content { return 'Hello World' } -ParameterFilter { $Path -like '*hello.md*'} -Verifiable
         Mock Set-Content { } -ParameterFilter { $Value -eq 'Hello World' } -Verifiable
         Mock Set-Content { throw "Wrong content Set-Content: $args" }

         Merge-Markdown -InPath '.\realFolderInPath' -OutPath '.\missingOutPath'

         It 'Should write file' {
            Assert-VerifiableMock
         }
      }
   }
}