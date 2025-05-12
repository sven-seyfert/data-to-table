#####

<p align="center">
    <img src="assets/images/logo.png" width="100" />
    <h2 align="center">Welcome to <code>data-to-table</code>【ツ】</h2>
</p>

[![license](https://img.shields.io/badge/license-MIT-indianred.svg?style=flat-square&logo=spdx&logoColor=white)](https://github.com/sven-seyfert/data-to-table/blob/main/LICENSE.md)
[![release](https://img.shields.io/github/release/sven-seyfert/data-to-table.svg?color=slateblue&style=flat-square&logo=github)](https://github.com/sven-seyfert/data-to-table/releases/latest)
[![autoit](https://img.shields.io/badge/lang-AutoIt-lightskyblue.svg?style=flat-square&logo=autodesk&logoColor=white)]()
[![last commit](https://img.shields.io/github/last-commit/sven-seyfert/data-to-table.svg?color=darkgoldenrod&style=flat-square&logo=github)](https://github.com/sven-seyfert/data-to-table/commits/main)
[![contributors](https://img.shields.io/github/contributors/sven-seyfert/data-to-table.svg?color=darkolivegreen&style=flat-square&logo=github)](https://github.com/sven-seyfert/data-to-table/graphs/contributors)
[![Discord](https://img.shields.io/badge/Discord-AutoIt_Community_Projects-%235865F2.svg?style=flat-square&logo=discord&logoColor=white)](https://discord.gg/5DWTpZK3QN)

---

[Description](#description) | [Features](#features) | [Getting started](#getting-started) | [Configuration](#configuration) | [Contributing](#contributing) | [License](#license) | [Acknowledgements](#acknowledgements)

## Description

This library (UDF) allows you to transform input data, like strings or arrays, to a nice readable table output with different border styles and aligned table cell content.<br>
Output your data to console, file or GUI.

👉 Please check out the [upcoming features](#ideas--upcoming-features) section.

The repository is highly inspired by the great AutoIt UDF "StringToTable.au3" by "ioa747".<br>
Forum thread link: https://www.autoitscript.com/forum/topic/212876-_stringtotable/

> All credits for the **original logic** go to "ioa747" who made<br>
> the UDF with ❤️ for a readable and elegant output.

## Features

### General transformation and column alignment

#### *from string input*

``` autoit
; The $sData string is separated (columns) by tabs.
Local Const $sData = _
    'Language	Popularity (%)	Job Demand	Typical Use' & @CRLF & _
    'JavaScript	62.3	Very High	Web Development, Frontend/Backend' & @CRLF & _
    'C#	27.1	High	Game Development, Windows Apps, Web Dev' & @CRLF & _
    'Go	13.8	Growing	Cloud Services, System Programming' & @CRLF & _
    'PowerShell	13.5	Low to Moderate	Task Automation, DevOps, System Admin' & @CRLF & _
    'AutoIt	0.5	Low	Windows GUI Automation, Scripting'
```

#### *or array input*

``` autoit
; Default separator is @TAB.
Local Const $aData[][5] = _
    [ _
        ['Language',    'Popularity (%)', 'Job Demand',      'Typical Use'                             ], _
        ['JavaScript',  '62.3',           'Very High',       'Web Development, Frontend/Backend'       ], _
        ['C#',          '27.1',           'High',            'Game Development, Windows Apps, Web Dev' ], _
        ['Go',          '13.8',           'Growing',         'Cloud Services, System Programming'      ], _
        ['PowerShell',  '13.5',           'Low to Moderate', 'Task Automation, DevOps, System Admin'   ], _
        ['AutoIt',      '0.5',            'Low',             'Windows GUI Automation, Scripting'       ] _
    ]
```

#### *to output result (border style and alignment)*

**1. File view**

<details>
  <summary>👀 OPEN ME</summary>

![1-4](assets/images/border-styles-1-to-5.jpg)
![5-8](assets/images/border-styles-6-to-10.jpg)

</details>
<br>

**2. Markdown view**

<details>
  <summary>👀 OPEN ME</summary>

==> Border style: "1 = no-border"

    Language   Popularity (%)   Job Demand                                Typical Use
    JavaScript           62.3    Very High          Web Development, Frontend/Backend
    C#                   27.1      High       Game Development, Windows Apps, Web Dev
    Go                   13.8     Growing          Cloud Services, System Programming
    PowerShell           13.5 Low to Moderate   Task Automation, DevOps, System Admin
    AutoIt                0.5       Low             Windows GUI Automation, Scripting

==> Border style: "2 = inner-border-header"

     Language   │ Popularity (%) │   Job Demand    │                             Typical Use
    ────────────┼────────────────┼─────────────────┼─────────────────────────────────────────
     JavaScript │           62.3 │    Very High    │       Web Development, Frontend/Backend
     C#         │           27.1 │      High       │ Game Development, Windows Apps, Web Dev
     Go         │           13.8 │     Growing     │      Cloud Services, System Programming
     PowerShell │           13.5 │ Low to Moderate │   Task Automation, DevOps, System Admin
     AutoIt     │            0.5 │       Low       │       Windows GUI Automation, Scripting

==> Border style: "3 = border-no-header"

    ┌────────────┬────────────────┬─────────────────┬─────────────────────────────────────────┐
    │ Language   │ Popularity (%) │   Job Demand    │                             Typical Use │
    │ JavaScript │           62.3 │    Very High    │       Web Development, Frontend/Backend │
    │ C#         │           27.1 │      High       │ Game Development, Windows Apps, Web Dev │
    │ Go         │           13.8 │     Growing     │      Cloud Services, System Programming │
    │ PowerShell │           13.5 │ Low to Moderate │   Task Automation, DevOps, System Admin │
    │ AutoIt     │            0.5 │       Low       │       Windows GUI Automation, Scripting │
    └────────────┴────────────────┴─────────────────┴─────────────────────────────────────────┘

==> Border style: "4 = border-and-header"

    ┌────────────┬────────────────┬─────────────────┬─────────────────────────────────────────┐
    │ Language   │ Popularity (%) │   Job Demand    │                             Typical Use │
    ├────────────┼────────────────┼─────────────────┼─────────────────────────────────────────┤
    │ JavaScript │           62.3 │    Very High    │       Web Development, Frontend/Backend │
    │ C#         │           27.1 │      High       │ Game Development, Windows Apps, Web Dev │
    │ Go         │           13.8 │     Growing     │      Cloud Services, System Programming │
    │ PowerShell │           13.5 │ Low to Moderate │   Task Automation, DevOps, System Admin │
    │ AutoIt     │            0.5 │       Low       │       Windows GUI Automation, Scripting │
    └────────────┴────────────────┴─────────────────┴─────────────────────────────────────────┘

==> Border style: "5 = border-edges-with-accent-and-header"

    ╔────────────┬────────────────┬─────────────────┬─────────────────────────────────────────╗
    │ Language   │ Popularity (%) │   Job Demand    │                             Typical Use │
    ├────────────┼────────────────┼─────────────────┼─────────────────────────────────────────┤
    │ JavaScript │           62.3 │    Very High    │       Web Development, Frontend/Backend │
    │ C#         │           27.1 │      High       │ Game Development, Windows Apps, Web Dev │
    │ Go         │           13.8 │     Growing     │      Cloud Services, System Programming │
    │ PowerShell │           13.5 │ Low to Moderate │   Task Automation, DevOps, System Admin │
    │ AutoIt     │            0.5 │       Low       │       Windows GUI Automation, Scripting │
    ╚────────────┴────────────────┴─────────────────┴─────────────────────────────────────────╝

==> Border style: "6 = double-outter-border-no-header"

    ╔════════════╤════════════════╤═════════════════╤═════════════════════════════════════════╗
    ║ Language   │ Popularity (%) │   Job Demand    │                             Typical Use ║
    ║ JavaScript │           62.3 │    Very High    │       Web Development, Frontend/Backend ║
    ║ C#         │           27.1 │      High       │ Game Development, Windows Apps, Web Dev ║
    ║ Go         │           13.8 │     Growing     │      Cloud Services, System Programming ║
    ║ PowerShell │           13.5 │ Low to Moderate │   Task Automation, DevOps, System Admin ║
    ║ AutoIt     │            0.5 │       Low       │       Windows GUI Automation, Scripting ║
    ╚════════════╧════════════════╧═════════════════╧═════════════════════════════════════════╝

==> Border style: "7 = all-double-border-and-header"

    ╔════════════╦════════════════╦═════════════════╦═════════════════════════════════════════╗
    ║ Language   ║ Popularity (%) ║   Job Demand    ║                             Typical Use ║
    ╠════════════╬════════════════╬═════════════════╬═════════════════════════════════════════╣
    ║ JavaScript ║           62.3 ║    Very High    ║       Web Development, Frontend/Backend ║
    ║ C#         ║           27.1 ║      High       ║ Game Development, Windows Apps, Web Dev ║
    ║ Go         ║           13.8 ║     Growing     ║      Cloud Services, System Programming ║
    ║ PowerShell ║           13.5 ║ Low to Moderate ║   Task Automation, DevOps, System Admin ║
    ║ AutoIt     ║            0.5 ║       Low       ║       Windows GUI Automation, Scripting ║
    ╚════════════╩════════════════╩═════════════════╩═════════════════════════════════════════╝

==> Border style: "8 = double-outter-border-and-header-with-single-inner-border"

    ╔════════════╤════════════════╤═════════════════╤═════════════════════════════════════════╗
    ║ Language   │ Popularity (%) │   Job Demand    │                             Typical Use ║
    ╟────────────┼────────────────┼─────────────────┼─────────────────────────────────────────╢
    ║ JavaScript │           62.3 │    Very High    │       Web Development, Frontend/Backend ║
    ║ C#         │           27.1 │      High       │ Game Development, Windows Apps, Web Dev ║
    ║ Go         │           13.8 │     Growing     │      Cloud Services, System Programming ║
    ║ PowerShell │           13.5 │ Low to Moderate │   Task Automation, DevOps, System Admin ║
    ║ AutoIt     │            0.5 │       Low       │       Windows GUI Automation, Scripting ║
    ╚════════════╧════════════════╧═════════════════╧═════════════════════════════════════════╝

==> Border style: "9 = rounded-corner-outside-border-only-no-header"

    ╭─────────────────────────────────────────────────────────────────────────────────────────╮
    │ Language     Popularity (%)     Job Demand                                  Typical Use │
    │ JavaScript             62.3      Very High            Web Development, Frontend/Backend │
    │ C#                     27.1        High         Game Development, Windows Apps, Web Dev │
    │ Go                     13.8       Growing            Cloud Services, System Programming │
    │ PowerShell             13.5   Low to Moderate     Task Automation, DevOps, System Admin │
    │ AutoIt                  0.5         Low               Windows GUI Automation, Scripting │
    ╰─────────────────────────────────────────────────────────────────────────────────────────╯

==> Border style: "10 = double-outside-border-only-no-header"

    ╔═════════════════════════════════════════════════════════════════════════════════════════╗
    ║ Language     Popularity (%)     Job Demand                                  Typical Use ║
    ║ JavaScript             62.3      Very High            Web Development, Frontend/Backend ║
    ║ C#                     27.1        High         Game Development, Windows Apps, Web Dev ║
    ║ Go                     13.8       Growing            Cloud Services, System Programming ║
    ║ PowerShell             13.5   Low to Moderate     Task Automation, DevOps, System Admin ║
    ║ AutoIt                  0.5         Low               Windows GUI Automation, Scripting ║
    ╚═════════════════════════════════════════════════════════════════════════════════════════╝

</details>

> 💡 Please be aware: The output result only looks good in case you use a monospace font in your file viewer/editor or in your GUI.<br>
> On console it should be default to have a monospace font, but the border visualization differs a bit from the file output result.

### Key aspects of the UDF (library)

- 10 different border styles
- highly abstracted library
- enhanced error handling
- usage of maps
- modification friendly / expandable

### Ideas / upcoming features

- [x] add more flexibility for border styles creation
- [x] create how-to about how user can add border styles
- [ ] add other ways of input data (by console out or via file for example)
- [ ] add *markdown table* format
- [ ] add *gherkin feature table* format
- [ ] check for other table related formats

## Getting started

#### *Preconditions*

To be defined [...]

#### *Usage*

See file `.\scr\main.au3` or this short example:

``` autoit
#include-once
#include "data-to-table.au3"

_Main()

Func _Main()
    Local Const $sData = _
        'Language	Popularity (%)	Job Demand	Typical Use' & @CRLF & _
        'JavaScript	62.3	Very High	Web Development, Frontend/Backend' & @CRLF & _
        'C#	27.1	High	Game Development, Windows Apps, Web Dev' & @CRLF & _
        'Go	13.8	Growing	Cloud Services, System Programming' & @CRLF & _
        'PowerShell	13.5	Low to Moderate	Task Automation, DevOps, System Admin' & @CRLF & _
        'AutoIt	0.5	Low	Windows GUI Automation, Scripting'

    Local Const $sResult = _DataToTable($sData, 4, @TAB, 'L, R, C, R')
    If @error Then
        ; your error handling
    EndIf

    ConsoleWrite($sResult)
    ; or
    FileWrite('...', $sResult)
    ; or
    GUICtrlSetData('...', $sResult)
EndFunc
```

## Configuration

To be defined [...]

## Contributing

To be defined [...]

## License

Copyright (c) 2025 Sven Seyfert (SOLVE-SMART)<br>
Distributed under the MIT License. See [LICENSE](https://github.com/sven-seyfert/data-to-table/blob/main/LICENSE.md) for more information.

## Acknowledgements

- Opportunity by [GitHub](https://github.com)
- Badges by [Shields](https://shields.io)
- Thanks to @ioa747 for his great work/idea of the [StringToTable UDF](https://www.autoitscript.com/forum/topic/212876-_stringtotable/)
- Thanks to @argumentum, @WildByDesign and @ioa747 for all the suggestions
- Thanks to all the contributors (mentioned in the CHANGELOG)

##

[To the top](#)
