# Markdown Merge

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

# How To Install

markdown merge is available in the PowerShell gallery for easy installation:

```PowerShell
Install-Module markdown merge
```

# How To Use

To process files simply provide a folder of files to be processed (inPath) and a folder to placed the processed files in (outPath). 

```PowerShell
merge-markdown -inPath .\.docs -outPath .\docs
```

# How It Works

markdown merge works by recursively going through files based on the tags that are found.  For instance, consider the following in a `README.md` file:

```Markdown
<!-- #include "first-file.md" -->
```

Let's also consider that `first-file.md` contains the following:

```Markdown
<!-- #include "third-file.md" -->
```

markdown merge will first read the contents of `README.md` and look for include tags.  It will find `<!-- #include "first-file.md" -->` first.  From there it will parse the tag, open `first-file.md` and find include tags in that file.  This process continues until no more include tags are found.  

At that point it will start over in the original file and parse other include tags if they exist.  Along the way, markdown merge will parse each file and keep a record of the contents.  Once the process is finished, a file will be written in `README.md` with all of the compiled content.

## Release Notes

### 0.0.1

Initial release.