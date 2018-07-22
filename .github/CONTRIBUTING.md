# Contributing to MarkdownMerge

I am truly grateful for all the support developing MarkdownMerge. It means a lot that you spend your time to help improve this module.

## Steps to contribute

1. Write help. **It is important that you do this before you start changing the module.**
2. Write unit tests.
3. Code the change.
4. Update the psd1 file.
5. Update the Readme.md file.

### Housekeeping

This module runs on Mac, PC and Linux. Therefore, **casing is very important**.  When you update the psd1 file the casing of the files must match those on disk. If they do not there could be issue loading the module on Mac and Linux.

### Get the code

Now it is time to get your hands on MarkdownMerge. Fork this repository, clone it to your development machine and create a branch for your work.

### Write Help

Every new change must have help that explains how to use it. The help can be authored using Markdown in the .docs folder. The help is generated using a combination of [platyPS](https://github.com/PowerShell/platyPS) and this module. platyPS enables the authoring of External Help with Markdown.  When creating help for a PowerShell module you will find yourself writing a lot of the same Markdown multiple times. This module enables reuse of the Markdown by allowing you to include markdown files into other markdown files using a C style include syntax.

I have found writing the help before I start to make a change saves me a lot of time. This forces me to think of all the use cases of the change. It also allows me to get the boring part out of the way so I end on a high note writing the code.

You can run gen-help.ps1 from the .docs folder to make sure you can generate the help file.

### Write Unit Test

Using [Pester](https://github.com/pester/Pester) write unit test for the new change. I am a firm believer if I cannot write a test before I write the code I am not clear on what I expect the code to do. After writing the help first writing the unit tests should be pretty straight forward.

At first it will feel odd to write the help and test first but the more you do it the easier it gets.

Because I will not be over your shoulder you could write the tests and even the help after. **Just know if your pull request does not have tests and help it will be rejected.**

### Code the change

Consistency is very important to me and will slow the pull request process if the changes are not consistent with those already in the module.

If you feel the conventions should be changed please log and issue so we can discuss.

### Update MarkdownMerge.psd1

Make sure casing of all the files you add match. This module runs on Mac, PC and Linux and casing is very important.

### Update README.md

Update the Release Notes section of the readme file with your changes.