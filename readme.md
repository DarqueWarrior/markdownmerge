# Trackyon.Markdown

[![Build status](https://loecda.visualstudio.com/markdownmerge/_apis/build/status/markdownmerge-CI)](https://loecda.visualstudio.com/markdownmerge/_build/latest?definitionId=49)
[![Deployment status](https://loecda.vsrm.visualstudio.com/_apis/public/Release/badge/35d956a5-10d6-4273-85a1-d672ce2bf980/1/1?WT.mc_id=devops-0000-dbrown)](https://loecda.visualstudio.com/markdownmerge/_releases2?definitionId=1&view=mine&_a=releases&WT.mc_id=devops-0000-dbrown)
[![PowerShell Gallery - PowerShellGet](https://img.shields.io/badge/PowerShell%20Gallery-Trackyon.Markdown-blue.svg)](https://www.powershellgallery.com/packages/Trackyon.Markdown/)
[![Minimum Supported PowerShell Version](https://img.shields.io/badge/PowerShell-5.0-blue.svg)](https://github.com/PowerShell/PowerShellGet)

This is a port of the npm module markdown-include. The functions in this module allow you to include markdown files into other markdown files using a C style include syntax inside a single line comment.

## Merge your markdown files

This modules main feature is that it allows you to include markdown files into other markdown files.  For example, you could place the following into a markdown file:

```Markdown
<!-- #include "./common/header.md" -->
<!-- #include "./synopsis/Add-VSTeamAccount.md" -->
```

And assuming that `header.md` contents are:

```Markdown
# Header
```

And assuming that `Add-VSTeamAccount.md` contents are:

```Markdown
Description of Add-VSTeamAccount
```

It would compile to:

```Markdown
# Header
Description of Add-VSTeamAccount
```

**NOTE**: The include statements are placed inside a single line comment ```<!-- -->```. This is done so the # in #include is not misinterpreted as a heading in your markdown.

This will also allow linters to ignore these lines and not log errors or warnings.

## How To Install

Trackyon.Markdown is available in the PowerShell gallery for easy installation:

```PowerShell
Install-Module Trackyon.Markdown -Scope CurrentUser
```

## How To Use

To process files simply provide a folder of files to be processed (inPath) and a folder to placed the processed files in (outPath).

```PowerShell
merge-markdown -inPath .\.docs -outPath .\docs
```

## How It Works

Trackyon.Markdown works by recursively going through files based on the tags that are found.  For instance, consider the following in a `README.md` file:

```Markdown
<!-- #include "first-file.md" -->
```

Let's also consider that `first-file.md` contains the following:

```Markdown
<!-- #include "third-file.md" -->
```

Trackyon.Markdown will first read the contents of `README.md` and look for include tags.  It will find `<!-- #include "first-file.md" -->` first.  From there it will parse the tag, open `first-file.md` and find include tags in that file.  This process continues until no more include tags are found.

At that point it will start over in the original file and parse other include tags if they exist.  Along the way, Trackyon.Markdown will parse each file and keep a record of the contents.  Once the process is finished, a file will be written in `README.md` with all of the compiled content.

## Contributors

[Guidelines](.github/CONTRIBUTING.md)

## Change Log

[Change Log](CHANGELOG.md)

## Maintainers

- [Donovan Brown](https://github.com/darquewarrior) - [@DonovanBrown](https://twitter.com/DonovanBrown)

## License

This project is [licensed under the MIT License](LICENSE).